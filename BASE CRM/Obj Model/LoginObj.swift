//
//  LoginObj.swift
//  BaseDemo
//
//  Created by macOS on 9/3/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginObj: NSObject, Mappable, NSCoding {
    required init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let tenant = coder.decodeObject(forKey: "tenant") as! String
        let token = coder.decodeObject(forKey: "token") as! String
        
        self.name = name
        self.tenant = tenant
        self.token = token
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(tenant, forKey: "tenant")
        coder.encode(token, forKey: "token")
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        if map.JSON["Token"] == nil {
            return nil
        }
    }
    
    /// Description
    /// - Parameter map:
    func mapping(map: Map) {
        self.name <- map[Constants.Obj.Login.name]
        self.tenant <- map[Constants.Obj.Login.tenant]
        self.token <- map[Constants.Obj.Login.token]
    }
    
    var name : String?
    var token : String?
    var tenant : String?
    
}

class ObjectView: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.idObj <- map["ID"]
        self.idField <- map["id_field"]
        self.nameObj <- map["name"]
        self.valueObj <- map["value"]
    }
    
    var idObj: String?
    var idField: String?
    var nameObj: String?
    var valueObj: String?
}

class ObjectList: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.dataList <- map["data.data"]
    }
    
    var dataList: Array<Any>?
}

class ObjectSubList: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.dataSubList <- map["data"]
        _id <- map["_id"]
    }
    
    var dataSubList: Array<ObjectView>?
    var _id: String?
}




