//
//  Error+Default.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

extension NSError {
    static func unknownError() -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : "Opps!"]
        
        return NSError(domain: "com.basebs.crm.ios", code: 999, userInfo: userInfo)
    }
    
    static func invalidUsernameOrPassword() -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : "Invalid username or password!"]
        
        return NSError(domain: "com.basebs.crm.ios", code: 998, userInfo: userInfo)
    }
    
    static func sessionExpired() -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : "Something went wrong \n Please login again!"]
        
        return NSError(domain: "com.basebs.crm.ios", code: 111, userInfo: userInfo)
    }
    
}
