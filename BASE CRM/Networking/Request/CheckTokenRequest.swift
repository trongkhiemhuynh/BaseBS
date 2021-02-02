//
//  CheckTokenRequest.swift
//  BaseDemo
//
//  Created by macOS on 12/17/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import Alamofire

class CheckTokenRequest: Requestable {
    var headers: BASEHeaderParameter?
    var params: BASEParameters?
    
    required init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
    
    var endPoint: String {
        return Constants.APIEndPoint.CheckToken
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    func addBody(request: inout URLRequest) {
        
    }
    
    typealias T = CheckTokenRequest
}
