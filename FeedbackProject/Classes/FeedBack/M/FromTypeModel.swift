//
//  EditTypeModel.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/9.
//

import UIKit
import Foundation
import RealmSwift
//import SwiftUI


class FromTypeModel: Object {

    @objc dynamic var ID: String? //ID

    @objc dynamic var title: String? //Form标题

    @objc dynamic var statu: String? //Form类型 0 Testing 2Save 3Publish

    var Child = List<FromChildTypeModel>()
    
}

class FromChildTypeModel: Object {

    @objc dynamic var ID: String? //ID

    @objc dynamic var title: String? //标题

    @objc dynamic var type: String? // FormCell类型

    @objc dynamic var editStatu: String? // FormCell编辑状态 0 Normal 1 Edit 2 UnEdit

    @objc dynamic var isSelet: Bool = false // FormCell选中状态

    @objc dynamic var height: Int = 104 // assgin

    var chioceList = List<ChioceModel>()
    
    var ImageList = List<ImageChioceModel>()
}



class ChioceModel: Object {
    
    @objc dynamic var ID: String? //ID

    @objc dynamic var title: String? //标题
    
    @objc dynamic var isEdit: Bool = false // assgin
    
}

class ImageChioceModel: Object {
    
    @objc dynamic var ID: String? //ID
    
    @objc dynamic var title: String? //标题

    @objc dynamic var imageUrl: String? //图片
    
}
