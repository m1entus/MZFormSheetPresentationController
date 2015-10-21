//
//  MZFormSheetPresentationViewControllerAnimator.m
//  MZFormSheetPresentationViewControllerAnimator
//
//  Created by Michał Zaborowski on 24.02.2015.
//  Copyright (c) 2015 Michał Zaborowski. All rights reserved.
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

#import "MZFormSheetPresentationViewControllerAnimator.h"
#import <objc/runtime.h>
#import "MZFormSheetPresentationController.h"

CGFloat const MZFormSheetPresentationViewControllerAnimatorDefaultTransitionDuration = 0.35;

@implementation MZFormSheetPresentationViewControllerAnimator

+ (instancetype)animatorForTransitionStyle:(MZFormSheetPresentationTransitionStyle)transitionStyle {
    MZFormSheetPresentationViewControllerAnimator *animator = [[[self class] alloc] init];

    Class transitionClass = [MZTransition sharedTransitionClasses][@(transitionStyle)];
    id<MZFormSheetPresentationViewControllerTransitionProtocol> transition = [[transitionClass alloc] init];
    animator.transition = transition;

    return animator;
}

- (instancetype)init {
    if (self = [super init]) {
        self.transitionDuration = MZFormSheetPresentationViewControllerAnimatorDefaultTransitionDuration;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    if (self.interactive) {
        return;
    }

    UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *targetViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *targetView = [transitionContext viewForKey:UITransitionContextToViewKey];

    if (self.isPresenting) {
        [self animateTransitionForPresentation:transitionContext sourceViewController:sourceViewController sourceView:sourceView targetViewController:targetViewController targetView:targetView];
    } else {
        [self animateTransitionForDismiss:transitionContext sourceViewController:sourceViewController sourceView:sourceView targetViewController:targetViewController targetView:targetView];
    }
}

- (void)animateTransitionForPresentation:(id<UIViewControllerContextTransitioning>)transitionContext sourceViewController:(UIViewController *)sourceViewController sourceView:(UIView *)sourceView targetViewController:(UIViewController *)targetViewController targetView:(UIView *)targetView {

    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:targetView];

    if (self.transition) {

        [self.transition entryFormSheetControllerTransition:targetViewController completionHandler:^{
            [sourceView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        [sourceView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }
}

- (void)animateTransitionForDismiss:(id<UIViewControllerContextTransitioning>)transitionContext sourceViewController:(UIViewController *)sourceViewController sourceView:(UIView *)sourceView targetViewController:(UIViewController *)targetViewController targetView:(UIView *)targetView {
    UIView *containerView = [transitionContext containerView];

    [containerView insertSubview:targetView belowSubview:sourceView];

    if (self.transition) {

        [self.transition exitFormSheetControllerTransition:sourceViewController completionHandler:^{
            [sourceView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        [sourceView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

@end
