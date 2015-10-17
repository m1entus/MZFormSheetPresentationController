//
//  CustomTransition.m
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

#import "CustomTransition.h"
#import "MZFormSheetPresentationViewController.h"

@implementation CustomTransition

- (void)entryFormSheetControllerTransition:(nonnull UIViewController *)formSheetController
                         completionHandler:(nonnull MZTransitionCompletionHandler)completionHandler {
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bounceAnimation.fillMode = kCAFillModeBoth;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.duration = 0.4;
    bounceAnimation.values = @[
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    bounceAnimation.timingFunctions = @[
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    bounceAnimation.delegate = self;
    [bounceAnimation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.view.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
}

- (void)exitFormSheetControllerTransition:(nonnull UIViewController *)formSheetController
                        completionHandler:(nonnull MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.view.frame;
    formSheetRect.origin.x = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         formSheetController.view.frame = formSheetRect;
                     }
                     completion:^(BOOL finished) {
                         completionHandler();
                     }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completionHandler)(void) = [anim valueForKey:@"completionHandler"];
    if (completionHandler) {
        completionHandler();
    }
}

@end
