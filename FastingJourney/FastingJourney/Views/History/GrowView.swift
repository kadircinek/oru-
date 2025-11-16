import SwiftUI

// Grow screen: turn completed fasts into a garden of trees
struct GrowView: View {
    @EnvironmentObject var progressViewModel: ProgressViewModel

    private var totalFasts: Int { Int(progressViewModel.userProfile.totalCompletedFasts) }
    private var treesGrown: Int { totalFasts / 15 }
    private var currentTreeProgress: Int { totalFasts % 15 }
    private var currentProgressPercent: Double { Double(currentTreeProgress) / 15.0 }
    private var fastsToNextTree: Int { max(0, 15 - currentTreeProgress) }

    private func stageEmoji(for progress: Int) -> String {
        switch progress {
        case 0: return "🌱"
        case 1...5: return "🌿"
        case 6...14: return "🌳"
        default: return "🌳"
        }
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Grow Your Garden")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Every 15 completed fasts grows one tree.")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    // Calendar Navigation Button
                    NavigationLink(destination: CalendarView()) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("View Calendar")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("See your fasting history")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Weight Tracking Navigation Button
                    NavigationLink(destination: WeightTrackingView()) {
                        HStack {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.success)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Weight Tracking")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Track your progress over time")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(16)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    
                    // Fasting Buddies Navigation Button
                    NavigationLink(destination: BuddyListView()) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Fasting Buddies")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Connect and fast together")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppColors.cardBackground,
                                            AppColors.primary.opacity(0.05)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                        )
                    }
                    .padding(.horizontal, 20)

                    // Current tree progress card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .stroke(AppColors.accentLight, lineWidth: 12)
                                    .frame(width: 90, height: 90)
                                Circle()
                                    .trim(from: 0, to: currentProgressPercent)
                                    .stroke(AppColors.primary, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 90, height: 90)
                                Text(stageEmoji(for: currentTreeProgress))
                                    .font(.system(size: 36))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Current Tree")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                Text("\(currentTreeProgress)/15 fasts")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.textSecondary)
                                Text(fastsToNextTree == 0 ? "Tree completed! 🌳" : "\(fastsToNextTree) fasts to grow a tree")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(fastsToNextTree == 0 ? AppColors.success : AppColors.primary)
                            }
                            Spacer()
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16).fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    .padding(.horizontal, 20)

                    // Garden grid
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Your Garden")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Text("\(treesGrown) trees")
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.textSecondary)
                        }

                        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Fully grown trees
                            ForEach(0..<treesGrown, id: \.self) { idx in
                                TreeTile(emoji: "🌳", title: "Tree #\(idx + 1)", subtitle: "Complete")
                            }
                            // Current slot (in progress) if not exactly multiple of 15
                            if currentTreeProgress > 0 {
                                TreeTile(emoji: stageEmoji(for: currentTreeProgress), title: "Tree #\(treesGrown + 1)", subtitle: "\(currentTreeProgress)/15")
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 20)
                }
                .padding(.vertical, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .onAppear {
            progressViewModel.refreshProfile()
        }
    }
}

private struct TreeTile: View {
    let emoji: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 36))
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12).fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 6, y: 2)
        )
    }
}

#Preview {
    GrowView()
        .environmentObject(ProgressViewModel())
}
