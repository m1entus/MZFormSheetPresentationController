//
//  CustomTransition.swift
//  MZFormSheetPresentationController Swift Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, CAAnimationDelegate, MZFormSheetPresentationViewControllerTransitionProtocol {
   
    func entryFormSheetControllerTransition(_ formSheetController: UIViewController, completionHandler: MZTransitionCompletionHandler) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform")
        bounceAnimation.fillMode = CAMediaTimingFillMode.both
        bounceAnimation.isRemovedOnCompletion = true
        bounceAnimation.duration = 0.4
        bounceAnimation.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 0.01)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.1)),
            NSValue(caTransform3D: CATransform3DIdentity)
        ]
        bounceAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
        bounceAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
        bounceAnimation.delegate = self
        bounceAnimation.setValue(completionHandler as AnyObject, forKey: "completionHandler")
        formSheetController.view.layer.add(bounceAnimation, forKey: "bounce")
    }
    
    func exitFormSheetControllerTransition(_ formSheetController: UIViewController, completionHandler: @escaping MZTransitionCompletionHandler) {
        var formSheetRect = formSheetController.view.frame
        formSheetRect.origin.x = UIScreen.main.bounds.width
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            formSheetController.view.frame = formSheetRect
        }, completion: {(value: Bool)  -> Void in
            completionHandler()
        })
    }
    
}
