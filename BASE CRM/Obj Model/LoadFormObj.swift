//
//  LoadFormObj.swift
//  BaseDemo
//
//  Created by macOS on 10/16/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import ObjectMapper

class LoadFormObj: Mappable {
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        message <- map["mess"]
        data <- map["data"]
        status <- map["status"]
    }
    
    var data: [DataObj]?
    var message: String?
    var status: Int?
}

class DataObj: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dat <- map["Data"]
    }
    
    var dat: [DatObj]?
}

class DatObj: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        type <- map["type"]
        name <- map["name"]
        option <- map["option"]
    }
    
    var type: String?
    var name: String?
    var option: [Country]?
    var id: String?
}

class Country: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        label <- map["label"]
        active <- map["active"]
    }
    
    var value: String?
    var label: String?
    var active: Bool?
}

class LoadFormList: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
//        arrForm <- map["data.0.Data"]
//        arrForm1 <- map["data.1.Data"]
        arrData <- map["data"]
    }
    
//    var arrForm: [LoadForm]?
//    var arrForm1: [LoadForm]?
    
    var arrData: [SectionForm]?
}

class SectionForm: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        sectionName <- map["Section_Name"]
        arrForm <- map["Data"]
    }
    
    var sectionName: String?
    var arrForm: [LoadForm]?
}

class LoadForm: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        name <- map["name"]
        id <- map["ID"]
        picklist <- map["option"]
        objectname <- map["objectname"]
        field <- map["field"]
        required <- map["required"]
        prefix <- map["prefix"]
    }
    
    var type: String?
    var name: String?
    var id: String?
    var picklist: [PickList]?
    var objectname: String?
    var field: String?
    var required: Int?
    var prefix: String?
}

class PickList: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        active <- map["active"]
        label <- map["label"]
        value <- map["value"]
    }
    
    var active: String?
    var label: String?
    var value: String?
}

struct OwnerModel: Codable {
    var firstName: String
    var lastName: String
    var middleName: String
    var idOwner: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "First_Name"
        case lastName = "Last_Name"
        case middleName = "Middle_Name"
        case idOwner = "_id"
    }
}

struct CustomViewModel: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "view_name"
    }
}

struct FieldCustomView: Codable {
    let name: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "name"
        case type = "type"
    }
}
