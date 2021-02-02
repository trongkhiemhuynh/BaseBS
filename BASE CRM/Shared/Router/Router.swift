//
//  Router.swift
//  BaseDemo
//
//  Created by macOS on 9/4/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

enum RouterType {
    case root
    case present
    case push
}

// MARK: - Basic Router protocol
protocol Router {
    
    associatedtype Element : UIViewController

    var routerType : RouterType {get}
    
    var viewController : Element {get}
    
    func handleData(_ block: (Element) -> Void)
    
}

extension Router {
    
    /// Passing data
    /// - Parameter block:
    func handleData(_ block: (Element) -> Void) {
        block(self.viewController)
    }
}
