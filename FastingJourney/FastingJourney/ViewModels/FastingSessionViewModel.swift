import Foundation

/// ViewModel for managing active fasting sessions
class FastingSessionViewModel: ObservableObject {
    @Published var activeSession: FastingSession?
    @Published var allSessions: [FastingSession] = []
    @Published var remainingTime: TimeInterval = 0
    @Published var progress: Double = 0
    @Published var endDate: Date?
    
    private var timer: Timer?
    private let persistenceManager = PersistenceManager.shared
    private let progressViewModel = ProgressViewModel()
    
    init() {
        loadSessions()
        restoreActiveSession()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Session Management
    
    func startFasting(with plan: FastingPlan) {
        let session = FastingSession(
            planId: plan.id,
            startDate: Date(),
            endDate: nil,
            isCompleted: false,
            actualFastingHours: 0
        )
        
        activeSession = session
        persistenceManager.addSession(session)
        
        // Schedule notifications if enabled
        let preferences = persistenceManager.loadPreferences()
        if preferences.enableStartReminders {
            NotificationManager.shared.scheduleStartReminder(for: plan, startDate: Date())
        }
        
        updateTimerValues()
    }
    
    func endFasting(with plan: FastingPlan) -> Bool {
        guard var session = activeSession else { return false }
        
        let endTime = Date()
        session.endDate = endTime
        session.actualFastingHours = endTime.timeIntervalSince(session.startDate) / 3600
        session.isCompleted = FastingCalculator.isFastSuccessful(session, targetHours: plan.fastingHours)
        
        persistenceManager.updateSession(session)
        activeSession = nil
        
        // Update user profile
        if session.isCompleted {
            updateUserProfile(with: session)
        }
        
        allSessions = persistenceManager.loadSessions()
        
        // Schedule end notification if enabled
        let preferences = persistenceManager.loadPreferences()
        if preferences.enableEndReminders {
            NotificationManager.shared.scheduleEndReminder(for: plan, endDate: endTime)
        }
        
        return session.isCompleted
    }
    
    func cancelFasting() {
        activeSession = nil
        stopTimer()
    }
    
    // MARK: - Loading
    
    private func loadSessions() {
        allSessions = persistenceManager.loadSessions()
    }
    
    private func restoreActiveSession() {
        // Check if there's an ongoing session from today
        let ongoingSessions = allSessions.filter { $0.endDate == nil }
        if let ongoing = ongoingSessions.first {
            activeSession = ongoing
        }
    }
    
    // MARK: - Timer Updates
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimerValues()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimerValues() {
        guard let session = activeSession,
              let activePlan = persistenceManager.loadActivePlan() else {
            remainingTime = 0
            progress = 0
            endDate = nil
            return
        }
        
        if let calc = FastingCalculator.calculateRemainingTime(
            session: session,
            targetHours: activePlan.fastingHours
        ) {
            remainingTime = calc.remaining
            endDate = calc.endDate
            progress = FastingCalculator.calculateProgress(
                session: session,
                targetHours: activePlan.fastingHours
            )
        }
    }
    
    // MARK: - Profile Updates
    
    private func updateUserProfile(with session: FastingSession) {
        var profile = persistenceManager.loadUserProfile()
        
        profile.totalCompletedFasts += 1
        profile.totalHoursFasted += session.actualFastingHours
        profile.lastFastingDate = session.endDate
        profile.level = FastingCalculator.calculateLevel(from: profile.totalCompletedFasts)
        
        // Update streaks
        let newStreak = FastingCalculator.calculateCurrentStreak(from: allSessions)
        profile.currentStreak = newStreak
        if newStreak > profile.longestStreak {
            profile.longestStreak = newStreak
        }
        
        persistenceManager.saveUserProfile(profile)
    }
    
    // MARK: - Helpers
    
    func isActive() -> Bool {
        return activeSession != nil
    }
}
