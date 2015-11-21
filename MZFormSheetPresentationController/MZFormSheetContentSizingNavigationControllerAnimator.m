//
//  MZFormSheetContentSizingNavigationAnimator.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 21.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "MZFormSheetContentSizingNavigationControllerAnimator.h"
#import "MZFormSheetPresentationController.h"
#import "MZFormSheetPresentationViewController.h"

@implementation MZFormSheetContentSizingNavigationControllerAnimator

- (instancetype)init {
    if (self = [super init]) {
        _duration = 0.3;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *targetView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIViewController *targetViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:sourceView];
    [containerView addSubview:targetView];
    targetView.alpha = 0.0;
    targetView.frame = [transitionContext finalFrameForViewController:targetViewController];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         targetView.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         [sourceView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
    
    MZFormSheetPresentationController *presentationController = (id)targetViewController.mz_formSheetPresentingPresentationController.presentationController;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [presentationController layoutPresentingViewController];
    } completion:nil];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

@end
