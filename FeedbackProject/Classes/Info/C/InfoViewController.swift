//
//  InfoViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts
import SwiftUI

class InfoViewController: BaseViewController ,ChartViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginOut()
    }

    func loginOut() {
        guard let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self,filter: "ID = 'login'",.login).first else { return }
        RealmManagerTool.shareManager().deleteObject(object: loginModel, .login)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            let vc: BaseNaviController = BaseNaviController(rootViewController: LoginViewController())
            appDelegate.window?.rootViewController = vc
        }
        
    }
    
}
