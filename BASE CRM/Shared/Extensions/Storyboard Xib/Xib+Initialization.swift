//
//  Xib+Initialization.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

protocol XibInitalization : Identifier {
    
    associatedtype Element : Identifier
    
    static func xib() -> UINib
    static func xibInstance() -> Element
    
}

extension XibInitalization {
    static func xib() -> UINib {
        return UINib(nibName: Element.identifier, bundle: nil)
    }
}


extension XibInitalization where Element : UIView {
    static func xibInstance() -> Element {
        let xib = self.xib()
        
        return xib.instantiate(withOwner: self, options: nil).first as! Element
    }
}

extension XibInitalization where Element : UIViewController {
    static func xibInstance() -> Element {
        return Element(nibName: Element.identifier, bundle: nil)
    }
}
