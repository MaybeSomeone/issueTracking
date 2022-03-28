//
//  RealmManagerToolTool.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

import UIKit
import RealmSwift
import SwiftUI


/// 每次添加数据库表的时候 需要给下面两个方法都添加上才可以
enum RealmDANameType: String {
    /// 登录
    case login = "/LoginDB.realm"
    /// 注册
    case register = "/RegisterDB.realm"
    ///feedback数据
    case feedback = "/FeedbackDB.realm"
    ///Issue数据
    case issue = "/IssueDB.realm"
    ///template数据
    case template = "/TemplateDB.realm"
    
   
}

extension RealmDANameType: EnumeratableEnumType {
    static var allValues: [RealmDANameType] {
        return [.login, .register]
    }
}


class RealmManagerTool: NSObject {
    
    static let _shareManager = RealmManagerTool()
    
    class func shareManager()->RealmManagerTool{
        return _shareManager
    }
    
    // Make sure the class has only one instance
    // Should not init or copy outside
    private override init() {}
    
    override func copy() -> Any {
        return self // RealmManagerTool.shared
    }
    
    override func mutableCopy() -> Any {
        return self // RealmManagerTool.shared
    }
    
}

protocol EnumeratableEnumType {
    static var allValues: [Self] {get}
}


/// 配置
extension RealmManagerTool  {
    
    
    ///  配置数据库
    func configRealm() {
        /// 这个方法主要用于数据模型属性增加或删除时的数据迁移，每次模型属性变化时，将 dbVersion 加 1 即可，Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构，移除属性的数据将会被删除。
        let dbVersion: UInt64 = 8
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        for item in RealmDANameType.allValues {
            let dbPath = docPath.appending(item.rawValue)
            /// 这里可以添加个Switch语句 来判断是哪个数据库需要迁移
            let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { [weak self] (migration, oldSchemaVersion) in
                guard let weakself = self else{ return }
                /// 所有的数据迁移都在这边使用
                if (oldSchemaVersion < dbVersion) {
                }
            }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
            Realm.Configuration.defaultConfiguration = config
            Realm.asyncOpen { realm in
                switch realm {
                case .success(let rm):
                    DebugPrint("Realm 服务器配置成功! \(rm.configuration.fileURL?.absoluteString ?? "")")
                case .failure(let error):
                    DebugPrint("Realm 数据库配置失败：\(error.localizedDescription)")
                }
            }
        }
    }
    
    func getDB(_ dbType: RealmDANameType) -> Realm? {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending(dbType.rawValue)
        guard let url = URL.init(string: dbPath) else { return nil }
        
        do {
            // 传入路径会自动创建数据库
            let defaultRealm = try Realm(fileURL: url)
            return defaultRealm
        } catch {
            return nil
        }
    }
}
///数据迁移
extension RealmManagerTool {
    /// 新增字段
    /// - Parameters:
    ///   - migration: 上面block直接传进来
    ///   - objClass: model名称
    ///   - newObjectList: 新添加字段的数组
    func addNewObjects(_ migration: Migration,_ objClass: String,_ newObjectList: [String])  {
        migration.enumerateObjects(ofType: objClass) { (oldObject, newObject) in
            for obj in newObjectList{
                newObject?[obj] = ""
            }
        }
    }
    
    /// 编辑字段
    /// - Parameters:
    ///   - migration: 上面block直接传进来
    ///   - objClass: model名称
    ///   - newKey: 新字段名称
    ///   - oldKey: 旧字段名称
    func editNewObjects(_ migration: Migration,_ objClass: String,_ newKey: String,_ oldKey: String)  {
        migration.enumerateObjects(ofType: objClass) { (oldObject, newObject) in
            newObject?[newKey] = oldObject?[oldKey]
        }
    }
}

/// 新增
extension RealmManagerTool {
    /// 新增单条数据
    func addObject<T: Object>(object: T,_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                defaultRealm.add(object, update: .all)
            }
//            DebugPrint(defaultRealm.configuration.fileURL)
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
    
    /// 保存多条数据
    func addObjects<T: Object>(by objects : [T],_ dbType: RealmDANameType) -> Void {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                defaultRealm.add(objects , update: .all)
            }
            DebugPrint(defaultRealm.configuration.fileURL)
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
}

/// 删除
extension RealmManagerTool {
    
    /// 删除单条
    /// - Parameter object: 删除数据对象
    func deleteObject(object: Object?,_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        if object == nil {
            DebugPrint("无此数据")
            return
        }
        
        do {
            try defaultRealm.write {
                defaultRealm.delete(object!)
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
    
    /// 删除多条数据
    /// - Parameter objects: 对象数组
    func deleteObjects(objects: [Object]?,_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        if objects?.count == 0 {
            DebugPrint("无此数据")
            return
        }
        
        do {
            try defaultRealm.write {
                defaultRealm.delete(objects!)
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
    
    /// 根据条件去删除单条/多条数据
    func deleteObjectFilter<T: Object>(objectClass: T.Type, filter: String?,_ dbType: RealmDANameType) {
        let objects = queryObjects(objectClass: objectClass, filter: filter,dbType)
        deleteObjects(objects: objects, dbType)
    }
    
    /// 删除某张表
    /// - Parameter objectClass: 删除对象
    func clearTableClass(objectClass: Object,_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                defaultRealm.delete(defaultRealm.objects((Object.self).self))
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
}

/// 查
extension RealmManagerTool {

    /// 查询数据
    /// - Parameters:
    ///   - objectClass: 当前查询对象
    ///   - filter: 查询条件
    func queryObjects <T: Object> (objectClass: T.Type, filter: String? = nil,_ dbType: RealmDANameType) -> [T]{
        
        guard let defaultRealm = self.getDB(dbType) else { return [] }
        var results : Results<Object>
        
        if filter != nil {
            results = defaultRealm.objects((T.self as Object.Type).self).filter(filter!)
        } else {
            results = defaultRealm.objects((T.self as Object.Type).self)
        }
        
        guard results.count > 0 else { return [] }
        var objectArray = [T]()
        for model in results{
            objectArray.append(model as! T)
        }
        
        return objectArray
    }
}

/// 更新
extension RealmManagerTool {
    
    /// 打开事务并操作
    func doWriteHandler(_ dbType: RealmDANameType,_ clouse: @escaping ()->()) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                clouse()
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
    
    /// 更新单条数据
    func updateObject(object: Object,_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                defaultRealm.add(object, update: .all)
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
    
    /// 更新多条数据
    func updateObjects(objects : [Object],_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                defaultRealm.add(objects , update: .all)
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
    
    /// 更新多条数据的某一个属性
    func updateObjectsAttribute(objectClass : Object ,attribute:[String:Any],_ dbType: RealmDANameType) {
        
        guard let defaultRealm = self.getDB(dbType) else { return }
        
        do {
            try defaultRealm.write {
                let objects = defaultRealm.objects((Object.self).self)
                let keys = attribute.keys
                for keyString in keys {
                    objects.setValue(attribute[keyString], forKey: keyString)
                }
            }
        } catch {
            DebugPrint(error.localizedDescription)
        }
    }
}
