//
//  CustomTransition.swift
//  MZFormSheetPresentationController Swift Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, MZFormSheetPresentationViewControllerTransitionProtocol {
   
    func entryFormSheetControllerTransition(formSheetController: UIViewController, completionHandler: MZTransitionCompletionHandler) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform")
        bounceAnimation.fillMode = kCAFillModeBoth
        bounceAnimation.removedOnCompletion = true
        bounceAnimation.duration = 0.4
        bounceAnimation.values = [
            NSValue(CATransform3D: CATransform3DMakeScale(0.01, 0.01, 0.01)),
            NSValue(CATransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)),
            NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1.1)),
            NSValue(CATransform3D: CATransform3DIdentity)
        ]
        bounceAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
        bounceAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        bounceAnimation.delegate = self
        bounceAnimation.setValue((completionHandler as? AnyObject)!, forKey: "completionHandler")
        formSheetController.view.layer.addAnimation(bounceAnimation, forKey: "bounce")
    }
    
    func exitFormSheetControllerTransition(formSheetController: UIViewController, completionHandler: MZTransitionCompletionHandler) {
        var formSheetRect = formSheetController.view.frame
        formSheetRect.origin.x = UIScreen.mainScreen().bounds.width
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            formSheetController.view.frame = formSheetRect
        }, completion: {(value: Bool)  -> Void in
            completionHandler()
        })
    }
    
}
