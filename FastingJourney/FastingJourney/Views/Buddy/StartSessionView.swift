import SwiftUI

/// View for starting a new fasting session with buddy
struct StartSessionView: View {
    let buddy: FastingBuddy
    @ObservedObject var viewModel: BuddyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPlan = "16:8"
    @State private var customDuration: Double = 16
    
    let plans = ["12:12", "14:10", "16:8", "18:6", "20:4", "Custom"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            Text(viewModel.manager.currentUserEmoji)
                                .font(.system(size: 40))
                            
                            Image(systemName: "link")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.primary)
                            
                            Text(buddy.profileEmoji)
                                .font(.system(size: 40))
                        }
                        
                        Text("Start Fasting Together")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Choose a fasting plan to complete together")
                            .font(.system(size: 15))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 20)
                    
                    // Plan Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Select Plan", systemImage: "calendar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(plans, id: \.self) { plan in
                                PlanButton(plan: plan, isSelected: selectedPlan == plan) {
                                    selectedPlan = plan
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Custom Duration
                    if selectedPlan == "Custom" {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Duration (hours)", systemImage: "clock.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack {
                                Slider(value: $customDuration, in: 12...24, step: 1)
                                    .tint(AppColors.primary)
                                
                                Text("\(Int(customDuration))h")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                                    .frame(width: 50)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.primary.opacity(0.05))
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Start Button
                    Button {
                        startSession()
                    } label: {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 20))
                            Text("Start Session")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(AppColors.primary)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .padding(.vertical, 20)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
    
    private func startSession() {
        let duration: TimeInterval
        
        if selectedPlan == "Custom" {
            duration = customDuration * 3600
        } else {
            let parts = selectedPlan.split(separator: ":")
            if let fastingHours = Int(parts[0]) {
                duration = Double(fastingHours) * 3600
            } else {
                duration = 16 * 3600
            }
        }
        
        viewModel.startSessionWith([buddy.userId], planName: selectedPlan, duration: duration)
        dismiss()
    }
}

struct PlanButton: View {
    let plan: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if plan == "Custom" {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 28))
                } else {
                    Text(plan)
                        .font(.system(size: 22, weight: .bold))
                }
                
                Text(plan == "Custom" ? "Custom" : "Plan")
                    .font(.system(size: 13))
            }
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? AppColors.primary : AppColors.cardBackground)
                    .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.04), radius: isSelected ? 10 : 6, y: isSelected ? 6 : 2)
            )
        }
    }
}
