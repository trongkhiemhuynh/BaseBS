//
//  PopUpConfirm.swift
//  BaseDemo
//
//  Created by macOS on 8/27/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class PopUpConfirm: BaseView {

    @IBOutlet weak var btnOk : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    
    override func awakeFromNib() {
        btnOk.layer.borderWidth = 1
        btnOk.layer.borderColor = Color.MainAppColor().cgColor
    }
    
    @IBAction func actionOk() {
        delegateAddSubView?.onPopView?()
    }
    
    @IBAction func actionCancel() {
        removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
