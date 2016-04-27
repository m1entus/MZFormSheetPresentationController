//
//  ViewController.m
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

#import "ViewController.h"
#import "MZFormSheetPresentationViewController.h"
#import "CustomTransition.h"
#import "PresentedTableViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"
#import "CustomPrenstationControllerAnimator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Default Background collor for all presentation controllers
    [[MZFormSheetPresentationController appearance] setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.3]];

    [MZTransition registerTransitionClass:[CustomTransition class] forTransitionStyle:MZFormSheetPresentationTransitionStyleCustom];
}

- (UINavigationController *)formSheetControllerWithNavigationController {
    return [self.storyboard instantiateViewControllerWithIdentifier:@"formSheetController"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue"]) {
        MZFormSheetPresentationViewControllerSegue *presentationSegue = (id)segue;
        presentationSegue.formSheetPresentationController.presentationController.shouldApplyBackgroundBlurEffect = YES;
        UINavigationController *navigationController = (id)presentationSegue.formSheetPresentationController.contentViewController;
        PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
        presentedViewController.textFieldBecomeFirstResponder = YES;
        presentedViewController.passingString = @"PASSSED DATA!!";
    }
}

#pragma mark - Mix

- (void)passDataToViewControllerAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
    
    PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
    presentedViewController.textFieldBecomeFirstResponder = YES;
    presentedViewController.passingString = @"PASSSED DATA!!";
    
    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *vc) {
        UINavigationController *navigationController = (id)vc;
        PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
        [presentedViewController.view layoutIfNeeded];
        presentedViewController.textField.text = @"PASS DATA DIRECTLY TO OUTLET!!";
    };
    
    [self presentViewController:formSheetController animated:YES completion:nil];
    
}
- (void)blurEffectAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;
    formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
    formSheetController.presentationController.blurEffectStyle = UIBlurEffectStyleLight;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}
- (void)parallaxEffectAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldUseMotionEffect = YES;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}
- (void)customContentViewSizeAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.contentViewSize = CGSizeMake(100, 100);
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)customBackgroundColorAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)centerVerticallyAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldCenterVertically = YES;
    PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
    presentedViewController.textFieldBecomeFirstResponder = YES;
    
    __weak typeof(formSheetController) weakFormSheet = formSheetController;
    formSheetController.presentationController.frameConfigurationHandler = ^(UIView * __nonnull presentedView, CGRect currentFrame, BOOL isKeyboardVisible) {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return CGRectMake(CGRectGetMidX(weakFormSheet.presentationController.containerView.bounds) - 210, currentFrame.origin.y, 420, currentFrame.size.height);
        }
        
        return currentFrame;
    };
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)contentViewShadowAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionUp | MZFormSheetPanGestureDismissDirectionDown | MZFormSheetPanGestureDismissDirectionLeft | MZFormSheetPanGestureDismissDirectionRight;

    __weak MZFormSheetPresentationViewController *weakController = formSheetController;
    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *a) {
        weakController.contentViewCornerRadius = 5.0;
        weakController.shadowRadius = 6.0;
    };
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)twoFormSheetControllersAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.portraitTopInset = 10;
    
    [self presentViewController:formSheetController animated:YES completion:^{
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TransparentViewController"];
        MZFormSheetPresentationViewController *formSheetController2 = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:controller];
        formSheetController2.presentationController.shouldDismissOnBackgroundViewTap = YES;
        formSheetController2.presentationController.shouldApplyBackgroundBlurEffect = YES;
        [formSheetController presentViewController:formSheetController2 animated:YES completion:nil];
    }];
}

- (void)customPresentationControllerAnimator {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.animatorForPresentationController = [[CustomPrenstationControllerAnimator alloc] init];
    formSheetController.presentationController.backgroundColor = [UIColor clearColor];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.transparentTouchEnabled = YES;

    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)transparentBackgroundViewAction {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TransparentViewController"];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:viewController];
    formSheetController.presentationController.transparentTouchEnabled = NO;
    // Uncomment if you don't want to capture status bar appearance in presentedViewController
//    formSheetController.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)panGestureDismissingGesture {
//    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TransparentViewController"];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:viewController];
    formSheetController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;
    formSheetController.allowDismissByPanningPresentedView = YES;

    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)presentFormSheetControllerWithTransition:(NSInteger)transition {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = (MZFormSheetPresentationTransitionStyle)transition;
    
    [self presentViewController:formSheetController animated:(transition != MZFormSheetPresentationTransitionStyleNone) completion:nil];
}

- (void)presentFormSheetControllerWithKeyboardMovement:(NSInteger)movementOption {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.movementActionWhenKeyboardAppears = (MZFormSheetActionWhenKeyboardAppears)movementOption;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleFade;
    PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
    presentedViewController.textFieldBecomeFirstResponder = YES;
    
    // Always on center
    if (movementOption == MZFormSheetActionWhenKeyboardAppearsCenterVertically) {
        formSheetController.presentationController.shouldCenterVertically = YES;
    }
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)modalPresentationInsideFormSheetController {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.portraitTopInset = 10;
    
    // This need to be set because presented modaly view need to be masked
    formSheetController.view.layer.masksToBounds = YES;
    
    [self presentViewController:formSheetController animated:YES completion:^{
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TransparentViewController"];
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        controller.view.layer.cornerRadius = navigationController.view.layer.cornerRadius;
        
        // Imporatant is to present view controller from navigationController
        // because UITransitionView will be added to navigationController view !!!
        [navigationController presentViewController:controller animated:YES completion:nil];
    }];
}

- (void)formSheetView {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 187.0f)];
    image.image = [UIImage imageNamed:@"home"];

    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentView:image];
    formSheetController.presentationController.shouldCenterVertically = YES;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;

    [self presentViewController:formSheetController animated:YES completion:nil];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: [self passDataToViewControllerAction]; break;
            case 1: [self blurEffectAction]; break;
            case 2: [self parallaxEffectAction]; break;
            case 3: [self customContentViewSizeAction]; break;
            case 4: [self customBackgroundColorAction]; break;
            case 5: /* Storyboard Segue */ break;
            case 6: [self centerVerticallyAction]; break;
            case 7: [self contentViewShadowAction]; break;
            case 8: [self twoFormSheetControllersAction]; break;
            case 9: [self transparentBackgroundViewAction]; break;
            case 10: [self customPresentationControllerAnimator]; break;
            case 11: [self panGestureDismissingGesture]; break;
            case 12: [self modalPresentationInsideFormSheetController]; break;
            case 13: [self formSheetView]; break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        [self presentFormSheetControllerWithTransition:indexPath.row];
    } else if (indexPath.section == 3) {
        [self presentFormSheetControllerWithKeyboardMovement:indexPath.row];
    }
}

@end
