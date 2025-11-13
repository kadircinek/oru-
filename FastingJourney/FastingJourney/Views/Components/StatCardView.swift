import SwiftUI

/// Card displaying a statistic
struct StatCardView: View {
    let icon: String
    let value: String
    let label: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headlineMedium)
                    .foregroundColor(AppColors.textPrimary)
                
                HStack(spacing: 4) {
                    Text(label)
                        .font(.captionMedium)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTypography.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppTypography.mediumRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack {
        StatCardView(icon: "flame.fill", value: "7", label: "Current Streak", unit: "days")
        StatCardView(icon: "star.fill", value: "12", label: "Longest Streak", unit: "days")
    }
    .padding()
}
