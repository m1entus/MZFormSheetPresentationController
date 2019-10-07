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
        MZTransition.registerClass(CustomTransition.self, for: .custom)
    }

    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewController(withIdentifier: "formSheetController") as! UINavigationController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func blurEffectAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffect.Style.dark
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func parallaxEffectAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func customContentViewSizeAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.contentViewSize = CGSize(width: 100, height: 100)
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func compressedContentViewSizeAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.contentViewSize = UIView.layoutFittingCompressedSize
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func expandedContentViewSizeAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.contentViewSize = UIView.layoutFittingExpandedSize
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func customBackgroundColorAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func centerVerticallyAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldCenterVertically = true
        let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
        presentedViewController.textFieldBecomeFirstResponder = true
        
        formSheetController.presentationController?.frameConfigurationHandler = { [weak formSheetController] view, currentFrame, isKeyboardVisible in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                return CGRect(x: formSheetController!.presentationController!.containerView!.bounds.midX - 210, y: currentFrame.origin.y, width: 420, height: currentFrame.size.height)
            }
            return currentFrame
        };
        
        self.present(formSheetController, animated: true, completion: nil)
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
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func twoFormSheetControllersAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.portraitTopInset = 10
        self.present(formSheetController, animated: true, completion: {
            let navigationController = self.formSheetControllerWithNavigationController()
            let formSheetController2 = MZFormSheetPresentationViewController(contentViewController: navigationController)
            formSheetController2.presentationController?.shouldDismissOnBackgroundViewTap = true
            formSheetController2.presentationController?.shouldApplyBackgroundBlurEffect = true
            formSheetController.present(formSheetController2, animated: true, completion: nil)
        })
    }
    
    func transparentBackgroundViewAction() {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "TransparentViewController")
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: viewController)
        formSheetController.presentationController?.isTransparentTouchEnabled = false
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func panGestureDismissingGesture() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.interactivePanGestureDismissalDirection = .all;
        self.present(formSheetController, animated: true, completion: nil)
    }

    func formSheetView() {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200.0, height: 25.0)))
        label.backgroundColor = .blue
        label.text = "Testing with just a view"
        label.textAlignment = .center
        label.textColor = .white

        let formSheetController = MZFormSheetPresentationViewController(contentView: label)
        if let presentationController = formSheetController.presentationController {
            presentationController.shouldCenterVertically = true
            presentationController.shouldDismissOnBackgroundViewTap = true
        }

        self.present(formSheetController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    func presentFormSheetControllerWithTransition(transition: Int) {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle(rawValue: transition)!
        
        self.present(formSheetController, animated: MZFormSheetPresentationTransitionStyle(rawValue: transition)! != .none, completion: nil)
    }
    
    func presentFormSheetControllerWithKeyboardMovement(movementOption: Int) {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears(rawValue: movementOption)!
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.fade
        let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
        presentedViewController.textFieldBecomeFirstResponder = true
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: passDataToViewControllerAction()
            case 1: blurEffectAction()
            case 2: parallaxEffectAction()
            case 3: customContentViewSizeAction()
            case 4: compressedContentViewSizeAction()
            case 5: expandedContentViewSizeAction()
            case 6: customBackgroundColorAction()
            case 7: /* Storyboard segue */ break;
            case 8: centerVerticallyAction()
            case 9: contentViewShadowAction()
            case 10: twoFormSheetControllersAction()
            case 11: transparentBackgroundViewAction()
            case 12: panGestureDismissingGesture()
            case 13: formSheetView()
            default: break;
            }
        } else if indexPath.section == 1 {
            presentFormSheetControllerWithTransition(transition: indexPath.row)
        } else if indexPath.section == 2 {
            presentFormSheetControllerWithKeyboardMovement(movementOption: indexPath.row)
        }
    }
}

