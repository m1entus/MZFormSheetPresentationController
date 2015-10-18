//
//  MZFormSheetPresentationViewControllerInteractiveAnimator.h
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 18.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetPresentationViewControllerInteractiveTransitioning.h"

@interface MZFormSheetPresentationViewControllerInteractiveAnimator : UIPercentDrivenInteractiveTransition <MZFormSheetPresentationViewControllerInteractiveTransitioning>
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
@end
