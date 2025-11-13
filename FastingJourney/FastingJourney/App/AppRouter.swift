import SwiftUI

/// App routing and navigation logic
struct AppRouter {
    /// Determines the root view based on app state
    static func getRootView(hasCompletedOnboarding: Bool) -> AnyView {
        if hasCompletedOnboarding {
            return AnyView(MainTabView())
        } else {
            return AnyView(OnboardingView(onComplete: {}))
        }
    }
}
