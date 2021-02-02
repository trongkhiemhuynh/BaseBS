//
//  MainViewController.swift
//  BaseDemo
//
//  Created by BASEBS on 8/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import FSCalendar

class ObjectDetailController: BaseViewController {
    
    @IBOutlet weak var cvObjDetail: UICollectionView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnOwner: UIButton!
    @IBOutlet weak var imgDrop: UIImageView!
    @IBOutlet weak var lblTitleAssign: UILabel!
    
    //properties
    var object: ObjectSubList?
    var isEdit = false
    var dictRequest: [String: Any]? = [:]
    var idObject: String?
    var arrDataUpdate: [Any]! = []
    var dictEdit: [String: String] = [:]
    var cellFrameInSuperview: CGRect?
    var viewModel: LoadFormViewModel?
    var loadForm: LoadFormList?
    var dictData: [String: String] = [:]
    var idOwner: String?
    var idRecord: String?
    var vCalendar: CalendarView?
    var cellSelected: AccountCollectionViewCell?
    var arrOwners: [OwnerModel]?
    let dispatchGroup = DispatchGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func loadListOwner() {
        Networking.shared.getOwnerInfo {[weak self] (arrModel) in
            if let arrOwner = arrModel as? [OwnerModel] {
                self?.arrOwners = arrOwner
            }
            print("debug++loadListOwner")
            self?.dispatchGroup.leave()
        }
    }
    
    private func loadUserOwner() {
        loadOwner { (isDone) in
            
        }
    }
    
    private func onLoadForm() {
        viewModel = LoadFormViewModel(id: idObject!)
        
        self.view.addSubview(vLoad)
        viewModel?.loadForm(completion: {[weak self] (arrForm, err) in
            self?.vLoad.removeFromSuperview()
            
            if let arrData = arrForm {
                self?.loadForm = arrData
            } else {
                print("error")
            }
            print("debug++onLoadForm")
            self?.dispatchGroup.leave()
        })
    }
    
    private func onReload() {
        
        if let arr = object?.dataSubList {
            arr.forEach { (objectview) in
                dictData[objectview.nameObj!] = objectview.valueObj
            }
        }
        
        print(dictData)
        
        self.cvObjDetail.reloadData()
    }
    
    override func initData() {
        //Notification
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NEW"), object: nil, queue: nil) { [weak self] (noti) in
            if let cell = noti.userInfo!["cell"] as? AccountCollectionViewCell {
                if cell.form?.type == TypeFieldNewObject.date.rawValue || cell.form?.type == TypeFieldNewObject.datelocal.rawValue {
//                    self?.vCalendar = CalendarView.xibInstance()
//                    self?.vCalendar?.fsCalendar.delegate = self
//                    self?.view.addSubview((self?.vCalendar!)!)
//                    self?.vCalendar?.frame = self!.view.bounds
//                    self?.cellSelected = cell
//
//                    return
                }
                
                if cell.form?.type == TypeFieldNewObject.linkObject.rawValue {
                    let vc = ObjectListController()
                    
                    vc.keyObj = cell.form?.objectname
                    
                    vc.isLinkObject = true
                    vc.handler = { obj in
                        if let item = obj as? ObjectSubList {
                            guard let arrLinkObject = item.dataSubList else {return}
                            
                            self?.autoUpdateField(arrLinkObject)
                        }

                    }
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        
        
        dispatchGroup.enter()
        onLoadForm()

        dispatchGroup.enter()
        loadListOwner()

        dispatchGroup.enter()
        loadUserOwner()
        
        dispatchGroup.notify(queue: .main) {
            self.onReload()
            
            print("debug++dispatchGroup.notify")
            //get name owner
            if let array = self.arrOwners {
                array.forEach {
                    print($0.idOwner)
                    print(self.idOwner)
                    
                    if $0.idOwner == self.idOwner {
                        let nameOwner = $0.lastName + " " + $0.middleName + " " + $0.firstName
                        self.btnOwner.setTitle(nameOwner, for: .normal)
                        return
                    }
                }
            } else {
                print("error!")
            }
        }
    }
    
    override func setupView() {
        cvObjDetail.registerCell(AccountCollectionViewCell.self)
        cvObjDetail.register(MagicHeaderCollectionReusableView.xib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MagicHeaderCollectionReusableView.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.btnOwner.isEnabled = false
        self.imgDrop.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("debug-two")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let heightCell2Bottom = self.view.frame.height - (cellFrameInSuperview?.origin.y ?? 0)
            let distance = keyboardSize.height - heightCell2Bottom

            if distance > 0 {
                self.cvObjDetail.frame.origin.y -= distance + heightLargeCell
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.cvObjDetail.frame.origin.y != 0 {
            self.cvObjDetail.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        AccountCollectionViewCell.keyLinkObject = nil
        ObjectNewController.arrFieldIdRequired.removeAll()
        ObjectNewController.dictLinkObject.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }
}

extension ObjectDetailController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return loadForm?.arrData?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = loadForm?.arrData?[section]
        
        return section?.arrForm?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MagicHeaderCollectionReusableView.identifier, for: indexPath) as? MagicHeaderCollectionReusableView
        let section = loadForm?.arrData?[indexPath.section]
        let headerName = section?.sectionName
        header?.backgroundColor = Color.BackgroundListColor()
        header?.lblSection.text = headerName
             
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: heightDefaultCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.identifier, for: indexPath) as! AccountCollectionViewCell
        
        let section = loadForm?.arrData?[indexPath.section]
        
        let form = section?.arrForm?[indexPath.row]
        //        print("debug--- \(form?.type)")
        let titleName = form?.name
        cell.lblTitle.text = titleName
        cell.form = form

        if (isEdit) {
            cell.onUpdateCreatNew(form: form, dictData: dictData)
            
            //check if updated
            if (dictEdit[titleName!] != nil) {
                cell.tf.text = dictEdit[titleName!]
            }
            
            cell.delegate = self
        } else {
            cell.tf.isUserInteractionEnabled = false
            cell.tf.text = dictData[titleName!]
        }

        return cell
    }
}

extension ObjectDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cvObjDetail.frame.width - paddingTop*2, height: heightLargeCell)
    }
}

extension ObjectDetailController: TicketDetailInputInfoCollectionViewCellOutput {
    func showPicklist(title: String, cell: UICollectionViewCell) {
        var arrDropDown: [String] = []
        
        //get picklist
        if let arrData = loadForm?.arrData {
            for section in arrData {
                for item in section.arrForm! {
                    if item.name == title {
                        for i in item.picklist! {
                            arrDropDown.append(i.label!)
                        }
                        break
                    } else {
                        
                    }
                }
            }
        }
        
        //show picklist
        showDropDown(below: cell, dataSource: arrDropDown) { [weak self] (index) in
            let cell = cell as? AccountCollectionViewCell
            let value = arrDropDown[index]
            cell?.tf.text = value
            
            self?.dictEdit[title] = value
        }
    }
    
    func didEndEdit(titleField: String, inputField: String) {
        print(titleField)
        
        //update
        dictEdit[titleField] = inputField
    }
    
    @IBAction func editAction() {
        isEdit = !isEdit
        btnUpdate.isHidden = !isEdit
        btnEdit.isHidden = isEdit
        
        self.btnOwner.isEnabled = true
        self.imgDrop.isHidden = false
        
        cvObjDetail.reloadData()
    }
    
    private func buildDictData() {
        print(dictEdit)
        
        if let arrField = object?.dataSubList {
            for field in arrField {
                if let titleField = field.nameObj {
                    //check value if have
                    guard let value = dictEdit[titleField]/*, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty*/ else {
                        //if not get old value field
                        let d = ["id_field":field.idField,"id_field_record": nil,"id_record": nil,"object_id":nil, "value": field.valueObj]
                        arrDataUpdate?.append(d)
                        
                        continue
                    }
                    
                    let d = ["id_field":field.idField,"id_field_record": nil,"id_record": nil,"object_id":nil, "value": value]
                    arrDataUpdate?.append(d)

                } else {
                    
                }
            }
        }
        
        dictRequest?["object_id"] = idObject
        dictRequest?["id"] = object?._id
        dictRequest?["data"] = arrDataUpdate
        dictRequest?["onwer_id"] = idOwner
    }
    
    private func loadOwner(completionHandler: @escaping (Bool) -> Void) {
        Networking.shared.loadRecord(idObject: idObject ?? "", idRecord: idRecord ?? "") {[weak self] (strIdOwner) in
            if strIdOwner != nil {
                self?.idOwner = strIdOwner
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            
            print("debug++loadOwner")
            self?.dispatchGroup.leave()
        }
    }
    
    func isRequest(completion: @escaping (Bool)->Void) {
        for i in ObjectNewController.arrFieldIdRequired {
            if let value = dictEdit[i] {
                if value.isEmpty {
                    completion(false)
                    return
                }
            }
        }
        
        completion(true)
    }
    
    @IBAction func update() {
        isRequest { (isSuccess) in
            if (isSuccess) {
                self.buildDictData()
                if let dictData = self.dictRequest {
                    self.view.addSubview(self.vLoad)
                    
                    Networking.shared.updateRecord(dict: dictData) { [weak self] (isSuccess) in
                        self?.vLoad.removeFromSuperview()
                        
                        if isSuccess {
                            //                        NotificationManager.pushNotificationLocal(title: "UPDATE", message: "DONE!")
                            self?.onPromtPopUp(message: "SUCCESS", completion: {
                                self?.navigationController?.popViewController(animated: true)
                            })
                            
                            NotificationCenter.default.post(name: NSNotification.Name.UPDATE_LIST, object: nil)
                        } else {
                            self?.showAlert(title: "ALERT!", message: "Something went wrong!")
                        }
                        
                    }
                    
                }
            } else {
                self.showAlert(title: "ALERT!", message: "Please try again!")
            }
        }
    }
    
    func textFieldDidBeginEdit(cell: UICollectionViewCell) {
        if let c = cell as? AccountCollectionViewCell {
            let cellRect = cell.frame
            cellFrameInSuperview = cvObjDetail.convert(cellRect, to: self.view)
        }
    }
    
    private func autoUpdateField(_ arrLinkObject: [ObjectView]) {
        guard let arrSection = loadForm?.arrData else {return}
        for section in arrSection {
            guard let arrForm = section.arrForm else {break}
            
            for form in arrForm {
                if form.type == TypeFieldNewObject.linkObject.rawValue {
                    // loop in link object
                    for j in arrLinkObject {
                        if form.field == j.idField {
                            dictEdit[form.name!] = j.valueObj
                        }
                    }
                }
            }
        }
        
        cvObjDetail.reloadData()
    }
}


extension ObjectDetailController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let cell = cellSelected {
            let formatter = ApplicationManager.sharedInstance.VNDateFormatter
            let strDate = formatter.string(from: date)
            cell.tf.text = strDate
            vCalendar?.removeFromSuperview()
            
            self.dictEdit[cell.lblTitle.text!] = strDate
//            print("selected date : ",strDate)
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let strDate = ApplicationManager.sharedInstance.globalDateFormatter.string(from: date)

//        print("deselected date : ",date)
    }
}

extension ObjectDetailController {
    @IBAction func onSelectOwner() {
        //show picklist
        
        if let array = arrOwners {
            let arrayName = array.map { (ownerModel) -> String in
                return ownerModel.lastName + " " + ownerModel.middleName + " " + ownerModel.firstName
            }
            
            showDropDown(below: (btnOwner)!, dataSource: arrayName) { (index) in
                let owner = self.arrOwners?[index]
                self.btnOwner.setTitle(arrayName[index], for: .normal)
                self.idOwner = owner?.idOwner
            }
        }
    }
}
