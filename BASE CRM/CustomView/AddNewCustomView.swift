//
//  AddNewCustomView.swift
//  BaseDemo
//
//  Created by macOS on 1/18/21.
//  Copyright © 2021 BASEBS. All rights reserved.
//

import UIKit


let kFilterCondition = "filter_condition"
let kAndFilter = "and_filter"
let kOrFilter = "or_filter"
let kIsDefault = "is_default"
let kLinkingObjCondition = "linking_obj_condition"
let kMetadata = "meta_data"
let kMetaFilter = "meta_filter"
let kViewName = "view_name"
let kShowField = "show_fields"
let kFieldID = "field_ID"
let kHidden = "hidden"
let kPosition = "position"
let kCustomViewId = "custom_view_id"
let kData = "data"

let hAdd: CGFloat = 70.0

class AddNewCustomView: UIView {

    @IBOutlet weak var cv: UICollectionView!
    
    @IBOutlet weak var tfViewName: UITextField!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var lbl: UILabel!

    var isSelectDefault = false
    weak var controller: UIViewController?
    
    @IBAction func onDefault() {
//        print(btnDefault.isSelected)
        isSelectDefault = !isSelectDefault
        
        if isSelectDefault {
            let image = UIImage(named: "checked_box")
            btnDefault.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "check_box")
            btnDefault.setImage(image, for: .normal)
        }
    }
    
    var objectId: String!

    var countAllCondition: Int = 1
    var countAnyCondition: Int = 1
    
    var dictRequest: [String: Any] = [:]
    var arrayModel: [Any]?
    var arrShowField: [Any] = []
    
    var dictAllCells: [Int: Any] = [:]
    var dictAnyCells: [Int: Any] = [:]

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")

        cv.registerCell(CustomViewCollectionViewCell.self)
        cv.registerCell(AddActionCollectionViewCell.self)
        
        cv.register(MagicHeaderCollectionReusableView.xib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MagicHeaderCollectionReusableView.identifier)
        
        cv.dataSource = self
        cv.delegate = self
         
        let image = UIImage(named: "check_box")
        btnDefault.setImage(image, for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.bounds.width, height: heightDefaultCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MagicHeaderCollectionReusableView.identifier, for: indexPath) as? MagicHeaderCollectionReusableView
        
        var name: String = ""
        
        if indexPath.section == 0 {
            name = "All condition"
        } else {
            name = "Any condition"
        }

        header?.backgroundColor = Color.BackgroundListColor()
        header?.lblSection.text = name
             
        return header!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("frame")
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        print("coder")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layoutSubviews")
        loadColumnAvailable()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func loadColumnAvailable() {
        //TODO:
        Networking.shared.fetchFieldsCustomView(objectId: objectId) {[weak self] (arrData, error) in
            if arrData != nil {
                self?.arrayModel = arrData
                
                print(arrData?.count)
            }
        }
    }
    
    @IBAction func dismiss() {
//        self.removeFromSuperview()
        controller?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSave() {
        guard let nameView = tfViewName.text, !nameView.isEmpty else { return }
        
        getShowField()
        
        print(objectId)
        var dictFilter = [kAndFilter:[], kOrFilter: []]
        
        var arrMetaData: [String] = []
        var isDefault = false
        var dictLinkObj = [kAndFilter:[], kOrFilter: []]
        var dictMeta = [kAndFilter:[], kOrFilter: []]
        
        
        var dictData: [String: Any] = [:]
        dictData[kViewName] = nameView
        dictData[kFilterCondition] = dictFilter
        dictData[kShowField] = arrShowField
        dictData[kMetadata] = arrMetaData
        dictData[kIsDefault] = isDefault
        dictData[kLinkingObjCondition] = dictLinkObj
        dictData[kMetaFilter] = dictMeta
        dictData["object_id"] = objectId
//        dictRequest[kData] = dictData
        print(dictData)
//        Networking.shared.creatCustomView(dictRequest: dictData)
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
    
    
}

extension AddNewCustomView: XibInitalization {
    typealias Element = AddNewCustomView
}

extension AddNewCustomView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return countAllCondition
        }
        
        return countAnyCondition
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == countAllCondition - 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddActionCollectionViewCell.identifier, for: indexPath) as! AddActionCollectionViewCell
//                let cell = AddActionCollectionViewCell.xibInstance()
                
                cell.handler = { [weak self] in
                    self?.countAllCondition += 1
//                    self?.hAll.constant += hAdd
                    self?.cv.reloadData()
                }
                cell.backgroundColor = .lightGray

                return cell
            }

            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViewCollectionViewCell.identifier, for: indexPath) as! CustomViewCollectionViewCell
//            if let cell = dictAllCells[indexPath.row] as? CustomViewCollectionViewCell {
//                return cell
//            }
            
            
//            let cell = CustomViewCollectionViewCell.xibInstance()
            cell.index = indexPath.row
            dictAllCells[indexPath.row] = cell
            
            cell.objectId = objectId
            cell.sView = self
            cell.arrFields = arrayModel

            cell.handler = { d in
                print(d)
            }
            
            cell.deleteHandler = { index in
                print(indexPath.row)
                print(indexPath.section)
                self.countAllCondition -= 1
                self.dictAllCells[index] = nil
                
                self.cv.reloadData()
            }

            return cell
        } else {
            if indexPath.row == countAnyCondition - 1 {
//                let cell = AddActionCollectionViewCell.xibInstance()
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddActionCollectionViewCell.identifier, for: indexPath) as! AddActionCollectionViewCell
                cell.handler = { [weak self] in
                    self?.countAnyCondition += 1
//                    self?.hAny.constant += hAdd
                    self?.cv.reloadData()
                }
                return cell
            }

//            if let cell = dictAnyCells[indexPath.row] as? CustomViewCollectionViewCell {
//                return cell
//            }
//
//
//            let cell = CustomViewCollectionViewCell.xibInstance()
//            dictAnyCells[indexPath.row] = cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViewCollectionViewCell.identifier, for: indexPath) as! CustomViewCollectionViewCell
            cell.objectId = objectId

            cell.deleteHandler = { index in
                print(indexPath.row)
                print(indexPath.section)
                self.countAnyCondition -= 1
                self.cv.reloadData()
            }
            
            return cell
        }
    }
}

extension AddNewCustomView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.cv.frame.width, height: 70)
    }
}


