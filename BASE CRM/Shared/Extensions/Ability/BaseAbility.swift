//
//  BaseAbility.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

protocol BaseAbility: class {
    
    func initBaseAbility()
    
    func initCommon()
    
    func initUIs()
    
    func initBinding()
    
    func initActions()
    
}

extension BaseAbility {
    func initBaseAbility() {
        initCommon()
        initUIs()
        initBinding()
        initActions()
    }
}
