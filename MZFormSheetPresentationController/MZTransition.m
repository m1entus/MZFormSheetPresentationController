//
//  MZTransition.m
//  MZFormSheetPresentationViewController
//
//  Created by Michał Zaborowski on 21.12.2013.
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

#import "MZTransition.h"
#import "MZFormSheetPresentationViewController.h"

NSString *const MZPresentationTransitionExceptionMethodNotImplemented = @"MZTransitionExceptionMethodNotImplemented";

CGFloat const MZPresentationTransitionDefaultBounceDuration = 0.4;
CGFloat const MZPresentationTransitionDefaultDropDownDuration = 0.4;

CGFloat const MZFormSheetPresentationViewControllerDefaultAnimationDuration = 0.35;

@implementation MZTransition

#pragma mark - Class methods

+ (void)registerTransitionClass:(Class)transitionClass forTransitionStyle:(MZFormSheetPresentationTransitionStyle)transitionStyle {
    [[MZTransition mutableSharedTransitionClasses] setObject:transitionClass forKey:@(transitionStyle)];
}

+ (Class)classForTransitionStyle:(MZFormSheetPresentationTransitionStyle)transitionStyle {
    return [MZTransition sharedTransitionClasses][@(transitionStyle)];
}

+ (NSDictionary *)sharedTransitionClasses {
    return [[self mutableSharedTransitionClasses] copy];
}

+ (NSMutableDictionary *)mutableSharedTransitionClasses {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *_instanceOfTransitionClasses = nil;
    dispatch_once(&onceToken, ^{
        _instanceOfTransitionClasses = [[NSMutableDictionary alloc] init];
    });
    return _instanceOfTransitionClasses;
}


- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    [NSException raise:MZPresentationTransitionExceptionMethodNotImplemented format:@"-[%@ entryFormSheetControllerTransition:completionHandler:] must be implemented", NSStringFromClass([self class])];
}
- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    [NSException raise:MZPresentationTransitionExceptionMethodNotImplemented format:@"-[%@ exitFormSheetControllerTransition:completionHandler:] must be implemented", NSStringFromClass([self class])];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completionHandler)(void) = [anim valueForKey:@"completionHandler"];
    if (completionHandler) {
        completionHandler();
    }
}

@end

@interface MZPresentationSlideFromTopTransition : MZTransition
@end

@implementation MZPresentationSlideFromTopTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromTop];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    CGRect originalFormSheetRect = formSheetRect;
    formSheetRect.origin.y = -[UIScreen mainScreen].bounds.size.height;
    formSheetController.view.frame = formSheetRect;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = originalFormSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.y = -[UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = formSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end

@interface MZPresentationSlideFromBottomTransition : MZTransition
@end

@implementation MZPresentationSlideFromBottomTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromBottom];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromBottom];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    CGRect originalFormSheetRect = formSheetRect;
    formSheetRect.origin.y = [UIScreen mainScreen].bounds.size.height;
    formSheetController.view.frame = formSheetRect;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = originalFormSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
                         formSheetController.view.frame = formSheetRect;
        }
        completion:^(BOOL finished) {
                        completionHandler();
        }];
}
@end

@interface MZPresentationSlideFromLeftTransition : MZTransition
@end

@implementation MZPresentationSlideFromLeftTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromLeft];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromLeft];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    CGRect originalFormSheetRect = formSheetRect;
    formSheetRect.origin.x = -[UIScreen mainScreen].bounds.size.width;
    formSheetController.view.frame = formSheetRect;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = originalFormSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.x = -[UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = formSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end

@interface MZPresentationSlideFromRightTransition : MZTransition
@end

@implementation MZPresentationSlideFromRightTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromRight];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideFromRight];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    CGRect originalFormSheetRect = formSheetRect;
    formSheetRect.origin.x = [UIScreen mainScreen].bounds.size.width;
    formSheetController.view.frame = formSheetRect;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = originalFormSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.x = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = formSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end

@interface MZPresentationSlideBounceFromLeftTransition : MZTransition
@end

@implementation MZPresentationSlideBounceFromLeftTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:
     MZFormSheetPresentationTransitionStyleSlideAndBounceFromLeft];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideAndBounceFromLeft];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGFloat x = formSheetController.view.center.x;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.values = @[ @(x - [UIScreen mainScreen].bounds.size.width), @(x + 20), @(x - 10), @(x) ];
    animation.keyTimes = @[ @(0), @(0.5), @(0.75), @(1) ];
    animation.timingFunctions = @[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ];
    animation.duration = MZPresentationTransitionDefaultDropDownDuration;
    animation.delegate = self;
    [animation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.view.layer addAnimation:animation forKey:@"bounceLeft"];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.x = -[UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = formSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end

@interface MZPresentationSlideBounceFromRightTransition : MZTransition
@end

@implementation MZPresentationSlideBounceFromRightTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideAndBounceFromRight];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleSlideAndBounceFromRight];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGFloat x = formSheetController.view.center.x;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.values = @[ @(x + [UIScreen mainScreen].bounds.size.width), @(x - 20), @(x + 10), @(x) ];
    animation.keyTimes = @[ @(0), @(0.5), @(0.75), @(1) ];
    animation.timingFunctions = @[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ];
    animation.duration = MZPresentationTransitionDefaultBounceDuration;
    animation.delegate = self;
    [animation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.view.layer addAnimation:animation forKey:@"bounceRight"];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.x = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.frame = formSheetRect;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end

@interface MZPresentationFadeTransition : MZTransition
@end

@implementation MZPresentationFadeTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleFade];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleFade];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    formSheetController.view.alpha = 0;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.alpha = 1;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        animations:^{
                         formSheetController.view.alpha = 0;
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end

@interface MZPresentationBounceTransition : MZTransition
@end

@implementation MZPresentationBounceTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleBounce];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleBounce];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bounceAnimation.fillMode = kCAFillModeBoth;
    bounceAnimation.duration = MZPresentationTransitionDefaultBounceDuration;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.values = @[
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)],
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
        [NSValue valueWithCATransform3D:CATransform3DIdentity]
    ];
    bounceAnimation.keyTimes = @[ @0.0f, @0.5f, @0.75f, @1.0f ];
    bounceAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
    ];
    bounceAnimation.delegate = self;
    [bounceAnimation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    formSheetController.view.transform = CGAffineTransformMakeScale(0.01, 0.01);

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[ @(1), @(1.2), @(0.01) ];
    animation.keyTimes = @[ @(0), @(0.4), @(1) ];
    animation.timingFunctions = @[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ];
    animation.duration = MZFormSheetPresentationViewControllerDefaultAnimationDuration;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [animation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.view.layer addAnimation:animation forKey:@"bounce"];

    formSheetController.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
}
@end

@interface MZPresentationDropDownTransition : MZTransition
@end

@implementation MZPresentationDropDownTransition
+ (void)load {
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleDropDown];
    [MZTransition registerTransitionClass:self forTransitionStyle:MZFormSheetPresentationTransitionStyleDropDown];
}

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGFloat y = formSheetController.view.center.y;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    animation.values = @[ @(y - [UIScreen mainScreen].bounds.size.height), @(y + 20), @(y - 10), @(y) ];
    animation.keyTimes = @[ @(0), @(0.5), @(0.75), @(1) ];
    animation.timingFunctions = @[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ];
    animation.duration = MZPresentationTransitionDefaultDropDownDuration;
    animation.delegate = self;
    [animation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.view.layer addAnimation:animation forKey:@"dropdown"];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler {
    CGPoint point = formSheetController.view.center;
    point.y += [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
                         formSheetController.view.center = point;
                         CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                         formSheetController.view.transform = CGAffineTransformMakeRotation(angle);
        }
        completion:^(BOOL finished) {
                         completionHandler();
        }];
}
@end