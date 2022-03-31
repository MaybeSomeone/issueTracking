//
//  IssueModel.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/25.
//

import UIKit
import Foundation
import RealmSwift

class IssueModel: Object {

    @objc dynamic var ID: String? //ID
    
    @objc dynamic var title: String? //标题
    
    @objc dynamic var assgin: String? // assgin
    
    @objc dynamic var status: String? //all 0 "Open" 1 ,"In Progress" 2 ,"Resolved" 3 ,"Closed" 4
    
    @objc dynamic var createDate : Date? // createDate
    
    @objc dynamic var resolveDate : Date? // resolveDate
    
    @objc dynamic var closeDate : Date? // closeDate
    
    @objc dynamic var latestUpdateDate : Date? // latestUpdateDate
     
    @objc dynamic var author: String? // 发布者
    
    @objc dynamic var category: String? // all 0 "Finance" 1 ,"Sales" 2  ,"Human Resources" 3
    
    @objc dynamic var priority: String?// all 0 "Critical" 1 ,"High" 2 ,"Medium" 3 ,"Low" 4
    
    @objc dynamic var type: String?// Issue Type all 0  "Feature" 1 ,"Task" 2 ,"Bug" 3
    
    @objc dynamic var descriptio: String? // descriptio描述
    
    @objc dynamic var assignee: String? //all None -----发布者
    
    @objc dynamic var repro: String?
    
    @objc dynamic var comments: String?
    
    @objc dynamic var snpImage: String? // snpImage截图
    // 主键
    override class func primaryKey() -> String? {
        return "ID"
    }
    
    
}
