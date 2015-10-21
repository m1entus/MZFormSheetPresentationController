//
//  MZFormSheetContentSizingNavigationAnimator.h
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 21.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface MZFormSheetContentSizingNavigationControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end
