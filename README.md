[![](http://inspace.io/github-cover.jpg)](http://inspace.io)

MZFormSheetPresentationController
===========

`MZFormSheetPresentationController` provides an alternative to the native iOS UIModalPresentationFormSheet, adding support for iPhone and additional opportunities to setup controller size and feel form sheet.

`MZFormSheetPresentationController` also has a number of predefined transitions so you can customize whether the modal form slides in, fades in, bounces in or you can create your own custom transition.  There are also a number of properties for customizing the exact look and position of the form.

This project is continuation of [`MZFormSheetController`](https://github.com/m1entus/MZFormSheetController) which allow you to make form sheet when deployment target is set to >iOS5 but use some tricky UIWindow hacks.

Here are a couple of images showing `MZFormSheetPresentationController` in action:

[![](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/screen1.png)](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/screen1.png)
[![](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/animation1.gif)](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/animation1.gif)
[![](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/screen2.png)](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/screen2.png)
[![](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/screen3.png)](https://raw.github.com/m1entus/MZFormSheetPresentationController/master/Screens/screen3.png)

## Requirements

MZFormSheetPresentationController requires either iOS 8.x and above.

## How To Use

There are two example projects, one is for Objective-C second is for Swift.

Let's start with a simple example

Objective-C
``` objective-c
UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"formSheetController"];
MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
formSheetController.contentViewSize = CGSizeMake(250, 250);

[self presentViewController:formSheetController animated:YES completion:nil];
```

Swift
```swift
let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("formSheetController") as! UINavigationController
let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
formSheetController.contentViewSize = CGSizeMake(250, 250)

self.presentViewController(formSheetController, animated: true, completion: nil)
```

This will display view controller inside form sheet container.

If you want to dismiss form sheet controller, use default dismissing view controller action.

Objective-C
```objective-c
[self dismissViewControllerAnimated:YES completion:nil];
```

Swift
```swift
self.dismissViewControllerAnimated(true, completion: nil)
```

Easy right ?!

## Passing data
If you want to pass data to presenting view controller, you are doing it like normal. Just remember that IBOutlets are initialized after viewDidLoad, if you don't want to create additional properies, you can always use completion handler `willPresentContentViewControllerHandler` to pass data directly to outlets. It is called after viewWillAppear and before `MZFormSheetPresentationController` animation.

Objective-C
```objective-c
MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];

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
```

Swift
```swift
let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)

let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
presentedViewController.textFieldBecomeFirstResponder = true
presentedViewController.passingString = "PASSED DATA"

formSheetController.willPresentContentViewControllerHandler = { vc in
    let navigationController = vc as! UINavigationController
    let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
    presentedViewController.view?.layoutIfNeeded()
    presentedViewController.textField?.text = "PASS DATA DIRECTLY TO OUTLET!!"
}

self.presentViewController(formSheetController, animated: true, completion: nil)
```

## Blur background effect

It is possible to display blurry background, you can set `MZFormSheetPresentationController` default appearance or directly to `MZFormSheetPresentationController`

Objective-C
```objective-c
// Blur will be applied to all MZFormSheetPresentationControllers by default
[[MZFormSheetPresentationController appearance] setShouldApplyBackgroundBlurEffect:YES];

or

// This will set to only one instance
formSheetController.shouldApplyBackgroundBlurEffect = YES;
```

Swift
```swift
// Blur will be applied to all MZFormSheetPresentationControllers by default
MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true

or

// This will set to only one instance
formSheetController.shouldApplyBackgroundBlurEffect = true
```

## Transitions

MZFormSheetPresentationController has predefined couple transitions.

Objective-C
``` objective-c
typedef NS_ENUM(NSInteger, MZFormSheetTransitionStyle) {
   MZFormSheetTransitionStyleSlideFromTop = 0,
   MZFormSheetTransitionStyleSlideFromBottom,
   MZFormSheetTransitionStyleSlideFromLeft,
   MZFormSheetTransitionStyleSlideFromRight,
   MZFormSheetTransitionStyleSlideAndBounceFromLeft,
   MZFormSheetTransitionStyleSlideAndBounceFromRight,
   MZFormSheetTransitionStyleFade,
   MZFormSheetTransitionStyleBounce,
   MZFormSheetTransitionStyleDropDown,
   MZFormSheetTransitionStyleCustom,
   MZFormSheetTransitionStyleNone,
};
```

If you want to use them you will have to just assign `contentViewControllerTransitionStyle` property

Objective-C
``` objective-c
formSheetController.contentViewControllerTransitionStyle = MZFormSheetTransitionStyleFade;
```

You can also create your own transition by implementing `MZFormSheetPresentationControllerTransitionProtocol` protocol and register your transition class as a custom style.

Objective-C
``` objective-c
@interface CustomTransition : NSObject <MZFormSheetPresentationControllerTransitionProtocol>
@end

[MZFormSheetPresentationController registerTransitionClass:[CustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];

formSheetController.contentViewControllerTransitionStyle = MZFormSheetTransitionStyleCustom;
```

Swift
```swift
class CustomTransition: NSObject, MZFormSheetPresentationControllerTransitionProtocol {
}

MZFormSheetPresentationController.registerTransitionClass(CustomTransition.self, forTransitionStyle: .Custom)

formSheetController.contentViewControllerTransitionStyle = .Custom
```

if you are creating own transition you have to call completionBlock at the end of animation.

Objective-C
```objective-c
- (void)exitFormSheetControllerTransition:(nonnull MZFormSheetPresentationController *)formSheetController
                        completionHandler:(nonnull MZTransitionCompletionHandler)completionHandler {
    CGRect formSheetRect = formSheetController.contentViewController.view.frame;
    formSheetRect.origin.x = formSheetController.view.bounds.size.width;

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         formSheetController.contentViewController.view.frame = formSheetRect;
                     }
                     completion:^(BOOL finished) {
                         completionHandler();
                     }];
}
```

Swift
```swift
func exitFormSheetControllerTransition(formSheetController: MZFormSheetPresentationController, completionHandler: MZTransitionCompletionHandler) {
    var formSheetRect = formSheetController.contentViewController!.view.frame
    formSheetRect.origin.x = formSheetController.view.bounds.size.width

    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        formSheetController.contentViewController!.view.frame = formSheetRect
    }, completion: {(value: Bool)  -> Void in
        completionHandler()
    })
}
```

## Transparent Touch Background

If you want to have access to the controller that is below MZFormSheetPresentationController, you can set property `transparentTouchEnabled` and background view controller will get all touches.

Objective-C
```objective-c
MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:viewController];
formSheetController.transparentTouchEnabled = YES;
```

Swift
```swift
let formSheetController = MZFormSheetPresentationController(contentViewController: viewController)
formSheetController.transparentTouchEnabled = true
```

## Completion Blocks

``` objective-c
/**
 The handler to call when user tap on background view.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerTapHandler didTapOnBackgroundViewCompletionHandler;

/**
 The handler to call when presented form sheet is before entry transition and its view will show on window.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerCompletionHandler willPresentContentViewControllerHandler;

/**
 The handler to call when presented form sheet is after entry transition animation.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerCompletionHandler didPresentContentViewControllerHandler;

/**
 The handler to call when presented form sheet will be dismiss, this is called before out transition animation.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerCompletionHandler willDismissContentViewControllerHandler;

/**
 The handler to call when presented form sheet is after dismiss.
 */
@property (nonatomic, copy, nullable) MZFormSheetPresentationControllerCompletionHandler didDismissContentViewControllerHandler;
```

## Autolayout

MZFormSheetPresentationController supports autolayout.

## Storyboard

MZFormSheetPresentationController supports storyboard.

MZFormSheetPresentationSegue is a custom storyboard segue which use default MZFormSheetPresentationController settings.

If you want to get acces to form sheet controller and pass data using storyboard segue, the code will look like this:

Objective-C
```objective-c
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
```

Swift
```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
        if identifier == "segue" {
            let presentationSegue = segue as! MZFormSheetPresentationControllerSegue
            presentationSegue.formSheetPresentationController.shouldApplyBackgroundBlurEffect = true
            let navigationController = presentationSegue.formSheetPresentationController.contentViewController as! UINavigationController
            let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
            presentedViewController.textFieldBecomeFirstResponder = true
            presentedViewController.passingString = "PASSED DATA"
        }
    }
}
```

## ARC

MZFormSheetPresentationController uses ARC.

## Contact

[Michal Zaborowski](http://github.com/m1entus)

[Twitter](https://twitter.com/iMientus)
