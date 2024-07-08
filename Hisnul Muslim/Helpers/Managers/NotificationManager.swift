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
        get async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            return settings.authorizationStatus == .authorized
        }
    }
    
    func scheduleDailyNotification(identifier: String, hour: Int, minute: Int, AdkarContent: String) async throws -> String {
        guard let uuid = UUID(uuidString: identifier) else {
            throw NSError(domain: "SchedulerNotifications", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid identifier"])
        }
        
        let content = UNMutableNotificationContent()
        content.title = AdkarContent
        content.body = "لقد طلبت منا تذكيرهذه الأذكار:\(AdkarContent)"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)
        
        return try await withCheckedThrowingContinuation { continuation in
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: "لقد طلبت إرسال إشعار بخصوص هذا الإعلان:\(AdkarContent) ، سنرسل لك الشكر")
                }
            }
        }
    }
}
