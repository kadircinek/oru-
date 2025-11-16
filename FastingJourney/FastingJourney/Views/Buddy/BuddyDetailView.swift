import SwiftUI

/// Buddy detail view with stats and actions
struct BuddyDetailView: View {
    let buddy: FastingBuddy
    @ObservedObject var viewModel: BuddyViewModel
    @State private var showingStartSession = false
    @State private var showingRemoveConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                profileHeader
                
                // Stats
                statsSection
                
                // Actions
                actionsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(buddy.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingStartSession) {
            StartSessionView(buddy: buddy, viewModel: viewModel)
        }
        .alert("Remove Buddy", isPresented: $showingRemoveConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                viewModel.removeBuddy(buddy)
            }
        } message: {
            Text("Are you sure you want to remove \(buddy.name) from your buddies?")
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            Text(buddy.profileEmoji)
                .font(.system(size: 80))
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                )
            
            VStack(spacing: 8) {
                Text(buddy.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 10, height: 10)
                    
                    Text(buddy.status.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                if let plan = buddy.currentPlan {
                    Text("Current Plan: \(plan)")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(AppColors.primary.opacity(0.1))
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
    }
    
    private var statsSection: some View {
        let stats = viewModel.getBuddyStats(buddy)
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatBox(title: "Sessions", value: "\(stats.totalSessions)", icon: "calendar")
                StatBox(title: "Completed", value: "\(stats.completedSessions)", icon: "checkmark.circle.fill")
                StatBox(title: "Success Rate", value: "\(Int(stats.successRate * 100))%", icon: "chart.line.uptrend.xyaxis")
                StatBox(title: "Streak", value: "\(stats.currentStreak)", icon: "flame.fill")
            }
        }
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button {
                showingStartSession = true
            } label: {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 20))
                    Text("Start Session Together")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppColors.primary)
                )
            }
            
            Button {
                showingRemoveConfirmation = true
            } label: {
                HStack {
                    Image(systemName: "person.fill.xmark")
                        .font(.system(size: 18))
                    Text("Remove Buddy")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1.5)
                )
            }
        }
    }
    
    private var statusColor: Color {
        switch buddy.status {
        case .fasting: return AppColors.primary
        case .eating: return AppColors.success
        case .offline: return AppColors.textSecondary
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primary)
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
        )
    }
}
