//
//  TabItem.swift
//  BaseDemo
//
//  Created by khiemht on 8/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation

import UIKit
enum TabItem: String, CaseIterable {
    case home = "Home"
    case menu = "Menu"
    case search = "Search"
    case notification = "Notification"
    case personal = "Personal"
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return UINavigationController(rootViewController: DashboardController())
        case .menu:
//            let controller = CustomMenuController()
            return UINavigationController(rootViewController: MenuViewController())
        case .search:
            let searchController = UIViewController()
            return searchController
        case .notification:
            let controller = UIViewController()
            return UINavigationController(rootViewController: controller)
        case .personal:
            let profileController = ProfileController()
            return UINavigationController(rootViewController: profileController)
        }
    }
    
    // these can be your icons
//    var icon: UIImage {
//        switch self {
//        case .dashboard:
//            return UIImage(named: "home_selected")!
//
//        case .profile:
//            return UIImage(named: "profile_selected")!
//        case .ticket:
//            return UIImage(named: "ticket_selected")!
//        case .setting:
//            return UIImage(named: "setting_selected")!
//        }
//    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
