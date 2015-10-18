//
//  MZFormSheetPresentationViewControllerInteractiveAnimator.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 18.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "MZFormSheetPresentationViewControllerInteractiveAnimator.h"
#import "MZFormSheetPresentationController.h"
#import "MZFormSheetPresentationViewController.h"

@interface MZFormSheetPresentationViewControllerInteractiveAnimator ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGRect sourceViewInitialFrame;
@property (nonatomic, assign) CGPoint panGestureRecognizerStartLocation;
@property (nonatomic, assign) MZFormSheetPanGestureDismissDirection dismissDirection;
@property (nonatomic, assign) MZFormSheetPanGestureDismissDirection currentDirection;
@end

@implementation MZFormSheetPresentationViewControllerInteractiveAnimator

#pragma mark - Pan Gesture

- (BOOL)shouldFailGestureRecognizerForDismissDirection:(MZFormSheetPanGestureDismissDirection)direction location:(CGPoint)location presentingView:(UIView *)presentingView {
    
    BOOL shouldFailUpAndDown = YES;
    BOOL shouldFailLeftAndRight = YES;
    
    if (direction & MZFormSheetPanGestureDismissDirectionUp || direction & MZFormSheetPanGestureDismissDirectionDown) {
        shouldFailUpAndDown = NO;
        
        if ((direction & MZFormSheetPanGestureDismissDirectionUp) && (direction & MZFormSheetPanGestureDismissDirectionDown)) {
            
            if ((location.y > presentingView.frame.origin.y && location.y < presentingView.frame.origin.y + presentingView.frame.size.height)) {
                shouldFailUpAndDown = YES;
            }
        } else if (direction & MZFormSheetPanGestureDismissDirectionUp) {
            if (location.y < presentingView.frame.origin.y + presentingView.frame.size.height) {
                shouldFailUpAndDown = YES;
            }
            
        } else if (direction & MZFormSheetPanGestureDismissDirectionDown) {
            if (location.y > presentingView.frame.origin.y) {
                shouldFailUpAndDown = YES;
            }
        }
    }
    
    if (direction & MZFormSheetPanGestureDismissDirectionLeft || direction & MZFormSheetPanGestureDismissDirectionRight) {
        shouldFailLeftAndRight = NO;
        
        if ((direction & MZFormSheetPanGestureDismissDirectionLeft) && (direction & MZFormSheetPanGestureDismissDirectionRight)) {
            
            if ((location.x > presentingView.frame.origin.x && location.x < presentingView.frame.origin.x + presentingView.frame.size.width)) {
                shouldFailLeftAndRight = YES;
            }
        } else if (direction & MZFormSheetPanGestureDismissDirectionLeft) {
            if (location.x < presentingView.frame.origin.x + presentingView.frame.size.width) {
                shouldFailLeftAndRight = YES;
            }
            
        } else if (direction & MZFormSheetPanGestureDismissDirectionRight) {
            if (location.x > presentingView.frame.origin.x) {
                shouldFailLeftAndRight = YES;
            }
        }
    }
    
    return shouldFailLeftAndRight && shouldFailUpAndDown;
}

- (MZFormSheetPanGestureDismissDirection)panDirectionForLocation:(CGPoint)location dismissDirection:(MZFormSheetPanGestureDismissDirection)dismissDirection {
    
    if ((dismissDirection & MZFormSheetPanGestureDismissDirectionDown) && location.y > self.sourceViewInitialFrame.origin.y && self.panGestureRecognizerStartLocation.y < self.sourceViewInitialFrame.origin.y) {
        
        return MZFormSheetPanGestureDismissDirectionDown;
        
    } else if (dismissDirection & MZFormSheetPanGestureDismissDirectionUp && location.y < self.sourceViewInitialFrame.origin.y + self.sourceViewInitialFrame.size.height && self.panGestureRecognizerStartLocation.y > self.sourceViewInitialFrame.origin.y + self.sourceViewInitialFrame.size.height) {
        
        return MZFormSheetPanGestureDismissDirectionUp;
        
    } else if (dismissDirection & MZFormSheetPanGestureDismissDirectionRight && location.x > self.sourceViewInitialFrame.origin.x && self.panGestureRecognizerStartLocation.x < self.sourceViewInitialFrame.origin.x) {
        return MZFormSheetPanGestureDismissDirectionRight;
        
    } else if (dismissDirection & MZFormSheetPanGestureDismissDirectionLeft && location.x < self.sourceViewInitialFrame.origin.x + self.sourceViewInitialFrame.size.width && self.panGestureRecognizerStartLocation.x > self.sourceViewInitialFrame.origin.x + self.sourceViewInitialFrame.size.width) {
        return MZFormSheetPanGestureDismissDirectionLeft;
    } else {
        return MZFormSheetPanGestureDismissDirectionNone;
    }
    return MZFormSheetPanGestureDismissDirectionNone;
}

- (CGFloat)animationRatioForLocation:(CGPoint)location dismissDirection:(MZFormSheetPanGestureDismissDirection)dismissDirection {
    
    if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionDown) {
        
        return (location.y - self.sourceViewInitialFrame.origin.y) / (CGRectGetHeight(self.transitionContext.containerView.bounds) - self.sourceViewInitialFrame.origin.y);

    } else if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionUp) {
        
        return 1.0 - (location.y / CGRectGetMaxY(self.sourceViewInitialFrame));
        
    } else if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionRight) {

        return (location.x - self.sourceViewInitialFrame.origin.x) / (CGRectGetWidth(self.transitionContext.containerView.bounds) - self.sourceViewInitialFrame.origin.x);
        
    } else if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionLeft) {
        
        return 1.0 - (location.x / CGRectGetMaxX(self.sourceViewInitialFrame));
    }
    return 0;
}

- (void)handleDismissalPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer dismissDirection:(MZFormSheetPanGestureDismissDirection)dismissDirection forPresentingView:(UIView *)presentingView fromViewController:(UIViewController *)viewController {
    
    self.dismissDirection = dismissDirection;
    
    CGPoint location = [recognizer locationInView:viewController.presentationController.containerView];
    CGPoint velocity = [recognizer velocityInView:viewController.presentationController.containerView];
    
    CGFloat animationRatio = [self animationRatioForLocation:location dismissDirection:dismissDirection];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if ([self shouldFailGestureRecognizerForDismissDirection:dismissDirection location:location presentingView:presentingView]) {
            recognizer.enabled = NO;
            recognizer.enabled = YES;
            return;
        }
        
        self.panGestureRecognizerStartLocation = location;
        self.sourceViewInitialFrame = presentingView.frame;
        [viewController dismissViewControllerAnimated:YES completion:nil];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionDown) {

            self.currentDirection = MZFormSheetPanGestureDismissDirectionDown;
            [self updateInteractiveTransition:animationRatio];
            
        } else if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionUp) {
            
            self.currentDirection = MZFormSheetPanGestureDismissDirectionUp;
            [self updateInteractiveTransition:animationRatio];
            
        } else if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionRight) {
            self.currentDirection = MZFormSheetPanGestureDismissDirectionRight;
            [self updateInteractiveTransition:animationRatio];
            
        } else if ([self panDirectionForLocation:location dismissDirection:dismissDirection] == MZFormSheetPanGestureDismissDirectionLeft) {
            self.currentDirection = MZFormSheetPanGestureDismissDirectionLeft;
            [self updateInteractiveTransition:animationRatio];
        } else {
            self.currentDirection = MZFormSheetPanGestureDismissDirectionNone;
            [self updateInteractiveTransition:0];
        }
 
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat velocityForSelectedDirection = velocity.y;
        
        if (animationRatio > 0.5 || velocityForSelectedDirection > 300) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
        
    }
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    self.sourceViewInitialFrame = sourceView.frame;
}

- (void)animationEnded:(BOOL)transitionCompleted {
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
    
    CGFloat distanceToPass = 0;
    
    if (percentComplete < 0) {
        percentComplete = 0;
    }
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZFormSheetPresentationController *presentationController = (id)[fromViewController presentationController];
    
    presentationController.dimmingView.alpha = (1.0 - percentComplete);
    
    CGRect sourceViewFrame = sourceView.frame;
    
    if (self.currentDirection == MZFormSheetPanGestureDismissDirectionLeft) {
        distanceToPass = CGRectGetWidth(transitionContext.containerView.bounds) - CGRectGetMinX(self.sourceViewInitialFrame);
        
        sourceViewFrame.origin.x = CGRectGetMinX(self.sourceViewInitialFrame) - (distanceToPass * percentComplete);
        
    } else if (self.currentDirection == MZFormSheetPanGestureDismissDirectionRight) {
        distanceToPass = CGRectGetWidth(transitionContext.containerView.bounds) - CGRectGetMinX(self.sourceViewInitialFrame);
        
        sourceViewFrame.origin.x = CGRectGetMinX(self.sourceViewInitialFrame) + (distanceToPass * percentComplete);
        
    } else if (self.currentDirection == MZFormSheetPanGestureDismissDirectionUp) {
        distanceToPass = CGRectGetMaxY(self.sourceViewInitialFrame);
        
        sourceViewFrame.origin.y = CGRectGetMinY(self.sourceViewInitialFrame) - (distanceToPass * percentComplete);
        
    } else if (self.currentDirection == MZFormSheetPanGestureDismissDirectionDown) {
        distanceToPass = CGRectGetHeight(transitionContext.containerView.bounds) - CGRectGetMinY(self.sourceViewInitialFrame);
        
        sourceViewFrame.origin.y = CGRectGetMinY(self.sourceViewInitialFrame) + (distanceToPass * percentComplete);
    }
    
    sourceView.frame = sourceViewFrame;
}

- (void)finishInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZFormSheetPresentationController *presentationController = (id)[fromViewController presentationController];
    
    CGRect sourceViewFrame = sourceView.frame;
    
    
    if (self.currentDirection == MZFormSheetPanGestureDismissDirectionLeft) {
        sourceViewFrame.origin.x = -sourceViewFrame.size.width;
        
    } else if (self.currentDirection == MZFormSheetPanGestureDismissDirectionRight) {
        sourceViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
        
    } else if (self.currentDirection == MZFormSheetPanGestureDismissDirectionUp) {
        sourceViewFrame.origin.y = -sourceViewFrame.size.height;
        
    } else if (self.currentDirection == MZFormSheetPanGestureDismissDirectionDown) {
        sourceViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    }
    
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration delay:0 options:0 animations:^{
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
    
    [UIView animateWithDuration:MZFormSheetPresentationViewControllerDefaultAnimationDuration delay:0 options:0 animations:^{
        presentationController.dimmingView.alpha = 1.0;
        sourceView.frame = self.sourceViewInitialFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:NO];
    }];
}


@end
