//
//  LocalNotificationApp.swift
//  LocalNotification
//
//  Created by Larry Shannon on 2/1/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        NotificationHandler.shared.handle(notification: response)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint("🧨", "willPresent")
        completionHandler([[.banner, .sound]])
    }
    
}

@main
struct LocalNotificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userAuth = Authentication.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userAuth)
        }
    }
}
