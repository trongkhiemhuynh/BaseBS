//
//  DashboardDueTicketsCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class DashboardDueTicketsCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
    }

}

extension DashboardDueTicketsCollectionViewCell: XibInitalization {
    typealias Element = DashboardDueTicketsCollectionViewCell
}
