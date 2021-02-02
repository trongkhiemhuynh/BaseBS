//
//  FetchMenuRequest.swift
//  BaseDemo
//
//  Created by macOS on 12/17/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import Alamofire

class FetchMenuRequest: Requestable {
    var headers: BASEHeaderParameter?
    
    required init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }
    
    var endPoint: String {
        return Constants.APIEndPoint.Menu
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var params: BASEParameters?
    
    func addBody(request: inout URLRequest) {
        
    }

//    required init(params: BASEParameters?) {
//        
//    }
    
    typealias T = FetchMenuRequest
    
}
