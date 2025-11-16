import SwiftUI
import Charts

/// Weight tracking main view with graph and statistics
struct WeightTrackingView: View {
    @StateObject private var viewModel = WeightTrackingViewModel()
    @State private var showingAddEntry = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Stats Cards
                statsSection
                
                // MARK: - Weight Chart
                chartSection
                
                // MARK: - Quick Actions
                quickActionsSection
                
                // MARK: - Recent Entries
                entriesSection
                
                Spacer(minLength: 20)
            }
            .padding(.vertical, 16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Weight Tracking")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddEntry = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddWeightEntryView(viewModel: viewModel)
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Current",
                    value: String(format: "%.1f", viewModel.stats.currentWeight ?? 0),
                    unit: viewModel.preferredUnit.symbol,
                    icon: "scalemass.fill",
                    color: AppColors.primary
                )
                
                StatCard(
                    title: "Total Loss",
                    value: String(format: "%.1f", abs(viewModel.stats.totalLoss)),
                    unit: viewModel.preferredUnit.symbol,
                    icon: viewModel.stats.totalLoss >= 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill",
                    color: viewModel.stats.totalLoss >= 0 ? AppColors.success : AppColors.error
                )
            }
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Weekly Avg",
                    value: String(format: "%.2f", abs(viewModel.stats.averageWeeklyLoss)),
                    unit: "\(viewModel.preferredUnit.symbol)/week",
                    icon: "chart.line.uptrend.xyaxis",
                    color: AppColors.orange
                )
                
                StatCard(
                    title: "Progress",
                    value: String(format: "%.1f", abs(viewModel.stats.progressPercentage)),
                    unit: "%",
                    icon: "percent",
                    color: AppColors.blue
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weight Progress")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                // Time range picker
                Menu {
                    ForEach(WeightTrackingViewModel.TimeRange.allCases, id: \.self) { range in
                        Button(range.rawValue) {
                            viewModel.selectedTimeRange = range
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedTimeRange.rawValue)
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.primary.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            if viewModel.entries.isEmpty {
                emptyChartPlaceholder
            } else {
                weightChart
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
        .padding(.horizontal, 20)
    }
    
    private var emptyChartPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 48))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text("No weight data yet")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            
            Text("Add your first weight entry to see your progress")
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var weightChart: some View {
        let chartData = viewModel.getChartData()
        
        if #available(iOS 16.0, *) {
            Chart {
                ForEach(chartData, id: \.date) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Weight", item.weight)
                    )
                    .foregroundStyle(AppColors.primary)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("Weight", item.weight)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primary.opacity(0.3), AppColors.primary.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5))
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 200)
        } else {
            // Fallback for iOS 15
            Text("Chart requires iOS 16+")
                .foregroundColor(AppColors.textSecondary)
                .frame(height: 200)
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        HStack(spacing: 12) {
            QuickActionButton(
                icon: "chart.bar.fill",
                title: "Fasting Stats",
                color: AppColors.orange
            ) {
                // TODO: Show correlation between fasting and weight
            }
            
            QuickActionButton(
                icon: "gearshape.fill",
                title: "Unit",
                color: AppColors.blue
            ) {
                let newUnit: WeightEntry.WeightUnit = viewModel.preferredUnit == .kg ? .lbs : .kg
                viewModel.setPreferredUnit(newUnit)
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Entries Section
    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Entries")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(viewModel.entries.count) total")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            if viewModel.entries.isEmpty {
                emptyEntriesPlaceholder
            } else {
                ForEach(viewModel.entries.prefix(10)) { entry in
                    WeightEntryRow(entry: entry, unit: viewModel.preferredUnit)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
        .padding(.horizontal, 20)
    }
    
    private var emptyEntriesPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 36))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text("No entries yet")
                .font(.system(size: 15))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
            
            Text(unit)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        )
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
            )
        }
    }
}

struct WeightEntryRow: View {
    let entry: WeightEntry
    let unit: WeightEntry.WeightUnit
    
    var body: some View {
        HStack(spacing: 12) {
            // Date
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                Text(entry.date.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            // Weight
            HStack(spacing: 4) {
                Text(String(format: "%.1f", entry.weightIn(unit)))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primary)
                Text(unit.symbol)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        WeightTrackingView()
    }
}
