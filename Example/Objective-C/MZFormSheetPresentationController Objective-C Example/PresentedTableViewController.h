//
//  PresentedTableViewController.h
//  MZFormSheetPresentationViewController Objective-C Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentedTableViewController : UITableViewController
@property (nonatomic, assign) BOOL textFieldBecomeFirstResponder;
@property (nonatomic, strong) NSString *passingString;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
