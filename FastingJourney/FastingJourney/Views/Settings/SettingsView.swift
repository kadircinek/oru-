import SwiftUI

/// Settings and Profile view
struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var progressViewModel: ProgressViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showResetConfirmation = false
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    VStack(spacing: AppTypography.large) {
                        // Profile Header
                        VStack(alignment: .center, spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                            
                            VStack(spacing: 4) {
                                if let user = authViewModel.currentUser {
                                    Text(user.name)
                                        .font(.titleMedium)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text(user.email)
                                        .font(.labelMedium)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                
                                Text("Level \(progressViewModel.userProfile.level) - \(progressViewModel.currentLevelName)")
                                    .font(.bodyRegular)
                                    .foregroundColor(AppColors.primary)
                                    .padding(.top, 4)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(AppTypography.large)
                        .background(AppColors.cardBackground)
                        .cornerRadius(AppTypography.mediumRadius)
                        
                        // Level Info
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Your Progress")
                            
                            StatCardView(
                                icon: "checkmark.circle.fill",
                                value: "\(progressViewModel.userProfile.totalCompletedFasts)",
                                label: "Completed Fasts",
                                unit: "total"
                            )
                            
                            StatCardView(
                                icon: "hourglass.fill",
                                value: String(format: "%.0f", progressViewModel.userProfile.totalHoursFasted),
                                label: "Total Hours Fasted",
                                unit: "hours"
                            )
                            
                            StatCardView(
                                icon: "flame.fill",
                                value: "\(progressViewModel.userProfile.currentStreak)",
                                label: "Current Streak",
                                unit: "days"
                            )
                        }
                        
                        // Personal Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Personal Info")
                            
                            NavigationLink(destination: PersonalInfoEditView().environmentObject(authViewModel)) {
                                HStack {
                                    Image(systemName: "person.text.rectangle.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Edit Profile Info")
                                            .font(.bodyRegular)
                                            .foregroundColor(AppColors.textPrimary)
                                        if let user = authViewModel.currentUser {
                                            if user.weight != nil && user.height != nil && user.age != nil {
                                                Text("Weight: \(String(format: "%.0f", user.weight!))kg, Height: \(String(format: "%.0f", user.height!))cm")
                                                    .font(.labelMedium)
                                                    .foregroundColor(AppColors.textSecondary)
                                            } else {
                                                Text("Add weight, height, age for calorie tracking")
                                                    .font(.labelMedium)
                                                    .foregroundColor(AppColors.warning)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                        }
                        
                        // Preferences
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Preferences")
                            
                            // Notification Settings Link
                            NavigationLink(destination: NotificationSettingsView().environmentObject(progressViewModel)) {
                                HStack {
                                    Image(systemName: "bell.badge.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Notification Settings")
                                            .font(.bodyRegular)
                                            .foregroundColor(AppColors.textPrimary)
                                        Text("Customize reminders and notifications")
                                            .font(.labelMedium)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                            
                            // Smart Features Link
                            NavigationLink(destination: SmartFeaturesView()) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Smart Features")
                                            .font(.bodyRegular)
                                            .foregroundColor(AppColors.textPrimary)
                                        Text("Location, weather and calendar integration")
                                            .font(.labelMedium)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                            
                            ToggleRow(
                                title: "Start Reminders",
                                subtitle: "Get notified when fasting begins",
                                isOn: $settingsViewModel.preferences.enableStartReminders,
                                onChange: { value in
                                    settingsViewModel.updateStartReminders(value)
                                }
                            )
                            
                            ToggleRow(
                                title: "End Reminders",
                                subtitle: "Get notified when fasting ends",
                                isOn: $settingsViewModel.preferences.enableEndReminders,
                                onChange: { value in
                                    settingsViewModel.updateEndReminders(value)
                                }
                            )

                            ToggleRow(
                                title: "Milestone Notifications",
                                subtitle: "Get a nudge at each fasting stage",
                                isOn: $settingsViewModel.preferences.enableStageNotifications,
                                onChange: { value in
                                    settingsViewModel.updateStageNotifications(value)
                                }
                            )
                            
                            ToggleRow(
                                title: "Water Reminders",
                                subtitle: "Get hydration reminders regularly",
                                isOn: $settingsViewModel.preferences.enableWaterReminders,
                                onChange: { value in
                                    settingsViewModel.updateWaterReminders(value)
                                }
                            )
                            
                            Picker("Time Format", selection: $settingsViewModel.preferences.timeFormat) {
                                Text("12-Hour").tag(AppPreferences.TimeFormat.twelve)
                                Text("24-Hour").tag(AppPreferences.TimeFormat.twentyFour)
                            }
                            .pickerStyle(.segmented)
                            .padding(AppTypography.medium)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppTypography.mediumRadius)
                            .onChange(of: settingsViewModel.preferences.timeFormat) { newValue in
                                settingsViewModel.updateTimeFormat(newValue)
                            }
                        }
                        
                        // Theme
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Appearance")
                            
                            Picker("Theme", selection: $settingsViewModel.preferences.theme) {
                                Text("System").tag(AppPreferences.AppTheme.system)
                                Text("Light").tag(AppPreferences.AppTheme.light)
                                Text("Dark").tag(AppPreferences.AppTheme.dark)
                            }
                            .pickerStyle(.segmented)
                            .padding(AppTypography.medium)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppTypography.mediumRadius)
                            .onChange(of: settingsViewModel.preferences.theme) { newValue in
                                settingsViewModel.updateTheme(newValue)
                            }
                        }
                        
                        // Data Management
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Data")
                            
                            Button(role: .destructive) {
                                showResetConfirmation = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Reset All Data")
                                            .font(.bodyRegular)
                                        Text("Clear all history and settings")
                                            .font(.labelMedium)
                                    }
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.error.opacity(0.1))
                                .foregroundColor(AppColors.error)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                        }
                        
                        // About
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("About")
                            
                            NavigationLink(destination: HealthTipsView()) {
                                HStack {
                                    Image(systemName: "heart.text.square.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Health Tips Library")
                                            .font(.bodyRegular)
                                        Text("Expert fasting guidance")
                                            .font(.labelMedium)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.cardBackground)
                                .foregroundColor(AppColors.textPrimary)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                            
                            NavigationLink(destination: AboutView()) {
                                HStack {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("About FastingJourney")
                                            .font(.bodyRegular)
                                        Text("Version \(settingsViewModel.appVersion)")
                                            .font(.labelMedium)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.cardBackground)
                                .foregroundColor(AppColors.textPrimary)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                        }
                        
                        // Logout
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Account")
                            
                            Button {
                                showLogoutConfirmation = true
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Sign Out")
                                            .font(.bodyRegular)
                                        Text("Log out of your account")
                                            .font(.labelMedium)
                                    }
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTypography.medium)
                                .background(AppColors.cardBackground)
                                .foregroundColor(AppColors.error)
                                .cornerRadius(AppTypography.mediumRadius)
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(AppTypography.large)
                }
                            .navigationTitle("⚙️ Settings")
            .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Profile")
                            .font(.titleMedium)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .alert("Reset All Data?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                settingsViewModel.resetAllData()
                progressViewModel.refreshProfile()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all your fasting history and reset your profile. This action cannot be undone.")
        }
        .alert("Sign Out?", isPresented: $showLogoutConfirmation) {
            Button("Sign Out", role: .destructive) {
                authViewModel.logout()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct SectionHeader: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.titleSmall)
            .foregroundColor(AppColors.textPrimary)
            .padding(.horizontal, AppTypography.medium)
    }
}

struct ToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let onChange: (Bool) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyRegular)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(.labelMedium)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { newValue in
                    onChange(newValue)
                }
        }
        .padding(AppTypography.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppTypography.mediumRadius)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsViewModel())
            .environmentObject(ProgressViewModel())
    }
}
