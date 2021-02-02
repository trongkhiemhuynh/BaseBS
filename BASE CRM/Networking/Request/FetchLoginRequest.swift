//
//  FetchLoginRequest.swift
//  BaseDemo
//
//  Created by macOS on 9/3/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Alamofire
import ObjectMapper
import Foundation
//import PromiseKit

class FetchLoginRequest: NSObject, Requestable {
    var headers: BASEHeaderParameter?
    var params: BASEParameters?
    
    required init(params: BASEParameters?, headers: BASEHeaderParameter?) {
        self.params = params
        self.headers = headers
    }

    func addBody(request: inout URLRequest) {
        if let params = params as? [String: String] {
            print(params)
        
            try? request.setMultipartFormData(params, encoding: .utf8)
        }
    }
    
    typealias T = LoginObj
    
    //decode data
    func decode(data: Any) -> LoginObj? {
        if let d = data as? Data {
            if let jsObj = try? JSONSerialization.jsonObject(with: d, options: []) as? [String : Any] {
                Logger.info(jsObj)

                return LoginObj(JSON: jsObj)!
            } else {
                return nil
            }
        } else {
            return nil
        }

    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var endPoint: String {
        return Constants.APIEndPoint.Login
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    required init(params: BASEParameters?) {
        
    }
    
//    func toPromise() -> Promise<LoginObj> {
//        return Promise<T> { seal in
//            let request = asURLRequest()
//            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
//            
//            session.dataTask(with: request) {
//                (data: Data?, response: URLResponse?, error: Error?) in
//                
//                if(error != nil) {
////                    print("Error: \(error)")
//                    let error = NSError(domain: "com.basebs.crm", code: 1234, userInfo:[NSLocalizedDescriptionKey : error?.localizedDescription])
//                    seal.reject(error)
//                } else {
//                    if let result = self.decode(data: data as Any) {
//                        seal.fulfill(result)
//                    } else {
//                        seal.reject(NSError.invalidUsernameOrPassword())
//                    }
//                }
//            }.resume()
//        }
//    }
}

extension FetchLoginRequest: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

        completionHandler(.useCredential, urlCredential)
    }
}
