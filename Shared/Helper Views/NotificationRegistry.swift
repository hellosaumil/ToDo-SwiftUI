//
//  NotificationRegistry.swift
//  ToDo-SwiftUI (iOS)
//
//  Created by Saumil Shah on 9/9/20.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static func registerNotification() {
        
        // MARK: Remove All Pending Notification Requests
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // MARK: Ask User's permission for Notifications
        _ = "Get notifed when your ToDoTasks are due."
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            
            if success {
                
                // MARK: Notification Permission Granted
                print("Notification Registry Successful. 🎉")
                
            } else if let error = error {
                
                // MARK: Notification Permissions DENIED
                print("\nPermission DENIED for Notification on User Device. ⚠️⛔️📱")
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func sampleNotification(dueDate:Date = Date()) {
        
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.body = "Some body text..."
        content.sound = UNNotificationSound.default
        
        print("\nNotifying...\(customDateFormatter.string(from: Date()))")
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
//        var date = DateComponents()
//        date.hour = 02
//        date.minute = 18
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

}
