//
//  CVAddCollectionViewCell.swift
//  BASE CRM
//
//  Created by khiemht on 1/28/21.
//  Copyright © 2021 HTK Technologies. All rights reserved.
//

import UIKit

class CVAddCollectionViewCell: UICollectionViewCell {
    
    var onDelete: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func delete() {
        onDelete!()
    }

}

extension CVAddCollectionViewCell: XibInitalization {
    typealias Element = CVAddCollectionViewCell
    
    
}
