//
//  LogCallViewCell.swift
//  BaseDemo
//
//  Created by macOS on 9/23/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import SwipeCellKit

class LogCallViewCell: SwipeCollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var vMore: UIView!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Color.BackgroundListColor()
    }
    
    func onUpdate(name: String?, company: String, imageName: String) {
        lblName.text = name
        lblCompany.text = company
        ivAvatar.image = UIImage(named: imageName)
        lblCompany.isHidden = company == ""
        lblName.isHidden = name == ""
    }
}

extension LogCallViewCell: XibInitalization {
    typealias Element = LogCallViewCell
}
