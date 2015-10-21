//
//  DynamicContentFirstViewController.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 22.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "DynamicContentFirstViewController.h"
#import "MZFormSheetPresentationController.h"

@interface DynamicContentFirstViewController ()

@end

@implementation DynamicContentFirstViewController

- (UIImage *)emptyImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    UIImage* transparentImage = [self emptyImageWithSize:CGSizeMake(self.navigationController.navigationBar.frame.size.width, 1)];
    [self.navigationController.navigationBar setBackgroundImage:transparentImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = transparentImage;
    self.navigationController.navigationBar.clipsToBounds = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)detailsButtonTapped:(id)sender {
    
}
- (BOOL)shouldUseContentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController {
    return YES;
}
- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    currentFrame.size.height = 252;
    return currentFrame;
}
@end
