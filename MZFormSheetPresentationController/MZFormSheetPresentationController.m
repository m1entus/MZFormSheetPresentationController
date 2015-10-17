//
//  MZFormSheetPresentationController.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 17.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "MZFormSheetPresentationController.h"
#import <objc/runtime.h>
#import "MZBlurEffectAdapter.h"
#import <JGMethodSwizzler/JGMethodSwizzler.h>

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
    [self removeKeyboardNotifications];
    [self.dimmingView removeGestureRecognizer:self.backgroundTapGestureRecognizer];
    self.backgroundTapGestureRecognizer = nil;
}

#pragma mark - Class methods

+ (NSMutableDictionary *)sharedTransitionClasses {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *_instanceOfTransitionClasses = nil;
    dispatch_once(&onceToken, ^{
        _instanceOfTransitionClasses = [[NSMutableDictionary alloc] init];
    });
    return _instanceOfTransitionClasses;
}


+ (void)registerTransitionClass:(Class)transitionClass forTransitionStyle:(MZFormSheetPresentationTransitionStyle)transitionStyle {
    [[MZFormSheetPresentationController sharedTransitionClasses] setObject:transitionClass forKey:@(transitionStyle)];
}

+ (Class)classForTransitionStyle:(MZFormSheetPresentationTransitionStyle)transitionStyle {
    return [MZFormSheetPresentationController sharedTransitionClasses][@(transitionStyle)];
}

+ (void)load {
    @autoreleasepool {
        MZFormSheetPresentationController *appearance = [self appearance];
        [appearance setContentViewSize:CGSizeMake(284.0, 284.0)];
        [appearance setPortraitTopInset:66.0];
        [appearance setLandscapeTopInset:6.0];
        [appearance setShouldCenterHorizontally:YES];
        [appearance setPresentedViewCornerRadius:5.0];
        [appearance setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [appearance setBlurEffectStyle:UIBlurEffectStyleLight];
    }
}

+ (id)appearance {
    return [MZAppearance appearanceForClass:[self class]];
}

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.frame];
    }
    return _dimmingView;
}

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

- (void)setPresentedViewCornerRadius:(CGFloat)presentedViewCornerRadius {
    _presentedViewCornerRadius = presentedViewCornerRadius;
    [self updatePresentedViewCornerRadius];
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

- (void)updatePresentedViewCornerRadius {
    if (self.presentedViewCornerRadius > 0) {
        self.presentedView.layer.masksToBounds = YES;
    }
    self.presentedView.layer.cornerRadius = self.presentedViewCornerRadius;
}

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


#pragma mark - Swizzle

- (void)turnOnTransparentTouch {
    __weak typeof(self) weakSelf = self;
    [self.containerView swizzleMethod:@selector(pointInside:withEvent:) withReplacement:JGMethodReplacementProviderBlock {
        return JGMethodReplacement(BOOL, UIView *, CGPoint point, UIEvent *event) {
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


- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        
        [[[self class] appearance] applyInvocationTo:self];
        
        [self addKeyboardNotifications];
    }
    return self;
}

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

- (void)presentationTransitionWillBegin {
    
    if (self.presentationTransitionWillBeginCompletionHandler) {
        self.presentationTransitionWillBeginCompletionHandler(self.presentingViewController);
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
    [self updatePresentedViewCornerRadius];

    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0;
    [self.containerView addSubview:self.dimmingView];
//    [self.containerView addSubview:[self presentedView]];
    
    // this is some kind of bug :<, if we will delete this line, then inside custom animator
    // we need to set finalFrameForViewController to targetView
    [self presentedView].frame = [self frameOfPresentedViewInContainerView];
    
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 1.0;
    } completion:nil];

}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
    if (self.presentationTransitionDidEndCompletionHandler) {
        self.presentationTransitionDidEndCompletionHandler(self.presentingViewController, completed);
    }
}


- (void)dismissalTransitionWillBegin {
    if (self.presentationTransitionWillBeginCompletionHandler) {
        self.presentationTransitionWillBeginCompletionHandler(self.presentingViewController);
    }
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.0;
    } completion:nil];
    
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {

    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
    
    if (self.dismissalTransitionDidEndCompletionHandler) {
        self.dismissalTransitionDidEndCompletionHandler(self.presentingViewController, completed);
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(CGRectGetMidX([UIScreen mainScreen].bounds) - self.contentViewSize.width/2, [self topInset], self.contentViewSize.width, self.contentViewSize.height);
}

- (CGFloat)yCoordinateBelowStatusBar {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (CGFloat)topInset {
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return self.portraitTopInset + [self yCoordinateBelowStatusBar];
    } else {
        return self.landscapeTopInset + [self yCoordinateBelowStatusBar];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.frame = self.containerView.bounds;
        [self setupFormSheetViewControllerFrame];
        
    } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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


- (void)setupFormSheetViewControllerFrame {

    CGRect formSheetRect = self.presentedView.frame;
    formSheetRect.size = self.contentViewSize;
    
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
        formSheetRect.origin.y = CGRectGetMidY(self.containerView.bounds) - formSheetRect.size.height;
    } else {
        formSheetRect.origin.y = self.topInset;
    }
    
    if (self.frameConfigurationHandler) {
        self.presentedView.frame = self.frameConfigurationHandler(self.presentedView,formSheetRect);
    } else {
        self.presentedView.frame = formSheetRect;
    }
}


@end
