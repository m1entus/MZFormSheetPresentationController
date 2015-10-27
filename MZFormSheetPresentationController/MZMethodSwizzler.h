//
//  MZMethodSwizzler.h
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

#import <Foundation/Foundation.h>

//-------------
/* typedefs */
//-------------

typedef void *(* MZ_IMP)(__unsafe_unretained id, SEL, ...);

typedef id (^MZMethodReplacementProvider)(MZ_IMP original, __unsafe_unretained Class swizzledClass, SEL selector);
//-----------------
/* Helper macros */
//-----------------

#define MZMethodReplacement(returntype, selftype, ...) ^ returntype (__unsafe_unretained selftype self, ##__VA_ARGS__)
#define MZMethodReplacementProviderBlock ^ id (MZ_IMP original, __unsafe_unretained Class swizzledClass, SEL _cmd)
#define MZOriginalImplementation(type, ...) ((__typeof(type (*)(__typeof(self), SEL, ...)))original)(self, _cmd, ##__VA_ARGS__)




//-------------------------------------------------------------
/** @name Super easy method swizzling on specific instances */
//-------------------------------------------------------------


@interface NSObject (MZInstanceSwizzler)

/**
 Swizzle the specified instance method on this specific instance only.
 
 @param selector Selector of the method to swizzle.
 @param replacement The replacement block to use for swizzling the method. Its signature needs to be: return_type ^(id self, ...).
 
 */
- (void)swizzleMethod:(SEL)selector withReplacement:(MZMethodReplacementProvider)replacementProvider;

- (BOOL)deswizzleMethod:(SEL)selector;
- (BOOL)deswizzle;


@end

