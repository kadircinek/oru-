import SwiftUI

/// Home/Dashboard view
struct HomeView: View {
    @EnvironmentObject var sessionViewModel: FastingSessionViewModel
    @EnvironmentObject var planViewModel: FastingPlanViewModel
    @EnvironmentObject var progressViewModel: ProgressViewModel
    @EnvironmentObject var hydrationViewModel: HydrationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showingPlanSelection = false
    @State private var confirmEndFasting = false
    @State private var selectedNutritionTip: NutritionTip?
    @State private var selectedHealthTip: HealthTip?
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    
    // Get progress bar color based on elapsed hours
    private func getProgressColor() -> Color {
        let elapsed = sessionViewModel.elapsedHours
        
        if elapsed < 4 {
            return Color(red: 0.3, green: 0.7, blue: 1.0) // Light Blue - Beginning
        } else if elapsed < 8 {
            return Color(red: 0.4, green: 0.8, blue: 0.4) // Green - Going Well
        } else if elapsed < 12 {
            return Color(red: 1.0, green: 0.7, blue: 0.2) // Orange - Mid Point
        } else if elapsed < 16 {
            return Color(red: 1.0, green: 0.5, blue: 0.0) // Deep Orange - Advanced
        } else {
            return Color(red: 1.0, green: 0.3, blue: 0.3) // Red/Pink - Expert Mode
        }
    }
    
    // Get stage message based on elapsed hours
    private func getStageMessage() -> String {
        let elapsed = sessionViewModel.elapsedHours
        
        if elapsed < 4 {
            return "🌱 Beginning Stage"
        } else if elapsed < 8 {
            return "💪 Progressing"
        } else if elapsed < 12 {
            return "🔥 Going Great!"
        } else if elapsed < 16 {
            return "⚡ Advanced Level!"
        } else {
            return "🏆 Expert Mode!"
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // MARK: - Header with Greeting and Active Plan
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome")
                                    .font(.title2.bold())
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text(planViewModel.selectedPlan?.name ?? "No plan selected")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Enhanced Share Button with Animation
                            Button {
                                shareProgress()
                            } label: {
                                ZStack {
                                    // Animated gradient background
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [AppColors.primary, AppColors.primary.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    // Pulse ring
                                    Circle()
                                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 2)
                                        .frame(width: 58, height: 58)
                                        .scaleEffect(1.0)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "square.and.arrow.up.fill")
                                            .font(.system(size: 16, weight: .bold))
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                            .shadow(color: AppColors.primary.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // MARK: - Weekly Progress Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textPrimary)
                            Text("Your Weekly Progress")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        HStack(spacing: 20) {
                            // Progress Ring with stage-based color
                            ZStack {
                                Circle()
                                    .stroke(AppColors.accentLight, lineWidth: 12)
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .trim(from: 0, to: sessionViewModel.progress / 100)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                getProgressColor(),
                                                getProgressColor().opacity(0.7)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeInOut(duration: 0.3), value: sessionViewModel.progress)
                                
                                VStack(spacing: 0) {
                                    Text("\(Int(progressViewModel.userProfile.totalCompletedFasts))")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("fasts")
                                        .font(.system(size: 11))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            
                            Spacer()
                            
                            // Stats
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "figure.walk")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.orange)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Hours Fasted")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppColors.textSecondary)
                                        Text("\(Int(progressViewModel.userProfile.totalHoursFasted))")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                }
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.blue)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Water Today")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppColors.textSecondary)
                                        Text("\(hydrationViewModel.entry.consumedMl) ml")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.accentLight.opacity(0.3))
                    )
                    .padding(.horizontal, 20)
                    
                    // MARK: - Current Fasting Status
                    VStack(alignment: .leading, spacing: 12) {
                        Text(sessionViewModel.isActive() ? "Current Fast" : "Ready to Start")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        if sessionViewModel.isActive() {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        if let plan = planViewModel.selectedPlan {
                                            Text(plan.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                        Text("In Progress")
                                            .font(.system(size: 13))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(FastingCalculator.formatTimeRemaining(sessionViewModel.remainingTime))
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(getProgressColor())
                                        Text("remaining")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                                
                                // Stage indicator
                                HStack {
                                    Text(getStageMessage())
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(getProgressColor())
                                    Spacer()
                                    Text("\(Int(sessionViewModel.progress))%")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                
                                // Progress Bar with animated gradient
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(AppColors.surfaceBackground)
                                        
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        getProgressColor(),
                                                        getProgressColor().opacity(0.7)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geo.size.width * (sessionViewModel.progress / 100))
                                            .animation(.easeInOut(duration: 0.3), value: sessionViewModel.progress)
                                        
                                        // Pulse effect at the end of progress bar
                                        if sessionViewModel.progress > 0 {
                                            Circle()
                                                .fill(getProgressColor().opacity(0.5))
                                                .frame(width: 12, height: 12)
                                                .offset(x: (geo.size.width * (sessionViewModel.progress / 100)) - 6)
                                        }
                                    }
                                }
                                .frame(height: 10)
                                
                                if let endDate = sessionViewModel.endDate {
                                    HStack(spacing: 6) {
                                        Image(systemName: "clock")
                                            .font(.system(size: 12))
                                        Text("Ends at \(endDate.formatted(date: .omitted, time: .shortened))")
                                            .font(.system(size: 13))
                                    }
                                    .foregroundColor(AppColors.textSecondary)
                                }
                                
                                Button {
                                    confirmEndFasting = true
                                } label: {
                                    Text("End Fast")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 46)
                                        .background(AppColors.error)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                            )
                        } else {
                            Button {
                                handleStartFasting()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.fill")
                                    Text("Start New Fast")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(AppColors.primary)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Calorie Burn Tracker
                    if sessionViewModel.isActive(), 
                       let user = authViewModel.currentUser,
                       user.weight != nil {
                        caloriesBurnedCard(user: user)
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Quick Stats Cards
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // Water Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(AppColors.blue)
                                    Spacer()
                                }
                                
                                Text("\(hydrationViewModel.entry.consumedMl)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("ml / \(hydrationViewModel.entry.targetMl) ml")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Button {
                                    hydrationViewModel.addWater(amount: 250)
                                } label: {
                                    Text("+ 250ml")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(AppColors.blue)
                                }
                            }
                            .frame(width: 140)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                            )
                            
                            // Streak Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(AppColors.orange)
                                    Spacer()
                                }
                                
                                Text("\(progressViewModel.userProfile.currentStreak)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("day streak")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Text("Keep going!")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(AppColors.orange)
                            }
                            .frame(width: 140)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                            )
                            
                            // Level Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(AppColors.warning)
                                    Spacer()
                                }
                                
                                Text("Level \(progressViewModel.userProfile.level)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text(progressViewModel.currentLevelName)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                if progressViewModel.userProfile.level < 4 {
                                    Text("\(progressViewModel.fastsToNextLevel) to next")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(AppColors.warning)
                                } else {
                                    Text("Max level!")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(AppColors.success)
                                }
                            }
                            .frame(width: 140)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Calorie Burn Tracker
                    if sessionViewModel.isActive(), 
                       let user = authViewModel.currentUser,
                       user.weight != nil {
                        caloriesBurnedCard(user: user)
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Share Progress Prompt (Motivational)
                    if sessionViewModel.isActive() && sessionViewModel.elapsedHours >= 4 {
                        Button {
                            shareProgress()
                        } label: {
                            HStack(spacing: 16) {
                                // Animated emoji
                                Text("📸")
                                    .font(.system(size: 48))
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Share Your Progress!")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Inspire others with your \(Int(sessionViewModel.elapsedHours))h fasting journey")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                            .background(
                                LinearGradient(
                                    colors: [
                                        AppColors.primary,
                                        AppColors.primary.opacity(0.8)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: AppColors.primary.opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Fasting Timeline
                    if sessionViewModel.isActive() {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Fasting Timeline")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, 20)
                            
                            if let plan = planViewModel.selectedPlan {
                                FastingTimelineView(
                                    entries: FastingTimelineProvider.stages(upto: plan.fastingHours),
                                    elapsedHours: sessionViewModel.elapsedHours
                                )
                                .padding(.horizontal, 20)
                            } else {
                                FastingTimelineView(
                                    entries: FastingTimelineProvider.stages(upto: 16),
                                    elapsedHours: sessionViewModel.elapsedHours
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    // MARK: - Daily Health Tip
                    let dailyTip = HealthTipsProvider.shared.getDailyTip()
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(dailyTip.category.emoji)
                                .font(.system(size: 20))
                            Text("Today's Health Tip")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Text(dailyTip.icon)
                                .font(.system(size: 36))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(dailyTip.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text(dailyTip.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                                    .lineLimit(3)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                HStack {
                                    Text(dailyTip.category.rawValue)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(AppColors.primary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(AppColors.primary.opacity(0.1))
                                        .cornerRadius(8)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Text("Tap for details")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(AppColors.primary)
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppColors.primary)
                                    }
                                }
                                .padding(.top, 4)
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.cardBackground,
                                        AppColors.accentLight.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        selectedHealthTip = dailyTip
                    }
                    
                    // MARK: - Nutrition Tips
                    let nutritionTip = NutritionTipsProvider.shared.getTipForFastingState(
                        isFasting: sessionViewModel.isActive(),
                        elapsedHours: sessionViewModel.elapsedHours,
                        remainingMinutes: Int(sessionViewModel.remainingTime / 60)
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(nutritionTip.category.emoji)
                                .font(.system(size: 20))
                            Text("Nutrition Tip")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Text(nutritionTip.category.rawValue)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(getCategoryColor(nutritionTip.category))
                                .cornerRadius(6)
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Text(nutritionTip.icon)
                                .font(.system(size: 36))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(nutritionTip.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text(nutritionTip.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                                    .lineLimit(3)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                // Tap to view more
                                HStack {
                                    Text("Tap to view details")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(getCategoryColor(nutritionTip.category))
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(getCategoryColor(nutritionTip.category))
                                }
                                .padding(.top, 4)
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.cardBackground,
                                        getCategoryColor(nutritionTip.category).opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        selectedNutritionTip = nutritionTip
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .alert("End Fasting?", isPresented: $confirmEndFasting) {
            Button("End", role: .destructive) {
                if let plan = planViewModel.selectedPlan {
                    _ = sessionViewModel.endFasting(with: plan)
                    progressViewModel.refreshProfile()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to end your fasting session?")
        }
        .sheet(item: $selectedNutritionTip) { tip in
            NavigationStack {
                NutritionTipDetailView(tip: tip)
            }
        }
        .sheet(item: $selectedHealthTip) { tip in
            NavigationStack {
                HealthTipDetailView(tip: tip)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = shareImage {
                ActivityViewController(image: image, text: "Check out my fasting progress!")
            }
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
    
    private func getCategoryColor(_ category: NutritionTip.NutritionCategory) -> Color {
        switch category {
        case .breakFast: return AppColors.orange
        case .mealPrep: return .purple
        case .hydration: return AppColors.blue
        case .macros: return AppColors.success
        case .supplements: return .pink
        case .timing: return AppColors.warning
        }
    }
    
    // MARK: - Share Progress
    
    private func shareProgress() {
        let totalFasts = Int(progressViewModel.userProfile.totalCompletedFasts)
        let totalHours = Int(progressViewModel.userProfile.totalHoursFasted)
        let streak = progressViewModel.userProfile.currentStreak
        
        SocialShareManager.shared.shareFastingAchievement(
            hoursCompleted: totalHours,
            totalFasts: totalFasts,
            streak: streak
        ) { image in
            shareImage = image
            showingShareSheet = true
        }
    }
    
    // MARK: - Calories Burned Card
    private func caloriesBurnedCard(user: User) -> some View {
        let elapsed = sessionViewModel.elapsedHours
        let caloriesBurned = CalorieCalculator.shared.calculateFastingCalories(
            user: user,
            fastingHours: elapsed
        )
        let fatBurned = CalorieCalculator.shared.calculateFatBurned(caloriesBurned: caloriesBurned)
        let fatPercentage = CalorieCalculator.shared.calculateFatBurningPercentage(fastingHours: elapsed)
        let hourlyRate = CalorieCalculator.shared.getHourlyBurnRate(user: user, fastingHours: elapsed)
        
        return VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                HStack(spacing: 6) {
                    Text("🔥")
                        .font(.system(size: 18))
                    Text("Calorie Burn")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                }
                Spacer()
                Text("Estimated")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.surfaceBackground)
                    .cornerRadius(8)
            }
            
            // Main stats
            HStack(spacing: 20) {
                // Calories burned
                VStack(alignment: .leading, spacing: 4) {
                    Text(CalorieCalculator.shared.formatCalories(caloriesBurned))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primary)
                    + Text(" kcal")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Calories Burned")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Fat burned
                VStack(alignment: .trailing, spacing: 4) {
                    Text(CalorieCalculator.shared.formatFat(fatBurned))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.orange)
                    + Text(" g")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Fat Burn")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Divider()
                .background(AppColors.surfaceBackground)
            
            // Additional info
            VStack(spacing: 8) {
                HStack {
                    Label("Hourly Burn", systemImage: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text("\(Int(hourlyRate)) kcal/hr")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                }
                
                HStack {
                    Label("Fat Burn Rate", systemImage: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text("\(Int(fatPercentage * 100))%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.orange)
                }
                
                if elapsed >= 12 {
                    HStack {
                        Text("⚡")
                        Text("In ketosis mode!")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.accent)
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            AppColors.primary.opacity(0.05),
                            AppColors.orange.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [AppColors.primary.opacity(0.2), AppColors.orange.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Macro Item Component
struct MacroItem: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

// MARK: - UIActivityViewController Wrapper

struct ActivityViewController: UIViewControllerRepresentable {
    let image: UIImage?
    let text: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let textToShare = "\(text)\n\n#FastingJourney #IntermittentFasting"
        let items: [Any] = image != nil ? [textToShare, image!] : [textToShare]
        
        let vc = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        vc.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList
        ]
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(FastingSessionViewModel())
            .environmentObject(FastingPlanViewModel())
            .environmentObject(ProgressViewModel())
            .environmentObject(HydrationViewModel())
    }
}

