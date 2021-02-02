//
//  ObjectNewController.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

// check field required
// required = 1;

import UIKit
import DropDown
import FSCalendar

//

enum TypeFieldNewObject: String {
    case text = "text"
    case number = "number"
    case email = "email"
    case datelocal = "datetime-local"
    case date = "date"
    case linkObject = "linkingobject"
    case select = "select"
    case id = "id"
    case user = "user"
}

let messageAlertField = "Please fill required field"

class ObjectNewController: BaseViewController {

    @IBOutlet weak var cvNewObject: UICollectionView!
    @IBOutlet weak var btnOwner: UIButton!
    
    var arrData: [String] = []
    var dictData: [String: String] = [:]
    var arrRequest: [Any] = []
    var keyObj: String?
    
    var loadForm: LoadFormList?
    var rectCellInSuperview: CGRect?
    var vCalendar: CalendarView?
    var cellSelected: AccountCollectionViewCell?
    var viewModel: LoadFormViewModel?
    var arrOwner: [OwnerModel]?
    
    static var arrFieldIdRequired = Set<String>()
    static var dictLinkObject = [String: String]()
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func setupView() {
        cvNewObject.dataSource = self
        cvNewObject.delegate = self
        
        cvNewObject.registerCell(AccountCollectionViewCell.self)
        cvNewObject.register(MagicHeaderCollectionReusableView.xib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MagicHeaderCollectionReusableView.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func initData() {
        dispatchGroup.enter()
        loadFormServer()
        
        dispatchGroup.enter()
        loadListOwner()

        dispatchGroup.notify(queue: .main) {
            self.reloadView()
            
            let firstOwner = self.arrOwner?.first
            
            let nameOwner = (firstOwner?.lastName)! + " " + (firstOwner?.middleName)! + " " + (firstOwner?.firstName)!
            
            //save to userdefault
            let userDefault = UserDefaults.standard
            userDefault.set(firstOwner?.idOwner, forKey: "kIdOwner")
            userDefault.synchronize()
            
            self.btnOwner.setTitle(nameOwner, for: .normal)
        }
        
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
    }
    
    private func loadFormServer() {
        guard let idObject = keyObj/*RealmManager.shared.onGetIDObject()*/ else {return}
        
        self.view.addSubview(vLoad)
        
        viewModel = LoadFormViewModel(id: idObject)
        viewModel?.loadForm(completion: {[weak self] (arrForm, err) in
            self?.vLoad.removeFromSuperview()
            
            if let arr = arrForm {
                self?.loadForm = arr
            } else {
                self?.showError(title: "ALERT!", message: err?.localizedDescription)
            }
            
            self?.dispatchGroup.leave()
        })
    }
    
    private func loadListOwner() {
        Networking.shared.getOwnerInfo { [weak self] (arrModel) in
            //            print(arrModel?.count)
            self?.arrOwner = arrModel as? [OwnerModel]
            
            self?.dispatchGroup.leave()
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
                            dictData[form.name!] = j.valueObj
                        }
                    }
                }
            }
        }
        
        cvNewObject.reloadData()
    }
    
    private func reloadView() {
        self.cvNewObject.reloadData()
    }
    
    @IBAction func onSave() {
        print("onSave")
        
        if validateField() {
            buildRequest()
            requestServer()
        } else {
            showAlert(title: "ALERT!", message: messageAlertField)
        }
    }
    
    deinit {
        //save to userdefault
        let userDefault = UserDefaults.standard
        userDefault.set(nil, forKey: "kIdOwner")
        userDefault.synchronize()
        
        NotificationCenter.default.removeObserver(self)
        AccountCollectionViewCell.keyLinkObject = nil
        ObjectNewController.arrFieldIdRequired.removeAll()
        ObjectNewController.dictLinkObject.removeAll()
    }
}

extension ObjectNewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return loadForm?.arrData?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = loadForm?.arrData?[section]
        
        return section?.arrForm?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.identifier, for: indexPath) as! AccountCollectionViewCell
        
        let section = loadForm?.arrData?[indexPath.section]
        
        let form = section?.arrForm?[indexPath.row]
        
        cell.onUpdateCreatNew(form: form, dictData: dictData)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: heightDefaultCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MagicHeaderCollectionReusableView.identifier, for: indexPath) as? MagicHeaderCollectionReusableView
        let section = loadForm?.arrData?[indexPath.section]
        let headerName = section?.sectionName
        header?.backgroundColor = Color.BackgroundListColor()
        header?.lblSection.text = headerName
             
        return header!
    }
}

extension ObjectNewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - paddingTop*2, height: heightLargeCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingTop
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ObjectNewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //check type
        print("xxx")
//        let cell = collectionView.cellForItem(at: indexPath) as! AccountCollectionViewCell
//
//        if cell.form?.type == TypeFieldNewObject.text.rawValue {
//            return
//        }

        
    }
}

extension ObjectNewController {
    private func validateField() -> Bool {
        print(dictData)
        print(ObjectNewController.arrFieldIdRequired)
        
        let arrKeys = dictData.keys
        
        if arrKeys.count == 0 || btnOwner.titleLabel?.text == nil {
            return false
        }
        
        for item in ObjectNewController.arrFieldIdRequired {
            if dictData[item] == nil {
                return false
            }
        }
        
        return true
        
    }
    
    private func buildRequest() {
        let arr = loadForm?.arrData
        
        for item in arr! {
            for i in item.arrForm! {
                if i.type == "id" {
                    let name = i.prefix! + i.id!
                    let dict = ["id_field": i.id,"value": name,"id_record":nil,"id_field_record":nil,"object_id":nil]

                    self.arrRequest.append(dict)
                    
                    continue
                }
                let name = dictData[i.name!]
                let dict = ["id_field": i.id,"value": name,"id_record":nil,"id_field_record":nil,"object_id":nil]

                self.arrRequest.append(dict)
            }
        }
    }
        
    
    private func requestServer() {
        self.view.addSubview(vLoad)
        Networking.shared.onInsertRecord(idObject: self.keyObj!,arr: self.arrRequest) { (success) in
            self.vLoad.removeFromSuperview()
            
            if success {
//                NotificationManager.pushNotificationLocal(title: "ADD", message: "DONE!")
                self.onPromtPopUp(message: "SUCCESS!") {
                    self.popView()
                }
                NotificationCenter.default.post(name: NSNotification.Name.UPDATE_LIST, object: nil)
            } else {
//                NotificationManager.pushNotificationLocal(title: "ADD", message: "FAILED!")
                self.onPromtPopUp(message: "FAILED!") {
                    self.popView()
                }
            }
            
            
        }
    }
    
    @IBAction func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("debug-two")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let heightCell2Bottom = self.view.frame.height - (rectCellInSuperview?.origin.y ?? 0)
            let distance = (keyboardSize.height + 50) - heightCell2Bottom

            if distance > 0 {
                self.cvNewObject.frame.origin.y = self.cvNewObject.frame.origin.y - (distance + heightLargeCell)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.cvNewObject.frame.origin.y != 0 {
            self.cvNewObject.frame.origin.y = 0
        }
    }
    
    @IBAction func onSelectOwner() {
        //show picklist
        
        if let array = arrOwner {
            var arrName: [String] = []
            
            //get list owner name
            for owner in array {
                let name = owner.lastName + " " + owner.middleName + " " + owner.firstName
                arrName.append(name)
            }

            showDropDown(below: self.btnOwner, dataSource: arrName) { (index) in
                let owner = self.arrOwner![index]
                self.btnOwner.setTitle(arrName[index], for: .normal)
                print(owner.idOwner)
                
                //save to userdefault
                let userDefault = UserDefaults.standard
                userDefault.set(owner.idOwner, forKey: "kIdOwner")
                userDefault.synchronize()
            }

        }

    }
}

extension ObjectNewController: TicketDetailInputInfoCollectionViewCellOutput {
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
            self?.dictData[title] = value
        }
    }
    
    func didEndEdit(titleField: String, inputField: String) {
        let value = inputField.trimmingCharacters(in: .whitespacesAndNewlines)
        if !value.isEmpty {
            dictData[titleField] = inputField            
        }
    }
    
    func textFieldDidBeginEdit(cell: UICollectionViewCell) {
        print("debug-one")
        
        rectCellInSuperview = cvNewObject.convert(cell.frame, to: self.view)
    }
}

extension ObjectNewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let cell = cellSelected {
            let formatter = ApplicationManager.sharedInstance.VNDateFormatter
            let strDate = formatter.string(from: date)
            cell.tf.text = strDate
            vCalendar?.removeFromSuperview()
            
            dictData[cell.lblTitle.text!] = strDate
//            print("selected date : ",strDate)
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let strDate = ApplicationManager.sharedInstance.globalDateFormatter.string(from: date)

//        print("deselected date : ",date)
    }
}

extension ObjectNewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let v = vCalendar {
            if touch.view!.isDescendant(of: v) {
                return false
            }
        }
        
        return true
    }
}


func showDropDown(below view: UIView, dataSource: [String], completion: @escaping (Int)->Void) {
    let dropDown = DropDown()
    dropDown.anchorView = view

    dropDown.dataSource = dataSource
    dropDown.direction = .any
    dropDown.selectionAction = { (index: Int, item: String) in
        print("Selected item: \(item) at index: \(index)")
        dropDown.hide()
        completion(index)
    }
    
    dropDown.show()
}

struct LoadFormViewModel {
    let idObject: String
    
    init(id: String) {
        self.idObject = id
    }
    
    func loadForm(completion: @escaping (LoadFormList?, Error?) -> ()) {
        Networking.shared.onCreatedForm(id: idObject) { (arrForm, err) in
            if let arr = arrForm as? LoadFormList {
                completion(arr, nil)
            } else {
                completion(nil, err)
            }
        }
    }
}
