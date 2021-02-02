//
//  AddressPagerCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 9/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class AddressPagerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = corner12Radius
        self.clipsToBounds = true
        self.backgroundColor = .white
    }
    
    func onUpdate(_ index: Int) {
        
        if index == 0 {
            lblCompany.text = "BASE Business Solution CORPORATION Ho Chi Minh"
            lblAddress.text = "Floor 12B, Doan Van Bo street, 4 district, Ho Chi Minh city"
            lblDirection.text = "Direction"
            lblPhone.text = "1900 633 568"
            lblMail.text = "info@basebs.com/marketing@basebs.com"
            lblWebsite.text = "basebs.com"
        } else {
            lblCompany.text = "BASE Business Solution CORPORATION Ha Noi"
            lblAddress.text = "Ha Noi"
            lblDirection.text = "Direction"
            lblPhone.text = "1900 633 568"
            lblMail.text = "info@basebs.com/marketing@basebs.com"
            lblWebsite.text = "basebs.com"
        }
        
    }

}

extension AddressPagerCollectionViewCell: XibInitalization {
    typealias Element = AddressPagerCollectionViewCell
}
