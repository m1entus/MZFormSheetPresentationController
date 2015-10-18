//
//  MZFormSheetPresentationViewControllerInteractiveTransitioning.h
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 18.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MZFormSheetPanGestureDismissDirection) {
    MZFormSheetPanGestureDismissDirectionNone = 0,
    MZFormSheetPanGestureDismissDirectionUp = 1 << 0,
    MZFormSheetPanGestureDismissDirectionDown = 1 << 1,
    MZFormSheetPanGestureDismissDirectionLeft = 1 << 2,
    MZFormSheetPanGestureDismissDirectionRight = 1 << 3,
//    MZFormSheetPanGestureDismissDirectionAll = MZFormSheetPanGestureDismissDirectionUp | MZFormSheetPanGestureDismissDirectionDown | MZFormSheetPanGestureDismissDirectionLeft | MZFormSheetPanGestureDismissDirectionRight
};

@protocol MZFormSheetPresentationViewControllerInteractiveTransitioning <NSObject>
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
- (void)handleDismissalPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer dismissDirection:(MZFormSheetPanGestureDismissDirection)dismissDirection forPresentingView:(UIView *)presentingView fromViewController:(UIViewController *)viewController;
@end
