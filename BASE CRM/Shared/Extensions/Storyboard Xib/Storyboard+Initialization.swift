//
//  Storyboard+Initialization.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInitialization : Identifier {
    associatedtype Element : Identifier
    static var storyBoardController : Element {get}
}

extension StoryboardInitialization where Element : UIViewController {
    static var storyBoardController : Element {
        let storyboard = UIStoryboard(name: Element.identifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Element.identifier) as! Element 
    }
}
