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
    private var notifiedStageHours: Set<Int> = []
    
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
        notifiedStageHours = []
        NotificationManager.shared.requestAuthorization { _ in }
        
        let sessionKey = sessionKey(for: session)
        let userProfile = persistenceManager.loadUserProfile()
        let preferences = userProfile.notificationPreferences
        
        // Schedule custom reminders based on user preferences
        if !preferences.customReminderTimes.isEmpty {
            NotificationManager.shared.scheduleCustomReminders(
                sessionKey: sessionKey,
                startDate: session.startDate,
                reminderHours: preferences.customReminderTimes,
                preferences: preferences
            )
        }
        
        // Schedule "Nearly Done" countdown notifications
        if let fastingHours = plan.fastingHours, preferences.enableNearlyDoneCountdown {
            let endDate = session.startDate.addingTimeInterval(TimeInterval(fastingHours * 3600))
            NotificationManager.shared.scheduleNearlyDoneCountdown(
                sessionKey: sessionKey,
                endDate: endDate,
                preferences: preferences
            )
        }
        
        // Schedule health tip reminders
        if let fastingHours = plan.fastingHours {
            NotificationManager.shared.scheduleHealthTipReminders(sessionKey: sessionKey, fastingHours: fastingHours)
        }
        
        // Schedule calorie burn notifications (if user has metrics)
        if let user = persistenceManager.getCurrentUser(),
           user.weight != nil && user.height != nil && user.age != nil && user.gender != nil,
           let fastingHours = plan.fastingHours {
            NotificationManager.shared.scheduleCalorieBurnNotifications(
                sessionKey: sessionKey,
                user: user,
                startDate: session.startDate,
                fastingHours: fastingHours
            )
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
        if let session = activeSession {
            let key = sessionKey(for: session)
            NotificationManager.shared.cancelHealthTipNotifications(sessionKey: key)
            NotificationManager.shared.cancelCalorieBurnNotifications(sessionKey: key)
            NotificationManager.shared.cancelCustomNotifications(sessionKey: key)
        }
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
            loadNotifiedStages()
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
            
            // Check if fasting is complete
            if remainingTime <= 0 && progress >= 100 {
                handleFastingCompletion(session: session, plan: activePlan)
                return
            }
        }

        // Stage notifications
        let preferences = persistenceManager.loadPreferences()
        if preferences.enableStageNotifications {
            let elapsed = elapsedHours
            let stages = FastingTimelineProvider.stages(upto: activePlan.fastingHours)
            for entry in stages {
                if elapsed >= Double(entry.hourFromStart), !notifiedStageHours.contains(entry.hourFromStart) {
                    notifiedStageHours.insert(entry.hourFromStart)
                    saveNotifiedStages()
                    let key = sessionKey(for: session)
                    NotificationManager.shared.scheduleStageReached(
                        sessionKey: key,
                        hour: entry.hourFromStart,
                        title: entry.title,
                        detail: entry.detail + " – Böyle devam!"
                    )
                }
            }
        }
    }
    
    private func handleFastingCompletion(session: FastingSession, plan: FastingPlan) {
        // Auto-complete the session
        var completedSession = session
        completedSession.endDate = Date()
        completedSession.actualFastingHours = Date().timeIntervalSince(session.startDate) / 3600
        completedSession.isCompleted = true
        
        persistenceManager.updateSession(completedSession)
        updateUserProfile(with: completedSession)
        
        // Send completion notification
        NotificationManager.shared.scheduleFastingCompletion(
            planName: plan.name,
            hours: Int(completedSession.actualFastingHours)
        )
        
        // Reset active session
        activeSession = nil
        remainingTime = 0
        progress = 100
        endDate = nil
        stopTimer()
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
    
    // Elapsed hours since the current fasting session started.
    var elapsedHours: Double {
        guard let session = activeSession else { return 0 }
        return Date().timeIntervalSince(session.startDate) / 3600.0
    }

    // MARK: - Stage Notification Persistence (per session)
    private func sessionKey(for session: FastingSession) -> String {
        String(format: "%.0f", session.startDate.timeIntervalSince1970)
    }
    private func notifiedStagesDefaultsKey(for session: FastingSession) -> String {
        "notifiedStages_" + sessionKey(for: session)
    }
    private func loadNotifiedStages() {
        guard let session = activeSession else { return }
        let key = notifiedStagesDefaultsKey(for: session)
        if let arr = UserDefaults.standard.array(forKey: key) as? [Int] {
            notifiedStageHours = Set(arr)
        }
    }
    private func saveNotifiedStages() {
        guard let session = activeSession else { return }
        let key = notifiedStagesDefaultsKey(for: session)
        UserDefaults.standard.set(Array(notifiedStageHours), forKey: key)
    }
}
