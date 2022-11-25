//
//  AppDelegate.swift
//  inSociety
//
//  Created by Aleksey Libin on 12.10.2022.
//

import UIKit
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        requestNotifications()
        FirebaseApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}



//MARK: - Notifications (prepare)
import UserNotifications

extension AppDelegate {
    func requestNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted ", granted)
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print(settings)
        }
    }
    
    func createNotification(with title: String, subTitle: String?, body: String) {
        let identifier = "Custom notification"
        
        let content = UNMutableNotificationContent()
        content.title = title
        if let subTitle = subTitle { content.subtitle = subTitle }
        content.body = body
        content.sound = UNNotificationSound.default
//        content.badge
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
