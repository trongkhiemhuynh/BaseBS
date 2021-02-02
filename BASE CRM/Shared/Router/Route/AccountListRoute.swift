//
//  AccountListRoute.swift
//  BaseDemo
//
//  Created by macOS on 10/5/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

class AccountListRoute: Router {
    typealias Element = UIViewController
    
    var routerType: RouterType {
        return .push
    }
    
    fileprivate lazy var _viewController: UIViewController = {
        return UIViewController()
    }()

    var viewController: UIViewController {
        return self._viewController
    }
}
