import SwiftUI

/// Empty state view for when there's no data
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var action: (() -> Void)? = nil
    var actionTitle: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .regular))
                .foregroundColor(AppColors.primary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.titleMedium)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(message)
                    .font(.bodySmall)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action = action, let actionTitle = actionTitle {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppTypography.large)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    EmptyStateView(
        icon: "calendar",
        title: "No History Yet",
        message: "Start your first fasting session to see your progress here",
        action: {},
        actionTitle: "Get Started"
    )
    .padding()
}
