//
//  ObjectListController.swift
//  BaseDemo
//
//  Created by macOS on 12/2/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import RxSwift
import SwipeCellKit
import ObjectMapper

protocol ObjectListPresenterOutput: class {
    func presentError(error: Error)
    func reload()
}

protocol ObjectListControllerOutput {
    func fetch(objId: String)
}

class ObjectListController: BaseViewController {
    @IBOutlet weak var cvObject: UICollectionView!
    @IBOutlet weak var btnCustomView: UIButton!
    
    typealias HandlerData = (Mappable) -> Void
    
    var handler: HandlerData?
    
    var keyObj: String?
    
//    let presenter = PresenterView.xibInstance()
//    let vMagic = MagicCollectionView.xibInstance()
    var arrResult: Array<String>?
    var arrObjectDetail: Array<Any>?
    
    
    var output: ObjectListControllerOutput?
    
    lazy var viewModel: ObjectListControllerViewModel =  {
        return ObjectListControllerViewModel(id: keyObj!)
    }()
    
    let disposeBag = DisposeBag()
    
    var isLinkObject: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UPDATE_LIST, object: nil, queue: nil) { [weak self] (notification) in
            self?.view.addSubview(self!.vLoad)
            self?.viewModel.loadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        //swipe
        let cells: [LogCallViewCell] = cvObject.visibleCells as! [LogCallViewCell]
        
        cells.forEach { (cell) in
            cell.hideSwipe(animated: true) { (ok) in
                print("debug--- \(ok)")
                print(cell.swipeOffset)
            }
        }
    }
    
    deinit {
        print("deinit \(String(describing: self.nibName))")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupView() {
        cvObject.registerCell(LogCallViewCell.self)
    }
    
    override func initData() {
        //        output?.fetch(objId: keyObj!)
        self.view.addSubview(vLoad)
        viewModel.loadData()
        
        viewModel.outputs.arrayElement.subscribe(onNext: {[weak self] (array) in
            self?.vLoad.removeFromSuperview()
            self?.arrResult = array
            self?.cvObject.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.outputs.messageError.subscribe(onNext: { [weak self] (message) in
            self?.vLoad.removeFromSuperview()
            
            self?.arrResult?.removeAll()
            self?.cvObject.reloadData()
//            self?.showError(title: "ALERT!", message: message)
            
        }).disposed(by: disposeBag)
        
        viewModel.outputs.arrayForDetail.subscribe(onNext: {[weak self] (array) in
            self?.vLoad.removeFromSuperview()
            self?.arrObjectDetail = array
        }).disposed(by: disposeBag)
        
        viewModel.outputs.messageDeleteRecord.subscribe(onNext: {[weak self] (message) in
            self?.vLoad.removeFromSuperview()
            
            if message == "DONE" {
                self?.view.addSubview(self!.vLoad)
                self?.viewModel.loadData()
            } else {
                
            }
            
            self?.onPromtPopUp(message: message, completion: {
                
            })
        }).disposed(by: disposeBag)
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("CUSTOM_VIEW"), object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {return}
            
            let customViewModel = userInfo["data"] as! CustomViewModel
            
            self.view.addSubview(self.vLoad)
            self.viewModel.loadSpecificCustomView(idCustom: customViewModel.id)
        }
    }
}

extension ObjectListController {
    @IBAction func addItem() {
        newObject()
    }
    
    func newObject() {
        print("New Object")
        let newObjectController = ObjectNewController()
        newObjectController.keyObj = keyObj
        self.navigationController?.pushViewController(newObjectController, animated: true)
    }
    
    @IBAction func onCustomView() {
        if let objectId = keyObj {
            let v = CustomView.xibInstance()
            v.controller = self
            v.frame = view.bounds
            v.objectId = objectId
            self.view.addSubview(v)
        }
    }

}

extension ObjectListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogCallViewCell.identifier, for: indexPath) as! LogCallViewCell
        let name = arrResult?[indexPath.row]
        cell.onUpdate(name: name, company: "", imageName: "menu_account")
        cell.delegate = self
        
        return cell
    }
}

extension ObjectListController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "DELETE") { action, indexPath in
            // handle action by updating model with deletion
            self.view.addSubview(self.vLoad)
            if let object = self.arrObjectDetail?[indexPath.row] as? ObjectSubList {
                self.viewModel.deleteObject(objectId: self.keyObj!, recordId: object._id!)
            }
        }

        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
}

extension ObjectListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let object = arrObjectDetail?[indexPath.row] as? ObjectSubList {
            //linking object
            if isLinkObject {
                handler!(object)
                self.navigationController?.popViewController(animated: true)
                
                return
            }
            
            let route = ObjectDetailRoute()
            RouterManager.shared.handleRouter(route)
            
            route.handleData { (vc) in
                vc.object = object
//                print("debug_khiemht_id -- \(object._id)")
                vc.idObject = keyObj
                vc.idRecord = object._id
            }
        }
        
    }
}

extension ObjectListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: heightLargeCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ObjectListController: UIGestureRecognizerDelegate {
    @IBAction func onBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("debug")
        return false
    }
}

extension ObjectListController: ObjectListPresenterOutput {
    func presentError(error: Error) {
        self.showError(title: "ALERT!", message: error.localizedDescription)
    }
    
    func reload() {
        
    }
}



protocol ObjectListControllerViewModelInput {
    
}

protocol ObjectListControllerViewModelOutput {
    var arrayElement: PublishSubject<Array<String>> {get}
    var messageError: PublishSubject<String> {get}
    var arrayForDetail: PublishSubject<Array<Any>> {get}
    var messageDeleteRecord: PublishSubject<String> {get}
}

struct ObjectListControllerViewModel: ObjectListControllerViewModelOutput, ObjectListControllerViewModelInput {
    var messageDeleteRecord: PublishSubject<String> = PublishSubject()
    var arrayElement: PublishSubject<Array<String>> = PublishSubject()
    var arrayForDetail: PublishSubject<Array<Any>> = PublishSubject()
    var messageError: PublishSubject<String> = PublishSubject()
    
    var inputs: ObjectListControllerViewModelInput {
        return self
    }
    
    var outputs: ObjectListControllerViewModelOutput {
        return self
    }
    
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func loadData() {
        print("debug_khiemht_idObject -- \(id)")

        Networking.shared.fetchObjectList(id: id) { (arrData, err) in
            if err != nil {
                self.messageError.onNext("Something went wrong!")
            } else {
                if let array = arrData, array.count > 0 {
                    self.arrayForDetail.onNext(array)
                    var arrResult: [String] = []
                    
                    for item in array {
                        if let obj = item as? ObjectSubList {
                            if let o = obj.dataSubList?.first {
                                guard let name = o.valueObj else {arrResult.append("UNKNOWN"); continue}
                                arrResult.append(name)
                            }
                        }
                    }
                    
                    self.arrayElement.onNext(arrResult)
                } else {
                    self.messageError.onNext("Something went wrong!")
                }
            }
        }
    }
    
    func loadSpecificCustomView(idCustom: String) {
        Networking.shared.fetchCustomViewList(idObject: id, idCustom: idCustom) { (arrData, err) in
            if err != nil {
                self.messageError.onNext("Something went wrong!")
            } else {
                if let array = arrData, array.count > 0 {
                    self.arrayForDetail.onNext(array)
                    var arrResult: [String] = []
                    
                    for item in array {
                        if let obj = item as? ObjectSubList {
                            if let o = obj.dataSubList?.first {
                                arrResult.append(o.valueObj!)
                            }
                        }
                    }
                    
                    self.arrayElement.onNext(arrResult)
                } else {
                    self.messageError.onNext("Something went wrong!")
                }
            }
        }
    }

    func deleteObject(objectId: String, recordId: String) {
        Networking.shared.deleteObject(objectId: objectId, recordId: recordId) { (success) in
            print(success)
            if success {
                self.messageDeleteRecord.onNext("DONE")
            } else {
                self.messageDeleteRecord.onNext("FAILED")
            }
            
        }
    }
}
