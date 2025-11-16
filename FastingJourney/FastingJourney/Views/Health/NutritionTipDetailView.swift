import SwiftUI

/// Detailed view for a nutrition tip
struct NutritionTipDetailView: View {
    let tip: NutritionTip
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Header with Icon
                HStack {
                    Text(tip.icon)
                        .font(.system(size: 60))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(tip.category.emoji)
                            .font(.system(size: 24))
                        Text(tip.category.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(getCategoryColor())
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 8)
                
                // MARK: - Title
                Text(tip.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // MARK: - Description
                Text(tip.description)
                    .font(.system(size: 17))
                    .foregroundColor(AppColors.textSecondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                // MARK: - Macros Section
                if let macros = tip.macros {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(AppColors.primary)
                            Text("Nutritional Breakdown")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        // Calorie card
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Calories")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                                Text("\(macros.calories)")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                                Text("kcal")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "flame.fill")
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.orange.opacity(0.3))
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardBackground)
                                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                        )
                        
                        // Macro bars
                        VStack(spacing: 16) {
                            MacroBar(
                                label: "Protein",
                                amount: macros.protein,
                                unit: "g",
                                percentage: macros.proteinPercent,
                                color: AppColors.blue
                            )
                            
                            MacroBar(
                                label: "Carbohydrates",
                                amount: macros.carbs,
                                unit: "g",
                                percentage: macros.carbsPercent,
                                color: AppColors.orange
                            )
                            
                            MacroBar(
                                label: "Fats",
                                amount: macros.fats,
                                unit: "g",
                                percentage: macros.fatsPercent,
                                color: AppColors.warning
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.accentLight.opacity(0.3))
                    )
                }
                
                // MARK: - Foods Section
                if !tip.foods.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(AppColors.success)
                            Text("Recommended Foods")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        FlowLayout(spacing: 10) {
                            ForEach(tip.foods, id: \.self) { food in
                                HStack(spacing: 6) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.success)
                                    Text(food)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(AppColors.cardBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.04), radius: 5, y: 2)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.accentLight.opacity(0.3))
                    )
                }
                
                // MARK: - Fasting Stage Info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(AppColors.primary)
                        Text("Best Time to Apply")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text(getStageDescription())
                        .font(.system(size: 15))
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                )
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 24))
                }
            }
        }
    }
    
    private func getCategoryColor() -> Color {
        switch tip.category {
        case .breakFast: return AppColors.orange
        case .mealPrep: return .purple
        case .hydration: return AppColors.blue
        case .macros: return AppColors.success
        case .supplements: return .pink
        case .timing: return AppColors.warning
        }
    }
    
    private func getStageDescription() -> String {
        switch tip.fastingStage {
        case .beforeFasting:
            return "Apply this tip before starting your fast. This will help you prepare your body and make your fasting experience more comfortable."
        case .early:
            return "Best applied during the first 0-4 hours of your fast. This is when your body is transitioning into fasting mode."
        case .middle:
            return "Apply this during hours 4-12 of your fast. Your body is actively burning fat for energy during this stage."
        case .late:
            return "This tip is most effective during hours 12-16+ of your fast, when autophagy and deep cellular renewal are occurring."
        case .breaking:
            return "Use this tip when you're ready to break your fast. Proper breaking is crucial for digestive comfort and nutrient absorption."
        case .afterFasting:
            return "Apply this after your fast is complete. This helps maintain the benefits of fasting and prepares you for your next fast."
        }
    }
}

// MARK: - Macro Bar Component
struct MacroBar: View {
    let label: String
    let amount: Int
    let unit: String
    let percentage: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(amount)\(unit)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(color)
                
                Text("(\(percentage)%)")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.surfaceBackground)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(percentage) / 100)
                }
            }
            .frame(height: 10)
        }
    }
}

#Preview {
    NavigationStack {
        NutritionTipDetailView(
            tip: NutritionTip(
                title: "Break Your Fast Right",
                description: "Choose light and digestion-friendly foods for your first meal. Focus on protein and healthy fats to ease your digestive system back into processing food.",
                icon: "🥗",
                category: .breakFast,
                fastingStage: .breaking,
                macros: NutritionTip.MacroBreakdown(protein: 25, carbs: 30, fats: 20, calories: 400),
                foods: ["Eggs", "Avocado", "Vegetables", "Whole grain bread", "Dates"]
            )
        )
    }
}
