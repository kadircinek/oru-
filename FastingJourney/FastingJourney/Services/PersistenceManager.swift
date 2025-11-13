import Foundation

/// Handles all persistence operations using UserDefaults
final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys: String {
        case activePlan = "activePlan"
        case sessions = "sessions"
        case userProfile = "userProfile"
        case preferences = "preferences"
        case hasCompletedOnboarding = "hasCompletedOnboarding"
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
        save(sessions, forKey: Keys.sessions.rawValue)
    }
    
    func loadSessions() -> [FastingSession] {
        return load(forKey: Keys.sessions.rawValue) ?? []
    }
    
    func addSession(_ session: FastingSession) {
        var sessions = loadSessions()
        sessions.append(session)
        saveSessions(sessions)
    }
    
    func updateSession(_ session: FastingSession) {
        var sessions = loadSessions()
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            saveSessions(sessions)
        }
    }
    
    // MARK: - User Profile
    
    func saveUserProfile(_ profile: UserProfile) {
        save(profile, forKey: Keys.userProfile.rawValue)
    }
    
    func loadUserProfile() -> UserProfile {
        return load(forKey: Keys.userProfile.rawValue) ?? UserProfile()
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
    
    // MARK: - Reset
    
    func resetAllData() {
        delete(forKey: Keys.activePlan.rawValue)
        delete(forKey: Keys.sessions.rawValue)
        delete(forKey: Keys.userProfile.rawValue)
        delete(forKey: Keys.preferences.rawValue)
        delete(forKey: Keys.hasCompletedOnboarding.rawValue)
    }
}

/// User preferences for the app
struct AppPreferences: Codable {
    var enableStartReminders: Bool = true
    var enableEndReminders: Bool = true
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
}
