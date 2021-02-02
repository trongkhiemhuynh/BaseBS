//
//  DashboardTicketCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class DashboardTicketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 12.0
        Logger.info(self.bounds)
        print("khiemht---bounds")
        Logger.info(self.contentView.bounds)
    }

}

extension DashboardTicketCollectionViewCell: XibInitalization {
    typealias Element = DashboardTicketCollectionViewCell
}
