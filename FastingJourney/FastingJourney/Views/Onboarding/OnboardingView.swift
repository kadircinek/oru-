import SwiftUI

/// Onboarding screen shown on first launch
struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background - Nature Green Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.3, green: 0.65, blue: 0.4).opacity(0.1),
                    Color(red: 0.45, green: 0.75, blue: 0.5).opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Hero Icon
                    Image(systemName: "timer.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(AppColors.primary)
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Track Your Fasting Journey")
                            .font(.displaySmall)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Discover popular fasting methods and watch your progress grow")
                            .font(.bodyRegular)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // Feature Cards
                    VStack(spacing: 12) {
                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Track Progress",
                            description: "See your fasting stats and level up"
                        )
                        
                        FeatureCard(
                            icon: "clock.fill",
                            title: "Popular Methods",
                            description: "Choose from 6 proven fasting protocols"
                        )
                        
                        FeatureCard(
                            icon: "flame.fill",
                            title: "Build Streaks",
                            description: "Maintain consistency and earn rewards"
                        )
                    }
                    
                    Spacer()
                    
                    // CTA Button
                    PrimaryButton(title: "Get Started") {
                        PersistenceManager.shared.markOnboardingCompleted()
                        onComplete()
                    }
                }
                .padding(AppTypography.large)
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.primary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.titleSmall)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppTypography.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppTypography.mediumRadius)
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
