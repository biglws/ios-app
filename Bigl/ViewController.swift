//
//  ViewController.swift
//  Bigl
//
//  Created by Roquie on 15/05/2017.
//  Copyright © 2017 Roquie. All rights reserved.
//

import UIKit
import Darwin
import RevealingSplashView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealingSplashView = showCompanyLogoWhenAppLoading()
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            revealingSplashView.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.performSegue(withIdentifier: "showSplitVC", sender: self)
            }
        }
    }
  
    func showCompanyLogoWhenAppLoading() -> RevealingSplashView {
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(
            iconImage: UIImage(named: "start-logo")!,
            iconInitialSize: CGSize(width: 100, height: 100),
            backgroundColor: UIColor(red:0, green:0, blue:0, alpha:1.0)
        )
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        return revealingSplashView
    }
}
