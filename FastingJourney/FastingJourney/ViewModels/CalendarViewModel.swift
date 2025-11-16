import Foundation
import SwiftUI

/// ViewModel for calendar functionality
class CalendarViewModel: ObservableObject {
    @Published var currentMonth: CalendarMonth?
    @Published var selectedDate: Date = Date()
    @Published var selectedDay: CalendarDay?
    @Published var showingDayDetail = false
    
    private let persistenceManager = PersistenceManager.shared
    private let calendar = Calendar.current
    
    init() {
        loadMonth(for: Date())
    }
    
    // MARK: - Load Month Data
    
    func loadMonth(for date: Date) {
        selectedDate = date
        
        let sessions = persistenceManager.loadSessions()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        // Get first day of month
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let firstDayOfMonth = calendar.date(from: components) else { return }
        
        // Get weekday of first day (0 = Sunday, 1 = Monday, etc.)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Get number of days in month
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let daysInMonth = range.count
        
        // Generate calendar days
        var allDays: [CalendarDay] = []
        
        // Add previous month's trailing days
        for day in (1..<firstWeekday).reversed() {
            if let prevDate = calendar.date(byAdding: .day, value: -day, to: firstDayOfMonth) {
                allDays.append(createCalendarDay(for: prevDate, isCurrentMonth: false, sessions: sessions))
            }
        }
        
        // Add current month's days
        for day in 1...daysInMonth {
            var dayComponents = components
            dayComponents.day = day
            if let dayDate = calendar.date(from: dayComponents) {
                allDays.append(createCalendarDay(for: dayDate, isCurrentMonth: true, sessions: sessions))
            }
        }
        
        // Add next month's leading days to complete the grid
        let remainingDays = (7 - (allDays.count % 7)) % 7
        for day in 1...remainingDays {
            if let nextDate = calendar.date(byAdding: .day, value: daysInMonth + day - 1, to: firstDayOfMonth) {
                allDays.append(createCalendarDay(for: nextDate, isCurrentMonth: false, sessions: sessions))
            }
        }
        
        // Group into weeks
        var weeks: [CalendarWeek] = []
        for i in stride(from: 0, to: allDays.count, by: 7) {
            let weekDays = Array(allDays[i..<min(i + 7, allDays.count)])
            weeks.append(CalendarWeek(days: weekDays))
        }
        
        // Calculate stats
        let currentMonthDays = allDays.filter { $0.isCurrentMonth }
        let totalFasts = currentMonthDays.filter { $0.fastingStatus != .none }.count
        let successfulFasts = currentMonthDays.filter { $0.fastingStatus == .completed }.count
        let currentStreak = calculateStreak(from: allDays)
        
        // Get month name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let monthName = dateFormatter.string(from: firstDayOfMonth)
        
        currentMonth = CalendarMonth(
            year: year,
            month: month,
            weeks: weeks,
            monthName: monthName,
            totalFasts: totalFasts,
            successfulFasts: successfulFasts,
            currentStreak: currentStreak
        )
    }
    
    // MARK: - Create Calendar Day
    
    private func createCalendarDay(for date: Date, isCurrentMonth: Bool, sessions: [FastingSession]) -> CalendarDay {
        let dayNumber = calendar.component(.day, from: date)
        let isToday = calendar.isDateInToday(date)
        
        // Filter sessions for this day
        let daySessions = sessions.filter { session in
            if let endDate = session.endDate {
                return calendar.isDate(endDate, inSameDayAs: date)
            }
            return false
        }
        
        // Determine fasting status
        var status: CalendarDay.FastingStatus = .none
        
        if !daySessions.isEmpty {
            let hasCompleted = daySessions.contains { $0.isCompleted }
            let hasMissed = daySessions.contains { !$0.isCompleted && $0.endDate != nil }
            
            if hasCompleted {
                status = .completed
            } else if hasMissed {
                status = .missed
            }
        }
        
        // Check for in-progress session
        let activeSessions = sessions.filter { $0.endDate == nil }
        if !activeSessions.isEmpty {
            let hasActiveToday = activeSessions.contains { calendar.isDate($0.startDate, inSameDayAs: date) }
            if hasActiveToday {
                status = .inProgress
            }
        }
        
        // Calculate total hours
        let totalHours = daySessions.reduce(0.0) { $0 + $1.actualFastingHours }
        
        return CalendarDay(
            date: date,
            dayNumber: dayNumber,
            isCurrentMonth: isCurrentMonth,
            isToday: isToday,
            fastingStatus: status,
            sessions: daySessions,
            totalHours: totalHours
        )
    }
    
    // MARK: - Calculate Streak
    
    private func calculateStreak(from days: [CalendarDay]) -> Int {
        let sortedDays = days
            .filter { $0.isCurrentMonth && $0.fastingStatus == .completed }
            .sorted { $0.date < $1.date }
        
        guard !sortedDays.isEmpty else { return 0 }
        
        var streak = 1
        var maxStreak = 1
        
        for i in 1..<sortedDays.count {
            let prevDate = sortedDays[i - 1].date
            let currentDate = sortedDays[i].date
            
            if let daysBetween = calendar.dateComponents([.day], from: prevDate, to: currentDate).day,
               daysBetween == 1 {
                streak += 1
                maxStreak = max(maxStreak, streak)
            } else {
                streak = 1
            }
        }
        
        return maxStreak
    }
    
    // MARK: - Navigation
    
    func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            loadMonth(for: newDate)
        }
    }
    
    func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            loadMonth(for: newDate)
        }
    }
    
    func goToToday() {
        loadMonth(for: Date())
    }
    
    // MARK: - Day Selection
    
    func selectDay(_ day: CalendarDay) {
        selectedDay = day
        showingDayDetail = !day.sessions.isEmpty
    }
}
