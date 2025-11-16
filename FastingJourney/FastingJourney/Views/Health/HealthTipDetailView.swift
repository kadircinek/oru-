import SwiftUI

/// Detailed view for a health tip
struct HealthTipDetailView: View {
    let tip: HealthTip
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
                
                // MARK: - Category Benefits Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(AppColors.error)
                        Text("Why This Matters")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text(getCategoryBenefitDescription())
                        .font(.system(size: 15))
                        .foregroundColor(AppColors.textSecondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(16)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 5, y: 2)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.accentLight.opacity(0.3))
                )
                
                // MARK: - Implementation Tips
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(AppColors.warning)
                        Text("How to Apply")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TipRow(
                            icon: "clock.fill",
                            title: "Best Timing",
                            description: getTimingAdvice(),
                            color: AppColors.blue
                        )
                        
                        TipRow(
                            icon: "repeat.circle.fill",
                            title: "Frequency",
                            description: getFrequencyAdvice(),
                            color: AppColors.success
                        )
                        
                        TipRow(
                            icon: "exclamationmark.triangle.fill",
                            title: "Important Note",
                            description: "Always listen to your body and consult with healthcare professionals for personalized advice.",
                            color: AppColors.warning
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                )
                
                // MARK: - Category Info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(AppColors.primary)
                        Text("Category")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text(getCategoryDescription())
                        .font(.system(size: 15))
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.cardBackground,
                                    getCategoryColor().opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
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
        case .hydration: return AppColors.blue
        case .nutrition: return AppColors.success
        case .exercise: return AppColors.orange
        case .mental: return .purple
        case .general: return AppColors.primary
        case .science: return .pink
        }
    }
    
    private func getCategoryBenefitDescription() -> String {
        switch tip.category {
        case .hydration:
            return "Proper hydration is essential during intermittent fasting. Water helps manage hunger, supports metabolism, aids detoxification, and maintains energy levels throughout your fasting window."
        case .nutrition:
            return "Smart nutrition choices during your eating window maximize the benefits of intermittent fasting. Focus on nutrient-dense foods to support your body's needs and maintain energy."
        case .exercise:
            return "Exercise complements intermittent fasting by enhancing fat burning, building muscle, and improving overall metabolic health. Timing your workouts properly maximizes results."
        case .mental:
            return "Mental wellness is crucial for fasting success. Managing stress, improving sleep quality, and maintaining mental clarity help you stay committed to your fasting schedule."
        case .general:
            return "These foundational practices support your intermittent fasting journey. Consistency, preparation, and flexibility are key to long-term success."
        case .science:
            return "Understanding the science behind fasting helps you appreciate the powerful changes happening in your body at the cellular level. Knowledge motivates continued practice."
        }
    }
    
    private func getTimingAdvice() -> String {
        switch tip.category {
        case .hydration:
            return "Throughout the day, especially first thing in the morning and before meals. Avoid excessive water intake during fasting."
        case .nutrition:
            return "During your eating window. Focus on nutrient-dense foods when breaking your fast."
        case .exercise:
            return "Light exercise can be done while fasting. Intense workouts are best saved for after breaking your fast."
        case .mental:
            return "Practice throughout the day. Meditation and mindfulness are especially effective during fasting."
        case .general:
            return "Incorporate these habits consistently into your daily routine for maximum benefit."
        case .science:
            return "These biological processes happen automatically. Understanding them helps you optimize your fasting schedule."
        }
    }
    
    private func getFrequencyAdvice() -> String {
        switch tip.category {
        case .hydration:
            return "Daily and consistently. Aim for at least 8 glasses of water during non-fasting hours."
        case .nutrition:
            return "Every meal during your eating window. Focus on balanced macros and micronutrients."
        case .exercise:
            return "3-5 times per week. Mix cardio and strength training for best results."
        case .mental:
            return "Daily practice, even if just 5-10 minutes. Consistency is more important than duration."
        case .general:
            return "Make it a daily habit. Small consistent actions lead to significant long-term results."
        case .science:
            return "These processes occur naturally with consistent fasting. Track your fasting hours to understand when each stage begins."
        }
    }
    
    private func getCategoryDescription() -> String {
        switch tip.category {
        case .hydration:
            return "Proper hydration is essential during intermittent fasting. Water helps with hunger management, supports metabolism, and aids in the detoxification process."
        case .nutrition:
            return "Nutrition tips focus on what and how to eat during your eating window to maximize the benefits of intermittent fasting and maintain optimal health."
        case .exercise:
            return "Exercise complements intermittent fasting by enhancing fat burning, building muscle, and improving overall metabolic health."
        case .mental:
            return "Mental wellness practices help manage hunger, stress, and emotional eating while supporting your overall fasting journey."
        case .general:
            return "General health tips provide foundational advice for a healthy lifestyle that supports and enhances your intermittent fasting practice."
        case .science:
            return "Understanding the scientific processes behind fasting helps you appreciate the powerful biological changes occurring in your body."
        }
    }
}

// MARK: - Tip Row Component
struct TipRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthTipDetailView(
            tip: HealthTip(
                category: .hydration,
                title: "Stay Hydrated",
                description: "Drinking plenty of water is crucial during intermittent fasting. It helps manage hunger, supports metabolism, and keeps you energized.",
                icon: "💧"
            )
        )
    }
}
