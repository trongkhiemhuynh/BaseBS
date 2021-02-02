//
//  NavigationMenuBaseController.swift
//  BaseDemo
//
//  Created by khiemht on 8/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import SideMenu

class MainAppController: UITabBarController {
    
    lazy var customTabbar: CustomTabBarView = {
        let tabbar = CustomTabBarView.xibInstance()
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        
        return tabbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    
    func loadTabBar() {
        // We'll create and load our custom tab bar here
        var controllers: [UIViewController] = []
        tabBar.isHidden = true
        self.selectedIndex = 0
        
        self.view.addSubview(customTabbar)
        
        NSLayoutConstraint.activate([
            customTabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabbar.heightAnchor.constraint(equalToConstant: heightTabbar)
        ])
        
        customTabbar.itemTapped = changeTab(tab:)

        TabItem.allCases.forEach {
            self.viewControllers?.append($0.viewController)
            controllers.append($0.viewController)
        }
        
        self.viewControllers = controllers
    }
    
    func changeTab(tab: Int) {
        if tab == ROOT_VIEW {
            //tapped the same tab
            let nav = self.viewControllers?[self.selectedIndex] as? UINavigationController
            nav?.popToRootViewController(animated: true)
        } else {
            self.selectedIndex = tab
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    deinit {
        Logger.info("MainAppController debug")
    }
}

extension MainAppController: XibInitalization {
    typealias Element = MainAppController
}
