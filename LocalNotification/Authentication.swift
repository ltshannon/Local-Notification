//
//  Authentication.swift
//  LocalNotification
//
//  Created by Larry Shannon on 2/1/24.
//

import SwiftUI

class Authentication: ObservableObject {
    static let shared = Authentication()
    @Published var permission = ""
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                debugPrint("👏", "Notification granted")
            } else {
                debugPrint("🧨", "Notification failed: \(error?.localizedDescription ?? "No error message")")
            }
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .authorized: self.permission = "Authorized"
                    case .denied: self.permission = "Denied"
                    case .notDetermined: self.permission = "Not Determined"
                    case .ephemeral: self.permission = "Authorized  for limited time"
                    default: self.permission = "unknown"
                    }
                }
            }
        }
    }
    
}
