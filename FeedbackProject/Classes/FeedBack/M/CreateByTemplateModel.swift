//
//  CreateByTemplateModel.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/9.
//

import UIKit
import RealmSwift

class CreateByTemplateModel: Object {

    @objc dynamic var ID: String? //ID
    
    @objc dynamic var title: String? //标题
    
    @objc dynamic var descriptio: String? // descriptio描述
    
    @objc dynamic var createDate : Date? // createDate
    
    // 主键
    override class func primaryKey() -> String? {
        return "ID"
    }
    dynamic var Child = List<FromChildTypeModel>()

}
