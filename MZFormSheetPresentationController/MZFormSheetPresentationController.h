//
//  MZFormSheetPresentationController.h
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 17.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

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

@interface MZFormSheetPresentationController : UIPresentationController


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
 Corner radius of content view
 By default, this is 5.0
 */
@property (nonatomic, assign) CGFloat presentedViewCornerRadius MZ_APPEARANCE_SELECTOR;

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

@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionBeginCompletionHandler presentationTransitionWillBeginCompletionHandler;
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionEndCompletionHandler presentationTransitionDidEndCompletionHandler;

@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionBeginCompletionHandler dismissalTransitionWillBeginCompletionHandler;
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTransitionEndCompletionHandler dismissalTransitionDidEndCompletionHandler;

@property (nonatomic, copy, nonnull) MZFormSheetPresentationFrameConfigurationHandler frameConfigurationHandler;

@end
