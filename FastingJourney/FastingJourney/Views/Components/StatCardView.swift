import SwiftUI

/// Card displaying a statistic
struct StatCardView: View {
    let icon: String
    let value: String
    let label: String
    let unit: String
    
    private var emojiIcon: String {
        switch label.lowercased() {
        case let str where str.contains("fast"):
            return "🎯"
        case let str where str.contains("streak") || str.contains("seri"):
            return "🔥"
        case let str where str.contains("avg") || str.contains("ort"):
            return "⚡"
        case let str where str.contains("total") || str.contains("toplam"):
            return "💪"
        default:
            return "✨"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(emojiIcon)
                    .font(.system(size: 24))
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTypography.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTypography.mediumRadius)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
