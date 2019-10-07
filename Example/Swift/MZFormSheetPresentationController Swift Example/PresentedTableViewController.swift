//
//  PresentedTableViewController.swift
//  MZFormSheetPresentationController Swift Example
//
//  Created by Michal Zaborowski on 18.06.2015.
//  Copyright (c) 2015 Michal Zaborowski. All rights reserved.
//

import UIKit

class PresentedTableViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    var textFieldBecomeFirstResponder: Bool = false
    var passingString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(PresentedTableViewController.close))
        
        if let text = self.passingString {
            self.textField.text = text;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if textFieldBecomeFirstResponder {
            self.textField.becomeFirstResponder()
        }
    }
    
    @objc func close() -> Void {
        self.dismiss(animated: true, completion: nil)
    }

}
