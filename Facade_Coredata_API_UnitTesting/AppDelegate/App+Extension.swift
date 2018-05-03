//
//  App+Extension.swift
//  careem_execise
//
//  Created by Waseem on 24/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift


/**
   It shows Alert to a give view Controller
 - Parameter vc: viewcontroll who will present
 - Parameter title: String
 - Paramter message: message to display
 */
func showAlertMessage(_ vc:UIViewController,title:String = "Movies Search" , _ message:String) {
    
    // create the alert
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
    // show the alert
    vc.present(alert, animated: true, completion: nil)
}


//This shows the progress spinner on viewcontroller
func loadingViewWithText(text : String , hide : Bool) {
    
    let progressView = ACProgressHUD.shared
    
    if hide {
        
        progressView.hideHUD()
        
    }else{
        
        progressView.progressText = text
        progressView.shadowColor = .black
        progressView.indicatorColor = UIColor.gray
        progressView.shadowRadius = 10.0
        progressView.enableBlurBackground = false
        progressView.showHudAnimation = .growIn
        progressView.dismissHudAnimation = .growOut
        progressView.showHUD()
    }
}


