//
//  MZFormSheetPresentationViewController.m
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

#import "MZFormSheetPresentationViewController.h"
#import "UIViewController+TargetViewController.h"
#import "MZFormSheetPresentationViewControllerAnimator.h"

@interface MZFormSheetPresentationViewControllerCustomView: UIView
@property (nonatomic, weak) MZFormSheetPresentationViewController *viewController;
@end

@implementation MZFormSheetPresentationViewControllerCustomView

- (instancetype)initWithViewController:(MZFormSheetPresentationViewController *)viewController {
    if (self = [super initWithFrame:[UIScreen mainScreen].applicationFrame]) {
        self.viewController = viewController;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    // This is workaroud for UIViewControllerBuiltinTransitionViewAnimator
    // who is setting frame to [UIScreen mainScreen] when modally presented over
    // MZFormSheetPresentationViewController using UIModalPresentationFullScreen style !!!
    // Made this workaround to have less github issues, for people who is not reading docs :)
    
    if (self.viewController.presentedViewController && (self.viewController.presentedViewController.modalPresentationStyle != UIModalPresentationOverFullScreen || self.viewController.modalPresentationStyle != UIModalPresentationCurrentContext || self.viewController.modalPresentationStyle != UIModalPresentationCustom)) {
        return;
    }
    [super setFrame:frame];
}

@end

@interface MZFormSheetPresentationViewController ()
@property (nonatomic, strong) UIViewController *contentViewController;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGRect panGestureRecognizerViewInitialFrame;
@property (nonatomic, assign) CGPoint panGestureRecognizerStartLocation;
@property (nonatomic, assign, getter=isPanGestureRecognized) BOOL panGestureRecognized;
@end

@implementation MZFormSheetPresentationViewController

- (void)loadView {
    self.view = [[MZFormSheetPresentationViewControllerCustomView alloc] initWithViewController:self];
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.contentViewController willMoveToParentViewController:nil];
    [self.contentViewController.view removeFromSuperview];
    [self.contentViewController removeFromParentViewController];
    self.contentViewController = nil;

}

#pragma mark - Appearance

+ (void)load {
    @autoreleasepool {
        MZFormSheetPresentationViewController *appearance = [self appearance];
        [appearance setContentViewCornerRadius:5.0];
        [appearance setShadowRadius:0.0];
    }
}

+ (id)appearance {
    return [MZAppearance appearanceForClass:[self class]];
}

#pragma mark - Setters


- (void)setContentViewCornerRadius:(CGFloat)contentViewCornerRadius {
    _contentViewCornerRadius = contentViewCornerRadius;
    if (_contentViewCornerRadius > 0) {
        self.contentViewController.view.layer.masksToBounds = YES;
    }
    self.contentViewController.view.layer.cornerRadius = _contentViewCornerRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    if (_shadowRadius > 0) {
        self.view.layer.shadowOffset = CGSizeZero;
        self.view.layer.shadowRadius = _shadowRadius;
        self.view.layer.shadowOpacity = 0.7;
        self.view.layer.masksToBounds = NO;
    }
    self.view.layer.shadowRadius = shadowRadius;
}

#pragma mark - Getters

- (MZFormSheetPresentationController *)presentationController {
    return (MZFormSheetPresentationController *)[super presentationController];
}

- (UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning> *)interactionAnimatorForPresentationController {
    if (!_interactionAnimatorForPresentationController) {
        _interactionAnimatorForPresentationController = [[MZFormSheetPresentationViewControllerAnimator alloc] init];
    }
    return _interactionAnimatorForPresentationController;
}


- (id <UIViewControllerAnimatedTransitioning>)animatorForPresentationController {
    if (!_animatorForPresentationController) {
        _animatorForPresentationController = [[MZFormSheetPresentationViewControllerAnimator alloc] init];
    }
    return _animatorForPresentationController;
}

#pragma mark - View Life cycle

- (instancetype)initWithContentViewController:(UIViewController *)viewController {
    if (self = [self init]) {
    
        NSParameterAssert(viewController);
        self.contentViewController = viewController;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;

        id appearance = [[self class] appearance];
        [appearance applyInvocationTo:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.contentViewController.view];
    [self addChildViewController:self.contentViewController];
    [self.contentViewController didMoveToParentViewController:self];

    [self setupFormSheetViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.presentedViewController) {
        
        if (self.allowInteractivePanGestureDissmisal) {
            [self addDismissalPanGestureRecognizer];
        }
        
        if (self.willPresentContentViewControllerHandler) {
            self.willPresentContentViewControllerHandler(self.contentViewController);
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.presentedViewController) {
        if (self.didPresentContentViewControllerHandler) {
            self.didPresentContentViewControllerHandler(self.contentViewController);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!self.presentedViewController) {
        if (self.willDismissContentViewControllerHandler) {
            self.willDismissContentViewControllerHandler(self.contentViewController);
        }
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (!self.presentedViewController) {
        if (self.didDismissContentViewControllerHandler) {
            self.didDismissContentViewControllerHandler(self.contentViewController);
        }
    }
    
    [super viewDidDisappear:animated];
}

#pragma mark - UIGestureRecognizer

- (void)addDismissalPanGestureRecognizer {
    [self removeDismissalPanGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissalPanGestureRecognizer:)];
    [self.presentationController.containerView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)removeDismissalPanGestureRecognizer {
    [self.panGestureRecognizer.view removeGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer = nil;
}

- (void)handleDismissalPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {

    CGPoint location = [recognizer locationInView:self.presentationController.containerView];
    CGPoint velocity = [recognizer velocityInView:self.presentationController.containerView];
    
    CGFloat animationRatio = (location.y - self.panGestureRecognizerViewInitialFrame.origin.y) / (CGRectGetHeight([UIScreen mainScreen].bounds) - self.panGestureRecognizerViewInitialFrame.origin.y);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (location.y > self.view.frame.origin.y || (location.x < self.view.frame.origin.x || location.x > self.view.frame.origin.x + self.view.frame.size.width)) {
            recognizer.enabled = NO;
            recognizer.enabled = YES;
            return;
        }
        
        self.panGestureRecognized = YES;
        self.interactionAnimatorForPresentationController.interactive = YES;
        self.panGestureRecognizerStartLocation = location;
        self.panGestureRecognizerViewInitialFrame = self.view.frame;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {

        if (location.y > self.panGestureRecognizerViewInitialFrame.origin.y) {
            [self.interactionAnimatorForPresentationController updateInteractiveTransition:animationRatio];
        } else {
            [self.interactionAnimatorForPresentationController updateInteractiveTransition:0];
        }
        
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        self.panGestureRecognized = NO;
        CGFloat velocityForSelectedDirection = velocity.y;
        
        if (animationRatio > 0.5 || velocityForSelectedDirection > 300) {
            [self.interactionAnimatorForPresentationController finishInteractiveTransition];
        } else {
            [self.interactionAnimatorForPresentationController cancelInteractiveTransition];
        }
        self.interactionAnimatorForPresentationController.interactive = NO;
        
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed) {
        self.interactionAnimatorForPresentationController.interactive = NO;
    }
}

#pragma mark - Setup

- (void)setupFormSheetViewController {

    self.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentViewController.view.layer.masksToBounds = YES;
    self.contentViewController.view.layer.cornerRadius = self.contentViewCornerRadius;
    //update shadow radius
    self.shadowRadius = self.shadowRadius;
    self.contentViewController.view.frame = self.view.bounds;
}

#pragma mark - UIViewController (UIContainerViewControllerProtectedMethods)

- (UIViewController *)childViewControllerForStatusBarStyle {
    if ([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
        return [navigationController.topViewController mz_childTargetViewControllerForStatusBarStyle];
    }

    return [self.contentViewController mz_childTargetViewControllerForStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if ([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
        return [navigationController.topViewController mz_childTargetViewControllerForStatusBarStyle];
    }
    return [self.contentViewController mz_childTargetViewControllerForStatusBarStyle];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self.contentViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.contentViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {
    return [self.contentViewController shouldAutorotate];
}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[MZFormSheetPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    if ([self.animatorForPresentationController isKindOfClass:[MZFormSheetPresentationViewControllerAnimator class]]) {
        
        MZFormSheetPresentationViewControllerAnimator *animator = (id)self.animatorForPresentationController;
        if (!animator.transition) {
            Class transitionClass = [MZTransition sharedTransitionClasses][@(self.contentViewControllerTransitionStyle)];
            id<MZFormSheetPresentationViewControllerTransitionProtocol> transition = [[transitionClass alloc] init];
            animator.transition = transition;
        }
    }
    
    self.animatorForPresentationController.presenting = YES;
    return self.animatorForPresentationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    if ([self.animatorForPresentationController isKindOfClass:[MZFormSheetPresentationViewControllerAnimator class]]) {
        
        MZFormSheetPresentationViewControllerAnimator *animator = (id)self.animatorForPresentationController;
        if (!animator.transition) {
            Class transitionClass = [MZTransition sharedTransitionClasses][@(self.contentViewControllerTransitionStyle)];
            id<MZFormSheetPresentationViewControllerTransitionProtocol> transition = [[transitionClass alloc] init];
            animator.transition = transition;
        }
    }
    
    
    self.animatorForPresentationController.presenting = NO;
    return self.animatorForPresentationController;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    self.interactionAnimatorForPresentationController.interactive = YES;
    return self.isPanGestureRecognized ? self.interactionAnimatorForPresentationController : nil;
}

@end

@implementation UIViewController (MZFormSheetPresentationViewController)
- (nullable MZFormSheetPresentationViewController *)mz_formSheetPresentingPresentationController {
    if ([self.presentingViewController.presentedViewController isKindOfClass:[MZFormSheetPresentationViewController class]]) {
        return (MZFormSheetPresentationViewController *)self.presentingViewController.presentedViewController;
    }
    return nil;
}

- (nullable MZFormSheetPresentationViewController *)mz_formSheetPresentedPresentationController {
    if ([self.presentedViewController isKindOfClass:[MZFormSheetPresentationViewController class]]) {
        return (MZFormSheetPresentationViewController *)self.presentedViewController;
    }
    return nil;
}
@end
