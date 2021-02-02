//
//  UITableView+Register.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: XibInitalization>(_ viewType : T.Type) {
        self.register(viewType.xib(), forCellReuseIdentifier: viewType.identifier)
    }
}
