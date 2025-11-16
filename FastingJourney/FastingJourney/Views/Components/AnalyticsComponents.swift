import SwiftUI

/// Simple bar chart for weekly/monthly data
struct SimpleBarChart: View {
    let data: [(String, Double)]
    let maxValue: Double
    let color: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 4) {
                    // Bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.8))
                        .frame(width: 35, height: barHeight(for: item.1))
                    
                    // Value
                    Text(String(format: "%.0f", item.1))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    // Label
                    Text(item.0)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func barHeight(for value: Double) -> CGFloat {
        let maxHeight: CGFloat = 120
        guard maxValue > 0 else { return 0 }
        return CGFloat(value / maxValue) * maxHeight
    }
}

/// Stat card for analytics
struct AnalyticsStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

/// Period selector
struct PeriodSelector: View {
    @Binding var selectedPeriod: AnalyticsPeriod
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(selectedPeriod == period ? .white : AppColors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedPeriod == period ? AppColors.primary : AppColors.cardBackground)
                        .cornerRadius(8)
                }
            }
        }
    }
}
