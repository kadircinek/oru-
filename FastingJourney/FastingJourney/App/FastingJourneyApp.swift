import SwiftUI

@main
struct FastingJourneyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var hasCompletedOnboarding = false
    @State private var isAppInitialized = false
    
    var body: some Scene {
        WindowGroup {
            if !isAppInitialized {
                ZStack {
                    AppColors.background.ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("🌱")
                            .font(.system(size: 80))
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
                            .scaleEffect(1.5)
                    }
                }
                .onAppear {
                    initializeApp()
                }
            } else {
                if authViewModel.isAuthenticated {
                    if hasCompletedOnboarding {
                        MainTabView()
                            .environmentObject(authViewModel)
                    } else {
                        OnboardingView {
                            hasCompletedOnboarding = true
                        }
                        .environmentObject(authViewModel)
                    }
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
    
    private func initializeApp() {
        // Check if onboarding was completed (only if authenticated)
        if authViewModel.isAuthenticated {
            let completed = PersistenceManager.shared.hasCompletedOnboarding()
            hasCompletedOnboarding = completed
        }
        
        // Request notification permissions
        NotificationManager.shared.requestAuthorization { _ in }
        
        isAppInitialized = true
    }
}
