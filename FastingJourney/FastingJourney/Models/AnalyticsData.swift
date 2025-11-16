import Foundation

/// Represents analytics data for fasting insights
struct AnalyticsData {
    let totalFasts: Int
    let totalHours: Double
    let averageHours: Double
    let longestFast: Double
    let currentStreak: Int
    let bestStreak: Int
    let successRate: Double // 0-100
    let weeklyData: [WeeklyDataPoint]
    let monthlyData: [MonthlyDataPoint]
}

/// Weekly data point for charts
struct WeeklyDataPoint: Identifiable {
    let id = UUID()
    let day: String // "Mon", "Tue", etc.
    let hours: Double
    let date: Date
}

/// Monthly data point for charts
struct MonthlyDataPoint: Identifiable {
    let id = UUID()
    let month: String // "Jan", "Feb", etc.
    let averageHours: Double
    let totalFasts: Int
    let successRate: Double
}

/// Time period for analytics
enum AnalyticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All Time"
}
