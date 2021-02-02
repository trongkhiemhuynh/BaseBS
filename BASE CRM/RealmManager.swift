//
//  RealmManager.swift
//  BaseDemo
//
//  Created by macOS on 10/15/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
//import RealmSwift

let kLogin = "KLOGIN"

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    func reset() {
//        guard let realm = try? Realm(), let object = onGetLoginObject() as? LoginObject else {return}
//
//        try? realm.write {
//            realm.delete(object)
//        }
        let userDefault = UserDefaults.standard
//        userDefault.set(nil, forKey: kLogin)
        userDefault.removeObject(forKey: kLogin)
        userDefault.synchronize()
    }
    
    func onModifiedObject(object: NSObject) {
//        let realm = try? Realm()
//        try? realm?.write {
//            realm?.add(object, update: .modified)
//        }
    }
    
    func onGetLoginObject() -> NSObject? {
//        let realm = try? Realm()
//
//        let obj = realm?.objects(LoginObject.self)
//
//        return obj?.first
        let userDefault = UserDefaults.standard
        if let data = userDefault.object(forKey: kLogin) as? Data {
            let objLogin = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginObj
            return objLogin
        }
       
        return nil
    }
    
    func onGetIDObject() -> String? {
//        let realm = try? Realm()
//        if let objs = realm?.objects(MenuObject.self) {
//            for obj in objs {
//                if obj.isSelected == true {
//                    return obj.value
//                }
//            }
//        }
//
//        return nil
        return ""
    }
    
    func onUpdateSelectedObject(nameObject: String) {
//        let realm = try? Realm()
//        if let objs = realm?.objects(MenuObject.self) {
//            for obj in objs {
//                if obj.key == nameObject {
//                    try? realm?.write {
//                        obj.isSelected = true
//                    }
//
//                    break
//                }
//            }
//        }
    }
    
    func resetAllStateObject() {
//        let realm = try? Realm()
//        if let objs = realm?.objects(MenuObject.self) {
//            for obj in objs {
//                obj.isSelected = false
//                
//                try! realm?.write {
//                    realm?.add(obj, update: .modified)
//                }
//            }
//        }
    }
    
}
