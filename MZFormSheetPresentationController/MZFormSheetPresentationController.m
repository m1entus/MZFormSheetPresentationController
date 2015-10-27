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

#import "MZFormSheetPresentationController.h"
#import <objc/runtime.h>
#import "MZBlurEffectAdapter.h"
#import "MZMethodSwizzler.h"
#import "MZFormSheetPresentationContentSizing.h"

CGFloat const MZFormSheetPresentationControllerDefaultAboveKeyboardMargin = 20;

@interface MZFormSheetPresentationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIVisualEffectView *blurBackgroundView;
@property (nonatomic, strong) MZBlurEffectAdapter *blurEffectAdapter;
@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapGestureRecognizer;

@property (nonatomic, assign, getter=isKeyboardVisible) BOOL keyboardVisible;
@property (nonatomic, strong) NSValue *screenFrameWhenKeyboardVisible;
@end

@implementation MZFormSheetPresentationController

- (void)dealloc {
    for (UIGestureRecognizer *gestureRecognizer in [self.containerView.gestureRecognizers copy]) {
        [self.containerView removeGestureRecognizer:gestureRecognizer];
    }
    
    [self removeKeyboardNotifications];
    [self.dimmingView removeGestureRecognizer:self.backgroundTapGestureRecognizer];
    self.backgroundTapGestureRecognizer = nil;
}

#pragma mark - Appearance

+ (void)load {
    @autoreleasepool {
        MZFormSheetPresentationController *appearance = [self appearance];
        [appearance setContentViewSize:CGSizeMake(284.0, 284.0)];
        [appearance setPortraitTopInset:66.0];
        [appearance setLandscapeTopInset:6.0];
        [appearance setShouldCenterHorizontally:YES];
        [appearance setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [appearance setBlurEffectStyle:UIBlurEffectStyleLight];
    }
}

+ (id)appearance {
    return [MZAppearance appearanceForClass:[self class]];
}

#pragma mark - Getters

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.frame];
    }
    return _dimmingView;
}

#pragma mark - Setters

- (void)setTransparentTouchEnabled:(BOOL)transparentTouchEnabled {
    if (_transparentTouchEnabled != transparentTouchEnabled) {
        _transparentTouchEnabled = transparentTouchEnabled;
        if (_transparentTouchEnabled) {
            [self turnOnTransparentTouch];
        } else {
            [self turnOffTransparentTouch];
        }
    }
}

- (void)setContentViewSize:(CGSize)contentViewSize {
    if (!CGSizeEqualToSize(_contentViewSize, contentViewSize)) {
        _contentViewSize = contentViewSize;
        [self setupFormSheetViewControllerFrame];
    }
}

- (BOOL)isPresentedViewControllerUsingModifiedContentFrame {
    if ([self.presentedViewController conformsToProtocol:@protocol(MZFormSheetPresentationContentSizing)]) {
        if ([self.presentedViewController respondsToSelector:@selector(shouldUseContentViewFrameForPresentationController:)]) {
            id <MZFormSheetPresentationContentSizing> presentedViewController = (id <MZFormSheetPresentationContentSizing>)self.presentedViewController;
            return [presentedViewController shouldUseContentViewFrameForPresentationController:self];
        }
    }
    return NO;
}

- (CGRect)modifiedContentViewFrameForFrame:(CGRect)frame {
    id <MZFormSheetPresentationContentSizing> presentedViewController = (id <MZFormSheetPresentationContentSizing>)self.presentedViewController;
    return [presentedViewController contentViewFrameForPresentationController:self currentFrame:frame];
}

- (CGSize)internalContentViewSize {
    if ([self isPresentedViewControllerUsingModifiedContentFrame]) {
        CGRect modifiedFrame = [self modifiedContentViewFrameForFrame:(CGRect){ .origin = self.presentedView.frame.origin, .size = self.contentViewSize }];
        return modifiedFrame.size;
    }
    return self.contentViewSize;
}


- (void)setBackgroundColor:(UIColor * __nullable)backgroundColor {
    _backgroundColor = backgroundColor;
    self.dimmingView.backgroundColor = _backgroundColor;
}

- (void)setShouldApplyBackgroundBlurEffect:(BOOL)shouldApplyBackgroundBlurEffect {
    if (_shouldApplyBackgroundBlurEffect != shouldApplyBackgroundBlurEffect) {
        _shouldApplyBackgroundBlurEffect = shouldApplyBackgroundBlurEffect;
        self.backgroundColor = [UIColor clearColor];
        [self setupBackgroundBlurView];
    }
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    if (_blurEffectStyle != blurEffectStyle) {
        _blurEffectStyle = blurEffectStyle;
        if (self.shouldApplyBackgroundBlurEffect) {
            MZBlurEffectAdapter *blurEffect = self.blurEffectAdapter;
            if (blurEffectStyle != blurEffect.blurEffectStyle) {
                [self setupBackgroundBlurView];
            }
        }
    }
}

#pragma mark - Init

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        
        [[[self class] appearance] applyInvocationTo:self];
        
        [self addKeyboardNotifications];
    }
    return self;
}

#pragma mark - Public

- (void)layoutPresentingViewController {
    [self setupFormSheetViewControllerFrame];
}

#pragma mark - Private

- (void)setupBackgroundBlurView {
    [self.blurBackgroundView removeFromSuperview];
    self.blurBackgroundView = nil;
    
    if (self.shouldApplyBackgroundBlurEffect) {
        
        self.blurEffectAdapter = [MZBlurEffectAdapter effectWithStyle:self.blurEffectStyle];
        UIVisualEffect *visualEffect = self.blurEffectAdapter.blurEffect;
        self.blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        
        self.blurBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.blurBackgroundView.frame = self.dimmingView.bounds;
        self.blurBackgroundView.translatesAutoresizingMaskIntoConstraints = YES;
        self.blurBackgroundView.userInteractionEnabled = NO;
        
        self.dimmingView.backgroundColor = [UIColor clearColor];
        [self.dimmingView addSubview:self.blurBackgroundView];
    } else {
        self.dimmingView.backgroundColor = self.backgroundColor;
    }
    
}

- (CGFloat)yCoordinateBelowStatusBar {
#if TARGET_OS_TV
    return 0;
#else
    return [UIApplication sharedApplication].statusBarFrame.size.height;
#endif
}

- (CGFloat)topInset {
#if TARGET_OS_TV
    return self.landscapeTopInset;
#else
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return self.portraitTopInset + [self yCoordinateBelowStatusBar];
    } else {
        return self.landscapeTopInset + [self yCoordinateBelowStatusBar];
    }
#endif
}

#pragma mark - Transparent Touch

- (void)turnOnTransparentTouch {
    __weak typeof(self) weakSelf = self;
    [self.containerView swizzleMethod:@selector(pointInside:withEvent:) withReplacement:MZMethodReplacementProviderBlock {
        return MZMethodReplacement(BOOL, UIView *, CGPoint point, UIEvent *event) {
            if (!CGRectContainsPoint(weakSelf.presentedView.frame, point)){
                return NO;
            }
            return YES;
        };
    }];
}

- (void)turnOffTransparentTouch {
    [self.containerView deswizzleMethod:@selector(pointInside:withEvent:)];
}

#pragma mark - Motion Effect

- (void)setupMotionEffectToPresentedView {
    UIMotionEffectGroup *effects = [[UIMotionEffectGroup alloc] init];
    
    UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontal.minimumRelativeValue = @-14;
    horizontal.maximumRelativeValue = @14;
    
    UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    vertical.minimumRelativeValue = @-18;
    vertical.maximumRelativeValue = @18;
    
    effects.motionEffects = @[horizontal, vertical];
    [self.presentedView addMotionEffect:effects];
}

#pragma mark - SuperClass Override

- (void)presentationTransitionWillBegin {
    
    if (self.presentationTransitionWillBeginCompletionHandler) {
        self.presentationTransitionWillBeginCompletionHandler(self.presentedViewController);
    }
    
    if (self.shouldUseMotionEffect) {
        [self setupMotionEffectToPresentedView];
    }
    
    if (self.shouldDismissOnBackgroundViewTap) {
        [self addBackgroundTapGestureRecognizer];
    }
    
    if (self.transparentTouchEnabled) {
        [self turnOffTransparentTouch];
        [self turnOnTransparentTouch];
    }
    
    [self setupBackgroundBlurView];

    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0;
    [self.containerView addSubview:self.dimmingView];

    // this is some kind of bug :<, if we will delete this line, then inside custom animator
    // we need to set finalFrameForViewController to targetView
    [self presentedView].frame = [self frameOfPresentedViewInContainerView];
    [self setupFormSheetViewControllerFrame];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            self.dimmingView.alpha = 1.0;
        }];
    } completion:nil];
    
    [super presentationTransitionWillBegin];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
    if (self.presentationTransitionDidEndCompletionHandler) {
        self.presentationTransitionDidEndCompletionHandler(self.presentedViewController, completed);
    }
}

- (void)dismissalTransitionWillBegin {
    if (self.presentationTransitionWillBeginCompletionHandler) {
        self.presentationTransitionWillBeginCompletionHandler(self.presentedViewController);
    }
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            self.dimmingView.alpha = 0.0;
        }];
    } completion:nil];
    
    [super dismissalTransitionWillBegin];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {

    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
    
    if (self.dismissalTransitionDidEndCompletionHandler) {
        self.dismissalTransitionDidEndCompletionHandler(self.presentingViewController, completed);
    }
    
    [super dismissalTransitionDidEnd:completed];
}

- (CGRect)frameOfPresentedViewInContainerView {
    return [self formSheetViewControllerFrame];
}

- (BOOL)shouldPresentInFullscreen {
    return YES;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

#pragma mark - UIGestureRecognizer

- (void)addBackgroundTapGestureRecognizer {
    [self removeBackgroundTapGestureRecognizer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapGestureRecognizer:)];
    tapGesture.delegate = self;
    self.backgroundTapGestureRecognizer = tapGesture;
    
    [self.dimmingView addGestureRecognizer:tapGesture];
}

- (void)removeBackgroundTapGestureRecognizer {
    [self.dimmingView removeGestureRecognizer:self.backgroundTapGestureRecognizer];
    self.backgroundTapGestureRecognizer = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // recive touch only on background window
    if (touch.view == self.dimmingView) {
        return YES;
    }
    return NO;
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    // If last form sheet controller will begin dismiss, don't want to recive touch
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGesture locationInView:[tapGesture.view superview]];
        if (self.didTapOnBackgroundViewCompletionHandler) {
            self.didTapOnBackgroundViewCompletionHandler(location);
        }
        if (self.shouldDismissOnBackgroundViewTap) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - UIKeyboard Notifications

- (void)addKeyboardNotifications {
    [self removeKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)willShowKeyboardNotification:(NSNotification *)notification {
    CGRect screenRect = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    screenRect.size.height = [UIScreen mainScreen].bounds.size.height - screenRect.size.height;
    screenRect.size.width = [UIScreen mainScreen].bounds.size.width;
    screenRect.origin.y = 0;
    
    self.screenFrameWhenKeyboardVisible = [NSValue valueWithCGRect:screenRect];
    self.keyboardVisible = YES;
    
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         [self setupFormSheetViewControllerFrame];
                     } completion:nil];
}

- (void)willHideKeyboardNotification:(NSNotification *)notification {
    self.keyboardVisible = NO;
    self.screenFrameWhenKeyboardVisible = nil;
    
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         [self setupFormSheetViewControllerFrame];
                     } completion:nil];
}

#pragma mark - Frame Configuration

- (CGRect)formSheetViewControllerFrame {
    CGRect formSheetRect = self.presentedView.frame;
    formSheetRect.size = self.internalContentViewSize;
    
    if (self.shouldCenterHorizontally) {
        formSheetRect.origin.x = CGRectGetMidX(self.containerView.bounds) - formSheetRect.size.width/2;
    }
    
    if (self.keyboardVisible && self.movementActionWhenKeyboardAppears != MZFormSheetActionWhenKeyboardAppearsDoNothing) {
        CGRect screenRect = [self.screenFrameWhenKeyboardVisible CGRectValue];
        
        if (screenRect.size.height > CGRectGetHeight(formSheetRect)) {
            switch (self.movementActionWhenKeyboardAppears) {
                case MZFormSheetActionWhenKeyboardAppearsCenterVertically:
                    formSheetRect.origin.y = ([self yCoordinateBelowStatusBar] + screenRect.size.height - formSheetRect.size.height) / 2 - screenRect.origin.y;
                    break;
                case MZFormSheetActionWhenKeyboardAppearsMoveToTop:
                    formSheetRect.origin.y = [self yCoordinateBelowStatusBar];
                    break;
                case MZFormSheetActionWhenKeyboardAppearsMoveToTopInset:
                    formSheetRect.origin.y = [self topInset];
                    break;
                case MZFormSheetActionWhenKeyboardAppearsAboveKeyboard:
                    formSheetRect.origin.y = formSheetRect.origin.y + (screenRect.size.height - CGRectGetMaxY(formSheetRect)) - MZFormSheetPresentationControllerDefaultAboveKeyboardMargin;
                default:
                    break;
            }
        } else {
            formSheetRect.origin.y = [self yCoordinateBelowStatusBar];
        }
        
    } else if (self.shouldCenterVertically) {
        formSheetRect.origin.y = CGRectGetMidY(self.containerView.bounds) - formSheetRect.size.height/2;
    } else {
        formSheetRect.origin.y = self.topInset;
    }
    
    CGRect modifiedPresentedViewFrame = CGRectZero;
    
    if (self.frameConfigurationHandler) {
        modifiedPresentedViewFrame = self.frameConfigurationHandler(self.presentedView,formSheetRect);
    } else {
        modifiedPresentedViewFrame = formSheetRect;
    }
    
    if ([self isPresentedViewControllerUsingModifiedContentFrame]) {
        modifiedPresentedViewFrame = [self modifiedContentViewFrameForFrame:modifiedPresentedViewFrame];
    }
    
    return modifiedPresentedViewFrame;
}

- (void)setupFormSheetViewControllerFrame {
    self.presentedView.frame = [self formSheetViewControllerFrame];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.frame = self.containerView.bounds;
        [self setupFormSheetViewControllerFrame];
        
    } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
