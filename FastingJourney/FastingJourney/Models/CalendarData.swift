import Foundation

/// Represents a single day in the calendar
struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let isCurrentMonth: Bool
    let isToday: Bool
    var fastingStatus: FastingStatus
    var sessions: [FastingSession]
    var totalHours: Double
    
    enum FastingStatus {
        case none          // No fasting
        case completed     // Successful fast
        case missed        // Started but not completed
        case inProgress    // Currently fasting
        
        var color: String {
            switch self {
            case .none: return "gray"
            case .completed: return "green"
            case .missed: return "red"
            case .inProgress: return "blue"
            }
        }
    }
}

/// Represents a week in the calendar
struct CalendarWeek: Identifiable {
    let id = UUID()
    let days: [CalendarDay]
}

/// Represents a month of calendar data
struct CalendarMonth {
    let year: Int
    let month: Int
    let weeks: [CalendarWeek]
    let monthName: String
    let totalFasts: Int
    let successfulFasts: Int
    let currentStreak: Int
    
    var successRate: Double {
        guard totalFasts > 0 else { return 0 }
        return (Double(successfulFasts) / Double(totalFasts)) * 100
    }
}

/// Day of week labels
enum Weekday: String, CaseIterable {
    case sun = "Su"
    case mon = "M"
    case tue = "Tu"
    case wed = "W"
    case thu = "Th"
    case fri = "F"
    case sat = "Sa"
}
