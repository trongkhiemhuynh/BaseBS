//
//  NewCustomViewController.swift
//  BASE CRM
//
//  Created by khiemht on 1/28/21.
//  Copyright © 2021 HTK Technologies. All rights reserved.
//

import UIKit

class NewCustomViewController: UIViewController {
    
    //outlet
    @IBOutlet weak var btnDefault: UIButton!
    
    @IBOutlet weak var btnAllCol1: UIButton!
    @IBOutlet weak var btnAllCol2: UIButton!
    @IBOutlet weak var btnAllCol3: UIButton!
    @IBOutlet weak var btnAllCol4: UIButton!
    @IBOutlet weak var btnAllCol5: UIButton!
    
    @IBOutlet weak var btnAnyCol1: UIButton!
    @IBOutlet weak var btnAnyCol2: UIButton!
    @IBOutlet weak var btnAnyCol3: UIButton!
    @IBOutlet weak var btnAnyCol4: UIButton!
    @IBOutlet weak var btnAnyCol5: UIButton!
    
    @IBOutlet weak var btnAllCom1: UIButton!
    @IBOutlet weak var btnAllCom2: UIButton!
    @IBOutlet weak var btnAllCom3: UIButton!
    @IBOutlet weak var btnAllCom4: UIButton!
    @IBOutlet weak var btnAllCom5: UIButton!
    
    @IBOutlet weak var btnAnyCom1: UIButton!
    @IBOutlet weak var btnAnyCom2: UIButton!
    @IBOutlet weak var btnAnyCom3: UIButton!
    @IBOutlet weak var btnAnyCom4: UIButton!
    @IBOutlet weak var btnAnyCom5: UIButton!
    
    @IBOutlet weak var tfAll1: UITextField!
    @IBOutlet weak var tfAll2: UITextField!
    @IBOutlet weak var tfAll3: UITextField!
    @IBOutlet weak var tfAll4: UITextField!
    @IBOutlet weak var tfAll5: UITextField!
    
    @IBOutlet weak var tfAny1: UITextField!
    @IBOutlet weak var tfAny2: UITextField!
    @IBOutlet weak var tfAny3: UITextField!
    @IBOutlet weak var tfAny4: UITextField!
    @IBOutlet weak var tfAny5: UITextField!
    
    @IBOutlet weak var tf: UITextField!
    
    var objectId: String!
    var dictRequest: [String: Any] = [:]
    var arrayModel: [Any]?
    var arrShowField: [Any] = []
    
    var dictAllCells: [Int: Any] = [:]
    var dictAnyCells: [Int: Any] = [:]
    
    var arrAndFilter: [Any] = []
    var arrOrFilter: [Any] = []
    var arrLinkAndFilter: [Any] = []
    var arrLinkOrFilter: [Any] = []
    var arrMetaAndFilter: [Any] = []
    var arrMetaOrFilter: [Any] = []
    var isSelectDefault = false
    var prefix: String = ""
    
    var heightAll:CGFloat = 50
    let heightAdd:CGFloat = 200
    
    var cAll = 2
    var cAny = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
//        register()
        loadColumnAvailable()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadColumnAvailable() {
        //TODO:
        guard let id = objectId else {return}
        Networking.shared.fetchFieldsCustomView(objectId: id) {[weak self] (arrData, error) in
            if arrData != nil {
                self?.arrayModel = arrData
                
                print(arrData?.count)
            }
        }
    }
    
    func register() {
//        cv.registerCell(CVViewNameCollectionViewCell.self)
//        cv.registerCell(CVIsDefaultCollectionViewCell.self)
//        cv.registerCell(CVAllConditionCollectionViewCell.self)
        
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "CV_ALL_ADD"), object: nil, queue: nil) { (notification) in
//            self.heightAll += self.heightAdd
//            self.cv.reloadData()
//        }
//
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "CV_ALL_SUB"), object: nil, queue: nil) { (notification) in
//            self.heightAll -= self.heightAdd
//            self.cv.reloadData()
//        }
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

//extension NewCustomViewController: UICollectionViewDataSource {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return 2
//        }
//        
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVViewNameCollectionViewCell.identifier, for: indexPath)
//            
//            return cell
//        }
//        
//        if indexPath.row == 1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVIsDefaultCollectionViewCell.identifier, for: indexPath)
//            
//            return cell
//        }
//        
////        if indexPath.row == 2 {
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVAllConditionCollectionViewCell.identifier, for: indexPath)
////
////            return cell
////        }
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVAllConditionCollectionViewCell.identifier, for: indexPath)
//            
//            return cell
//        
//    }
//}

//extension NewCustomViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("debug")
//        print(indexPath.row)
//
//        if indexPath.row == 2 {
//            return CGSize(width: self.cv.bounds.width, height: heightAll)
//        }
//
//        return CGSize(width: self.cv.bounds.width, height: 70)
//    }
//}

extension NewCustomViewController {
    
    @IBAction func onColumn(sender: UIButton) {
        if let arr = arrayModel as? [FieldCustomView] {
            var arrNameField : [String] = []
            arr.forEach { (field) in
                arrNameField.append(field.name)
            }
            
            showDropDown(below: self.btnAllCol1, dataSource: arrNameField) { (index) in
                let obj = arr[index]
                
                sender.setTitle(obj.name, for: .normal)
            }
        }
    }
    
    private func getFieldCustomView(colum: UIButton) -> FieldCustomView? {
        guard let columnName = colum.titleLabel?.text, columnName != "Column" else {return nil}
        
        var fieldCustom: FieldCustomView?
        
        arrayModel?.forEach({ (field) in
            guard let f = field as? FieldCustomView else {return}
            
            if f.name == columnName {
                fieldCustom = f
                return
            }
            
        })
        
        return fieldCustom
    }
    
    @IBAction func onCompare(sender: UIButton) {
        
        var fieldCustom: FieldCustomView?
        
        if sender == btnAllCom1 {
            fieldCustom = getFieldCustomView(colum: btnAllCol1)
        } else if sender == btnAllCom2 {
            fieldCustom = getFieldCustomView(colum: btnAllCol2)
        } else if sender == btnAllCom3 {
            fieldCustom = getFieldCustomView(colum: btnAllCol3)
        } else if sender == btnAllCom4 {
            fieldCustom = getFieldCustomView(colum: btnAllCol4)
        } else if sender == btnAllCom5 {
            fieldCustom = getFieldCustomView(colum: btnAllCol5)
        }

        if let o = fieldCustom {
            
            var array: [String] = []
            
//            self.dict["type"] = o.type
            //
            array = arrayText
            
            if (o.type == TypeFieldNewObject.number.rawValue) {
                array = arrayNumber
            } else if o.type == TypeFieldNewObject.date.rawValue || o.type == TypeFieldNewObject.datelocal.rawValue {
                array = arrayDate
            }
            
            showDropDown(below: sender, dataSource: array) { (index) in
                let compareName = array[index]
                let pre = dictPrefix[compareName]!
                
                
                let dict: [String: Any] = ["id_field":o.id, "type": o.type, "value": [pre: ""]]
                
                if o.type == "linkingobject" {
                    self.arrLinkAndFilter.append(dict)
                } else {
                    let arr = self.arrAndFilter
                    
                    var index = 0
                    for item in arr {
                        
                        guard let i = item as? [String: Any] else {continue}
                        
                        let idold = i["id_field"] as! String
                        let idnew = dict["id_field"] as! String
                        
                        if idold == idnew  {
                            self.arrAndFilter.remove(at: index)
                            break
                        }
                        
                        index += 1
                    }
                    
                    self.arrAndFilter.append(dict)
                }
                
                sender.setTitle(compareName, for: .normal)
                
                if sender == self.btnAllCom1 {
                    self.onTextField(name: compareName, tf: self.tfAll1)
                } else if sender == self.btnAllCom2 {
                    self.onTextField(name: compareName, tf: self.tfAll2)
                } else if sender == self.btnAllCom3 {
                    self.onTextField(name: compareName, tf: self.tfAll3)
                } else if sender == self.btnAllCom4 {
                    self.onTextField(name: compareName, tf: self.tfAll4)
                } else if sender == self.btnAllCom5 {
                    self.onTextField(name: compareName, tf: self.tfAll5)
                }

            }
        }
    }
    
    private func onTextField(name: String, tf: UITextField) {
        if name == "is empty" || name == "is not empty" {
//            self.dict["value"] = [self.prefix: ""]
            tf.isUserInteractionEnabled = false
            tf.text = ""
            tf.backgroundColor = .lightGray
        } else {
            tf.isUserInteractionEnabled = true
            tf.backgroundColor = .white
        }
    }
    
    @IBAction func onDefault() {
        isSelectDefault = !isSelectDefault
        
        if isSelectDefault {
            let image = UIImage(named: "checked_box")
            btnDefault.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "check_box")
            btnDefault.setImage(image, for: .normal)
        }
        
    }
    
    @IBAction func save() {

        if verify() {
            getShowField()
            getAllCondition()
//            print(objectId)
            let dictFilter = [kAndFilter:arrAndFilter, kOrFilter: arrOrFilter]
            
            let arrMetaData: [String] = []
            let dictLinkObj = [kAndFilter:arrLinkAndFilter, kOrFilter: arrLinkOrFilter]
            let dictMeta = [kAndFilter:arrMetaAndFilter, kOrFilter: arrMetaOrFilter]
            
            
            var dictData: [String: Any] = [:]
            dictData[kViewName] = tf.text!
            dictData[kFilterCondition] = dictFilter
            dictData[kShowField] = arrShowField
            dictData[kMetadata] = arrMetaData
            dictData[kIsDefault] = isSelectDefault
            dictData[kLinkingObjCondition] = dictLinkObj
            dictData[kMetaFilter] = dictMeta
            dictData["object_id"] = objectId
            //        dictRequest[kData] = dictData
            print(dictData)
            Networking.shared.creatCustomView()
        } else {
            self.showError(title: "ALERT!", message: "Please input required field!")
        }
        
    }
    
    @IBAction func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func verify() -> Bool {
        if (tf.text!.isEmpty) || (objectId == nil) {
            return false
        }
        
        return true
    }
    
    private func getShowField() {
        
        var pos = 0
        
        arrayModel?.forEach({ (obj) in
            if let field = obj as? FieldCustomView {
                arrShowField.append([kFieldID: field.id, kPosition: pos, kHidden: false])
                pos += 1
            }
        })
    }
    
    private func getAllCondition() {
        let arrCol = [btnAllCol1, btnAllCol2, btnAllCol3, btnAllCol4, btnAllCol5]
        let arrCom = [btnAllCom1, btnAllCom2, btnAllCom3, btnAllCom4, btnAllCom5]
        let arrTf = [tfAll1, tfAll2, tfAll3, tfAll4, tfAll5]
        
        for col in arrCol {
            guard let titleColum = col?.titleLabel?.text, titleColum != "Column" else {
                continue
            }
            
            
            
        }
    }
}
