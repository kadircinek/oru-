import SwiftUI

/// Calendar view showing monthly fasting history
struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header with Month Navigation
                    HStack {
                        Button(action: viewModel.previousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text(viewModel.currentMonth?.monthName ?? "")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Button(action: viewModel.goToToday) {
                                Text("Today")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: viewModel.nextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    if let month = viewModel.currentMonth {
                        
                        // MARK: - Month Stats
                        HStack(spacing: 12) {
                            StatPill(
                                label: "Fasts",
                                value: "\(month.successfulFasts)",
                                color: .green
                            )
                            
                            StatPill(
                                label: "Success",
                                value: String(format: "%.0f%%", month.successRate),
                                color: AppColors.primary
                            )
                            
                            StatPill(
                                label: "Streak",
                                value: "\(month.currentStreak)",
                                color: .orange
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Weekday Headers
                        HStack(spacing: 0) {
                            ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // MARK: - Calendar Grid
                        VStack(spacing: 8) {
                            ForEach(month.weeks) { week in
                                HStack(spacing: 8) {
                                    ForEach(week.days) { day in
                                        CalendarDayCell(day: day)
                                            .onTapGesture {
                                                viewModel.selectDay(day)
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Legend
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Legend")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 16) {
                                LegendItem(color: .green, label: "Completed")
                                LegendItem(color: .blue, label: "In Progress")
                                LegendItem(color: .red, label: "Missed")
                                LegendItem(color: .gray, label: "No Fast")
                            }
                        }
                        .padding(16)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $viewModel.showingDayDetail) {
            if let day = viewModel.selectedDay {
                DayDetailSheet(day: day)
            }
        }
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let day: CalendarDay
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(day.dayNumber)")
                .font(.system(size: 15, weight: day.isToday ? .bold : .regular))
                .foregroundColor(day.isCurrentMonth ? AppColors.textPrimary : AppColors.textTertiary)
            
            // Status indicator
            Circle()
                .fill(statusColor)
                .frame(width: 6, height: 6)
                .opacity(day.fastingStatus == .none ? 0 : 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(day.isToday ? AppColors.primary.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(day.isToday ? AppColors.primary : Color.clear, lineWidth: 2)
        )
    }
    
    private var statusColor: Color {
        switch day.fastingStatus {
        case .none: return .clear
        case .completed: return .green
        case .missed: return .red
        case .inProgress: return .blue
        }
    }
}

// MARK: - Stat Pill
struct StatPill: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Legend Item
struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

// MARK: - Day Detail Sheet
struct DayDetailSheet: View {
    let day: CalendarDay
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Date Header
                        VStack(spacing: 8) {
                            Text(day.date, style: .date)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(statusColor)
                                    .frame(width: 12, height: 12)
                                
                                Text(statusText)
                                    .font(.system(size: 15))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Total Hours
                        VStack(spacing: 8) {
                            Text(String(format: "%.1f", day.totalHours))
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(AppColors.primary)
                            
                            Text("Total Hours Fasted")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // Sessions List
                        if !day.sessions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Fasting Sessions")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.horizontal, 20)
                                
                                ForEach(day.sessions) { session in
                                    SessionRow(session: session)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationTitle("Day Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
    
    private var statusColor: Color {
        switch day.fastingStatus {
        case .none: return .gray
        case .completed: return .green
        case .missed: return .red
        case .inProgress: return .blue
        }
    }
    
    private var statusText: String {
        switch day.fastingStatus {
        case .none: return "No Fasting"
        case .completed: return "Completed"
        case .missed: return "Missed"
        case .inProgress: return "In Progress"
        }
    }
}

// MARK: - Session Row
struct SessionRow: View {
    let session: FastingSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%.1f hours", session.actualFastingHours))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                if let endDate = session.endDate {
                    Text("Ended: \(endDate, style: .time)")
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(session.isCompleted ? .green : .red)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        CalendarView()
    }
}
