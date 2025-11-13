import SwiftUI

@main
struct FastingJourneyApp: App {
    @State private var hasCompletedOnboarding = false
    @State private var isAppInitialized = false
    
    var body: some Scene {
        WindowGroup {
            if !isAppInitialized {
                Color.clear.onAppear {
                    initializeApp()
                }
            } else if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
    }
    
    private func initializeApp() {
        // Check if onboarding was completed
        let completed = PersistenceManager.shared.hasCompletedOnboarding()
        hasCompletedOnboarding = completed
        
        // Request notification permissions
        NotificationManager.shared.requestAuthorization { _ in }
        
        isAppInitialized = true
    }
}
