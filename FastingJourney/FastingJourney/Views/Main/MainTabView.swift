import SwiftUI

/// Main tab-based navigation view
struct MainTabView: View {
    @StateObject var planViewModel = FastingPlanViewModel()
    @StateObject var sessionViewModel = FastingSessionViewModel()
    @StateObject var progressViewModel = ProgressViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        TabView {
            // Home tab
            NavigationStack {
                HomeView()
                    .environmentObject(sessionViewModel)
                    .environmentObject(planViewModel)
                    .environmentObject(progressViewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            // Plans tab
            NavigationStack {
                PlansView()
                    .environmentObject(planViewModel)
            }
            .tabItem {
                Label("Plans", systemImage: "clock.arrow.circlepath")
            }
            
            // History tab
            NavigationStack {
                HistoryView()
                    .environmentObject(sessionViewModel)
            }
            .tabItem {
                Label("History", systemImage: "calendar")
            }
            
            // Profile tab
            NavigationStack {
                SettingsView()
                    .environmentObject(settingsViewModel)
                    .environmentObject(progressViewModel)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
        .tint(AppColors.primary)
    }
}

#Preview {
    MainTabView()
}
