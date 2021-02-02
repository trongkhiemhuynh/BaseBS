//
//  MainRoute.swift
//  BaseDemo
//
//  Created by macOS on 9/8/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

class MainRoute: Router {

    typealias Element = MainAppController
    
    var routerType: RouterType {
        return .root
    }
    
    private lazy var _viewController: MainAppController = {
        return MainAppController.xibInstance()
    }()
    
    var viewController: MainAppController {
//        ApplicationManager.sharedInstance.mainTabbar = _viewController
        return _viewController
    }
}
