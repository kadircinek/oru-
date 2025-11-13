import Foundation

/// ViewModel for app settings and preferences
class SettingsViewModel: ObservableObject {
    @Published var preferences: AppPreferences = AppPreferences()
    @Published var showResetConfirmation: Bool = false
    @Published var appVersion: String = "1.0"
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadPreferences()
        loadAppVersion()
    }
    
    // MARK: - Loading
    
    private func loadPreferences() {
        preferences = persistenceManager.loadPreferences()
    }
    
    private func loadAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
    }
    
    // MARK: - Preference Updates
    
    func updateStartReminders(_ enabled: Bool) {
        preferences.enableStartReminders = enabled
        savePreferences()
    }
    
    func updateEndReminders(_ enabled: Bool) {
        preferences.enableEndReminders = enabled
        savePreferences()
    }
    
    func updateReminderOffset(_ minutes: Int) {
        preferences.reminderOffsetMinutes = minutes
        savePreferences()
    }
    
    func updateTimeFormat(_ format: AppPreferences.TimeFormat) {
        preferences.timeFormat = format
        savePreferences()
    }
    
    func updateTheme(_ theme: AppPreferences.AppTheme) {
        preferences.theme = theme
        savePreferences()
    }
    
    private func savePreferences() {
        persistenceManager.savePreferences(preferences)
    }
    
    // MARK: - Data Management
    
    func resetAllData() {
        persistenceManager.resetAllData()
        preferences = AppPreferences()
        NotificationManager.shared.cancelAllNotifications()
    }
    
    // MARK: - Helpers
    
    func getTimeFormatDisplay() -> String {
        switch preferences.timeFormat {
        case .twelve:
            return "12-Hour"
        case .twentyFour:
            return "24-Hour"
        }
    }
    
    func getThemeDisplay() -> String {
        switch preferences.theme {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
