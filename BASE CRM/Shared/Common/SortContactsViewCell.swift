//
//  SortContactsViewCell.swift
//  BaseDemo
//
//  Created by macOS on 9/10/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class SortContactsViewCell: UITableViewCell {

    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var iv:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iv.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SortContactsViewCell : XibInitalization {
    typealias Element = SortContactsViewCell
}
