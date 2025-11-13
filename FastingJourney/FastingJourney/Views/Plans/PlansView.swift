import SwiftUI

/// Fasting plans browser
struct PlansView: View {
    @EnvironmentObject var viewModel: FastingPlanViewModel
    @State private var selectedPlan: FastingPlan?
    @State private var showDetailView = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) { _, newValue in
                        viewModel.updateSearchText(newValue)
                    }
                    .padding(AppTypography.large)
                
                // Filter Segmented Control
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    Text("All").tag(FastingPlanViewModel.PlanFilter.all)
                    Text("Beginner").tag(FastingPlanViewModel.PlanFilter.beginner)
                    Text("Advanced").tag(FastingPlanViewModel.PlanFilter.advanced)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppTypography.large)
                .padding(.bottom, AppTypography.medium)
                .onChange(of: viewModel.selectedFilter) { _, newValue in
                    viewModel.setFilter(newValue)
                }
                
                // Plans List
                ScrollView {
                    VStack(spacing: AppTypography.medium) {
                        ForEach(viewModel.filteredPlans) { plan in
                            NavigationLink(destination: PlanDetailView(plan: plan)
                                .environmentObject(viewModel)) {
                                PlanCardView(
                                    plan: plan,
                                    isSelected: viewModel.selectedPlan?.id == plan.id
                                )
                            }
                            .foregroundColor(.primary)
                        }
                        
                        if viewModel.filteredPlans.isEmpty {
                            EmptyStateView(
                                icon: "magnifyingglass",
                                title: "No Plans Found",
                                message: "Try adjusting your filters or search term"
                            )
                            .padding(AppTypography.large)
                        }
                    }
                    .padding(AppTypography.large)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Fasting Plans")
                    .font(.titleMedium)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search plans...", text: $text)
                .font(.bodyRegular)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(AppTypography.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppTypography.mediumRadius)
    }
}

#Preview {
    NavigationStack {
        PlansView()
            .environmentObject(FastingPlanViewModel())
    }
}
