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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("formSheetController") as! UINavigationController
    }
    
    func presentFormSheetControllerWithKeyboardMovement(movementOption: Int) {
//        let navigationControll
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            presentFormSheetControllerWithKeyboardMovement(indexPath.row)
        }
    }
}

