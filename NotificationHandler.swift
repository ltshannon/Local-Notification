//
//  NotificationHandler.swift
//  LocalNotification
//
//  Created by Larry Shannon on 2/1/24.
//

import SwiftUI

public class NotificationHandler: ObservableObject {
    public static let shared = NotificationHandler()
    @Published private(set) var latestNotification: UNNotificationResponse? = .none // default value

    public func handle(notification: UNNotificationResponse) {
        self.latestNotification = notification
    }
    
}
