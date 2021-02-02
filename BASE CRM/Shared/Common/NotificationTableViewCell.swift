//
//  NotificationTableViewCell.swift
//  BaseDemo
//
//  Created by macOS on 9/9/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var iv:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = Color.BackgroundListColor()
        self.backgroundColor = Color.BackgroundListColor()
        iv.layer.cornerRadius = iv.bounds.height/2
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NotificationTableViewCell: XibInitalization {
    typealias Element = NotificationTableViewCell
}
