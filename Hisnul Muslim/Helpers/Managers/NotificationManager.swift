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
    
    func scheduleDailyNotification(identifier: String, hour: Int, minute: Int, AdkarContent: String, completion: @escaping (String?) -> Void) {
        guard let uuid = UUID(uuidString: identifier) else {
            completion("Invalid identifier")
            return
        }
        let content = UNMutableNotificationContent()
        content.title = AdkarContent
        content.body = "لقد طلبت منا تذكيرهذه الأذكار:\(AdkarContent)"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour)
        dateComponents.minute = Int(minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                completion("Error scheduling notification: \(error.localizedDescription)")
            } else {
                completion("لقد طلبت إرسال إشعار بخصوص هذا الإعلان:\(AdkarContent) ، سنرسل لك الشكر")
            }
        }
    }


}
