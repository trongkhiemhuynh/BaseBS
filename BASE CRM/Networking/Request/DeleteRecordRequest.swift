//
//  DeleteRecordRequest.swift
//  BaseDemo
//
//  Created by macOS on 12/17/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import Alamofire

struct DeleteRecordRequest: Requestable {
    var headers: BASEHeaderParameter?
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
    
    var endPoint: String {
        return Constants.APIEndPoint.DeleteObject
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var params: BASEParameters?
    
    func addBody(request: inout URLRequest) {
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        request.httpBody = jsonData
    }
    
    typealias T = DeleteRecordRequest
}
