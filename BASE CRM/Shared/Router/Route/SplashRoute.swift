//
//  SplashRoute.swift
//  BaseDemo
//
//  Created by macOS on 9/8/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

class SplashRoute : Router {
    
    typealias Element = SplashViewController

    var routerType: RouterType {
        return .root
    }
    
    fileprivate lazy var _viewController: SplashViewController = {
        return SplashViewController.xibInstance()
    }()
    
    var viewController: SplashViewController {
        return _viewController
    }
}
