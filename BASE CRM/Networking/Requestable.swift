//
//  Requestable.swift
//  BaseDemo
//
//  Created by macOS on 8/31/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
//import PromiseKit
import Alamofire
import ObjectMapper

/// Requestable function
protocol Requestable {
//    associatedtype T
    
    var basePath: String {get}
    var endPoint: String {get}
    var httpMethod: HTTPMethod {get}
    var params: BASEParameters? {get}
    var headers: BASEHeaderParameter? {get}
    var parameterEncoding: ParameterEncoding {get}

//    func toPromise() -> Promise<T>
//    func decode(data: Any) -> T?
    func addBody(request: inout URLRequest)
    
    init(params: BASEParameters?, headers: BASEHeaderParameter?)
}

extension Requestable {
    // Variable
    typealias BASEParameters = [String: Any]
    typealias BASEHeaderParameter = [String: Any]

    var basePath: String {
        return Constants.App.BaseURL
    }

    var urlPath: String {
        let path = basePath + endPoint
        Logger.info(path)
        return path
    }

    var url: URL {
        return URL(string: urlPath)!
    }
    
    var parameterEncoding: ParameterEncoding {
        get { return JSONEncoding.default }
    }
    
    func buildURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = self.httpMethod.rawValue
        request.timeoutInterval = TimeInterval(10)
        
        addBody(request: &request)
    
        // Add addional Header if need
        if let headers = self.headers  {
            for (key, value) in headers {
                request.addValue(value as! String , forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    func addBody(request: inout URLRequest) {
        let data = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        request.httpBody = data
    }

}

// MARK: - Conform URLConvitible from Alamofire
extension Requestable {
    func asURLRequest() -> URLRequest {
        return buildURLRequest()
    }
}
