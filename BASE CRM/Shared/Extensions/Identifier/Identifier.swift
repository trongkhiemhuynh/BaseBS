//
//  Identifier.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Identifier protocol
protocol Identifier {
    static var identifier : String {get}
}

// MARK: - Extension
extension Identifier {
    static var identifier : String {
        return String(describing: self)
    }
}

// MARK: - automatically conform
extension UIViewController : Identifier {}
extension UIView : Identifier {}


