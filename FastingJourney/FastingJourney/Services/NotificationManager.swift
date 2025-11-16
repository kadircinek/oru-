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
    
    // MARK: - Water Reminders
    /// Schedule a direct water intake encouragement (manual trigger)
    func scheduleWaterEncouragement(remainingMl: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Keep Drinking Water 💧"
        content.body = remainingMl > 0 ? "Remaining to reach goal: \(remainingMl) ml" : "Goal completed, you're awesome!"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let req = UNNotificationRequest(identifier: "water_encouragement_\(Int(Date().timeIntervalSince1970))", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req)
    }
    
    /// Schedule smart water reminder with progress milestone
    /// - Parameters:
    ///   - intervalMinutes: Minutes until next reminder
    ///   - consumedMl: Current water consumed
    ///   - targetMl: Daily water target
    func scheduleSmartWaterReminder(intervalMinutes: Int, consumedMl: Int, targetMl: Int) {
        let content = UNMutableNotificationContent()
        let progressPercent = min(Double(consumedMl) / Double(targetMl) * 100, 100)
        let remaining = max(targetMl - consumedMl, 0)
        
        // Customize message based on progress
        if progressPercent < 30 {
            content.title = "💧 Time to Drink Water!"
            content.body = "Drink water to start your day! Goal: \(targetMl)ml, Remaining: \(remaining)ml"
        } else if progressPercent < 50 {
            content.title = "💪 You're Doing Great!"
            content.body = "\(Int(progressPercent))% completed! \(remaining)ml more, you can do it!"
        } else if progressPercent < 75 {
            content.title = "🎯 Halfway There!"
            content.body = "Awesome! You're very close to your goal. Remaining: \(remaining)ml"
        } else if progressPercent < 100 {
            content.title = "🏆 Almost Done!"
            content.body = "Last \(remaining)ml! You're about to reach your goal!"
        } else {
            content.title = "🎉 Goal Completed!"
            content.body = "Congratulations! You've reached your daily water goal! Keep it up!"
        }
        
        content.sound = .default
        
        let fireDate = Date().addingTimeInterval(TimeInterval(intervalMinutes * 60))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireDate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(
            identifier: "smart_water_\(Int(fireDate.timeIntervalSince1970))",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { 
                print("Error scheduling smart water reminder: \(error.localizedDescription)") 
            }
        }
    }

    // MARK: - Stage Notifications
    /// Schedule a near-immediate notification for a reached fasting stage
    /// - Parameters:
    ///   - sessionKey: Unique key for the current session (e.g., start timestamp)
    ///   - hour: Stage hour from start
    ///   - title: Stage title
    ///   - detail: Stage detail/motivation
    func scheduleStageReached(sessionKey: String, hour: Int, title: String, detail: String) {
        let content = UNMutableNotificationContent()
        
        // Enhanced messages for key milestones
        switch hour {
        case 0...2:
            content.title = "🌱 Fast Started - Hour \(hour)"
            content.body = "\(title): \(detail) Your body is using glucose stores."
        case 4:
            content.title = "💪 Hour 4 Completed!"
            content.body = "\(title): \(detail) Insulin levels are starting to drop!"
        case 8:
            content.title = "🔥 Hour 8 - Fat Burning Started!"
            content.body = "\(title): \(detail) Your body is entering fat-burning mode!"
        case 12:
            content.title = "⚡ Hour 12 - Ketosis Begins!"
            content.body = "\(title): \(detail) Started producing ketones! You're amazing!"
        case 16:
            content.title = "🏆 Hour 16 - Advanced Level!"
            content.body = "\(title): \(detail) Autophagy active! Cell renewal accelerated!"
        case 18...24:
            content.title = "🌟 Hour \(hour) - Expert Level!"
            content.body = "\(title): \(detail) Incredible achievement! Keep going!"
        default:
            content.title = "✨ Hour \(hour) Completed!"
            content.body = "\(title): \(detail)"
        }
        
        content.sound = .default

        // Fire in ~1 second to avoid foreground throttle race conditions
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let identifier = "fasting_stage_\(sessionKey)_\(hour)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print("Error scheduling stage notification: \(error.localizedDescription)") }
        }
    }
    
    // MARK: - Calorie Burn Notifications
    /// Schedule calorie burn progress notifications
    /// - Parameters:
    ///   - sessionKey: Unique key for the current session
    ///   - user: User with weight, height, age, gender for calculations
    ///   - startDate: When fasting started
    ///   - fastingHours: Target fasting hours
    func scheduleCalorieBurnNotifications(sessionKey: String, user: User, startDate: Date, fastingHours: Int) {
        guard user.weight != nil, user.height != nil, user.age != nil, user.gender != nil else {
            return // Can't calculate without metrics
        }
        
        // Key calorie milestone hours: 4, 8, 12, 16
        let milestoneHours: [Int] = [4, 8, 12, 16].filter { $0 <= fastingHours }
        
        for hour in milestoneHours {
            let calculator = CalorieCalculator.shared
            let caloriesBurned = calculator.calculateFastingCalories(user: user, fastingHours: Double(hour))
            let fatBurned = calculator.calculateFatBurned(caloriesBurned: caloriesBurned)
            let fatPercentage = calculator.calculateFatBurningPercentage(fastingHours: Double(hour))
            
            let content = UNMutableNotificationContent()
            
            if hour == 12 {
                // Special ketosis notification
                content.title = "⚡ Entered Ketosis Mode!"
                content.body = "Congratulations! You burned \(Int(caloriesBurned)) kcal and lost \(String(format: "%.1f", fatBurned))g of fat. Your body is now burning fat! 🔥"
            } else {
                content.title = "🔥 \(hour) Hour Calorie Burn"
                content.body = "Great! You burned \(Int(caloriesBurned)) kcal. Fat burning rate: \(Int(fatPercentage * 100))%. Keep going! 💪"
            }
            
            content.sound = .default
            
            let fireDate = startDate.addingTimeInterval(TimeInterval(hour * 3600))
            let timeInterval = fireDate.timeIntervalSince(Date())
            
            if timeInterval > 60 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let identifier = "calorie_burn_\(sessionKey)_\(hour)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error { 
                        print("Error scheduling calorie notification: \(error.localizedDescription)") 
                    }
                }
            }
        }
    }
    
    /// Cancel calorie burn notifications for a session
    func cancelCalorieBurnNotifications(sessionKey: String) {
        let identifiers = [4, 8, 12, 16].map { "calorie_burn_\(sessionKey)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Health Tip Notifications
    /// Schedule health tip reminders during fasting
    /// - Parameters:
    ///   - sessionKey: Unique key for the current session
    ///   - fastingHours: Target fasting hours
    func scheduleHealthTipReminders(sessionKey: String, fastingHours: Int) {
        // Schedule tips at key intervals: 4h, 8h, 12h, 16h
        let intervals: [Int] = [4, 8, 12, 16].filter { $0 < fastingHours }
        
        for hour in intervals {
            let tip = HealthTipsProvider.shared.getCurrentTip(fastingHours: hour)
            let content = UNMutableNotificationContent()
            content.title = "\(tip.icon) Health Tip - Hour \(hour)"
            content.body = "\(tip.title): \(tip.description)"
            content.sound = .default
            
            let timeInterval = Double(hour * 3600) // Convert hours to seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let identifier = "health_tip_\(sessionKey)_\(hour)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error { 
                    print("Error scheduling health tip notification: \(error.localizedDescription)") 
                }
            }
        }
    }
    
    /// Cancel health tip notifications for a session
    func cancelHealthTipNotifications(sessionKey: String) {
        let identifiers = [4, 8, 12, 16].map { "health_tip_\(sessionKey)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Custom Reminders
    /// Schedule custom reminders based on user preferences
    /// - Parameters:
    ///   - sessionKey: Unique key for the current session
    ///   - startDate: When the fasting session started
    ///   - reminderHours: Hours from start when reminders should fire
    ///   - preferences: User notification preferences
    func scheduleCustomReminders(sessionKey: String, startDate: Date, reminderHours: [Int], preferences: NotificationPreferences) {
        for hour in reminderHours {
            // Calculate the fire date
            let fireDate = startDate.addingTimeInterval(TimeInterval(hour * 3600))
            
            // Check if it falls within quiet hours
            if preferences.quietHoursEnabled && isInQuietHours(date: fireDate, start: preferences.quietHoursStart, end: preferences.quietHoursEnd) {
                continue // Skip this notification
            }
            
            let content = UNMutableNotificationContent()
            
            // Use motivational quote if enabled
            if preferences.enableMotivationalQuotes {
                content.title = "Fasting Reminder - Hour \(hour)"
                content.body = MotivationalQuotesProvider.shared.getQuoteForHour(hour)
            } else {
                content.title = "Fasting Reminder"
                content.body = "\(hour) hours completed! Keep going! 💪"
            }
            
            content.sound = .default
            
            let timeInterval = max(60, fireDate.timeIntervalSince(Date()))
            if timeInterval > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let identifier = "custom_reminder_\(sessionKey)_\(hour)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling custom reminder: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    /// Schedule "Nearly Done" countdown notifications
    /// - Parameters:
    ///   - sessionKey: Unique key for the current session
    ///   - endDate: When the fasting session ends
    ///   - preferences: User notification preferences
    func scheduleNearlyDoneCountdown(sessionKey: String, endDate: Date, preferences: NotificationPreferences) {
        guard preferences.enableNearlyDoneCountdown else { return }
        
        // Send notifications at 1 hour, 30 min, 15 min, 5 min before end
        let intervals: [(minutes: Int, message: String)] = [
            (60, "Almost done! 1 hour left! 🎯"),
            (30, "Great! Only 30 minutes left! ⏰"),
            (15, "Final 15 minutes! You can do it! 💪"),
            (5, "5 minutes left! About to finish! 🏁")
        ]
        
        for interval in intervals {
            let fireDate = endDate.addingTimeInterval(-TimeInterval(interval.minutes * 60))
            
            // Check if it falls within quiet hours
            if preferences.quietHoursEnabled && isInQuietHours(date: fireDate, start: preferences.quietHoursStart, end: preferences.quietHoursEnd) {
                continue
            }
            
            let timeInterval = fireDate.timeIntervalSince(Date())
            if timeInterval > 60 { // Only schedule if more than 1 minute in future
                let content = UNMutableNotificationContent()
                content.title = "Neredeyse Bitti! 🎉"
                content.body = interval.message
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let identifier = "nearly_done_\(sessionKey)_\(interval.minutes)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling nearly done notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    /// Check if a date falls within quiet hours
    private func isInQuietHours(date: Date, start: Int, end: Int) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if start < end {
            // Normal case: e.g., 22:00 - 07:00
            return hour >= start && hour < end
        } else {
            // Wraps midnight: e.g., 22:00 - 07:00
            return hour >= start || hour < end
        }
    }
    
    /// Cancel all custom notifications for a session
    func cancelCustomNotifications(sessionKey: String) {
        var identifiers: [String] = []
        
        // Custom reminders
        for hour in 0...24 {
            identifiers.append("custom_reminder_\(sessionKey)_\(hour)")
        }
        
        // Nearly done notifications
        for minutes in [5, 15, 30, 60] {
            identifiers.append("nearly_done_\(sessionKey)_\(minutes)")
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Completion Notification
    /// Schedule fasting completion notification with restart prompt
    func scheduleFastingCompletion(planName: String, hours: Int) {
        let content = UNMutableNotificationContent()
        content.title = "🎉 Fast Completed!"
        content.body = "You successfully completed the \(planName) plan! It lasted \(hours) hours. Would you like to start a new fast?"
        content.sound = .default
        content.categoryIdentifier = "FAST_COMPLETE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let identifier = "fasting_complete_\(Int(Date().timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Add notification actions
        let startNewAction = UNNotificationAction(
            identifier: "START_NEW_FAST",
            title: "Start New Fast",
            options: .foreground
        )
        let laterAction = UNNotificationAction(
            identifier: "LATER",
            title: "Later",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "FASTING_COMPLETE",
            actions: [startNewAction, laterAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling completion notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Location-Based Notifications
    
    /// Schedule notification when approaching home with fasting ending soon
    func scheduleHomeApproachReminder(minutesRemaining: Int) {
        let content = UNMutableNotificationContent()
        content.title = "🏠 Approaching Home!"
        content.body = "Your fast ends in \(minutesRemaining) minutes. You can make your preparations when you get home."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let identifier = "home_approach_\(Int(Date().timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling home approach notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Weather-Based Notifications
    
    /// Schedule weather alert notification
    func scheduleWeatherAlert(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Hava Durumu Uyarısı"
        content.body = message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
        let identifier = "weather_alert_\(Int(Date().timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling weather notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Calendar-Based Notifications
    
    /// Schedule calendar-based fasting suggestion
    func scheduleCalendarBasedSuggestion(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Akıllı Oruç Önerisi"
        content.body = message
        content.sound = .default
        
        // Schedule for evening (20:00) to suggest tomorrow's plan
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = "calendar_suggestion_\(Int(Date().timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling calendar notification: \(error.localizedDescription)")
            }
        }
    }
}
