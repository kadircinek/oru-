import SwiftUI

/// Detailed view of a fasting plan
struct PlanDetailView: View {
    @EnvironmentObject var viewModel: FastingPlanViewModel
    @Environment(\.dismiss) var dismiss
    
    let plan: FastingPlan
    @State private var showConfirmation = false
    @State private var confirmationMessage = ""
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppTypography.large) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text(plan.name)
                            .font(.displaySmall)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(plan.shortDescription)
                            .font(.bodyRegular)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    // Tags
                    if !plan.tags.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(plan.tags, id: \.self) { tag in
                                TagPillView(text: tag, isSelected: viewModel.selectedPlan?.id == plan.id)
                            }
                        }
                    }
                    
                    // Details Card
                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle("How It Works")
                        
                        if let fasting = plan.fastingHours, let eating = plan.eatingHours {
                            DetailRow(icon: "timer", label: "Fast Duration", value: "\(fasting) hours")
                            DetailRow(icon: "utensils", label: "Eating Window", value: "\(eating) hours")
                            DetailRow(icon: "calendar", label: "Type", value: "Time-based")
                        } else {
                            DetailRow(icon: "calendar", label: "Type", value: "Schedule-based")
                        }
                    }
                    .padding(AppTypography.medium)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        SectionTitle("About This Plan")
                        
                        Text(plan.detailedDescription)
                            .font(.bodyRegular)
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(2)
                    }
                    
                    // Example Schedule
                    if let fasting = plan.fastingHours, let eating = plan.eatingHours {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("Example Schedule")
                            
                            let fastStart = Calendar.current.date(byAdding: .hour, value: 8, to: Date()) ?? Date()
                            let eatStart = Calendar.current.date(byAdding: .hour, value: 8 + fasting, to: Date()) ?? Date()
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "moon.stars")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Fasting Window")
                                            .font(.labelMedium)
                                            .foregroundColor(AppColors.textSecondary)
                                        Text("From \(fastStart.formatted(date: .omitted, time: .shortened)) for \(fasting) hours")
                                            .font(.bodySmall)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(AppTypography.medium)
                                .background(Color(red: 0.3, green: 0.7, blue: 0.9).opacity(0.1))
                                .cornerRadius(AppTypography.smallRadius)
                                
                                HStack {
                                    Image(systemName: "sun.max")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.accent)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Eating Window")
                                            .font(.labelMedium)
                                            .foregroundColor(AppColors.textSecondary)
                                        Text("From \(eatStart.formatted(date: .omitted, time: .shortened)) for \(eating) hours")
                                            .font(.bodySmall)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(AppTypography.medium)
                                .background(AppColors.accent.opacity(0.1))
                                .cornerRadius(AppTypography.smallRadius)
                            }
                        }
                    }
                    
                    // Health Disclaimer
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.warning)
                            
                            Text("Health Disclaimer")
                                .font(.labelMedium)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Text("This app is for informational and motivational purposes only and does not provide medical advice. Always consult a healthcare professional before starting or changing any fasting or nutrition plan.")
                            .font(.bodySmall)
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(1.5)
                    }
                    .padding(AppTypography.medium)
                    .background(AppColors.warning.opacity(0.1))
                    .cornerRadius(AppTypography.mediumRadius)
                    
                    Spacer(minLength: 20)
                }
                .padding(AppTypography.large)
            }
            
            // Action Button
            VStack {
                Spacer()
                
                PrimaryButton(
                    title: viewModel.selectedPlan?.id == plan.id ? "Current Plan" : "Set as Active Plan",
                    action: {
                        viewModel.selectPlan(plan)
                        confirmationMessage = "✓ \(plan.name) activated!"
                        showConfirmation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }
                )
                .disabled(viewModel.selectedPlan?.id == plan.id)
                .padding(AppTypography.large)
                .background(AppColors.background)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Plan Details")
                    .font(.titleMedium)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct SectionTitle: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.titleSmall)
            .foregroundColor(AppColors.textPrimary)
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.primary)
                .frame(width: 24)
            
            Text(label)
                .font(.bodyRegular)
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodyRegular)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

#Preview {
    NavigationStack {
        PlanDetailView(plan: FastingPlan.allPlans[0])
            .environmentObject(FastingPlanViewModel())
    }
}
