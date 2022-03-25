//
//  FeedbackModel.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/8.
//

import Foundation
import RealmSwift

class FeedbackModel: Object {

    @objc dynamic var ID: String? //ID
    
    @objc dynamic var title: String? //标题
    
    @objc dynamic var descriptio: String? // descriptio描述
    
    @objc dynamic var status: String? //all 0 "Testing" 1 ,"Save" 2 ,"Publish" 3
    
    @objc dynamic var createDate : Date? // createDate
     
    @objc dynamic var author: String? // 发布者
    
//    @objc dynamic var choice: Array<Any>? //多选框
    
    @objc dynamic var richtext: String? //
    // 主键
    override class func primaryKey() -> String? {
        return "ID"
    }
    
    
}
