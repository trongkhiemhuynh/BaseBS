//
//  AccountCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 9/16/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
//import RxSwift

class AccountCollectionViewCell: UICollectionViewCell {
    //outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var iv: UIImageView!
    
    weak var delegate: TicketDetailInputInfoCollectionViewCellOutput?
    
    var form: LoadForm?
    
    static var keyLinkObject: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Color.BackgroundListColor()
        btnDropDown.isHidden = true
        tf.addTarget(self, action: #selector(changedText(_:)), for: .editingChanged)
    }

    func onUpdateCreatNew(form: LoadForm?, dictData: [String: String]) {
        
        guard let f = form else {return}
        let value = dictData[(f.name)!]

        lblTitle.text = f.name

        tf.text = value
        
        self.form = f
        //check type select picklist
        if (form?.type == TypeFieldNewObject.select.rawValue || form?.type == TypeFieldNewObject.user.rawValue) {
            tf.isUserInteractionEnabled = false
            btnDropDown.isHidden = false
        } else if (form?.type == TypeFieldNewObject.linkObject.rawValue) {
            tf.isUserInteractionEnabled = false

            if (!ObjectNewController.dictLinkObject.keys.contains((form?.objectname)!) || (ObjectNewController.dictLinkObject.keys.contains((form?.objectname)!) && ObjectNewController.dictLinkObject[(form?.objectname)!] == form?.name)) {
                
                ObjectNewController.dictLinkObject[(form?.objectname)!] = form?.name
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleType))
                self.addGestureRecognizer(tapGesture)
            } else {
                self.lblTitle.textColor = .lightGray
                self.tf.textColor = .lightGray
            }
        } else if (form?.type == TypeFieldNewObject.datelocal.rawValue || form?.type == TypeFieldNewObject.date.rawValue){
            tf.isUserInteractionEnabled = true
            tf.placeholder = "yyyy-mm-dd hh:mm:ss"
            tf.keyboardType = .default
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleType))
//            self.addGestureRecognizer(tapGesture)
        } else if (form?.type == TypeFieldNewObject.email.rawValue) {
            tf.keyboardType = .emailAddress
        } else if (form?.type == TypeFieldNewObject.number.rawValue) {
            tf.keyboardType = .numberPad
        } else if (form?.type == TypeFieldNewObject.id.rawValue) {
            tf.isUserInteractionEnabled = false
            tf.text = (form?.prefix ?? "") + (form?.id ?? "")
            self.lblTitle.textColor = .lightGray
            self.tf.textColor = .lightGray
        } else {
            tf.keyboardType = .default
        }
        
        //check field required
        if form?.required == 1 {
            self.lblTitle.text = self.lblTitle.text! + "*"
            ObjectNewController.arrFieldIdRequired.insert((form?.name)!)
        }
    }
    
    func onUpdateDetail() {
        
    }
    
    override func prepareForReuse() {
        tf.text?.removeAll()
        btnDropDown.isHidden = true
        tf.isUserInteractionEnabled = true
        
        self.lblTitle.textColor = .darkGray
        self.tf.textColor = .darkGray
        
        if let gestures = self.gestureRecognizers {
            //reset tap gesture
            for g in gestures {
                self.removeGestureRecognizer(g)
            }
        }
    }
    
    @objc func changedText(_ textField: UITextField) {
        let titleName = lblTitle.text?.replacingOccurrences(of: "*", with: "")
        delegate?.didEndEdit(titleField: titleName!, inputField: textField.text!)
    }
    
    @IBAction func actionPicklist() {
        let titleName = lblTitle.text?.replacingOccurrences(of: "*", with: "")
        delegate?.showPicklist(title: titleName!, cell: self)
    }
    
    @objc func handleType() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEW"), object: nil, userInfo: ["cell":self])
    }
}

extension AccountCollectionViewCell: XibInitalization {
    typealias Element = AccountCollectionViewCell
}

extension AccountCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEdit?(cell: self)
    }
}
