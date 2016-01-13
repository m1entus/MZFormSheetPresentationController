//
//  ViewController.swift
//  MZFormSheetPresentationController Swift Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MZTransition.registerTransitionClass(CustomTransition.self, forTransitionStyle: .Custom)
    }

    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("formSheetController") as! UINavigationController
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "segue" {
                let presentationSegue = segue as! MZFormSheetPresentationViewControllerSegue
                presentationSegue.formSheetPresentationController.presentationController?.shouldApplyBackgroundBlurEffect = true
                let navigationController = presentationSegue.formSheetPresentationController.contentViewController as! UINavigationController
                let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
                presentedViewController.textFieldBecomeFirstResponder = true
                presentedViewController.passingString = "PASSED DATA"
            }
        }
    }
    
    // MARK: Mix
    
    func passDataToViewControllerAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        
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
    }
    
    func blurEffectAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func parallaxEffectAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func customContentViewSizeAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.contentViewSize = CGSizeMake(100, 100)
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func customBackgroundColorAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func centerVerticallyAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldCenterVertically = true
        let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
        presentedViewController.textFieldBecomeFirstResponder = true
        
        formSheetController.presentationController?.frameConfigurationHandler = { [weak formSheetController] view, currentFrame in
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                return CGRectMake(CGRectGetMidX(formSheetController!.presentationController!.containerView!.bounds) - 210, currentFrame.origin.y, 420, currentFrame.size.height)
            }
            return currentFrame
        };
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func contentViewShadowAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        formSheetController.willPresentContentViewControllerHandler = { [weak formSheetController] (value: UIViewController)  -> Void in
            if let weakController = formSheetController {
                weakController.contentViewCornerRadius = 5.0
                weakController.shadowRadius = 6.0
            }
        }
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func twoFormSheetControllersAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.portraitTopInset = 10
        self.presentViewController(formSheetController, animated: true, completion: {
            let navigationController = self.formSheetControllerWithNavigationController()
            let formSheetController2 = MZFormSheetPresentationViewController(contentViewController: navigationController)
            formSheetController2.presentationController?.shouldDismissOnBackgroundViewTap = true
            formSheetController2.presentationController?.shouldApplyBackgroundBlurEffect = true
            formSheetController.presentViewController(formSheetController2, animated: true, completion: nil)
        })
    }
    
    func transparentBackgroundViewAction() {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("TransparentViewController") 
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: viewController)
        formSheetController.presentationController?.transparentTouchEnabled = false
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func panGestureDismissIngGesture() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.interactivePanGestureDissmisalDirection = .All;
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    func presentFormSheetControllerWithTransition(transition: Int) {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle(rawValue: transition)!
        
        self.presentViewController(formSheetController, animated: MZFormSheetPresentationTransitionStyle(rawValue: transition)! != .None, completion: nil)
    }
    
    func presentFormSheetControllerWithKeyboardMovement(movementOption: Int) {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears(rawValue: movementOption)!
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
        let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
        presentedViewController.textFieldBecomeFirstResponder = true
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: passDataToViewControllerAction()
            case 1: blurEffectAction()
            case 2: parallaxEffectAction()
            case 3: customContentViewSizeAction()
            case 4: customBackgroundColorAction()
            case 5: /* Storyboard segue */ break;
            case 6: centerVerticallyAction()
            case 7: contentViewShadowAction()
            case 8: twoFormSheetControllersAction()
            case 9: transparentBackgroundViewAction()
            case 10: panGestureDismissIngGesture()
            default: break;
            }
        } else if indexPath.section == 1 {
            presentFormSheetControllerWithTransition(indexPath.row)
        } else if indexPath.section == 2 {
            presentFormSheetControllerWithKeyboardMovement(indexPath.row)
        }
    }
}

