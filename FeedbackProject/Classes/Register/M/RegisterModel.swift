//
//  RegisterModel.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import Foundation
import RealmSwift

class RegisterModel: Object {
    
    @objc dynamic var ID = "register"
    
    @objc dynamic var password: String?
    
    @objc dynamic var username: String?
    // 主键
    override class func primaryKey() -> String? {
        return "ID"
    }
    
}
