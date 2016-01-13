//
//  MZFormSheetPresentationViewController.h
//  MZFormSheetPresentationViewController
//
//  Created by Michał Zaborowski on 24.02.2015.
//  Copyright (c) 2015 Michał Zaborowski. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "MZTransition.h"
#import "MZFormSheetPresentationController.h"
#import <MZAppearance/MZAppearance.h>
#import "MZFormSheetPresentationViewControllerAnimatedTransitioning.h"
#import "MZFormSheetPresentationViewControllerInteractiveTransitioning.h"
#import "MZFormSheetPresentationContentSizing.h"

extern CGFloat const MZFormSheetPresentationViewControllerDefaultAnimationDuration;

typedef void(^MZFormSheetPresentationViewControllerCompletionHandler)(UIViewController * __nonnull contentViewController);

@interface MZFormSheetPresentationViewController : UIViewController <MZAppearance, MZFormSheetPresentationContentSizing, UIViewControllerTransitioningDelegate>


/**
 *  The view controller responsible for the content portion of the popup.
 */

@property (nonatomic, readonly, strong, nullable) UIViewController *contentViewController;

@property (nonatomic, readonly, nullable) MZFormSheetPresentationController *presentationController;

/**
 Corner radius of content view
 By default, this is 5.0
 */
@property (nonatomic, assign) CGFloat contentViewCornerRadius MZ_APPEARANCE_SELECTOR;

/**
 The blur radius (in points) used to render the layer’s shadow.
 By default, this is 6.0
 */
@property (nonatomic, assign) CGFloat shadowRadius MZ_APPEARANCE_SELECTOR;

/**
 *  Allow dismiss the modals by swiping up/down/left/right on the navigation bar.
 *  By default, this is None.
 */
@property (nonatomic, assign) MZFormSheetPanGestureDismissDirection interactivePanGestureDissmisalDirection;

/**
 *  Allow dismiss the modals by swiping up/down/left/right on the presented view.
 *  By default, this is NO.
 */
@property (nonatomic, assign) BOOL allowDismissByPanningPresentedView;

/**
 The transition style to use when presenting the receiver.
 By default, this is MZFormSheetPresentationTransitionStyleSlideFromTop.
 */
@property (nonatomic, assign) MZFormSheetPresentationTransitionStyle contentViewControllerTransitionStyle MZ_APPEARANCE_SELECTOR;

@property (nonatomic, strong, null_resettable) id <MZFormSheetPresentationViewControllerAnimatedTransitioning> animatorForPresentationController;


@property (nonatomic, strong, null_resettable) UIPercentDrivenInteractiveTransition <MZFormSheetPresentationViewControllerInteractiveTransitioning> *interactionAnimatorForPresentationController;

/**
 The handler to call when presented form sheet is before entry transition and its view will show on window.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationViewControllerCompletionHandler willPresentContentViewControllerHandler;

/**
 The handler to call when presented form sheet is after entry transition animation.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationViewControllerCompletionHandler didPresentContentViewControllerHandler;

/**
 The handler to call when presented form sheet will be dismiss, this is called before out transition animation.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationViewControllerCompletionHandler willDismissContentViewControllerHandler;

/**
 The handler to call when presented form sheet is after dismiss.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationViewControllerCompletionHandler didDismissContentViewControllerHandler;

/**
 Returns an initialized popup controller object with just a view.
 @param view This parameter must not be nil.
 */
- (nonnull instancetype)initWithContentView:(UIView * __nonnull)contentView;

/**
 Returns an initialized popup controller object.
 @param viewController This parameter must not be nil.
 */
- (nonnull instancetype)initWithContentViewController:(UIViewController * __nonnull)viewController;

@end

@interface UIViewController (MZFormSheetPresentationViewController)
- (nullable MZFormSheetPresentationViewController *)mz_formSheetPresentingPresentationController;
- (nullable MZFormSheetPresentationViewController *)mz_formSheetPresentedPresentationController;
@end
