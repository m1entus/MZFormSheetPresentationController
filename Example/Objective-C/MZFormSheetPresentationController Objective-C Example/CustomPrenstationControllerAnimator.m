//
//  CustomPrenstationControllerAnimator.m
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 17.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "CustomPrenstationControllerAnimator.h"

@interface CustomPrenstationControllerAnimator ()
@property (nonatomic, strong) UIView *transitionContextContainerView;
@property (nonatomic, strong) UIView *customBackgorundView;
@end

@implementation CustomPrenstationControllerAnimator

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.35;
        self.customBackgorundView = [[UIView alloc] init];
        self.customBackgorundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
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

    self.customBackgorundView.frame = containerView.bounds;
    self.customBackgorundView.alpha = 0.0;
    [containerView addSubview:self.customBackgorundView];
    
    [containerView addSubview:targetView];
    targetView.alpha = 0.0;
    
    [UIView animateWithDuration:self.duration animations:^{
        targetView.alpha = 1.0;
        self.customBackgorundView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [sourceView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
    }];
}

- (void)animateTransitionForDismiss:(id<UIViewControllerContextTransitioning>)transitionContext sourceViewController:(UIViewController *)sourceViewController sourceView:(UIView *)sourceView targetViewController:(UIViewController *)targetViewController targetView:(UIView *)targetView {
    UIView *containerView = [transitionContext containerView];
    
    [containerView insertSubview:targetView belowSubview:sourceView];
    sourceView.alpha = 1.0;
    
    [UIView animateWithDuration:self.duration animations:^{
        self.customBackgorundView.alpha = 0.0;
        sourceView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.customBackgorundView removeFromSuperview];
            [sourceView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

@end
