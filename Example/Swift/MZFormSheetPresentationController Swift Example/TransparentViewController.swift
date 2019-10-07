//
//  TransparentViewController.swift
//  MZFormSheetPresentationController Swift Example
//
//  Created by Michal Zaborowski on 22.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

import UIKit

class TransparentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func turnOnTransparencyButtonTapped() {
        if let viewController = self.mz_formSheetPresentingPresentationController() {
            viewController.presentationController?.backgroundColor = UIColor.clear
            viewController.presentationController?.isTransparentTouchEnabled = true
        }
        
    }
    
    @IBAction func turnOffTransparencyButtonTapped() {
        if let viewController = self.mz_formSheetPresentingPresentationController() {
            viewController.presentationController?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            viewController.presentationController?.isTransparentTouchEnabled = false
        }
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}
