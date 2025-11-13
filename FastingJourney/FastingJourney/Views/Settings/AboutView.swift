import SwiftUI

/// About and disclaimer view
struct AboutView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppTypography.large) {
                    // App Info
                    VStack(alignment: .center, spacing: 8) {
                        Image(systemName: "timer.circle.fill")
                            .font(.system(size: 48, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                        
                        Text("FastingJourney")
                            .font(.displaySmall)
                            .foregroundColor(AppColors.textPrimary)
                        
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("Version \(version)")
                                .font(.bodySmall)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(AppTypography.large)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.titleMedium)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("FastingJourney is a modern app designed to help you track popular fasting methods, monitor your progress, and achieve your health goals through intermittent fasting.")
                            .font(.bodyRegular)
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(2)
                    }
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.titleMedium)
                            .foregroundColor(AppColors.textPrimary)
                        
                        FeatureItem(
                            icon: "checkmark.circle.fill",
                            title: "Track Fasting Sessions",
                            description: "Log your fasting activities and monitor duration"
                        )
                        
                        FeatureItem(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Monitor Progress",
                            description: "See your streaks, levels, and total hours fasted"
                        )
                        
                        FeatureItem(
                            icon: "clock.arrow.circlepath",
                            title: "Multiple Plans",
                            description: "Choose from 6 popular fasting protocols"
                        )
                        
                        FeatureItem(
                            icon: "bell.fill",
                            title: "Smart Reminders",
                            description: "Get notified at the start and end of your fasting window"
                        )
                    }
                    
                    // Health Disclaimer
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.warning)
                            
                            Text("Health & Safety Disclaimer")
                                .font(.titleMedium)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("This app is for informational and motivational purposes only and does not provide medical advice.")
                                .font(.bodyRegular)
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(1.5)
                            
                            Text("Always consult a healthcare professional before starting or changing any fasting or nutrition plan. Fasting may not be suitable for everyone, including pregnant women, children, people with certain medical conditions, or those taking specific medications.")
                                .font(.bodyRegular)
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(1.5)
                            
                            Text("The app provides estimates and general information only. Results vary by individual based on diet, lifestyle, and other factors.")
                                .font(.bodyRegular)
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(1.5)
                        }
                    }
                    .padding(AppTypography.medium)
                    .background(AppColors.warning.opacity(0.1))
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    // Privacy Note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy")
                            .font(.titleMedium)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("FastingJourney stores all your data locally on your device. We do not collect, transmit, or store any personal information on external servers.")
                            .font(.bodyRegular)
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(2)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(AppTypography.large)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("About")
                    .font(.titleMedium)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primary)
                .frame(width: 24, height: 24, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.labelLarge)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
