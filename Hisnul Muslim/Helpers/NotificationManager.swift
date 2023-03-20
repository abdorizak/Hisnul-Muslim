//
//  NotificationManager.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/19/23.
//

import Foundation
import UIKit
import UserNotifications

final class SchedulerNotifications {
    static let shared = SchedulerNotifications()
    
    var isUserAllowNotification: Bool {
        var isAuthorized = false
        let semaphore = DispatchSemaphore(value: 0)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            isAuthorized = settings.authorizationStatus == .authorized
            semaphore.signal()
        }
        semaphore.wait()
        return isAuthorized
    }
    
    
    func scheduleDailyNotification(hour: Int, minute: Int, title: String, AdkarContent: Content) -> String {
        let content = UNMutableNotificationContent()
        content.title = AdkarContent.title
        content.body = ""
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour)
        dateComponents.minute = Int(minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-notification", content: content, trigger: trigger)
        var message: String?
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                message = "Error scheduling notification: \(error.localizedDescription)"
            } else {
                message = "لقد طلبت إرسال إشعار بخصوص هذا الإعلان:\(AdkarContent.title) ، سنرسل لك الشكر"
            }
        }
        return message ?? "N/A"
    }
    
}
