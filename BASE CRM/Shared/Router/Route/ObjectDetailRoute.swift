//
//  ObjectDetailRoute.swift
//  BaseDemo
//
//  Created by macOS on 10/15/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

class ObjectDetailRoute: Router {
    typealias Element = ObjectDetailController
    
    var routerType: RouterType {
        return .push
    }
    
    fileprivate lazy var _viewController: ObjectDetailController = {
        return ObjectDetailController()
    }()

    var viewController: ObjectDetailController {
        return self._viewController
    }
}
