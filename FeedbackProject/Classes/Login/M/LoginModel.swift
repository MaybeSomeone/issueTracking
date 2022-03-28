//
//  LoginModel.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit
import Foundation
import RealmSwift

class LoginModel: Object {

    @objc dynamic var ID = "login"
    
    @objc dynamic var password: String?
    
    @objc dynamic var username: String?
    // 主键
    override class func primaryKey() -> String? {
        return "ID"
    }
    
}
