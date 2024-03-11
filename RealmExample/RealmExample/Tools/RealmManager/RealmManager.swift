//
//  RealmManager.swift
//  RealmExample
//
//  Created by 王延磊 on 2024/3/7.
//

import Foundation
import RealmSwift
import HandyJSON
struct RealmManager {
    private var realm: Realm
    static var share = RealmManager()
    
    private init() {
        
        self.realm = try! Realm()
    }
    /**
     * 查询数据
     */
    func findObjects<T: Object>(withType type: T.Type) -> [T] {
        let models = realm.objects(type).compactMap { $0 } as [T]
        return models
    }
    
    /**
     * 带有排序的查找，默认升序
     */
    func findObjects<T: Object>(withType type: T.Type, keyPath:String,ascending:Bool=true) -> [T] {
        let models = realm.objects(type).sorted(byKeyPath: keyPath, ascending: ascending).compactMap { $0 } as [T]
        return models
    }
    
    func findObjects<T: Object>(withType type: T.Type, filter: String) -> [T] {
        let models = realm.objects(type).filter(filter).compactMap { $0 } as [T]
        return models
    }
    
    /**
     * 添加数据
     */
    func updateObject<T: Object>(_ data: T) {
        try! realm.write {
            realm.add(data, update: .all)
        }
    }
    func updateObjects<T: Object>(_ datas: [T]){
        try! realm.write {
            realm.add(datas, update: .all)
        }
    }
    
    
    /**
     * 删除数据
     */
    func deleteObject<T: Object>(_ data: T) {
        try! realm.write {
            realm.delete(data)
        }
    }
    func deleteObjects<T: Object>(_ datas: [T]) {
        guard datas.count != 0 else { return }
        try! realm.write {
            realm.delete(datas)
        }
    }
    func deleteAll(){
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    /// 获取数据库中第一个model
    /// - Parameter type: model类型
    /// - Returns: model
    static func getFirstObject<T: Object>( _ type: T.Type) -> T {
        return RealmManager.share.findObjects(withType: type).first ?? T()
    }
}


extension Object{
    
    /// 单独处理数组
    /// - Parameters:
    ///   - models: 数组原始数据
    ///   - key: 属性名
    @objc func configListValue(models:[Any], key:String) {}
    
    /// HandyJSON转Realme
    /// - Parameter model: HandyJSON原始数据
    /// - Returns: Realme类型数据
    func create(by model: HandyJSON)-> Object{
        
        var realmKeys = [String]()
        let mirror_realm = Mirror(reflecting: self)
        for m in mirror_realm.children {
            let key = m.label ?? ""
            realmKeys.append(key)
        }
       let mirror = Mirror(reflecting: model)
        
       for child in mirror.children {
           let key = child.label ?? ""
           if !realmKeys.contains(key) {
               continue
           }
           var value = child.value
           if child.value is HandyJSON {
               let realm_value = self.value(forKey: key)
               let subClassName = (realm_value as! Object).className1
               let subClass = NSClassFromString(subClassName) as! Object.Type
               value = subClass.init().create(by: child.value as! HandyJSON)
           }
           if child.value is Array<Any> {
               self.configListValue(models: child.value as! [Any],key: key)
               continue
           }
           self.setValue(value, forKey: key)
       }
       return self
   }
}
