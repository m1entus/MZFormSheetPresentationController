//
//  ViewController.m
//  tvOSApplication
//
//  Created by Michal Zaborowski on 28.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "ViewController.h"
#import "MZFormSheetPresentationController.h"
#import "MZFormSheetPresentationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (UINavigationController *)formSheetControllerWithNavigationController {
    return [self.storyboard instantiateViewControllerWithIdentifier:@"formSheetController"];
}

- (IBAction)buttonTapped:(id)sender {
    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
 
    formSheetController.presentationController.shouldCenterVertically = YES;
    formSheetController.presentationController.shouldCenterHorizontally = YES;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
