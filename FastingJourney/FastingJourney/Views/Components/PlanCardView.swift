import SwiftUI

/// Card for displaying a fasting plan
struct PlanCardView: View {
    let plan: FastingPlan
    var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.name)
                        .font(.titleSmall)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(plan.shortDescription)
                        .font(.bodySmall)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primary)
            }
            
            // Tags
            if !plan.tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(plan.tags.prefix(2), id: \.self) { tag in
                        TagPillView(text: tag, isSelected: isSelected)
                    }
                    if plan.tags.count > 2 {
                        TagPillView(text: "+\(plan.tags.count - 2)", isSelected: isSelected)
                    }
                }
            }
            
            // Duration info
            if let fastingHours = plan.fastingHours, let eatingHours = plan.eatingHours {
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                    Text("\(fastingHours)h fast · \(eatingHours)h eating")
                        .font(.labelMedium)
                }
                .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTypography.medium)
        .background(isSelected ? AppColors.primaryLight.opacity(0.1) : AppColors.cardBackground)
        .border(isSelected ? AppColors.primary : Color.clear, width: 2)
        .cornerRadius(AppTypography.mediumRadius)
    }
}

#Preview {
    VStack(spacing: 12) {
        PlanCardView(plan: FastingPlan.allPlans[0], isSelected: false)
        PlanCardView(plan: FastingPlan.allPlans[1], isSelected: true)
    }
    .padding()
}
