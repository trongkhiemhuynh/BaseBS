//
//  LoginRoute.swift
//  BaseDemo
//
//  Created by macOS on 9/4/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

class LoginRoute : Router {
    typealias Element = LoginController
    
    var routerType: RouterType {
        return .root
    }
    
    fileprivate lazy var _viewController: LoginController = {
        return LoginController.xibInstance()
    }()

    var viewController: LoginController {
        return self._viewController
    }
}
