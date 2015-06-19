//
//  ViewController.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

#import "ViewController.h"
#import "MZFormSheetPresentationController.h"
#import "CustomTransition.h"
#import "PresentedTableViewController.h"
#import "MZFormSheetPresentationControllerSegue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Default Background collor for all presentation controllers
    [[MZFormSheetPresentationController appearance] setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.3]];

    [MZFormSheetPresentationController registerTransitionClass:[CustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
}

- (UINavigationController *)formSheetControllerWithNavigationController {
    return [self.storyboard instantiateViewControllerWithIdentifier:@"formSheetController"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue"]) {
        MZFormSheetPresentationControllerSegue *presentationSegue = (id)segue;
        presentationSegue.formSheetPresentationController.shouldApplyBackgroundBlurEffect = YES;
        UINavigationController *navigationController = (id)presentationSegue.formSheetPresentationController.contentViewController;
        PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
        presentedViewController.textFieldBecomeFirstResponder = YES;
        presentedViewController.passingString = @"PASSSED DATA!!";
    }
}

#pragma mark - Mix

- (void)passDataToViewControllerAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.shouldApplyBackgroundBlurEffect = YES;
    
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
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldApplyBackgroundBlurEffect = YES;
    formSheetController.blurEffectStyle = UIBlurEffectStyleLight;
    // To set blur effect color, but uglty animation
//    formSheetController.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}
- (void)parallaxEffectAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldUseMotionEffect = YES;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}
- (void)customContentViewSizeAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.contentViewSize = CGSizeMake(100, 100);
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)customBackgroundColorAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)centerVerticallyAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldCenterVertically = YES;
    PresentedTableViewController *presentedViewController = [navigationController.viewControllers firstObject];
    presentedViewController.textFieldBecomeFirstResponder = YES;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)contentViewShadowAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.backgroundColor = [UIColor clearColor];

    __weak MZFormSheetPresentationController *weakController = formSheetController;
    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *a) {
        weakController.contentViewController.view.layer.masksToBounds = NO;
        
        CALayer *layer = weakController.contentViewController.view.layer;
        
        [layer setShadowOffset:CGSizeMake(0, 3)];
        [layer setShadowOpacity:0.8];
        [layer setShadowRadius:3.0f];
        
        [layer setShadowPath:
         [[UIBezierPath bezierPathWithRoundedRect:[weakController.contentViewController.view bounds]
                                     cornerRadius:12.0f] CGPath]];
    };
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)twoFormSheetControllersAction {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.portraitTopInset = 10;
    
    [self presentViewController:formSheetController animated:YES completion:^{
        UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
        MZFormSheetPresentationController *formSheetController2 = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
        formSheetController2.shouldDismissOnBackgroundViewTap = YES;
        formSheetController2.shouldApplyBackgroundBlurEffect = YES;
        [formSheetController presentViewController:formSheetController2 animated:YES completion:nil];
    }];
}

- (void)presentFormSheetControllerWithTransition:(NSInteger)transition {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = (MZFormSheetTransitionStyle)transition;
    
    [self presentViewController:formSheetController animated:(transition != MZFormSheetTransitionStyleNone) completion:nil];
}

- (void)presentFormSheetControllerWithKeyboardMovement:(NSInteger)movementOption {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    formSheetController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.movementActionWhenKeyboardAppears = (MZFormSheetActionWhenKeyboardAppears)movementOption;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetTransitionStyleFade;
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
