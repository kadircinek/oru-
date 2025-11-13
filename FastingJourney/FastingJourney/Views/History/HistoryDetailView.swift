import SwiftUI

/// Detailed view of a fasting session
struct HistoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    let session: FastingSession
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppTypography.large) {
                    // Status Card
                    HStack(spacing: 12) {
                        Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(session.isCompleted ? AppColors.success : AppColors.error)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(session.isCompleted ? "Completed" : "Incomplete")
                                .font(.titleMedium)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(session.startDate.formatted(date: .abbreviated, time: .shortened))
                                .font(.bodySmall)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(AppTypography.medium)
                    .background(session.isCompleted ?
                        AppColors.success.opacity(0.1) :
                        AppColors.error.opacity(0.1))
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    // Session Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Session Details")
                            .font(.titleMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                        
                        DetailRow(
                            icon: "calendar",
                            label: "Start Time",
                            value: session.startDate.formatted(date: .abbreviated, time: .shortened)
                        )
                        
                        if let endDate = session.endDate {
                            DetailRow(
                                icon: "calendar",
                                label: "End Time",
                                value: endDate.formatted(date: .abbreviated, time: .shortened)
                            )
                        }
                        
                        DetailRow(
                            icon: "hourglass",
                            label: "Duration",
                            value: String(format: "%.2f hours", session.actualFastingHours)
                        )
                        
                        let minutes = Int(session.actualFastingHours * 60)
                        DetailRow(
                            icon: "timer",
                            label: "Duration (minutes)",
                            value: "\(minutes) min"
                        )
                    }
                    .padding(AppTypography.medium)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    // Statistics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Statistics")
                            .font(.titleMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                        
                        let hoursPerDay = session.actualFastingHours
                        let caloriesSaved = Int(hoursPerDay * 125) // Rough estimate
                        
                        StatCardView(
                            icon: "flame.fill",
                            value: String(format: "%.1f", hoursPerDay),
                            label: "Hours Fasted",
                            unit: "hours"
                        )
                        
                        StatCardView(
                            icon: "bolt.fill",
                            value: "\(caloriesSaved)",
                            label: "Estimated Calories Saved",
                            unit: "kcal"
                        )
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(AppTypography.large)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Session Details")
                    .font(.titleMedium)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    let sampleSession = FastingSession(
        planId: UUID(),
        startDate: Date().addingTimeInterval(-14400),
        endDate: Date(),
        isCompleted: true,
        actualFastingHours: 16
    )
    
    NavigationStack {
        HistoryDetailView(session: sampleSession)
    }
}
