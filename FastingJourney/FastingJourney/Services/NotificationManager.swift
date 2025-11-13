import Foundation
import UserNotifications
import UIKit

/// Handles local notifications for fasting reminders
final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Request user permission for notifications
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /// Schedule a reminder for when a fasting session starts
    /// - Parameters:
    ///   - plan: The fasting plan being used
    ///   - startDate: When the fasting window starts
    func scheduleStartReminder(for plan: FastingPlan, startDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Fast"
        content.body = "\(plan.name) fasting window is starting!"
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        // Calculate trigger time (15 minutes before start as default)
        let timeInterval = max(60, startDate.timeIntervalSince(Date()) - 900) // At least 1 minute in future
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "fasting_start_\(plan.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling start reminder: \(error.localizedDescription)")
            }
        }
    }
    
    /// Schedule a reminder for when a fasting session ends
    /// - Parameters:
    ///   - plan: The fasting plan being used
    ///   - endDate: When the fasting window ends
    func scheduleEndReminder(for plan: FastingPlan, endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Fasting Window Ends"
        content.body = "Your \(plan.name) fasting window is ending. Time to break your fast!"
        content.sound = .default
        
        let timeInterval = max(60, endDate.timeIntervalSince(Date())) // At least 1 minute in future
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "fasting_end_\(plan.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling end reminder: \(error.localizedDescription)")
            }
        }
    }
    
    /// Cancel all scheduled notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Cancel a specific notification
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
