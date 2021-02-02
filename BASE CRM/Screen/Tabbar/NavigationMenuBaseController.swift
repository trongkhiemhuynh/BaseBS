//
//  NavigationMenuBaseController.swift
//  BaseDemo
//
//  Created by khiemht on 8/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

//class MainAppController: UITabBarController {
//    
//    @IBOutlet weak var vCustomTabbar : CustomTabBarView!
//    
//    var customTabBar: TabNavigationMenu!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.loadTabBar()
//        // Do any additional setup after loading the view.
//    }
//    
//    func loadTabBar() {
//        // We'll create and load our custom tab bar here
//        tabBar.isHidden = true
//        let tabItems: [TabItem] = [.dashboard, .profile, .ticket, .setting]
//        
//        self.selectedIndex = 0
//        
//        let customTabbar = Bundle.main.loadNibNamed("CustomTabBarView", owner: self, options: nil)?.first as? CustomTabBarView
//        self.view.addSubview(customTabbar!)
//        customTabbar?.frame = CGRect(x: 0, y: heightScreen - tabBarHeight, width: widthScreen, height: tabBarHeight)
//        customTabbar?.itemTapped = changeTab(tab:)
//        // load controller
//        var controllers = [UIViewController]()
//        for i in 0 ..< tabItems.count {
//            controllers.append(tabItems[i].viewController) // we fetch the matching view controller and append here
//        }
//        
//        self.viewControllers = controllers
//        
//        
//        //        self.setupCustomTabMenu(tabItems) { (controllers) in
//        //            self.viewControllers = controllers
//        //        }
//        
//        
//        
//        // default our selected index to the first item
//        
//    }
//    
//    func setupCustomTabMenu(_ items : [TabItem], completion: @escaping ([UIViewController]) -> Void) {
//        
//        let frame = tabBar.frame
//        var controllers = [UIViewController]()
//        // hide the tab bar
//        tabBar.isHidden = true
//        self.customTabBar = TabNavigationMenu(menuItems: items, frame: frame)
//        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
//        self.customTabBar.clipsToBounds = true
//        self.customTabBar.itemTapped = self.changeTab
//        // Add it to the view
//        self.view.addSubview(customTabBar)
//        // Add positioning constraints to place the nav menu right where the tab bar should be
//        NSLayoutConstraint.activate([
//            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
//            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
//            self.customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
//            self.customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
//            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
//        ])
//        for i in 0 ..< items.count {
//            controllers.append(items[i].viewController) // we fetch the matching view controller and append here
//        }
//        self.view.layoutIfNeeded() // important step
//        completion(controllers) // setup complete. handoff here
//    }
//    
//    func changeTab(tab: Int) {
//        self.selectedIndex = tab
//    }
//    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        
//    }
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destination.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//}
//
//extension MainAppController : XibInitalization {
//    typealias Element = MainAppController
//}
