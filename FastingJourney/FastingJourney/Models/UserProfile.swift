import Foundation

/// Represents user's profile and progress
struct UserProfile: Codable {
    var level: Int
    var totalCompletedFasts: Int
    var longestStreak: Int
    var currentStreak: Int
    var lastFastingDate: Date?
    var totalHoursFasted: Double
    
    init(
        level: Int = 1,
        totalCompletedFasts: Int = 0,
        longestStreak: Int = 0,
        currentStreak: Int = 0,
        lastFastingDate: Date? = nil,
        totalHoursFasted: Double = 0
    ) {
        self.level = level
        self.totalCompletedFasts = totalCompletedFasts
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.lastFastingDate = lastFastingDate
        self.totalHoursFasted = totalHoursFasted
    }
}
