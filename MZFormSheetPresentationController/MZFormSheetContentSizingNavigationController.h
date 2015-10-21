//
//  MZFormSheetContentSizingNavigationController.h
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 21.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetContentSizingNavigationControllerAnimator.h"
#import "MZFormSheetPresentationContentSizing.h"

@interface MZFormSheetContentSizingNavigationController : UINavigationController <UINavigationControllerDelegate, MZFormSheetPresentationContentSizing>
@property (nonatomic, strong, readonly) MZFormSheetContentSizingNavigationControllerAnimator *animator;
@end
