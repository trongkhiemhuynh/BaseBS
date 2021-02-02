//
//  MenuCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 9/8/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgMenu : UIImageView!
    @IBOutlet weak var lblMenu : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension MenuCollectionViewCell : XibInitalization {
    typealias Element = MenuCollectionViewCell
}
