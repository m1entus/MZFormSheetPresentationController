//
//  PresentedTableViewController.m
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

#import "PresentedTableViewController.h"
#import "MZFormSheetPresentationViewController.h"

@interface PresentedTableViewController ()

@end

@implementation PresentedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    

    self.textField.text = self.passingString;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.textFieldBecomeFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
