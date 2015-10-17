//
//  MZFormSheetPresentationControllerAnimatorProtocol.h
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 17.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MZFormSheetPresentationControllerAnimatorProtocol <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;

/* Needed to be able to turn on transparentTouchEnabled */
@property (nonatomic, readonly) UIView *transitionContextContainerView;
@end
