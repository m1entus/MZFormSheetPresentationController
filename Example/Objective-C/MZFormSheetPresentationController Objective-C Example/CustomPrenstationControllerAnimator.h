//
//  CustomPrenstationControllerAnimator.h
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 17.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZFormSheetPresentationViewControllerAnimatedTransitioning.h"
@import UIKit;

@interface CustomPrenstationControllerAnimator : NSObject <MZFormSheetPresentationViewControllerAnimatedTransitioning>
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
@end
