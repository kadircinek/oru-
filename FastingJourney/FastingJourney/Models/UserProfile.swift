import Foundation

/// Notification preferences for the user
struct NotificationPreferences: Codable, Equatable {
    var customReminderTimes: [Int] // Hours from fasting start (e.g., [2, 4, 8, 12])
    var enableMotivationalQuotes: Bool
    var enableNearlyDoneCountdown: Bool // "Neredeyse bitti" countdown
    var quietHoursEnabled: Bool
    var quietHoursStart: Int // Hour in 24h format (e.g., 22 for 10 PM)
    var quietHoursEnd: Int // Hour in 24h format (e.g., 7 for 7 AM)
    
    init(
        customReminderTimes: [Int] = [4, 8, 12],
        enableMotivationalQuotes: Bool = true,
        enableNearlyDoneCountdown: Bool = true,
        quietHoursEnabled: Bool = false,
        quietHoursStart: Int = 22,
        quietHoursEnd: Int = 7
    ) {
        self.customReminderTimes = customReminderTimes
        self.enableMotivationalQuotes = enableMotivationalQuotes
        self.enableNearlyDoneCountdown = enableNearlyDoneCountdown
        self.quietHoursEnabled = quietHoursEnabled
        self.quietHoursStart = quietHoursStart
        self.quietHoursEnd = quietHoursEnd
    }
}

/// Represents user's profile and progress
struct UserProfile: Codable {
    var level: Int
    var totalCompletedFasts: Int
    var longestStreak: Int
    var currentStreak: Int
    var lastFastingDate: Date?
    var totalHoursFasted: Double
    var notificationPreferences: NotificationPreferences
    
    init(
        level: Int = 1,
        totalCompletedFasts: Int = 0,
        longestStreak: Int = 0,
        currentStreak: Int = 0,
        lastFastingDate: Date? = nil,
        totalHoursFasted: Double = 0,
        notificationPreferences: NotificationPreferences = NotificationPreferences()
    ) {
        self.level = level
        self.totalCompletedFasts = totalCompletedFasts
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.lastFastingDate = lastFastingDate
        self.totalHoursFasted = totalHoursFasted
        self.notificationPreferences = notificationPreferences
    }
}
