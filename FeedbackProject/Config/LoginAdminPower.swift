//
//  LoginAdminPower.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/5/17.
//

import UIKit

class LoginAdminPower: NSObject {

    /// 判断是否是管理者
    static func isAdmin() -> Bool {
        
        guard let loginModel = RealmManagerTool.shareManager().queryObjects(objectClass: LoginModel.self,filter: "ID = 'login'",.login).first else { return false}
        
        if (loginModel.username != nil) && (loginModel.password != nil) {
            if loginModel.adminuser == "0" {
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    
}
