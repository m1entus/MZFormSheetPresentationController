//
//  MZFormSheetContentSizingNavigationController.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 21.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "MZFormSheetContentSizingNavigationController.h"
#import "MZFormSheetPresentationController.h"
#import "MZFormSheetPresentationViewController.h"

@interface MZFormSheetContentSizingNavigationController ()
@property (nonatomic, strong) MZFormSheetContentSizingNavigationControllerAnimator *animator;
@end

@implementation MZFormSheetContentSizingNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[MZFormSheetContentSizingNavigationControllerAnimator alloc] init];
    self.delegate = self;
}

- (BOOL)shouldUseContentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController {
    if ([self.visibleViewController conformsToProtocol:@protocol(MZFormSheetPresentationContentSizing)]) {
        return [(id<MZFormSheetPresentationContentSizing>)self.visibleViewController shouldUseContentViewFrameForPresentationController:presentationController];
    }
    return NO;
}
- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    return [(id<MZFormSheetPresentationContentSizing>)self.visibleViewController contentViewFrameForPresentationController:presentationController currentFrame:currentFrame];
}

#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    self.animator.operation = operation;
    return self.animator;
}

@end
