//
//  AssignTicketViewController.swift
//  BaseDemo
//
//  Created by BASEBS on 8/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

@objc protocol TicketDetailInputInfoCollectionViewCellOutput: class {
    func didEndEdit(titleField: String, inputField : String)
    func showPicklist(title: String, cell: UICollectionViewCell)
    @objc optional func textFieldDidBeginEdit(cell: UICollectionViewCell)
}

class TicketDetailInputInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iv:UIImageView!
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var tf : UITextField!
    
    //delegate
    weak var delegate : TicketDetailInputInfoCollectionViewCellOutput?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 30))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
    }
    
    @objc func textChanged(textField: UITextField) {
        print(textField.text)
    }
    
    public func onUpdate( image: UIImage?, title: String?, detail: String?) {
        iv.image = image
        lbl.text = title
        tf.text = detail
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TicketDetailInputInfoCollectionViewCell : XibInitalization {
    typealias Element = TicketDetailInputInfoCollectionViewCell
    
    
}

extension TicketDetailInputInfoCollectionViewCell: UITextFieldDelegate {
    
//    @IBAction func textFieldEdit() {
//        delegate?.didEndEdit(titleField: lbl.text!, inputField: tf.text!)
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("debug--")
//        Logger.debug(textField.text!)
//        delegate?.didEndEdit(titleField: lbl.text!, inputField: tf.text!)
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("debug")
//        Logger.debug(textField.text!)
//        return true
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        Logger.debug(textField.text!)
//        delegate?.didEndEdit(titleField: lbl.text!, inputField: tf.text!)
//        return true
//    }
}
