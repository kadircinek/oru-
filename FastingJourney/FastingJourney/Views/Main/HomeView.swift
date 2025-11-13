import SwiftUI

/// Home/Dashboard view
struct HomeView: View {
    @EnvironmentObject var sessionViewModel: FastingSessionViewModel
    @EnvironmentObject var planViewModel: FastingPlanViewModel
    @EnvironmentObject var progressViewModel: ProgressViewModel
    
    @State private var showingPlanSelection = false
    @State private var confirmEndFasting = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTypography.large) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back")
                            .font(.bodyRegular)
                            .foregroundColor(AppColors.textSecondary)
                        
                        if let plan = planViewModel.selectedPlan {
                            Text(plan.name)
                                .font(.headlineLarge)
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 12))
                                if let fasting = plan.fastingHours, let eating = plan.eatingHours {
                                    Text("\(fasting)h fast · \(eating)h eating")
                                        .font(.labelMedium)
                                }
                            }
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppTypography.smallRadius)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Progress Ring
                    VStack(spacing: 16) {
                        ProgressRingView(
                            progress: sessionViewModel.progress,
                            remainingTime: sessionViewModel.isActive() ? 
                                FastingCalculator.formatTimeRemaining(sessionViewModel.remainingTime) :
                                "--:--",
                            isActive: sessionViewModel.isActive()
                        )
                        .frame(height: 280)
                        .onTapGesture {
                            if !sessionViewModel.isActive() {
                                handleStartFasting()
                            } else {
                                confirmEndFasting = true
                            }
                        }
                        
                        if sessionViewModel.isActive(),
                           let endDate = sessionViewModel.endDate {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 12))
                                Text("Ends at \(endDate.formatted(date: .omitted, time: .shortened))")
                                    .font(.labelMedium)
                            }
                            .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .padding(AppTypography.medium)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTypography.mediumRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        if sessionViewModel.isActive() {
                            Button(role: .destructive) {
                                confirmEndFasting = true
                            } label: {
                                Text("End Fasting")
                                    .font(.titleSmall)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(AppTypography.mediumRadius)
                            }
                        } else {
                            PrimaryButton(title: "Start Fasting") {
                                handleStartFasting()
                            }
                        }
                    }
                    
                    // Stats Section
                    VStack(spacing: 12) {
                        Text("Your Stats")
                            .font(.titleMedium)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                let stats = progressViewModel.getStatistics()
                                ForEach(stats, id: \.label) { stat in
                                    StatCardView(
                                        icon: stat.icon,
                                        value: stat.value,
                                        label: stat.label,
                                        unit: stat.unit
                                    )
                                    .frame(minWidth: 160)
                                }
                            }
                            .padding(.horizontal, -AppTypography.large)
                        }
                    }
                    
                    // Level Info
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Level \(progressViewModel.userProfile.level) – \(progressViewModel.currentLevelName)")
                                    .font(.titleMedium)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                if progressViewModel.userProfile.level < 4 {
                                    Text("\(progressViewModel.fastsToNextLevel) fasts to Level \(progressViewModel.userProfile.level + 1)")
                                        .font(.labelMedium)
                                        .foregroundColor(AppColors.textSecondary)
                                } else {
                                    Text("Max level reached!")
                                        .font(.labelMedium)
                                        .foregroundColor(AppColors.success)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: progressViewModel.userProfile.level >= 3 ? "star.fill" : "star")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.accent)
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.textTertiary.opacity(0.2))
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.gradientPrimary)
                                    .frame(width: geometry.size.width * progressViewModel.levelProgress)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(AppTypography.medium)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    Spacer(minLength: 20)
                }
                .padding(AppTypography.large)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("FastingJourney")
                    .font(.titleMedium)
                    .fontWeight(.semibold)
            }
        }
        .alert("End Fasting?", isPresented: $confirmEndFasting) {
            Button("End", role: .destructive) {
                if let plan = planViewModel.selectedPlan {
                    let success = sessionViewModel.endFasting(with: plan)
                    progressViewModel.refreshProfile()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to end your fasting session?")
        }
        .onAppear {
            progressViewModel.refreshProfile()
        }
    }
    
    private func handleStartFasting() {
        if let plan = planViewModel.selectedPlan {
            sessionViewModel.startFasting(with: plan)
        } else {
            showingPlanSelection = true
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(FastingSessionViewModel())
            .environmentObject(FastingPlanViewModel())
            .environmentObject(ProgressViewModel())
    }
}
