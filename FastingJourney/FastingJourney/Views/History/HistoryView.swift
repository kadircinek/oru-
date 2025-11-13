import SwiftUI

/// View showing fasting history
struct HistoryView: View {
    @EnvironmentObject var viewModel: FastingSessionViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.allSessions.isEmpty {
                EmptyStateView(
                    icon: "calendar.badge.clock",
                    title: "No Fasting History",
                    message: "Start your first fasting session to see your history here",
                    action: { dismiss() },
                    actionTitle: "Go Home"
                )
            } else {
                VStack(spacing: 0) {
                    // Summary
                    VStack(alignment: .leading, spacing: 12) {
                        let last7Days = viewModel.allSessions.filter { session in
                            let daysSince = Date().timeIntervalSince(session.endDate ?? session.startDate) / 86400
                            return daysSince <= 7
                        }
                        
                        let completedLast7 = last7Days.filter { $0.isCompleted }.count
                        let avgDuration = last7Days.filter { $0.isCompleted }
                            .reduce(0) { $0 + $1.actualFastingHours } / Double(max(1, last7Days.filter { $0.isCompleted }.count))
                        
                        HStack(spacing: 16) {
                            StatCardView(
                                icon: "checkmark.circle.fill",
                                value: "\(completedLast7)",
                                label: "Last 7 Days",
                                unit: "completed"
                            )
                            
                            StatCardView(
                                icon: "hourglass",
                                value: String(format: "%.1f", avgDuration),
                                label: "Avg Duration",
                                unit: "hours"
                            )
                        }
                        .padding(.horizontal, AppTypography.large)
                        .padding(.vertical, AppTypography.large)
                    }
                    
                    Divider()
                        .padding(.horizontal, AppTypography.large)
                    
                    // Sessions List
                    ScrollView {
                        VStack(spacing: AppTypography.medium) {
                            let sortedSessions = viewModel.allSessions
                                .sorted { ($0.endDate ?? $0.startDate) > ($1.endDate ?? $1.startDate) }
                            
                            ForEach(sortedSessions) { session in
                                NavigationLink(destination: HistoryDetailView(session: session)) {
                                    HistorySessionRow(session: session)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        .padding(AppTypography.large)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("History")
                    .font(.titleMedium)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct HistorySessionRow: View {
    let session: FastingSession
    
    var body: some View {
        HStack(spacing: 12) {
            // Status Icon
            Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(session.isCompleted ? AppColors.success : AppColors.error)
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(session.startDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.labelMedium)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("–")
                        .foregroundColor(AppColors.textSecondary)
                    
                    if let endDate = session.endDate {
                        Text(endDate.formatted(date: .omitted, time: .shortened))
                            .font(.labelMedium)
                            .foregroundColor(AppColors.textSecondary)
                    } else {
                        Text("Ongoing")
                            .font(.labelMedium)
                            .foregroundColor(AppColors.warning)
                    }
                }
                
                Text(String(format: "%.1f hours", session.actualFastingHours))
                    .font(.bodySmall)
                    .foregroundColor(AppColors.textPrimary)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppTypography.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppTypography.mediumRadius)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
            .environmentObject(FastingSessionViewModel())
    }
}
