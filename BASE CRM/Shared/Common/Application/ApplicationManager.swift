//
//  ApplicationManager.swift
//  BaseDemo
//
//  Created by macOS on 8/31/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
//import RealmSwift

class ApplicationManager {
    
    //
    // MARK: - Variable
    static let sharedInstance = ApplicationManager()
    
    var itemMenuSelected: ItemMenu?
    var templateDashboard: DashboardType = .sale
    
    // Global Date formatter
    lazy var globalDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'Z'"
        return dateFormatter
    }()
    
    lazy var defaultDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }()
    
    lazy var VNDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    func saveUserDefault(value: Any?, key: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        
        userDefault.synchronize()
    }
    
    func getValueUserDefault(key: String) -> Any? {
        let userDefault = UserDefaults.standard
        let value = userDefault.value(forKey: key)
        
        return value
    }
    
    
    //
    // MARK: Public
    
    /// SDK
//    func initAllSDKs() {
//        let configuration = Realm.Configuration(
//            schemaVersion: 2,
//            migrationBlock: { migration, oldSchemaVersion in
//                if oldSchemaVersion < 1 {
//
//                    // if just the name of your model's property changed you can do this
////                    migration.renameProperty(onType: NotSureItem.className(), from: "text", to: "title")
////
////                    // if you want to fill a new property with some values you have to enumerate
////                    // the existing objects and set the new value
////                    migration.enumerateObjects(ofType: NotSureItem.className()) { oldObject, newObject in
////                        let text = oldObject!["text"] as! String
////                        newObject!["textDescription"] = "The title is \(text)"
////                    }
//
//                    // if you added a new property or removed a property you don't
//                    // have to do anything because Realm automatically detects that
//                }
//            }
//        )
//        Realm.Configuration.defaultConfiguration = configuration
//
//        // opening the Realm file now makes sure that the migration is performed
////        let realm = try! Realm()
//    }
    
    
    /// Common
    func initCommon() {
        
        // Logger
        self.initLogger()
        
        // Global Appearance
        self.initGlobalAppearance()
        
//        self.registerPushNotification()
    }
    
}


//
// MARK: - Private
extension ApplicationManager {
    
    // Logger
    fileprivate func initGlobalAppearance() {
        let routerManager = RouterManager.shared
        let routeSplash = SplashRoute()

        routerManager.handleRouter(routeSplash)
    }
    
    private func requestLocation() {
        LocationManager.shared.requestAccessLocation()
    }
    
    private func registerPushNotification() {
        NotificationManager.registerPushNotification()
    }
}


// MARK:
// MARK: Logger
extension ApplicationManager {
    fileprivate func initLogger() {
        Logger.initLogger()
    }
}
