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
    formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
    formSheetController.presentationController.blurEffectStyle = UIBlurEffectStyleDark;
    // To set blur effect color, but uglty animation
//    formSheetController.presentationController.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    
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
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)contentViewShadowAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.allowInteractivePanGestureDissmisal = YES;

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
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
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
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        [self presentFormSheetControllerWithTransition:indexPath.row];
    } else if (indexPath.section == 2) {
        [self presentFormSheetControllerWithKeyboardMovement:indexPath.row];
    }
}

@end
