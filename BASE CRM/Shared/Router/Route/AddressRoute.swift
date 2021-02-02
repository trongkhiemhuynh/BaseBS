//
//  AddressRoute.swift
//  BaseDemo
//
//  Created by macOS on 9/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

class AddressRoute: Router {
    typealias Element = AddressController
    
    var routerType: RouterType {
        return .push
    }
    
    fileprivate lazy var _viewController: AddressController = {
        return AddressController.xibInstance()
    }()

    var viewController: AddressController {
        return self._viewController
    }
}
