//
//  CustomTabBarView.swift
//  BaseDemo
//
//  Created by khiemht on 8/20/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

let ROOT_VIEW = 1000

class CustomTabBarView: UIView {
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    var itemTapped: ((_ tab : Int) -> Void)?
    var activeItem: Int = 0
    
    @IBAction func tappedButton(_ sender : UIButton) {
        switchTab(from: self.activeItem, to: sender.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        if from != to {
            deactiveTab(tab: from)
            activateTab(tab: to)
        } else {
            itemTapped!(ROOT_VIEW)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
    func setupView() {
//        activateTab(tab: activeItem)
        lbl1.textColor = Color.MainAppColor()
        iv1.image = UIImage(named: "home_select_1")
        iv2.image = UIImage(named: "menu_unselect_1")
        iv3.image = UIImage(named: "search_unselect_1")
        iv4.image = UIImage(named: "noti_unselect_1")
        iv5.image = UIImage(named: "personal_unselect_1")
    }
    
    func deactiveTab(tab: Int) {
        Logger.info("steve-- \(tab)")
        //        let btn = viewWithTag(tab) as? UIButton
        //        btn?.setTitleColor(Color.TextTitleColor, for: .normal)
        switch tab {
        case 0:
            lbl1.textColor = Color.TextTitleColor
            iv1.image = UIImage(named: "home_unselect_1")
        case 1:
            lbl2.textColor = Color.TextTitleColor
            iv2.image = UIImage(named: "menu_unselect_1")
        case 2:
            lbl3.textColor = Color.TextTitleColor
            iv3.image = UIImage(named: "search_unselect_1")
        case 3:
            lbl4.textColor = Color.TextTitleColor
            iv4.image = UIImage(named: "noti_unselect_1")
        case 4:
            lbl5.textColor = Color.TextTitleColor
            iv5.image = UIImage(named: "personal_unselect_1")
        default:
            print("out of range")
        }
    }
    
    func activateTab(tab : Int) {
        Logger.info("steve-- \(tab)")

        switch tab {
        case 0:
            lbl1.textColor = Color.MainAppColor()
            iv1.image = UIImage(named: "home_select_1")
        case 1:
            lbl2.textColor = Color.MainAppColor()
            iv2.image = UIImage(named: "menu_select_1")
        case 2:
            lbl3.textColor = Color.MainAppColor()
            iv3.image = UIImage(named: "search_select_1")
        case 3:
            lbl4.textColor = Color.MainAppColor()
            iv4.image = UIImage(named: "notification_select_1")
        case 4:
            lbl5.textColor = Color.MainAppColor()
            iv5.image = UIImage(named: "personal_select_1")
        default:
            print("out of range")
        }
        
        activeItem = tab
        itemTapped!(tab)
    }
}

extension CustomTabBarView: XibInitalization {
    typealias Element = CustomTabBarView
}
