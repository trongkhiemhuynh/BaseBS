//
//  NotificationManager.swift
//  BaseDemo
//
//  Created by macOS on 11/20/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static func registerPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]) { (granted, error) in
            guard granted else {return}
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else {return}
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    class func pushNotificationLocal(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        let request = UNNotificationRequest(identifier: "BASE-IDENTIFIER", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
