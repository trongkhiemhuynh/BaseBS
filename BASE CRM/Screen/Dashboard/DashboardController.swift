//
//  DashboardViewController.swift
//  BaseDemo
//
//  Created by BASEBS on 8/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import Charts
import SideMenu
//import RealmSwift

protocol DashboardControllerOutput: class {
    func addNewWatchItem()
}

class DashboardController: BaseViewController {
    
    //outlet
    @IBOutlet weak var lblCountNotification : UILabel!
    @IBOutlet weak var btnAddMoreItem: UIButton!
    
    //variable
    var subView: BaseView?
//    var controller: ReportController?
    var isReport: Bool = false
    
    lazy var blurView : UIView = {
        let v = UIView(frame: view.frame)
        v.backgroundColor = .black
        v.layer.opacity = 0.4
        
        return v
    }()
    
    override func viewDidLoad() {
        isHiddenNavigationBar = true
        super.viewDidLoad()
    }

    override func setupView() {
        lblCountNotification.layer.cornerRadius = lblCountNotification.bounds.height/2
        lblCountNotification.clipsToBounds = true
        view.backgroundColor = .white
        
        addSubView()
    }
    
    override func initData() {
        super.initData()
        BASESideMenu.shared.menu.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.info(view.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isHiddenNavigationBar = true
        super.viewWillAppear(animated)
        
        //set frame
        let vHeight = self.view.bounds.height - heightTabbar - heightBottomArea
        let vWidth = self.view.bounds.width
       subView?.frame = CGRect(origin: .zero, size: CGSize(width: vWidth, height: vHeight))
    }

    func addSubView() {
        let type = ApplicationManager.sharedInstance.templateDashboard
        
        switch type {
        case .manager:
            subView = ManagerDashboard.xibInstance()
            subView?.addBarChart()
            subView?.addPieChart()
        case .sale:
            subView = SaleDashboard.xibInstance()
        case .agent:
            print("undefine")
        }
        self.vContent.addSubview(subView!)
    }
    
    @IBAction func actionClick() {

    }
    
    @IBAction func actionDismiss() {
//        popupView.removeFromSuperview()
    }
    
    @IBAction func didTapMenu() {
        let sideMenu = BASESideMenu.shared.sideMenuNavigation
        present(sideMenu, animated: true, completion: nil)
    }
    
    @IBAction func didTapAlert() {
//        let notiView = NotificationView.xibInstance()
//        generateView(subView: notiView, title: "Notification", actionType: .none)
    }

}

extension DashboardController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        view.addSubview(blurView)
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        blurView.removeFromSuperview()
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        Logger.info(menu)
    }
    
    func onPushView(_ name : [String:String]) {
        Logger.info(name)
        guard let vcName = name.values.first else {return}
        
        //handle for tabbar ticket
//        if vcName == HamburgerMenu.ticket.rawValue {
//            ApplicationManager.sharedInstance.mainTabbar?.customTabbar.switchTab(from: TabMenu.dashboard.rawValue, to: TabMenu.ticket.rawValue)
//        }

        if let keyObj = name.keys.first {
            //FIXME bypass the first
            if keyObj == "init" {
                return
            }
            
            //flag selected for object
            RealmManager.shared.onUpdateSelectedObject(nameObject: vcName)
            
            // push to object list
            let objectListController = ObjectListController()
            objectListController.keyObj = keyObj
            self.navigationController?.pushViewController(objectListController, animated: true)
        }
    }
}

extension DashboardController: XibInitalization {
    typealias Element = DashboardController
}

extension DashboardController {
    @IBAction func onAddMore() {
        print("onAddMore")
        if let v = subView as? SaleDashboard {
            v.addNewWatchItem()
        }
    }
    
//    public func onShowReport() {
//        if let saleView = subView as? SaleDashboard {
//            controller = ReportController()
//
//            saleView.vReport.isHidden = false
//            self.addChild(controller!)
//            saleView.vReport.addSubview(controller!.view)
//            controller?.view.frame =  saleView.vReport.bounds
//            controller?.didMove(toParent: self)
//            btnAddMoreItem.isHidden = true
//        }
//    }
    
//    public func onHideReport() {
//        if let saleView = subView as? SaleDashboard {
//            controller?.willMove(toParent: nil)
//            controller?.removeFromParent()
//            controller?.view.removeFromSuperview()
//            saleView.vReport.isHidden = true
//            btnAddMoreItem.isHidden = false
//        }
//    }
    
    private func onPushLocal(_ name : [String:String]?) {
        guard let vcName = name?.values.first else {return}
        
        if let keyObj = name?.keys.first {
        //FIXME bypass the first
            if keyObj == "init" {
                return
            }
            
            if vcName == "Dashboard" {
//                onHideReport()
            } else {
//                onShowReport()
                //TODO: Push to list objects
                
            }
        }
            
    }
}

extension DashboardController: MenuViewSelectedOutput {
    func onSelectedItem(dict: [String : String]) {
        onPushView(dict)
    }
    
    
}

class BASESideMenu {
    static let shared = BASESideMenu()

    lazy var sideMenuNavigation: SideMenuNavigationController = {
        let side = SideMenuNavigationController(rootViewController: menu)
        side.menuWidth = widthScreen - heightTabbar
        side.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = side
        
        return side
    }()
    
    lazy var menu: MenuViewController = {
        MenuViewController()
    }()
    
    private init() {}
}

class CustomMenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupView()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.present(BASESideMenu.shared.sideMenuNavigation, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupView() {
        //set background color
        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        
        let menu = BASESideMenu.shared.menu
        
        addChild(menu)
        view.addSubview(menu.view)
        menu.view.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.width - heightTabbar, height: self.view.frame.height))
        menu.didMove(toParent: self)
    }
}
