//
//  AddActionCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 1/26/21.
//  Copyright © 2021 BASEBS. All rights reserved.
//

import UIKit

class AddActionCollectionViewCell: UICollectionViewCell {

    var handler: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addValue() {
        handler()
    }

}

extension AddActionCollectionViewCell: XibInitalization {
    typealias Element = AddActionCollectionViewCell
}
