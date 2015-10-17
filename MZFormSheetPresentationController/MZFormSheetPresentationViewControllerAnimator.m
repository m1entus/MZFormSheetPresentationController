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

@interface MZFormSheetPresentationViewControllerAnimator ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGRect sourceViewInitialFrame;
@end

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

    UIView *sourceView = [transitionContext respondsToSelector:@selector(viewForKey:)] ? [transitionContext viewForKey:UITransitionContextFromViewKey] : sourceViewController.view;
    UIView *targetView = [transitionContext respondsToSelector:@selector(viewForKey:)] ? [transitionContext viewForKey:UITransitionContextToViewKey] : sourceViewController.view;

    if (self.isPresenting) {
        [self animateTransitionForPresentation:transitionContext sourceViewController:sourceViewController sourceView:sourceView targetViewController:targetViewController targetView:targetView];
    } else {
        [self animateTransitionForDismiss:transitionContext sourceViewController:sourceViewController sourceView:sourceView targetViewController:targetViewController targetView:targetView];
    }
}

- (void)animateTransitionForPresentation:(id<UIViewControllerContextTransitioning>)transitionContext sourceViewController:(UIViewController *)sourceViewController sourceView:(UIView *)sourceView targetViewController:(UIViewController *)targetViewController targetView:(UIView *)targetView {

    
    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:targetView];
    targetView.frame = [transitionContext finalFrameForViewController:targetViewController];
    
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

#pragma mark - UIViewControllerInteractiveTransitioning Methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    self.sourceViewInitialFrame = sourceView.frame;
}

- (void)animationEnded:(BOOL)transitionCompleted {
    self.interactive = NO;
    self.presenting = NO;
    if (transitionCompleted) {
        if (self.presenting == NO) {
            self.transitionContext = nil;
        }
    }
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods


- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGFloat heightToPass = CGRectGetHeight(transitionContext.containerView.bounds) - CGRectGetMinY(self.sourceViewInitialFrame);
    
    if (percentComplete < 0) {
        percentComplete = 0;
    }
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZFormSheetPresentationController *presentationController = (id)[fromViewController presentationController];
    
    presentationController.dimmingView.alpha = (1.0 - percentComplete);
    
    CGRect sourceViewFrame = sourceView.frame;
    sourceViewFrame.origin.y = self.sourceViewInitialFrame.origin.y + (heightToPass * percentComplete);
    sourceView.frame = sourceViewFrame;
}

- (void)finishInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZFormSheetPresentationController *presentationController = (id)[fromViewController presentationController];
    
    CGRect sourceViewFrame = sourceView.frame;
    sourceViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerAnimatorDefaultTransitionDuration delay:0 options:0 animations:^{
        sourceView.frame = sourceViewFrame;
        presentationController.dimmingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)cancelInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZFormSheetPresentationController *presentationController = (id)[fromViewController presentationController];
    
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerAnimatorDefaultTransitionDuration delay:0 options:0 animations:^{
        presentationController.dimmingView.alpha = 1.0;
        sourceView.frame = self.sourceViewInitialFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:NO];
    }];
}

@end
