//
//  CustomViewCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 1/18/21.
//  Copyright © 2021 BASEBS. All rights reserved.
//

import UIKit

let arrayText = ["equals","not equal to","is empty", "is not empty"]
let dictPrefixText = ["equals": "$eq","not equal to":"$eq","is empty":"$eq","is not empty":"$eq"]
let arrayNumber = ["equals", "not equal to","less than","greater than","less or equal","greater or equal","is empty","is not empty"]
let arrayDate = ["equals", "not equal to","between","is empty","is not empty"]

class CustomViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnColum: UIButton!
    @IBOutlet weak var btnEqual: UIButton!
    @IBOutlet weak var tf: UITextField!
    
    var objectId: String!
    
    var arrName: [String] = []
    weak var sView: UIView?
        
    
    var arrFields: [Any]?
    var fieldCustom: FieldCustomView?
    var dict: [String:Any] = [:]
    
    var handler: (([String:Any]) -> ())?
    
    var deleteHandler: ((Int) -> ())?
    var index: Int!
    var prefix: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tf.addTarget(self, action: #selector(changedText(_:)), for: .editingChanged)
    }
    
    @objc func changedText(_ textField: UITextField) {
        self.dict["value"] = [prefix: textField.text]
        
        handler!(dict)
    }
    
    @IBAction func onColum() {
//        loadColumnAvailable()
        if let arr = arrFields as? [FieldCustomView] {
            var arrNameField : [String] = []
            arr.forEach { (field) in
                arrNameField.append(field.name)
            }
            
            showDropDown(below: self.btnColum, dataSource: arrNameField) { (index) in
                let obj = arr[index]
                self.fieldCustom = obj
                self.dict["id_field"] = obj.id
                self.dict["index"] = self.index
                print(obj.type)
                self.btnColum.setTitle(obj.name, for: .normal)
            }
        }
    }
    
    @IBAction func onEqual() {
        
        if let o = fieldCustom {
            
            var array = arrayDate
            
//            self.dict["type"] = o.type
//
//            if (o.type == "text") {
//                // handler()
//                array = arrayText
//            } else if (o.type == "number") {
//                array = arrayNumber
//            }
            
            array = arrayText
            
            showDropDown(below: self.btnEqual, dataSource: array) { (index) in
                self.prefix = dictPrefixText[array[index]]!
                self.btnEqual.setTitle(array[index], for: .normal)
            }
        }
        
    }
    
//    func update() {
//        guard let array = self.arrayModel as? [FieldCustomView] else {return}
//        arrName.removeAll()
//        
//        array.forEach { (item) in
//            arrName.append(item.name)
//        }
//        
//        showDropDown(below: self.btnColum, dataSource: arrName) { (index) in
//            let nameSelect = self.arrName[index]
//            
//            self.btnColum.setTitle(nameSelect, for: .normal)
//        }
//    }
    
    @IBAction func onDelete() {
        deleteHandler!(index)
    }
    
    override func prepareForReuse() {
        self.btnColum.setTitle("Select", for: .normal)
        self.btnEqual.setTitle("Select", for: .normal)
        self.tf.text = ""
    }
}

extension CustomViewCollectionViewCell: XibInitalization {
    typealias Element = CustomViewCollectionViewCell
}

extension CustomViewCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
}
