import SwiftUI

/// Analytics and Insights view
struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Analytics")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Track your fasting journey")
                            .font(.system(size: 15))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // MARK: - Period Selector
                    PeriodSelector(selectedPeriod: $viewModel.selectedPeriod)
                        .padding(.horizontal, 20)
                    
                    if let data = viewModel.analyticsData {
                        
                        // MARK: - Key Stats Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            
                            AnalyticsStatCard(
                                title: "Total Fasts",
                                value: "\(data.totalFasts)",
                                subtitle: "Completed sessions",
                                icon: "checkmark.circle.fill",
                                color: AppColors.primary
                            )
                            
                            AnalyticsStatCard(
                                title: "Success Rate",
                                value: viewModel.formattedSuccessRate(),
                                subtitle: "Completion rate",
                                icon: "chart.line.uptrend.xyaxis",
                                color: .green
                            )
                            
                            AnalyticsStatCard(
                                title: "Total Hours",
                                value: viewModel.formattedTotalHours(),
                                subtitle: "Lifetime fasting",
                                icon: "hourglass.fill",
                                color: .orange
                            )
                            
                            AnalyticsStatCard(
                                title: "Average",
                                value: "\(viewModel.formattedAverageHours())h",
                                subtitle: "Per fasting session",
                                icon: "chart.bar.fill",
                                color: .blue
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Weekly Chart
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                
                                Text("Weekly Overview")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            if !data.weeklyData.isEmpty {
                                let chartData = data.weeklyData.map { ($0.day, $0.hours) }
                                let maxValue = data.weeklyData.map { $0.hours }.max() ?? 1
                                
                                SimpleBarChart(
                                    data: chartData,
                                    maxValue: maxValue,
                                    color: AppColors.primary
                                )
                                .padding(.vertical, 8)
                            } else {
                                Text("No data available for this week")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 40)
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // MARK: - Streak Information
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.orange)
                                
                                Text("Streaks")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            HStack(spacing: 16) {
                                // Current Streak
                                VStack(spacing: 8) {
                                    Text("\(data.currentStreak)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    Text("Current Streak")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppColors.background)
                                .cornerRadius(12)
                                
                                // Best Streak
                                VStack(spacing: 8) {
                                    Text("\(data.bestStreak)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.orange)
                                    
                                    Text("Best Streak")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppColors.background)
                                .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // MARK: - Personal Records
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.yellow)
                                
                                Text("Personal Records")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            VStack(spacing: 12) {
                                RecordRow(
                                    title: "Longest Fast",
                                    value: "\(viewModel.formattedLongestFast()) hours",
                                    icon: "trophy.fill",
                                    color: .yellow
                                )
                                
                                RecordRow(
                                    title: "Total Fasted",
                                    value: "\(viewModel.formattedTotalHours()) hours",
                                    icon: "clock.fill",
                                    color: AppColors.primary
                                )
                                
                                RecordRow(
                                    title: "Best Streak",
                                    value: "\(data.bestStreak) days",
                                    icon: "flame.fill",
                                    color: .orange
                                )
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                    } else {
                        ProgressView()
                            .padding(.top, 100)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.loadAnalytics()
        }
    }
}

// MARK: - Record Row Component
struct RecordRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(12)
        .background(AppColors.background)
        .cornerRadius(10)
    }
}

#Preview {
    AnalyticsView()
}
