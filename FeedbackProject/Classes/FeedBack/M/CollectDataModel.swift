//
//  CollectDataModel.swift
//  FeedbackProject
//
//  Created by 梁诗鹏 on 2022/4/20.
//

import UIKit
import RealmSwift

class CollectDataModel: Object {
    
    required override init() {

    }
   
    @objc dynamic var FormId: String? //ID
    
    @objc dynamic var ID: String? //ID
    
    var lableCount: Int? //ID
    
    var singleSelected = List<String>() //single

    var multitedSelected = List<String>() //single
    
    // 主键
    override class func primaryKey() -> String? {
        return "ID"
    }
}
