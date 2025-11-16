import SwiftUI

/// Main tab-based navigation view
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var planViewModel = FastingPlanViewModel()
    @StateObject var sessionViewModel = FastingSessionViewModel()
    @StateObject var progressViewModel = ProgressViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var hydrationViewModel = HydrationViewModel()
    @StateObject var analyticsViewModel = AnalyticsViewModel()
    @StateObject var buddyViewModel = BuddyViewModel()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(sessionViewModel)
                .environmentObject(planViewModel)
                .environmentObject(progressViewModel)
                .environmentObject(hydrationViewModel)
                .environmentObject(authViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            NavigationView {
                PlansView()
                    .environmentObject(planViewModel)
                    .environmentObject(sessionViewModel)
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                Text("Plans")
            }
            .tag(1)
            
            NavigationView {
                GrowView()
                    .environmentObject(progressViewModel)
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "leaf.fill" : "leaf")
                Text("Grow")
            }
            .tag(2)
            
            NavigationView {
                AnalyticsView()
                    .environmentObject(analyticsViewModel)
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                Text("Analytics")
            }
            .tag(3)
            
            NavigationView {
                SettingsView()
                    .environmentObject(settingsViewModel)
                    .environmentObject(progressViewModel)
                    .environmentObject(authViewModel)
            }
            .tabItem {
                Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                Text("Settings")
            }
            .tag(4)
        }
        .accentColor(AppColors.primary)
    }
}

#Preview {
    MainTabView()
}
