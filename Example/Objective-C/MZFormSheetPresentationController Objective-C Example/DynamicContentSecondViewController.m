//
//  DynamicContentSecondViewController.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 22.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "DynamicContentSecondViewController.h"

@interface DynamicContentSecondViewController ()

@end

@implementation DynamicContentSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldUseContentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController {
    return YES;
}
- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    currentFrame.origin.y = 20;
    currentFrame.size.height = 450;
    return currentFrame;
}
@end
