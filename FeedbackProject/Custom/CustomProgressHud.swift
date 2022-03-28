//
//  CustomProgressHud.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/23.
//

import UIKit
import SVProgressHUD

class CustomProgressHud:  NSObject{

    static func show()  {
        DispatchQueue.main.async {
            SVProgressHUD.show()
            SVProgressHUD.dismiss(withDelay: 0.75)
        }
    }
     
    static func dismiss(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func showError(withStatus:String?){
        DispatchQueue.main.async {
            SVProgressHUD.showError(withStatus: withStatus)
            SVProgressHUD.dismiss(withDelay: 0.75)
        }
    }
 
    static func showSuccess(withStatus:String?){
        DispatchQueue.main.async {
            SVProgressHUD.showSuccess(withStatus: withStatus)
            SVProgressHUD.dismiss(withDelay: 0.75)
        }
    }
    
    static func showProgress(_ progress:Float){
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress)
        }
    }
}
