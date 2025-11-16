import Foundation
import UserNotifications

/// ViewModel for daily hydration tracking & water reminders
class HydrationViewModel: ObservableObject {
    @Published private(set) var entry: HydrationEntry
    @Published var nextReminderDate: Date?
    
    private let persistence = PersistenceManager.shared
    private var timer: Timer?
    
    init() {
        let prefs = persistence.loadPreferences()
        entry = persistence.loadTodayHydration(targetMl: prefs.defaultDailyWaterTargetMl)
        scheduleInitialReminderIfNeeded()
        startTimer()
    }
    
    deinit { timer?.invalidate() }
    
    // MARK: - Public API
    var progress: Double { entry.progress }
    var consumedMl: Int { entry.consumedMl }
    var targetMl: Int { entry.targetMl }
    
    func addWater(amount: Int) {
        entry.consumedMl += amount
        entry.events.append(HydrationEvent(timestamp: Date(), amountMl: amount))
        persistence.saveHydration(entry)
        
        // Show encouragement notification
        let remaining = max(entry.targetMl - entry.consumedMl, 0)
        NotificationManager.shared.scheduleWaterEncouragement(remainingMl: remaining)
        
        if entry.consumedMl >= entry.targetMl { 
            cancelPendingWaterReminders() 
        } else {
            // Reschedule smart reminder
            let prefs = persistence.loadPreferences()
            scheduleSmartReminder(intervalMinutes: prefs.waterReminderIntervalHours * 60)
        }
    }
    
    func updateTarget(_ newTarget: Int) {
        entry.targetMl = newTarget
        persistence.saveHydration(entry)
    }
    
    // MARK: - Reminder Scheduling
    private func scheduleInitialReminderIfNeeded() {
        let prefs = persistence.loadPreferences()
        guard prefs.enableWaterReminders else { return }
        if nextReminderDate == nil {
            scheduleSmartReminder(intervalMinutes: prefs.waterReminderIntervalHours * 60)
        }
    }
    
    private func scheduleSmartReminder(intervalMinutes: Int) {
        guard entry.consumedMl < entry.targetMl else { return }
        let fireDate = Date().addingTimeInterval(Double(intervalMinutes) * 60)
        nextReminderDate = fireDate
        
        NotificationManager.shared.scheduleSmartWaterReminder(
            intervalMinutes: intervalMinutes,
            consumedMl: entry.consumedMl,
            targetMl: entry.targetMl
        )
    }
    
    // Legacy method for backward compatibility
    private func scheduleNextReminder(intervalHours: Int) {
        scheduleSmartReminder(intervalMinutes: intervalHours * 60)
    }
    
    private func cancelPendingWaterReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Timer Loop
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func tick() {
        // Day rollover
        if !Calendar.current.isDate(entry.date, inSameDayAs: Date()) {
            let prefs = persistence.loadPreferences()
            entry = HydrationEntry(targetMl: prefs.defaultDailyWaterTargetMl)
            persistence.saveHydration(entry)
            scheduleInitialReminderIfNeeded()
        }
        // Schedule next reminder if passed
        if let next = nextReminderDate, Date() >= next {
            let prefs = persistence.loadPreferences()
            scheduleSmartReminder(intervalMinutes: prefs.waterReminderIntervalHours * 60)
        }
    }
}
