//
//  TransparentViewController.m
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 22.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

#import "TransparentViewController.h"
#import "MZFormSheetPresentationViewController.h"

@interface TransparentViewController ()

@end

@implementation TransparentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)turnOnTransparencyButtonTapped:(id)sender {
    self.mz_formSheetPresentingPresentationController.presentationController.backgroundColor = [UIColor clearColor];
    self.mz_formSheetPresentingPresentationController.presentationController.transparentTouchEnabled = YES;
}
- (IBAction)turnOffTransparencyButtonTapped:(id)sender {
    self.mz_formSheetPresentingPresentationController.presentationController.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.mz_formSheetPresentingPresentationController.presentationController.transparentTouchEnabled = NO;
    
}
- (IBAction)dismissButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
