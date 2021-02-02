//
//  MenuCollectionViewController.swift
//  BaseDemo
//
//  Created by macOS on 9/8/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import SideMenu
//import RxSwift
//import RxCocoa


let heightBottomArea: CGFloat = {
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows.first
        return  (window?.safeAreaInsets.bottom)!
    } else {
    
        return 0
    }
}()

private let reuseIdentifier = "Cell"

protocol MenuViewSelectedOutput: class {
    func onSelectedItem(dict: [String: String])
}

class MenuViewController: BaseViewController {

    var collectionView: UICollectionView!
    
//    var itemVar: [String:String] {
//        get {
//            return _rx_ItemVar.value
//        }
//
//        set {
//            Logger.info(newValue)
//            _rx_ItemVar.accept(newValue)
//        }
//    }
    
    var arrMenu: Array<Any>?
    weak var delegate: MenuViewSelectedOutput?
    
//    var _rx_ItemVar = BehaviorRelay<[String:String]>(value: ["init": HamburgerMenu.dashboard.rawValue])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
        
        self.collectionView.registerCell(MenuCollectionViewCell.self)
        self.collectionView.registerCell(TicketDetailInfoCollectionViewCell.self)

        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: 100, height: 20)
        }
        
        self.collectionView.backgroundColor = .white
        self.view.backgroundColor = .white
    }
    
    override func initData() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.view.bounds.height, heightScreen)
        self.collectionView.frame = CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - heightTabbar - heightBottomArea))
    }
    
    func equals(_ x : Any, _ y : Any) -> Bool {
        guard x is AnyHashable else { return false }
        guard y is AnyHashable else { return false }
        return (x as! AnyHashable) == (y as! AnyHashable)
    }
    
    private func onRequest() {
        self.view.addSubview(self.vLoad)
        Networking.shared.fetchMenu { [weak self] (arrData, err) in
            self?.vLoad.removeFromSuperview()
            
            if err != nil {
                self?.showError(title: "ALERT!", message: err?.localizedDescription)
            } else {
                self?.arrMenu?.removeAll()
                var arrResult = arrData
                
                arrResult?.sort(by: { (x, y) -> Bool in
                    let x1 = x as! Dictionary<String, String>
                    let y1 = y as! Dictionary<String, String>
                    
                    return x1.values.first! < y1.values.first!
                })
                
                self?.arrMenu = arrResult!
                self?.collectionView.reloadData()
            }
        }
    }
    
//    private func dumDataTest() {
//        arrMenu.append(["khiemht":"Report"])
//        arrMenu.append(["khiemht1":"Dashboard"])
//        self.collectionView.reloadData()
//    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (arrMenu?.count ?? 0) + 1 // for top cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketDetailInfoCollectionViewCell.identifier, for: indexPath) as! TicketDetailInfoCollectionViewCell
            // Configure the cell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as! MenuCollectionViewCell
            let dict = arrMenu?[indexPath.row - 1] as! [String:String]
            let item = dict.values.first!
            
            let nameImage = "menu_\(item.lowercased().replacingOccurrences(of: " ", with: "_"))"
            let image = UIImage(named: nameImage)
            
            cell.imgMenu.image = image ?? UIImage(named: "menu_account")
            cell.lblMenu.text = item
            // Configure the cell
            
            return cell
        }
    }
}

extension MenuViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsetsDefault.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        if indexPath.row == 0 {
            return CGSize(width: widthPerItem, height: heightHeaderDetailTicket)
        } else {
            return CGSize(width: widthPerItem, height: heightDefaultCell)
        }
    }
}

extension MenuViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        let nameItem = arrMenu?[indexPath.row - 1] as? [String: String]
//        Logger.info(nameItem)
//
//        ApplicationManager.sharedInstance.mainTabbar?.selectedIndex = 0
//
//        let currentPosition = ApplicationManager.sharedInstance.mainTabbar?.customTabbar.activeItem
//        let nextPostion = 0
//        ApplicationManager.sharedInstance.mainTabbar?.customTabbar.switchTab(from: currentPosition!, to: nextPostion)
        
        guard let delegate = delegate else {
            let controller = ObjectListController()
            controller.keyObj = nameItem?.keys.first
            self.navigationController?.pushViewController(controller, animated: true)
            
            return
        }
        
        SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
            
        })
        
        delegate.onSelectedItem(dict: nameItem!)
    }
}
