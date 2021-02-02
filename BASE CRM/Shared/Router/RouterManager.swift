//
//  RouterManager.swift
//  BaseDemo
//
//  Created by macOS on 9/4/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

class RouterManager {
    
    static let shared = RouterManager()
    
    init() {
        
    }
    
    /// rootViewController
    var rootViewController : UIViewController? {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController
    }
    
    /// visibleNavigationController
    var visibleNavigationController : UINavigationController? {
        return self.visibleViewController?.navigationController
    }
    
    /// visibleViewController
    var visibleViewController : UIViewController? {
        guard let rootViewController = self.rootViewController else {
            return nil
        }
        
        /// Present
        if let presentedVC = rootViewController.presentedViewController {
            return presentedVC
        }
        
        if let navigationVC = rootViewController as? UINavigationController {
            return navigationVC.visibleViewController
        }
        
        return rootViewController
    }
    
    /// handleRouter
    /// - Parameter router: generic
    func handleRouter<A: Router>(_ router : A) {
        let viewController = router.viewController
        
        switch router.routerType {
        case .root:
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window = UIWindow(frame: UIScreen.main.bounds)
            app.window?.rootViewController = viewController
            app.window?.makeKeyAndVisible()
        case .present:
            self.visibleViewController?.present(viewController, animated: true, completion: nil)
        case .push:
            if let visibleNav = self.visibleNavigationController {
                visibleNav.pushViewController(viewController, animated: true)
            } else {
                let topController = UIApplication.getTopViewController()
                topController?.onPushController(viewController)
            }
        }
    }
}
