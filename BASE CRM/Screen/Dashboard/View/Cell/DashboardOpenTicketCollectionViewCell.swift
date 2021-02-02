//
//  DashboardOpenTicketCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class DashboardOpenTicketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init")
    }

    override func layoutSubviews() {
        print("layoutSubviews")
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
        Logger.info(self.bounds)
        
        lbl1.layer.cornerRadius = lbl1.bounds.height/2
        lbl2.layer.cornerRadius = lbl2.bounds.height/2
        lbl3.layer.cornerRadius = lbl3.bounds.height/2
        lbl1.clipsToBounds = true
        lbl2.clipsToBounds = true
        lbl3.clipsToBounds = true
    }
    
}

extension DashboardOpenTicketCollectionViewCell: XibInitalization {
    typealias Element = DashboardOpenTicketCollectionViewCell
}
