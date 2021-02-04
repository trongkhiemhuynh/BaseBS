//
//  CustomViewCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 1/18/21.
//  Copyright © 2021 BASEBS. All rights reserved.
//

import UIKit

let arrayText = ["equals","not equal to","is empty", "is not empty"]

let arrayNumber = ["equals", "not equal to","less than","greater than","less or equal","greater or equal","is empty","is not empty"]
let arrayDate = ["equals", "not equal to","between","is empty","is not empty"]

//let dictPrefixNumber = ["equals": "$eq","not equal to":"$ne","less than":"$lt","greater than":"$gt","less or equal":"$le","greater or equal":"$ge","is empty":"$eq","is not empty":"$ne"]
//let dictPrefixText = ["equals": "$eq","not equal to":"$ne","between":"$be","is not empty":"$ne", "is empty":"$eq"]
let dictPrefix = ["equals": "$eq",
                  "not equal to":"$ne",
                  "is empty":"$eq",
                  "is not empty":"$ne",
                  "less than":"$lt",
                  "greater than":"$gt",
                  "less or equal":"$le",
                  "greater or equal":"$ge",
                  "between":"$be"
]

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
    var dictData: [Int: Any] = [:]
    
    var handler: (([Int:Any]) -> ())?
    
    var deleteHandler: ((Int) -> ())?
    var index: Int!
    var prefix: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tf.addTarget(self, action: #selector(changedText(_:)), for: .editingChanged)
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
//                self.dict["index"] = self.index
                
                print(obj.type)
                self.dict["name_column"] = obj.name
                
                self.btnColum.setTitle(obj.name, for: .normal)
            }
        }
    }
    
    @IBAction func onEqual() {
        
        if let o = fieldCustom {
            
            var array: [String] = []
            
            self.dict["type"] = o.type
//
            array = arrayText
            
            if (o.type == TypeFieldNewObject.number.rawValue) {
                array = arrayNumber
            } else if o.type == TypeFieldNewObject.date.rawValue || o.type == TypeFieldNewObject.datelocal.rawValue {
                array = arrayDate
            }
            
            showDropDown(below: self.btnEqual, dataSource: array) { (index) in
                let nameEqual = array[index]
                
                self.prefix = dictPrefix[nameEqual]!
                self.btnEqual.setTitle(nameEqual, for: .normal)
                self.dict["name_equal"] = nameEqual
                
                if nameEqual == "is empty" || nameEqual == "is not empty" {
                    self.dict["value"] = [self.prefix: ""]
                    self.tf.isUserInteractionEnabled = false
                    self.tf.backgroundColor = .lightGray
                    self.dictData[self.index] = self.dict
                    self.handler!(self.dictData)
                }
            }
        }
        
    }
    
    @objc func changedText(_ textField: UITextField) {
        self.dict["value"] = [prefix: textField.text]
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
        dictData[self.index] = self.dict
        handler!(dictData)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
}
