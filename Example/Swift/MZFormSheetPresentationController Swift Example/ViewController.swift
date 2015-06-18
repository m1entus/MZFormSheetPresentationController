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
        MZFormSheetPresentationController.registerTransitionClass(CustomTransition.self, forTransitionStyle: .Custom)
    }

    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("formSheetController") as! UINavigationController
    }
    
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
    
    // MARK: Mix
    
    func passDataToViewControllerAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldDismissOnBackgroundViewTap = true
        formSheetController.shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
        presentedViewController.textFieldBecomeFirstResponder = true
        presentedViewController.passingString = "PASSED DATA"
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func blurEffectAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldApplyBackgroundBlurEffect = true
        formSheetController.blurEffectStyle = UIBlurEffectStyle.Light
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func parallaxEffectAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldUseMotionEffect = true
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func customContentViewSizeAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.contentViewSize = CGSizeMake(100, 100)
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func customBackgroundColorAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func centerVerticallyAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldCenterVertically = true
        let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
        presentedViewController.textFieldBecomeFirstResponder = true
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func contentViewShadowAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.backgroundColor = UIColor.clearColor()
        
        formSheetController.willPresentContentViewControllerHandler = { [weak formSheetController] (value: UIViewController)  -> Void in
            if let weakController = formSheetController {
                weakController.contentViewController!.view.layer.masksToBounds = false;
                let layer = weakController.contentViewController!.view.layer
                layer.shadowOffset = CGSizeMake(0, 3)
                layer.shadowOpacity = 0.3
                layer.shadowRadius = 3.0
            }
        }
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func twoFormSheetControllersAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldDismissOnBackgroundViewTap = true
        formSheetController.portraitTopInset = 10
        self.presentViewController(formSheetController, animated: true, completion: {
            let navigationController = self.formSheetControllerWithNavigationController()
            let formSheetController2 = MZFormSheetPresentationController(contentViewController: navigationController)
            formSheetController2.shouldDismissOnBackgroundViewTap = true
            formSheetController2.shouldApplyBackgroundBlurEffect = true
            formSheetController.presentViewController(formSheetController2, animated: true, completion: nil)
        })
    }
    
    // MARK: -
    
    func presentFormSheetControllerWithTransition(transition: Int) {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetTransitionStyle(rawValue: transition)!
        
        self.presentViewController(formSheetController, animated: MZFormSheetTransitionStyle(rawValue: transition)! != .None, completion: nil)
    }
    
    func presentFormSheetControllerWithKeyboardMovement(movementOption: Int) {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationController(contentViewController: navigationController)
        formSheetController.shouldApplyBackgroundBlurEffect = true
        formSheetController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears(rawValue: movementOption)!
        formSheetController.contentViewControllerTransitionStyle = .Fade
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
            default: break;
            }
        } else if indexPath.section == 1 {
            presentFormSheetControllerWithTransition(indexPath.row)
        } else if indexPath.section == 2 {
            presentFormSheetControllerWithKeyboardMovement(indexPath.row)
        }
    }
}

