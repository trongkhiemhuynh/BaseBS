//
//  CustomView.swift
//  BaseDemo
//
//  Created by macOS on 1/18/21.
//  Copyright © 2021 BASEBS. All rights reserved.
//

import UIKit

class CustomView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var cv: UICollectionView!
    
    //properties
    var arrCustomView: Array<CustomViewModel>?
    var objectId: String!
    
    weak var controller: UIViewController?
//    var arrData: [String]?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    
    override func awakeFromNib() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        nibSetup()
    }


    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)

//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.delegate = self
        
//        self.addGestureRecognizer(tap)
//        cv.registerCell(AccountCollectionViewCell.self)
//        nibSetup()
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    @IBAction func dismiss() {
        self.removeFromSuperview()
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cv.registerCell(AccountCollectionViewCell.self)
        loadCustomView(keyObj: objectId)
    }

    private func nibSetup() {
        backgroundColor = .clear

        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
//        let bundle = Bundle(for: type(of: self))

        let nib = UINib(nibName: "CustomView", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }
    
    public func loadCustomView(keyObj: String) {
        Networking.shared.onLoadAllCustomView(idObject:keyObj) { [weak self] (arrData) in
            guard let arr = arrData as? [CustomViewModel] else {return}
            self?.arrCustomView = arr
            
            var arrName: [String] = []
            arr.forEach { (customModel) in
                arrName.append(customModel.name)
            }
            
            if arrName.isEmpty {
//                self?.showAlert(title: "ALERT!", message: "No data.")
                let lbl = UILabel()
                lbl.text = "No data!"
                lbl.contentMode = .center
                lbl.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 50))
                lbl.textAlignment = .center
                
                lbl.center = (self?.center)!
                lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
                self?.addSubview(lbl)
                
                return
            }
            
            self?.updateView(arrData: arrName)
        }
    }
    
    private func updateView(arrData: [String]) {
        
//        self.arrData = arrData
        
        cv.reloadData()
        
//        showDropDown(below: self.btnCustomView, dataSource: arrData) { (index) in
//            if let custom = self.arrCustomView?[index] {
//                print(custom.name)
//
//                self.view.addSubview(self.vLoad)
//                self.viewModel.loadSpecificCustomView(idCustom: custom.id)
//            }
//
//        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CustomView: XibInitalization {
    typealias Element = CustomView
}

extension CustomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrCustomView?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.identifier, for: indexPath) as! AccountCollectionViewCell
        let customViewModel = arrCustomView?[indexPath.row]
        let name = customViewModel?.name
        cell.lblTitle.text = name
        cell.tf.isHidden = true
        cell.delegate = self
        cell.btnDropDown.setImage(UIImage(named: "trash"), for: .normal)
        cell.btnDropDown.isHidden = false
        cell.backgroundColor = .lightGray
        return cell
    }
}

extension CustomView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cv.bounds.width, height: 50)
    }
}

extension CustomView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let custom = arrCustomView?[indexPath.row] else {return}
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CUSTOM_VIEW"), object: nil, userInfo: ["data":custom])
        
        self.removeFromSuperview()
    }
}

extension CustomView: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if let v = touch.view {
//            if v.isDescendant(of: cv) {
//                return false
//            }
//        }
//
//        return true
//    }
}

extension CustomView {
    @IBAction func addNewView() {
        print("addnew")
        
        /*let controller = UIViewController()
        
        let add = AddNewCustomView.xibInstance()
        add.controller = controller
        add.objectId = objectId
        controller.view.addSubview(add)
        add.frame = controller.view.bounds
        */
        
        let controller = NewCustomViewController()
        controller.objectId = objectId
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CustomView: TicketDetailInputInfoCollectionViewCellOutput {
    func didEndEdit(titleField: String, inputField: String) {
        
    }
    
    func showPicklist(title: String, cell: UICollectionViewCell) {
        //remove custome view
        arrCustomView?.forEach({ (customView) in
            if customView.name == title {
                Networking.shared.deleteCustomView(objectId: objectId, customeViewId: customView.id)
                return
            }
        })
        
        NotificationCenter.default.addObserver(forName: Notification.Name("DELETE_CV"), object: nil, queue: .main) { (noti) in
            let userInfo = noti.userInfo
            
            if let isDone = userInfo!["data"] as? Bool {
                if isDone {
                    self.loadCustomView(keyObj: self.objectId)
                } else {
                    print("xxx")
                }
            }
        }
    }
}

