import Foundation

/// Handles all persistence operations using CoreData with UserDefaults fallback
final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let defaults = UserDefaults.standard
    
    // Use lazy var to avoid initialization order issues
    private lazy var coreData: CoreDataManager = {
        return CoreDataManager.shared
    }()
    
    // Use CoreData if migration completed, otherwise use UserDefaults
    private var useCoreData: Bool {
        return UserDefaults.standard.bool(forKey: "HasMigratedToCoreData")
    }
    
    // MARK: - Keys
    private enum Keys: String {
        case activePlan = "activePlan"
        case sessions = "sessions"
        case userProfile = "userProfile"
        case preferences = "preferences"
        case hasCompletedOnboarding = "hasCompletedOnboarding"
        case hydrationToday = "hydrationToday"
        case currentUser = "currentUser"
    }
    
    // MARK: - Public Methods
    
    /// Save a codable object to UserDefaults
    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let encoded = try JSONEncoder().encode(value)
            defaults.set(encoded, forKey: key)
            defaults.synchronize()
        } catch {
            print("Failed to save \(key): \(error.localizedDescription)")
        }
    }
    
    /// Load a codable object from UserDefaults
    func load<T: Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Failed to load \(key): \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Delete all data for a key
    func delete(forKey key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    // MARK: - Active Plan
    
    func saveActivePlan(_ plan: FastingPlan) {
        save(plan, forKey: Keys.activePlan.rawValue)
    }
    
    func loadActivePlan() -> FastingPlan? {
        return load(forKey: Keys.activePlan.rawValue)
    }
    
    // MARK: - Fasting Sessions
    
    func saveSessions(_ sessions: [FastingSession]) {
        if useCoreData {
            // CoreData handles individual saves, not bulk
            // This method kept for compatibility
        } else {
            save(sessions, forKey: Keys.sessions.rawValue)
        }
    }
    
    func loadSessions() -> [FastingSession] {
        if useCoreData {
            return coreData.fetchAllSessions()
        } else {
            return load(forKey: Keys.sessions.rawValue) ?? []
        }
    }
    
    func addSession(_ session: FastingSession) {
        if useCoreData {
            coreData.saveFastingSession(session)
        } else {
            var sessions = loadSessions()
            sessions.append(session)
            saveSessions(sessions)
        }
    }
    
    func updateSession(_ session: FastingSession) {
        if useCoreData {
            coreData.updateSession(session)
        } else {
            var sessions = loadSessions()
            if let index = sessions.firstIndex(where: { $0.id == session.id }) {
                sessions[index] = session
                saveSessions(sessions)
            }
        }
    }
    
    // MARK: - User Profile
    
    func saveUserProfile(_ profile: UserProfile) {
        if useCoreData {
            coreData.saveUserProfile(profile)
        } else {
            save(profile, forKey: Keys.userProfile.rawValue)
        }
    }
    
    func loadUserProfile() -> UserProfile {
        if useCoreData {
            return coreData.fetchUserProfile() ?? UserProfile()
        } else {
            return load(forKey: Keys.userProfile.rawValue) ?? UserProfile()
        }
    }
    
    // MARK: - Preferences
    
    func savePreferences(_ preferences: AppPreferences) {
        save(preferences, forKey: Keys.preferences.rawValue)
    }
    
    func loadPreferences() -> AppPreferences {
        return load(forKey: Keys.preferences.rawValue) ?? AppPreferences()
    }
    
    // MARK: - Onboarding
    
    func markOnboardingCompleted() {
        defaults.set(true, forKey: Keys.hasCompletedOnboarding.rawValue)
        defaults.synchronize()
    }
    
    func hasCompletedOnboarding() -> Bool {
        return defaults.bool(forKey: Keys.hasCompletedOnboarding.rawValue)
    }
    
    // MARK: - Current User
    
    func getCurrentUser() -> User? {
        return load(forKey: Keys.currentUser.rawValue)
    }
    
    // MARK: - Hydration
    
    func loadTodayHydration(targetMl: Int = 2500) -> HydrationEntry {
        if useCoreData {
            if let todayEntry = coreData.fetchTodayHydration() {
                return todayEntry
            } else {
                let fresh = HydrationEntry(targetMl: targetMl)
                saveHydration(fresh)
                return fresh
            }
        } else {
            if let stored: HydrationEntry = load(forKey: Keys.hydrationToday.rawValue) {
                // If date mismatches, start new entry
                if !Calendar.current.isDate(stored.date, inSameDayAs: Date()) {
                    let fresh = HydrationEntry(targetMl: targetMl)
                    saveHydration(fresh)
                    return fresh
                }
                return stored
            } else {
                let fresh = HydrationEntry(targetMl: targetMl)
                saveHydration(fresh)
                return fresh
            }
        }
    }
    
    func saveHydration(_ entry: HydrationEntry) {
        if useCoreData {
            coreData.saveHydrationEntry(entry)
        } else {
            save(entry, forKey: Keys.hydrationToday.rawValue)
        }
    }
    
    // MARK: - Reset
    
    func resetAllData() {
        delete(forKey: Keys.activePlan.rawValue)
        delete(forKey: Keys.sessions.rawValue)
        delete(forKey: Keys.userProfile.rawValue)
        delete(forKey: Keys.preferences.rawValue)
        delete(forKey: Keys.hasCompletedOnboarding.rawValue)
        delete(forKey: Keys.hydrationToday.rawValue)
    }
}

/// User preferences for the app
struct AppPreferences: Codable {
    var enableStartReminders: Bool = true
    var enableEndReminders: Bool = true
    var enableStageNotifications: Bool = true
    var enableWaterReminders: Bool = true
    var waterReminderIntervalHours: Int = 2
    var defaultDailyWaterTargetMl: Int = 2500
    var reminderOffsetMinutes: Int = 15
    var timeFormat: TimeFormat = .twentyFour
    var theme: AppTheme = .system

    enum TimeFormat: String, Codable {
        case twelve = "12h"
        case twentyFour = "24h"
    }

    enum AppTheme: String, Codable {
        case system = "system"
        case light = "light"
        case dark = "dark"
    }

    // Backward-compatible decoding with defaults for missing keys
    init(enableStartReminders: Bool = true,
         enableEndReminders: Bool = true,
         enableStageNotifications: Bool = true,
         enableWaterReminders: Bool = true,
         waterReminderIntervalHours: Int = 2,
         defaultDailyWaterTargetMl: Int = 2500,
         reminderOffsetMinutes: Int = 15,
         timeFormat: TimeFormat = .twentyFour,
         theme: AppTheme = .system) {
        self.enableStartReminders = enableStartReminders
        self.enableEndReminders = enableEndReminders
        self.enableStageNotifications = enableStageNotifications
        self.enableWaterReminders = enableWaterReminders
        self.waterReminderIntervalHours = waterReminderIntervalHours
        self.defaultDailyWaterTargetMl = defaultDailyWaterTargetMl
        self.reminderOffsetMinutes = reminderOffsetMinutes
        self.timeFormat = timeFormat
        self.theme = theme
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.enableStartReminders = try c.decodeIfPresent(Bool.self, forKey: .enableStartReminders) ?? true
        self.enableEndReminders = try c.decodeIfPresent(Bool.self, forKey: .enableEndReminders) ?? true
        self.enableStageNotifications = try c.decodeIfPresent(Bool.self, forKey: .enableStageNotifications) ?? true
        self.enableWaterReminders = try c.decodeIfPresent(Bool.self, forKey: .enableWaterReminders) ?? true
        self.waterReminderIntervalHours = try c.decodeIfPresent(Int.self, forKey: .waterReminderIntervalHours) ?? 2
        self.defaultDailyWaterTargetMl = try c.decodeIfPresent(Int.self, forKey: .defaultDailyWaterTargetMl) ?? 2500
        self.reminderOffsetMinutes = try c.decodeIfPresent(Int.self, forKey: .reminderOffsetMinutes) ?? 15
        self.timeFormat = try c.decodeIfPresent(TimeFormat.self, forKey: .timeFormat) ?? .twentyFour
        self.theme = try c.decodeIfPresent(AppTheme.self, forKey: .theme) ?? .system
    }
}
