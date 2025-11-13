import Foundation

/// ViewModel for progress tracking and level calculations
class ProgressViewModel: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile()
    @Published var currentLevelName: String = "Beginner"
    @Published var fastsToNextLevel: Int = 5
    @Published var levelProgress: Double = 0
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadUserProfile()
        updateLevelInfo()
    }
    
    // MARK: - Loading
    
    func loadUserProfile() {
        userProfile = persistenceManager.loadUserProfile()
    }
    
    // MARK: - Level Information
    
    func updateLevelInfo() {
        userProfile = persistenceManager.loadUserProfile()
        currentLevelName = FastingCalculator.levelName(for: userProfile.level)
        fastsToNextLevel = FastingCalculator.fastsNeededForNextLevel(userProfile.totalCompletedFasts)
        calculateLevelProgress()
    }
    
    private func calculateLevelProgress() {
        let thresholds = [0, 5, 15, 30]
        
        if userProfile.level == 4 {
            levelProgress = 1.0 // Max level
            return
        }
        
        let currentThreshold = thresholds[userProfile.level - 1]
        let nextThreshold = thresholds[userProfile.level]
        let progress = Double(userProfile.totalCompletedFasts - currentThreshold) /
                       Double(nextThreshold - currentThreshold)
        
        levelProgress = min(1.0, max(0.0, progress))
    }
    
    // MARK: - Statistics
    
    func getStatistics() -> [StatItem] {
        return [
            StatItem(
                label: "Current Streak",
                value: "\(userProfile.currentStreak)",
                unit: "days",
                icon: "flame.fill"
            ),
            StatItem(
                label: "Longest Streak",
                value: "\(userProfile.longestStreak)",
                unit: "days",
                icon: "star.fill"
            ),
            StatItem(
                label: "Completed Fasts",
                value: "\(userProfile.totalCompletedFasts)",
                unit: "total",
                icon: "checkmark.circle.fill"
            ),
            StatItem(
                label: "Hours Fasted",
                value: String(format: "%.0f", userProfile.totalHoursFasted),
                unit: "hours",
                icon: "hourglass.fill"
            )
        ]
    }
    
    // MARK: - Updates
    
    func refreshProfile() {
        loadUserProfile()
        updateLevelInfo()
    }
}

struct StatItem {
    let label: String
    let value: String
    let unit: String
    let icon: String
}
