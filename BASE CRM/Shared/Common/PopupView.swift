//
//  LoadingView.swift
//  BaseDemo
//
//  Created by khiemht on 8/21/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

//class PopupView: BaseView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//    @IBOutlet weak var iv:UIImageView!
//    @IBOutlet weak var tbl : UITableView!
//    @IBOutlet weak var vDismiss : UIView!
//
//    // dummydata
//    var arrItems = ["Change Owner","New Child Ticket"]
//
//    var isLeftIc: Bool = true
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.iv.layer.cornerRadius = 5.0
//
//        self.tbl.register(CustomPopUpTableViewCell.self)
//
//        self.tbl.isUserInteractionEnabled = true
//
//        vDismiss.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissView(gesture:))))
//    }
//
//    @objc func dismissView(gesture: UITapGestureRecognizer) {
//
//        removeFromSuperview()
//
//        UIView.animate(withDuration: 0.35, delay: 0.0, options: .transitionFlipFromTop, animations: {
//            self.layoutIfNeeded()
//        }) { (success) in
//            if success {
//
//            }
//        }
//
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//
//}

//extension PopupView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CustomPopUpTableViewCell.identifier, for: indexPath) as! CustomPopUpTableViewCell
//        let name = arrItems[indexPath.row]
//        cell.updateData(nameImg: name.lowercased().replacingOccurrences(of: " ", with: "_"), title: name, isLeftIc: isLeftIc)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return heightDefaultCell
//    }
//}

//extension PopupView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! CustomPopUpTableViewCell
//
//        guard let itemName = cell.lbl.text else {return}
//
//        switch itemName {
////        case "Email":
////            let extendRoute = ExtendRoute()
////            RouterManager.shared.handleRouter(extendRoute)
////            extendRoute.handleData { (controller) in
////                controller.extendedType = .email
////            }
//        case "Change Owner":
//            let route = ChangeOwnerRoute()
//            RouterManager.shared.handleRouter(route)
//        case "New Child Ticket":
//            let route = NewChildRoute()
//            RouterManager.shared.handleRouter(route)
//        default:
//            print("bug!!!")
//        }
//
//        removeFromSuperview()
//    }
//}

//extension PopupView: XibInitalization {
//    typealias Element = PopupView
//}
