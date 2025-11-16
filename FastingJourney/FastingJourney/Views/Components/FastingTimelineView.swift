import SwiftUI

/// Single timeline entry row showing status
struct TimelineEntryRow: View {
    let entry: FastingTimelineEntry
    let status: FastingTimelineProvider.StageStatus
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(circleColor)
                        .frame(width: 20, height: 20)
                    Image(systemName: entry.systemIcon)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                }
                Rectangle()
                    .fill(lineColor)
                    .frame(width: 2)
                    .opacity(status == .locked ? 0.15 : 0.4)
            }
            .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Hour \(entry.hourFromStart)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    if status == .reached { badge("Completed", color: AppColors.success) }
                    else if status == .upcoming { badge("Soon", color: AppColors.accent) }
                }
                Text(entry.title)
                    .font(.bodyRegular)
                    .foregroundColor(AppColors.textPrimary)
                Text(entry.detail)
                    .font(.labelMedium)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var circleColor: Color {
        switch status {
        case .reached: return AppColors.primary
        case .upcoming: return AppColors.accent
        case .locked: return AppColors.textTertiary
        }
    }
    private var lineColor: Color {
        switch status {
        case .reached: return AppColors.primary
        case .upcoming: return AppColors.accent
        case .locked: return AppColors.textTertiary
        }
    }
    
    @ViewBuilder private func badge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(6)
    }
}

/// Timeline list container
struct FastingTimelineView: View {
    let entries: [FastingTimelineEntry]
    let elapsedHours: Double
    
    private var currentTip: HealthTip {
        HealthTipsProvider.shared.getCurrentTip(fastingHours: Int(elapsedHours))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fasting Timeline")
                .font(.titleMedium)
                .foregroundColor(AppColors.textPrimary)
            
            // Dynamic health tip based on current hour
            if elapsedHours > 0 {
                HStack(spacing: 12) {
                    Text(currentTip.icon)
                        .font(.system(size: 28))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentTip.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        Text(currentTip.description)
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(2)
                    }
                }
                .padding(12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.primary.opacity(0.1), AppColors.accent.opacity(0.1)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            
            VStack(spacing: 0) {
                ForEach(entries) { entry in
                    let status = FastingTimelineProvider.status(for: entry, elapsedHours: elapsedHours)
                    TimelineEntryRow(entry: entry, status: status)
                    if entry.id != entries.last?.id { Divider().opacity(0.1) }
                }
            }
            .padding(.horizontal, 4)
            
            Text("Disclaimer: Time ranges may vary from person to person. This content is not medical advice.")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
                .padding(.top, 4)
        }
        .padding(AppTypography.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppTypography.mediumRadius)
    }
}

#Preview {
    ScrollView {
        FastingTimelineView(entries: FastingTimelineProvider.stages(upto: 24), elapsedHours: 18)
            .environmentObject(FastingSessionViewModel())
    }
    .padding()
}
