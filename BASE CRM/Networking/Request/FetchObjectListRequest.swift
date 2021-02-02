//
//  FetchObjectListRequest.swift
//  BaseDemo
//
//  Created by macOS on 12/15/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import Alamofire
//import PromiseKit

struct FetchObjectListRequest: Requestable {
    typealias T = FetchObjectListRequest
    var headers: BASEHeaderParameter?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }

    var params: BASEParameters?

    var endPoint: String {
        return Constants.APIEndPoint.ObjectList
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
//    
//    var header: BASEHeaderParameter? {
//        return ["CurrentPage": String(1),"RecordPerPage": String(20),"Authorization": authorization]
//    }
    
//    func addBody(request: inout URLRequest) {
//        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//        request.httpBody = jsonData
//    }
    
    init(params: BASEParameters?) {
        self.params = params
    }
}

struct FetchCustomViewListRequest: Requestable {
    var endPoint: String {
        return Constants.APIEndPoint.LoadSpecificCustomView
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var params: BASEParameters?
    
    var headers: BASEHeaderParameter?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
}

struct InsertRecordRequest: Requestable {
    typealias T = InsertRecordRequest
    var headers: BASEHeaderParameter?
    var params: BASEParameters?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.headers = headers
        self.params = params
    }
    
    init(params: BASEParameters?) {
        self.params = params
    }

    var endPoint: String {
        return Constants.APIEndPoint.Insert
    }

    var httpMethod: HTTPMethod {
        return .post
    }

    func addBody(request: inout URLRequest) {
        if let value = params?.values.first {
            let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            
            request.httpBody = jsonData
        }
    }
}

struct LoadFormRequest: Requestable {
    typealias T = LoadFormRequest
    var headers: BASEHeaderParameter?
    var params: BASEParameters?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.headers = headers
        self.params = params
    }

    var endPoint: String {
        return Constants.APIEndPoint.CreatedForm
    }

    var httpMethod: HTTPMethod {
        return .get
    }
    
    func addBody(request: inout URLRequest) {
        
    }
}

struct UpdateRecordRequest: Requestable {
    var endPoint: String {
        return Constants.APIEndPoint.UpdateRecord
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var params: BASEParameters?
    
    var headers: BASEHeaderParameter?
    
    func addBody(request: inout URLRequest) {
        let value = params?.values.first
        
        let data = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
        request.httpBody = data
    }
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
    
    typealias T = UpdateRecordRequest
}


struct LoadRecordRequest: Requestable {
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        
    }
    
    func addBody(request: inout URLRequest) {
    }
    
    var endPoint: String {
        return Constants.APIEndPoint.LoadRecord+"?object_id=\(object_id!)&id=\(id!)"
        
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var params: BASEParameters?
    
    var headers: BASEHeaderParameter?
    
    var object_id: String?
    var id: String?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?, object_id: String, id: String) {
        self.params = params
        self.headers = headers
        self.object_id = object_id
        self.id = id
    }
    
    typealias T = UpdateRecordRequest
}

struct LoadAllCustomViewRequest: Requestable {
    var endPoint: String {
        return Constants.APIEndPoint.LoadAllCustomView
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var params: BASEParameters?
    
    var headers: BASEHeaderParameter?

    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
}

struct LoadFieldsCustomView: Requestable {
    var endPoint: String {
        return Constants.APIEndPoint.FieldsCustomView
    }
    
    var httpMethod: HTTPMethod {
        return HTTPMethod.post
    }
    
    var params: BASEParameters?
    
    var headers: BASEHeaderParameter?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
}

struct DeleteCustomView: Requestable {
    var endPoint: String {
        return Constants.APIEndPoint.DeleteSpecificCustomView
    }
    
    var httpMethod: HTTPMethod {
        return HTTPMethod.post
    }
    
    var params: BASEParameters?
    
    var headers: BASEHeaderParameter?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
}
