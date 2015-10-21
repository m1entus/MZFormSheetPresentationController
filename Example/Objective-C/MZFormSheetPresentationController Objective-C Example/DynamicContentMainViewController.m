//
//  DynamicContentFirstViewController.m
//  MZFormSheetPresentationController Objective-C Example
//
//  Created by Michal Zaborowski on 22.10.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "DynamicContentMainViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"
#import "MZFormSheetPresentationController.h"

@interface DynamicContentMainViewController ()

@end

@implementation DynamicContentMainViewController

- (UIImage *)emptyImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(performSettingsSegue)];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        MZFormSheetPresentationViewControllerSegue *presentationSegue = (id)segue;
        presentationSegue.formSheetPresentationController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleDropDown;
        presentationSegue.formSheetPresentationController.allowDismissByPanningPresentedView = YES;
    }
}

- (void)performSettingsSegue {
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.presentingViewController) {
        self.navigationController.navigationBar.barTintColor = self.view.window.tintColor;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    UIImage* transparentImage = [self emptyImageWithSize:CGSizeMake(self.navigationController.navigationBar.frame.size.width, 1)];
    [self.navigationController.navigationBar setBackgroundImage:transparentImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = transparentImage;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
- (IBAction)settingsButtonTapped:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
