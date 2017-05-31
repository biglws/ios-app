//
//  GlobalSplitViewController.swift
//  Bigl
//
//  Created by Roquie on 24/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("i am called ...")
        
        self.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool{
        return false
    }
    
    
    
}
