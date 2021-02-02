//
//  UICollectionView+Register.swift
//  BaseDemo
//
//  Created by macOS on 8/28/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerCell<T: XibInitalization>(_ viewType : T.Type) {
        register(viewType.xib(), forCellWithReuseIdentifier: viewType.identifier)
    }
}
