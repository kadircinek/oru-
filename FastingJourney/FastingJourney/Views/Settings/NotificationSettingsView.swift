import SwiftUI

struct NotificationSettingsView: View {
    @EnvironmentObject var progressViewModel: ProgressViewModel
    @State private var preferences: NotificationPreferences
    @State private var showingReminderPicker = false
    @State private var newReminderHour = 4
    
    init() {
        let prefs = PersistenceManager.shared.loadUserProfile().notificationPreferences
        _preferences = State(initialValue: prefs)
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notification Settings")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Customize your reminders")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    // Motivational Quotes Toggle
                    SettingCard(
                        icon: "quote.bubble.fill",
                        title: "Motivational Messages",
                        subtitle: "Show random motivational messages in notifications"
                    ) {
                        Toggle("", isOn: $preferences.enableMotivationalQuotes)
                            .labelsHidden()
                            .tint(AppColors.primary)
                    }
                    
                    // Nearly Done Countdown Toggle
                    SettingCard(
                        icon: "timer",
                        title: "Nearly Done Notifications",
                        subtitle: "Countdown notifications before fast ends"
                    ) {
                        Toggle("", isOn: $preferences.enableNearlyDoneCountdown)
                            .labelsHidden()
                            .tint(AppColors.primary)
                    }
                    
                    // Custom Reminder Times
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(AppColors.primary)
                            Text("Reminder Hours")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Button(action: {
                                showingReminderPicker = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(AppColors.primary)
                                    .font(.system(size: 20))
                            }
                        }
                        
                        Text("How many hours after fasting starts do you want notifications?")
                            .font(.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(preferences.customReminderTimes.sorted(), id: \.self) { hour in
                                HStack(spacing: 4) {
                                    Text("\(hour) hours")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Button(action: {
                                        withAnimation {
                                            preferences.customReminderTimes.removeAll { $0 == hour }
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(AppColors.textSecondary)
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppColors.accentLight)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding(16)
                    .background(AppColors.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // Quiet Hours
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(AppColors.primary)
                            Text("Quiet Hours")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Toggle("", isOn: $preferences.quietHoursEnabled)
                                .labelsHidden()
                                .tint(AppColors.primary)
                        }
                        
                        if preferences.quietHoursEnabled {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Start")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                        .frame(width: 80, alignment: .leading)
                                    
                                    Picker("", selection: $preferences.quietHoursStart) {
                                        ForEach(0..<24, id: \.self) { hour in
                                            Text(String(format: "%02d:00", hour))
                                                .tag(hour)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(AppColors.primary)
                                }
                                
                                HStack {
                                    Text("End")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                        .frame(width: 80, alignment: .leading)
                                    
                                    Picker("", selection: $preferences.quietHoursEnd) {
                                        ForEach(0..<24, id: \.self) { hour in
                                            Text(String(format: "%02d:00", hour))
                                                .tag(hour)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(AppColors.primary)
                                }
                                
                                Text("No notifications will be sent during these hours")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(16)
                    .background(AppColors.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
                .padding(.vertical, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: preferences) { newValue in
            savePreferences(newValue)
        }
        .sheet(isPresented: $showingReminderPicker) {
            ReminderHourPicker(selectedHour: $newReminderHour, preferences: $preferences)
        }
    }
    
    private func savePreferences(_ prefs: NotificationPreferences) {
        var profile = PersistenceManager.shared.loadUserProfile()
        profile.notificationPreferences = prefs
        PersistenceManager.shared.saveUserProfile(profile)
        progressViewModel.refreshProfile()
    }
}

// Helper view for setting card
private struct SettingCard<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content
    
    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AppColors.primary)
                .font(.system(size: 20))
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            content
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}

// Picker sheet for adding reminder hours
private struct ReminderHourPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedHour: Int
    @Binding var preferences: NotificationPreferences
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("How many hours later to remind?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Picker("Hours", selection: $selectedHour) {
                        ForEach(1...24, id: \.self) { hour in
                            Text("\(hour) hours")
                                .tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Button(action: {
                        if !preferences.customReminderTimes.contains(selectedHour) {
                            preferences.customReminderTimes.append(selectedHour)
                        }
                        dismiss()
                    }) {
                        Text("Add")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NotificationSettingsView()
            .environmentObject(ProgressViewModel())
    }
}
