//
//  MZMethodSwizzler.m
//  MZFormSheetPresentationController
//
//  Created by Michał Zaborowski on 16.01.2014.
//  Copyright (c) 2013 Michał Zaborowski. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Originaly Created by Jonas Gessner 22.08.2013
//  Copyright (c) 2013 Jonas Gessner. All rights reserved.
//

#import "MZMethodSwizzler.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

#pragma mark Defines

#ifdef __clang__
#if __has_feature(objc_arc)
#define MZ_ARC_ENABLED
#endif
#endif

#ifdef MZ_ARC_ENABLED
#define MZBridgeCast(type, obj) ((__bridge type)obj)
#define releaseIfNecessary(object)
#else
#define MZBridgeCast(type, obj) ((type)obj)
#define releaseIfNecessary(object) [object release];
#endif


#define kClassKey @"k"
#define kCountKey @"c"
#define kIMPKey @"i"

// See http://clang.llvm.org/docs/Block-ABI-Apple.html#high-level
struct Block_literal_1 {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor_1 {
        unsigned long int reserved;         // NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
    // imported variables
};

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};
typedef int BlockFlags;



#pragma mark - Block Analysis

NS_INLINE const char *blockGetType(id block) {
    struct Block_literal_1 *blockRef = MZBridgeCast(struct Block_literal_1 *, block);
    BlockFlags flags = blockRef->flags;
    
    if (flags & BLOCK_HAS_SIGNATURE) {
        void *signatureLocation = blockRef->descriptor;
        signatureLocation += sizeof(unsigned long int);
        signatureLocation += sizeof(unsigned long int);
        
        if (flags & BLOCK_HAS_COPY_DISPOSE) {
            signatureLocation += sizeof(void(*)(void *dst, void *src));
            signatureLocation += sizeof(void (*)(void *src));
        }
        
        const char *signature = (*(const char **)signatureLocation);
        return signature;
    }
    
    return NULL;
}

NS_INLINE BOOL blockIsCompatibleWithMethodType(id block, __unsafe_unretained Class class, SEL selector, BOOL instanceMethod) {
    const char *blockType = blockGetType(block);
    
    NSMethodSignature *blockSignature = [NSMethodSignature signatureWithObjCTypes:blockType];
    NSMethodSignature *methodSignature = (instanceMethod ? [class instanceMethodSignatureForSelector:selector] : [class methodSignatureForSelector:selector]);
    
    if (!blockSignature || !methodSignature) {
        return NO;
    }
    
    if (blockSignature.numberOfArguments != methodSignature.numberOfArguments) {
        return NO;
    }
    const char *blockReturnType = blockSignature.methodReturnType;
    
    if (strncmp(blockReturnType, "@", 1) == 0) {
        blockReturnType = "@";
    }
    
    if (strcmp(blockReturnType, methodSignature.methodReturnType) != 0) {
        return NO;
    }
    
    for (unsigned int i = 0; i < methodSignature.numberOfArguments; i++) {
        if (i == 0) {
            // self in method, block in block
            if (strcmp([methodSignature getArgumentTypeAtIndex:i], "@") != 0) {
                return NO;
            }
            if (strcmp([blockSignature getArgumentTypeAtIndex:i], "@?") != 0) {
                return NO;
            }
        }
        else if(i == 1) {
            // SEL in method, self in block
            if (strcmp([methodSignature getArgumentTypeAtIndex:i], ":") != 0) {
                return NO;
            }
            if (instanceMethod ? strncmp([blockSignature getArgumentTypeAtIndex:i], "@", 1) != 0 : (strncmp([blockSignature getArgumentTypeAtIndex:i], "@", 1) != 0 && strcmp([blockSignature getArgumentTypeAtIndex:i], "r^#") != 0)) {
                return NO;
            }
        }
        else {
            const char *blockSignatureArg = [blockSignature getArgumentTypeAtIndex:i];
            
            if (strncmp(blockSignatureArg, "@", 1) == 0) {
                blockSignatureArg = "@";
            }
            
            if (strcmp(blockSignatureArg, [methodSignature getArgumentTypeAtIndex:i]) != 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

NS_INLINE BOOL blockIsValidReplacementProvider(id block) {
    const char *blockType = blockGetType(block);
    
    MZMethodReplacementProvider dummy = MZMethodReplacementProviderBlock {
        return nil;
    };
    
    const char *expectedType = blockGetType(dummy);
    
    return (strcmp(expectedType, blockType) == 0);
}



NS_INLINE void classSwizzleMethod(Class cls, Method method, IMP newImp) {
    if (!class_addMethod(cls, method_getName(method), newImp, method_getTypeEncoding(method))) {
        // class already has implementation, swizzle it instead
        method_setImplementation(method, newImp);
    }
}





#pragma mark - Original Implementations

static OSSpinLock lock = OS_SPINLOCK_INIT;

static NSMutableDictionary *originalClassMethods;
static NSMutableDictionary *originalInstanceMethods;
static NSMutableDictionary *originalInstanceInstanceMethods;


NS_INLINE MZ_IMP originalInstanceInstanceMethodImplementation(__unsafe_unretained Class class, SEL selector, BOOL fetchOnly) {
    NSCAssert(!OSSpinLockTry(&lock), @"Spin lock is not locked");
    
    if (!originalInstanceInstanceMethods) {
        originalInstanceInstanceMethods = [[NSMutableDictionary alloc] init];
    }
    
    NSString *classKey = NSStringFromClass(class);
    NSString *selectorKey = NSStringFromSelector(selector);
    
    NSMutableDictionary *instanceSwizzles = originalInstanceInstanceMethods[classKey];
    
    if (!instanceSwizzles) {
        instanceSwizzles = [NSMutableDictionary dictionary];
        
        originalInstanceInstanceMethods[classKey] = instanceSwizzles;
    }
    
    MZ_IMP orig = NULL;
    
    if (fetchOnly) {
        NSMutableDictionary *dict = instanceSwizzles[selectorKey];
        if (!dict) {
            return NULL;
        }
        NSValue *pointerValue = dict[kIMPKey];
        orig = [pointerValue pointerValue];
        unsigned int count = [dict[kCountKey] unsignedIntValue];
        if (count == 1) {
            [instanceSwizzles removeObjectForKey:selectorKey];
            if (instanceSwizzles.count == 0) {
                [originalInstanceInstanceMethods removeObjectForKey:classKey];
            }
        }
        else {
            dict[kCountKey] = @(count-1);
        }
    }
    else {
        NSMutableDictionary *dict = instanceSwizzles[selectorKey];
        if (!dict) {
            dict = [NSMutableDictionary dictionaryWithCapacity:2];
            dict[kCountKey] = @(1);
            
            orig = (MZ_IMP)[class instanceMethodForSelector:selector];
            dict[kIMPKey] = [NSValue valueWithPointer:orig];
            
            instanceSwizzles[selectorKey] = dict;
        }
        else {
            orig = [dict[kIMPKey] pointerValue];
            
            unsigned int count = [dict[kCountKey] unsignedIntValue];
            dict[kCountKey] = @(count+1);
        }
    }
    
    if (originalInstanceInstanceMethods.count == 0) {
        releaseIfNecessary(originalInstanceInstanceMethods);
        originalInstanceInstanceMethods = nil;
    }
    
    return orig;
}

#pragma mark - Instance Specific Swizzling & Deswizzling

static NSMutableDictionary *dynamicSubclassesByObject;

NS_INLINE unsigned int swizzleCount(__unsafe_unretained id object) {
    NSValue *key = [NSValue valueWithPointer:MZBridgeCast(const void *, object)];
    
    unsigned int count = [dynamicSubclassesByObject[key][kCountKey] unsignedIntValue];
    
    return count;
}

NS_INLINE void decreaseSwizzleCount(__unsafe_unretained id object) {
    NSValue *key = [NSValue valueWithPointer:MZBridgeCast(const void *, object)];
    
    NSMutableDictionary *classDict = dynamicSubclassesByObject[key];
    
    unsigned int count = [classDict[kCountKey] unsignedIntValue];
    
    classDict[kCountKey] = @(count-1);
}

NS_INLINE BOOL deswizzleInstance(__unsafe_unretained id object) {
    OSSpinLockLock(&lock);
    
    BOOL success = NO;
    
    if (swizzleCount(object) > 0) {
        Class dynamicSubclass = object_getClass(object);
        
        object_setClass(object, [object class]);
        
        objc_disposeClassPair(dynamicSubclass);
        
        [originalInstanceInstanceMethods removeObjectForKey:NSStringFromClass([object class])];
        
        [dynamicSubclassesByObject removeObjectForKey:[NSValue valueWithPointer:MZBridgeCast(const void *, object)]];
        
        if (!dynamicSubclassesByObject.count) {
            releaseIfNecessary(dynamicSubclassesByObject);
            dynamicSubclassesByObject = nil;
        }
        
        if (!originalInstanceInstanceMethods.count) {
            releaseIfNecessary(originalInstanceInstanceMethods);
            originalInstanceInstanceMethods = nil;
        }
        
        success = YES;
    }
    
    OSSpinLockUnlock(&lock);
    
    return success;
}

NS_INLINE BOOL deswizzleMethod(__unsafe_unretained id object, SEL selector) {
    OSSpinLockLock(&lock);
    
    BOOL success = NO;
    
    unsigned int count = swizzleCount(object);
    
    if (count == 1) {
        OSSpinLockUnlock(&lock);
        return deswizzleInstance(object);
    }
    else if (count > 1) {
        MZ_IMP originalIMP = originalInstanceInstanceMethodImplementation([object class], selector, YES);
        if (originalIMP) {
            method_setImplementation(class_getInstanceMethod(object_getClass(object), selector), (IMP)originalIMP);
            
            success = YES;
        }
        
        decreaseSwizzleCount(object);
    }
    
    OSSpinLockUnlock(&lock);
    
    return success;
}


NS_INLINE void swizzleInstance(__unsafe_unretained id object, SEL selector, MZMethodReplacementProvider replacementProvider) {
    Class class = [object class];
    
    if (!blockIsValidReplacementProvider(replacementProvider)) {
        NSCAssert(blockIsValidReplacementProvider(replacementProvider), @"Invalid method replacemt provider");
    }
    
    NSCAssert([object respondsToSelector:selector], @"Invalid method: -[%@ %@]", NSStringFromClass(class), NSStringFromSelector(selector));
    
    OSSpinLockLock(&lock);
    
    if (!dynamicSubclassesByObject) {
        dynamicSubclassesByObject = [[NSMutableDictionary alloc] init];
    };
    
    NSValue *key = [NSValue valueWithPointer:MZBridgeCast(const void *, object)];
    
    NSMutableDictionary *classDict = dynamicSubclassesByObject[key];
    
    Class newClass = [classDict[kClassKey] pointerValue];
    
    if (!classDict || !newClass) {
        NSString *dynamicSubclass = [NSStringFromClass(class) stringByAppendingFormat:@"_MZMS_%@", [[NSUUID UUID] UUIDString]];
        
        const char *newClsName = [dynamicSubclass UTF8String];
        
        NSCAssert(!objc_lookUpClass(newClsName), @"Class %@ already exists!\n", dynamicSubclass);
        
        newClass = objc_allocateClassPair(class, newClsName, 0);
        
        NSCAssert(newClass, @"Could not create class %@\n", dynamicSubclass);
        
        objc_registerClassPair(newClass);
        
        classDict = [NSMutableDictionary dictionary];
        classDict[kClassKey] = [NSValue valueWithPointer:MZBridgeCast(const void *, newClass)];
        classDict[kCountKey] = @(1);
        
        dynamicSubclassesByObject[[NSValue valueWithPointer:MZBridgeCast(const void *, object)]] = classDict;
        
        Method classMethod = class_getInstanceMethod(newClass, @selector(class));
        
        id swizzledClass = ^Class (__unsafe_unretained id self) {
            return class;
        };
        
        classSwizzleMethod(newClass, classMethod, imp_implementationWithBlock(swizzledClass));
        
        SEL deallocSel = sel_getUid("dealloc");
        
        Method dealloc = class_getInstanceMethod(newClass, deallocSel);
        __block MZ_IMP deallocImp = (MZ_IMP)method_getImplementation(dealloc);
        
        id deallocHandler = ^(__unsafe_unretained id self) {
            NSCAssert(deswizzleInstance(self), @"Deswizzling of class %@ failed", NSStringFromClass([self class]));
            
            if (deallocImp) {
                deallocImp(self, deallocSel);
            }
        };
        
        classSwizzleMethod(newClass, dealloc, imp_implementationWithBlock(deallocHandler));
    }
    else {
        unsigned int count = [classDict[kCountKey] unsignedIntValue];
        classDict[kCountKey] = @(count+1);
    }
    
    Method origMethod = class_getInstanceMethod(class, selector);
    
    MZ_IMP origIMP = originalInstanceInstanceMethodImplementation([object class], selector, NO);
    
    id replaceBlock = replacementProvider(origIMP, class, selector);
    
    if (!blockIsCompatibleWithMethodType(replaceBlock, class, selector, YES)) {
        NSCAssert(blockIsCompatibleWithMethodType(replaceBlock, class, selector, YES), @"Invalid method replacement");
    }
    
    
    classSwizzleMethod(newClass, origMethod, imp_implementationWithBlock(replaceBlock));
    
    object_setClass(object, newClass);
    
    OSSpinLockUnlock(&lock);
}



@implementation NSObject (MZInstanceSwizzler)

- (void)swizzleMethod:(SEL)selector withReplacement:(MZMethodReplacementProvider)replacementProvider {
    swizzleInstance(self, selector, replacementProvider);
}

- (BOOL)deswizzleMethod:(SEL)selector {
    return deswizzleMethod(self, selector);
}

- (BOOL)deswizzle {
    return deswizzleInstance(self);
}

@end

