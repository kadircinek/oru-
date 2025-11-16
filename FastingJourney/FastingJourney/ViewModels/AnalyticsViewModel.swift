import Foundation

/// ViewModel for analytics and insights
class AnalyticsViewModel: ObservableObject {
    @Published var analyticsData: AnalyticsData?
    @Published var selectedPeriod: AnalyticsPeriod = .week
    @Published var isLoading = false
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadAnalytics()
    }
    
    // MARK: - Loading
    
    func loadAnalytics() {
        isLoading = true
        
        let userProfile = persistenceManager.loadUserProfile()
        let allSessions = persistenceManager.loadSessions()
        
        // Filter only completed sessions
        let completedSessions = allSessions.filter { $0.endDate != nil }
        
        // Calculate analytics
        let totalFasts = userProfile.totalCompletedFasts
        let totalHours = userProfile.totalHoursFasted
        let averageHours = totalFasts > 0 ? totalHours / Double(totalFasts) : 0
        
        // Find longest fast
        let longestFast = completedSessions.map { $0.actualFastingHours }.max() ?? 0
        
        // Calculate success rate (completed vs total sessions including active)
        let allSessionsCount = allSessions.count
        let successRate = allSessionsCount > 0 ? (Double(totalFasts) / Double(allSessionsCount)) * 100 : 0
        
        // Generate weekly data
        let weeklyData = generateWeeklyData(from: completedSessions)
        
        // Generate monthly data
        let monthlyData = generateMonthlyData(from: completedSessions)
        
        analyticsData = AnalyticsData(
            totalFasts: totalFasts,
            totalHours: totalHours,
            averageHours: averageHours,
            longestFast: longestFast,
            currentStreak: userProfile.currentStreak,
            bestStreak: userProfile.longestStreak,
            successRate: successRate,
            weeklyData: weeklyData,
            monthlyData: monthlyData
        )
        
        isLoading = false
    }
    
    // MARK: - Weekly Data Generation
    
    private func generateWeeklyData(from sessions: [FastingSession]) -> [WeeklyDataPoint] {
        let calendar = Calendar.current
        let today = Date()
        
        // Get last 7 days
        var dataPoints: [WeeklyDataPoint] = []
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            // Filter sessions for this day
            let sessionsForDay = sessions.filter { session in
                guard let endDate = session.endDate else { return false }
                return calendar.isDate(endDate, inSameDayAs: date)
            }
            
            // Calculate total hours for this day
            let totalHours = sessionsForDay.reduce(0.0) { $0 + $1.actualFastingHours }
            
            // Get day name
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dayName = dayFormatter.string(from: date)
            
            dataPoints.append(WeeklyDataPoint(
                day: dayName,
                hours: totalHours,
                date: date
            ))
        }
        
        return dataPoints.reversed() // Oldest to newest
    }
    
    // MARK: - Monthly Data Generation
    
    private func generateMonthlyData(from sessions: [FastingSession]) -> [MonthlyDataPoint] {
        let calendar = Calendar.current
        let today = Date()
        
        var dataPoints: [MonthlyDataPoint] = []
        
        // Get last 6 months
        for monthOffset in 0..<6 {
            guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: today) else { continue }
            
            // Get start and end of month
            guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)),
                  let monthEnd = calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .month, value: 1, to: monthStart)!) else {
                continue
            }
            
            // Filter sessions for this month
            let sessionsForMonth = sessions.filter { session in
                guard let endDate = session.endDate else { return false }
                return endDate >= monthStart && endDate <= monthEnd
            }
            
            let totalFasts = sessionsForMonth.count
            let totalHours = sessionsForMonth.reduce(0.0) { $0 + $1.actualFastingHours }
            let averageHours = totalFasts > 0 ? totalHours / Double(totalFasts) : 0
            
            // Calculate success rate for month (simplified)
            let successRate = totalFasts > 0 ? 100.0 : 0.0
            
            // Get month name
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            let monthName = monthFormatter.string(from: monthDate)
            
            dataPoints.append(MonthlyDataPoint(
                month: monthName,
                averageHours: averageHours,
                totalFasts: totalFasts,
                successRate: successRate
            ))
        }
        
        return dataPoints.reversed() // Oldest to newest
    }
    
    // MARK: - Period Selection
    
    func selectPeriod(_ period: AnalyticsPeriod) {
        selectedPeriod = period
        loadAnalytics()
    }
    
    // MARK: - Formatted Values
    
    func formattedAverageHours() -> String {
        guard let data = analyticsData else { return "0.0" }
        return String(format: "%.1f", data.averageHours)
    }
    
    func formattedTotalHours() -> String {
        guard let data = analyticsData else { return "0" }
        return String(format: "%.0f", data.totalHours)
    }
    
    func formattedSuccessRate() -> String {
        guard let data = analyticsData else { return "0" }
        return String(format: "%.0f%%", data.successRate)
    }
    
    func formattedLongestFast() -> String {
        guard let data = analyticsData else { return "0.0" }
        return String(format: "%.1f", data.longestFast)
    }
}
