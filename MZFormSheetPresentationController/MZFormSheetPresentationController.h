//
//  MZFormSheetPresentationViewControllerAnimator.m
//  MZFormSheetPresentationViewControllerAnimator
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
#import <MZAppearance/MZAppearance.h>
#import "MZTransition.h"

typedef void(^MZFormSheetPresentationControllerTransitionBeginCompletionHandler)(UIViewController * __nonnull presentingViewController);
typedef void(^MZFormSheetPresentationControllerTransitionEndCompletionHandler)(UIViewController * __nonnull presentingViewController, BOOL completed);
typedef void(^MZFormSheetPresentationControllerTapHandler)(CGPoint location);
typedef CGRect(^MZFormSheetPresentationFrameConfigurationHandler)(UIView * __nonnull presentedView, CGRect currentFrame);

typedef NS_ENUM(NSInteger, MZFormSheetActionWhenKeyboardAppears) {
    MZFormSheetActionWhenKeyboardAppearsDoNothing = 0,
    MZFormSheetActionWhenKeyboardAppearsCenterVertically,
    MZFormSheetActionWhenKeyboardAppearsMoveToTop,
    MZFormSheetActionWhenKeyboardAppearsMoveToTopInset,
    MZFormSheetActionWhenKeyboardAppearsAboveKeyboard
};

@interface MZFormSheetPresentationController : UIPresentationController <MZAppearance>
@property (nonatomic, strong, readonly, null_resettable) UIView *dimmingView;

/**
 *  The preferred size for the container’s content. (required)
 */
@property (nonatomic, assign) CGSize contentViewSize MZ_APPEARANCE_SELECTOR;

/**
 Distance that the presented form sheet view is inset from the status bar in landscape orientation.
 By default, this is 6.0
 */
@property (nonatomic, assign) CGFloat landscapeTopInset MZ_APPEARANCE_SELECTOR;

/**
 Distance that the presented form sheet view is inset from the status bar in portrait orientation.
 By default, this is 66.0
 */
@property (nonatomic, assign) CGFloat portraitTopInset MZ_APPEARANCE_SELECTOR;

/**
 Returns whether the form sheet controller should dismiss after background view tap.
 By default, this is NO
 */
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundViewTap MZ_APPEARANCE_SELECTOR;

/**
 Returns whether the form sheet controller should user motion effect.
 By default, this is NO
 */
@property (nonatomic, assign) BOOL shouldUseMotionEffect MZ_APPEARANCE_SELECTOR;

/**
 Center form sheet horizontally.
 By default, this is YES
 */
@property (nonatomic, assign) BOOL shouldCenterHorizontally MZ_APPEARANCE_SELECTOR;

/**
 Center form sheet vertically.
 By default, this is NO
 */
@property (nonatomic, assign) BOOL shouldCenterVertically MZ_APPEARANCE_SELECTOR;


/**
 The background color of the background view.
 By default, this is a black at with a 0.5 alpha component
 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor MZ_APPEARANCE_SELECTOR;

/*
 The intensity of the blur effect. See UIBlurEffectStyle for valid options.
 By default, this is UIBlurEffectStyleLight
 */
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle MZ_APPEARANCE_SELECTOR;

/*
 Apply background blur effect, this property need to be set before form sheet presentation
 By default, this is NO
 */
@property (nonatomic, assign) BOOL shouldApplyBackgroundBlurEffect MZ_APPEARANCE_SELECTOR;

/**
 The movement action to use when the keyboard appears.
 By default, this is MZFormSheetActionWhenKeyboardAppears.
 */
@property (nonatomic, assign) MZFormSheetActionWhenKeyboardAppears movementActionWhenKeyboardAppears MZ_APPEARANCE_SELECTOR;


/**
 Returns whether the background view be touch transparent.
 If transparent is set to YES, background view will not recive touch and didTapOnBackgroundViewCompletionHandler will not be called.
 Also will not be possible to dismiss form sheet on background tap.
 By default, this is NO.
 */
@property (nonatomic, assign, getter = isTransparentTouchEnabled) BOOL transparentTouchEnabled MZ_APPEARANCE_SELECTOR;


/**
 The handler to call when user tap on background view.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTapHandler didTapOnBackgroundViewCompletionHandler;

/**
 *  Notifies the presentation controller that the presentation animations are about to start.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionBeginCompletionHandler presentationTransitionWillBeginCompletionHandler;

/**
 *  Notifies the presentation controller that the presentation animations finished.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionEndCompletionHandler presentationTransitionDidEndCompletionHandler;

/**
 *  Notifies the presentation controller that the dismissal animations are about to start.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionBeginCompletionHandler dismissalTransitionWillBeginCompletionHandler;

/**
 *  Notifies the presentation controller that the dismissal animations finished.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionEndCompletionHandler dismissalTransitionDidEndCompletionHandler;

/**
 *  This completion handler allow you to change frame during rotation and animations
 *  for presentedView
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationFrameConfigurationHandler frameConfigurationHandler;

/**
 *  This method recalculate presenting view frame
 */
- (void)layoutPresentingViewController;

@end
