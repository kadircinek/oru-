import Foundation

/// Utility functions for fasting calculations
struct FastingCalculator {
    
    /// Calculate remaining time in a fasting session
    /// - Parameters:
    ///   - session: The active fasting session
    ///   - targetHours: Target fasting hours (nil if already completed or unknown)
    /// - Returns: Tuple with remaining time and end date
    static func calculateRemainingTime(
        session: FastingSession?,
        targetHours: Int?
    ) -> (remaining: TimeInterval, endDate: Date)? {
        guard let session = session else { return nil }
        
        let endDate: Date
        
        if let targetHours = targetHours {
            endDate = session.startDate.addingTimeInterval(TimeInterval(targetHours * 3600))
        } else {
            // If no target, use end date if available
            guard let end = session.endDate else { return nil }
            endDate = end
        }
        
        let remaining = endDate.timeIntervalSince(Date())
        return (max(0, remaining), endDate)
    }
    
    /// Calculate progress percentage
    /// - Parameters:
    ///   - session: The active fasting session
    ///   - targetHours: Target fasting hours
    /// - Returns: Progress percentage (0-100)
    static func calculateProgress(
        session: FastingSession?,
        targetHours: Int?
    ) -> Double {
        guard let session = session, let targetHours = targetHours else { return 0 }
        
        let totalSeconds = TimeInterval(targetHours * 3600)
        let elapsedSeconds = Date().timeIntervalSince(session.startDate)
        let progress = min(100, (elapsedSeconds / totalSeconds) * 100)
        
        return progress
    }
    
    /// Determine if a fast was successful based on target
    /// - Parameters:
    ///   - session: The completed fasting session
    ///   - targetHours: Target fasting hours
    /// - Returns: True if fast met or exceeded target
    static func isFastSuccessful(_ session: FastingSession, targetHours: Int?) -> Bool {
        guard let targetHours = targetHours else {
            return session.actualFastingHours > 0
        }
        return session.actualFastingHours >= Double(targetHours)
    }
    
    /// Format time remaining into readable string
    /// - Parameter seconds: Seconds remaining
    /// - Returns: Formatted string (e.g., "2h 30m")
    static func formatTimeRemaining(_ seconds: TimeInterval) -> String {
        let totalSeconds = Int(max(0, seconds))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        } else {
            return String(format: "%dm", minutes)
        }
    }
    
    /// Calculate current streak based on sessions
    /// - Parameter sessions: Array of fasting sessions
    /// - Returns: Current consecutive day streak
    static func calculateCurrentStreak(from sessions: [FastingSession]) -> Int {
        let completedSessions = sessions
            .filter { $0.isCompleted }
            .sorted { $0.endDate ?? $0.startDate > $1.endDate ?? $1.startDate }
        
        guard !completedSessions.isEmpty else { return 0 }
        
        var streak = 0
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())
        
        for session in completedSessions {
            let sessionDate = calendar.startOfDay(for: session.endDate ?? session.startDate)
            
            if sessionDate == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if sessionDate < currentDate {
                break
            }
        }
        
        return streak
    }
    
    /// Calculate level based on completed fasts
    /// - Parameter completedFasts: Total number of completed fasts
    /// - Returns: Level (1-4)
    static func calculateLevel(from completedFasts: Int) -> Int {
        switch completedFasts {
        case 0...4:
            return 1 // Beginner
        case 5...14:
            return 2 // Consistent
        case 15...29:
            return 3 // Advanced
        default:
            return 4 // Expert
        }
    }
    
    /// Get level name
    /// - Parameter level: The level number
    /// - Returns: Human-readable level name
    static func levelName(for level: Int) -> String {
        switch level {
        case 1:
            return "Beginner"
        case 2:
            return "Consistent"
        case 3:
            return "Advanced"
        case 4:
            return "Expert"
        default:
            return "Unknown"
        }
    }
    
    /// Calculate fasts needed for next level
    /// - Parameter currentFasts: Current number of completed fasts
    /// - Returns: Number of fasts needed to reach next level
    static func fastsNeededForNextLevel(_ currentFasts: Int) -> Int {
        let nextLevelThreshold: Int
        
        if currentFasts < 5 {
            nextLevelThreshold = 5
        } else if currentFasts < 15 {
            nextLevelThreshold = 15
        } else if currentFasts < 30 {
            nextLevelThreshold = 30
        } else {
            return 0 // Already at max level
        }
        
        return max(0, nextLevelThreshold - currentFasts)
    }
}
