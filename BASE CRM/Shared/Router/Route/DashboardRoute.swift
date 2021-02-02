//
//  DashboardRoute.swift
//  BaseDemo
//
//  Created by macOS on 9/8/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

class DashboardRoute : Router {
    typealias Element = DashboardController
    
    private var _viewController : DashboardController = {
        return DashboardController.xibInstance()
    }()
    
    var viewController: DashboardController {
        return _viewController
    }
    
    var routerType: RouterType {
        return .push
    }
}
