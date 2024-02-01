//
//  ContentView.swift
//  LocalNotification
//
//  Created by Larry Shannon on 2/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userAuth: Authentication
    @State var permission = ""
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                let content = UNMutableNotificationContent()
                content.title = "This is the title of the notification"
                content.subtitle = "This is the subtitle of the notification"
                content.sound = UNNotificationSound.defaultRingtone
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            } label: {
                Text("Show Notification")
            }
            Spacer()
            Text("Notification Settings: \(permission)")
                .onNotification { notification in
                    print(notification)
                }
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .authorized: permission = "Authorized"
                    case .denied: permission = "Denied"
                    case .notDetermined: permission = "Not Determined"
                    case .ephemeral: permission = "Authorized  for limited time"
                    default: permission = "unknown"
                    }
                }
            }
        }
        .onChange(of: userAuth.permission) {
            DispatchQueue.main.async {
                permission = userAuth.permission
            }
        }
        .padding()
    }
}

struct NotificationViewModifier: ViewModifier {
    private let onNotification: (UNNotificationResponse) -> Void

    init(onNotification: @escaping (UNNotificationResponse) -> Void) {
        self.onNotification = onNotification
    }
 
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationHandler.shared.$latestNotification) { notification in
                guard let notification else { return }
                onNotification(notification)
            }
    }
}

extension View {
    func onNotification(perform action: @escaping (UNNotificationResponse) -> Void) -> some View {
        modifier(NotificationViewModifier(onNotification: action))
    }
}

#Preview {
    ContentView()
}
