//
//  FeedbackModel.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/8.
//

import Foundation
import RealmSwift

class FeedbackModel: Object ,NSCopying{
  
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopyObj = type(of: self).init()
        theCopyObj.ID = self.ID
        theCopyObj.title = self.title
        theCopyObj.descriptio = self.descriptio
        theCopyObj.status = self.status
        theCopyObj.createDate = self.createDate
        theCopyObj.author = self.author
        theCopyObj.richtext = self.richtext

        theCopyObj.Child = self.Child
        return theCopyObj

    }
    
    required override init() {

    }

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
    
      var Child = List<FromChildTypeModel>()

}


class FromChildTypeModel: Object ,NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
    
        let theCopyObj = Swift.type(of: self).init()
        theCopyObj.ID = self.ID
        theCopyObj.title = self.title
        theCopyObj.content = self.content
        theCopyObj.type = self.type
        theCopyObj.editStatu = self.editStatu
        theCopyObj.isSelet = self.isSelet
        theCopyObj.height = self.height
        for model in self.chioceList{
            theCopyObj.chioceList.append(model.copy() as! ChioceModel)
        }
        for model in self.ImageList{
            theCopyObj.ImageList.append(model.copy() as! ImageChioceModel)
        }
        return theCopyObj
    }
    
    required override init() {

    }
  
    
    @objc dynamic var ID: String? //ID

    @objc dynamic var title: String? //标题

    @objc dynamic var content: String? //内容

    @objc dynamic var type: String? // FormCell类型

    @objc dynamic var editStatu: String? // FormCell编辑状态 0 Normal 1 Edit 2 UnEdit

    @objc dynamic var isSelet: Bool = false // FormCell选中状态

    @objc dynamic var height: Int = 104 // assgin

    var chioceList = List<ChioceModel>()
    
    var ImageList = List<ImageChioceModel>()
}



class ChioceModel: Object ,NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let theCopyObj = type(of: self).init()
        theCopyObj.ID = self.ID
        theCopyObj.title = self.title
        theCopyObj.isEdit = self.isEdit
        return theCopyObj

    }
    
    required override init() {

    }
    @objc dynamic var ID: String? //ID

    @objc dynamic var title: String? //标题
    
    @objc dynamic var isEdit: Bool = false // assgin
    
}

class ImageChioceModel: Object ,NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let theCopyObj = type(of: self).init()
        theCopyObj.ID = self.ID
        theCopyObj.title = self.title
        theCopyObj.imageUrl = self.imageUrl
        return theCopyObj

    }
    
    required override init() {

    }
    @objc dynamic var ID: String? //ID
    
    @objc dynamic var title: String? //标题

    @objc dynamic var imageUrl: String? //图片
    
}
