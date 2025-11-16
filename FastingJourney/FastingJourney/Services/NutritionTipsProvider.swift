import Foundation

/// Provides nutrition tips based on fasting stage
class NutritionTipsProvider {
    static let shared = NutritionTipsProvider()
    
    private let tips: [NutritionTip]
    
    private init() {
        self.tips = [
            // MARK: - Before Fasting
            NutritionTip(
                title: "Pre-Fast Hydration",
                description: "Drink 500-750ml of water before starting your fast. It's crucial to fill your body's water reserves.",
                icon: "💧",
                category: .hydration,
                fastingStage: .beforeFasting,
                macros: nil,
                foods: ["Water", "Mineral water", "Herbal tea"]
            ),
            NutritionTip(
                title: "Start with Complex Carbs",
                description: "Complex carbs like oats and whole grain bread maintain blood sugar balance and provide satiety.",
                icon: "🌾",
                category: .breakFast,
                fastingStage: .beforeFasting,
                macros: NutritionTip.MacroBreakdown(protein: 15, carbs: 45, fats: 10, calories: 320),
                foods: ["Oats", "Whole grain bread", "Quinoa", "Brown rice"]
            ),
            
            // MARK: - Early Fasting (0-4 hours)
            NutritionTip(
                title: "Stay Hydrated",
                description: "Hunger is normal in the first hours. Drinking 250ml of water every hour will help you get through this period easily.",
                icon: "💧",
                category: .hydration,
                fastingStage: .early,
                macros: nil,
                foods: ["Water", "Unsweetened tea", "Black coffee (unsweetened)"]
            ),
            
            // MARK: - Middle Fasting (4-12 hours)
            NutritionTip(
                title: "Fat Burning Begins",
                description: "Your body is now using fats as an energy source. You can drink salt water to maintain electrolyte balance.",
                icon: "🔥",
                category: .supplements,
                fastingStage: .middle,
                macros: nil,
                foods: ["Himalayan salt + water", "Magnesium supplement"]
            ),
            NutritionTip(
                title: "Meal Prep Time",
                description: "Plan what you'll eat when your fast ends. Prefer light, protein-rich meals.",
                icon: "📦",
                category: .mealPrep,
                fastingStage: .middle,
                macros: NutritionTip.MacroBreakdown(protein: 30, carbs: 20, fats: 15, calories: 335),
                foods: ["Chicken breast", "Vegetables", "Olive oil", "Small portion of rice"]
            ),
            
            // MARK: - Late Fasting (12-16+ hours)
            NutritionTip(
                title: "Autophagy Active",
                description: "After 12+ hours, your body has entered the cellular renewal (autophagy) process. Keep going!",
                icon: "🔬",
                category: .timing,
                fastingStage: .late,
                macros: nil,
                foods: []
            ),
            NutritionTip(
                title: "Final Hours",
                description: "You'll be breaking your fast soon. Remember to keep your first meal light so your stomach is ready.",
                icon: "⏰",
                category: .timing,
                fastingStage: .late,
                macros: nil,
                foods: ["Kefir", "Dates", "Almonds", "Vegetable soup"]
            ),
            
            // MARK: - Breaking Fast
            NutritionTip(
                title: "Break Your Fast Right",
                description: "Choose light and digestion-friendly foods for your first meal. Focus on protein and healthy fats.",
                icon: "🥗",
                category: .breakFast,
                fastingStage: .breaking,
                macros: NutritionTip.MacroBreakdown(protein: 25, carbs: 30, fats: 20, calories: 400),
                foods: ["Eggs", "Avocado", "Vegetables", "Whole grain bread", "Dates"]
            ),
            NutritionTip(
                title: "Ideal Breaking Menu",
                description: "2-3 dates + 1 glass water ➜ wait 20 min ➜ Egg omelet + avocado + veggie salad",
                icon: "🍽️",
                category: .breakFast,
                fastingStage: .breaking,
                macros: NutritionTip.MacroBreakdown(protein: 30, carbs: 35, fats: 25, calories: 480),
                foods: ["Dates", "Eggs", "Avocado", "Greens", "Tomatoes", "Cucumber"]
            ),
            NutritionTip(
                title: "Avoid Overeating",
                description: "Give your stomach time to adjust after fasting. Don't consume too much food in the first 30 minutes.",
                icon: "⚠️",
                category: .timing,
                fastingStage: .breaking,
                macros: nil,
                foods: []
            ),
            
            // MARK: - After Fasting
            NutritionTip(
                title: "Balanced Nutrition",
                description: "Maintain the balance of protein, complex carbs, and healthy fats in your post-fast meals.",
                icon: "⚖️",
                category: .macros,
                fastingStage: .afterFasting,
                macros: NutritionTip.MacroBreakdown(protein: 35, carbs: 40, fats: 20, calories: 480),
                foods: ["Meat/chicken/fish", "Brown rice", "Vegetables", "Olive oil", "Almonds"]
            ),
            NutritionTip(
                title: "Prepare for Next Fast",
                description: "Consume protein and healthy fats in your last meal. This will make your next fast easier.",
                icon: "📦",
                category: .mealPrep,
                fastingStage: .afterFasting,
                macros: NutritionTip.MacroBreakdown(protein: 30, carbs: 25, fats: 18, calories: 380),
                foods: ["Grilled chicken", "Quinoa", "Olive oil", "Broccoli", "Almonds"]
            ),
            NutritionTip(
                title: "Calculate Calories",
                description: "Make sure you reach your daily calorie goal during non-fasting periods. Eating too little can be harmful.",
                icon: "🔢",
                category: .macros,
                fastingStage: .afterFasting,
                macros: nil,
                foods: []
            )
        ]
    }
    
    /// Get appropriate nutrition tip based on fasting status
    func getTipForFastingState(
        isFasting: Bool,
        elapsedHours: Double,
        remainingMinutes: Int
    ) -> NutritionTip {
        let stage: NutritionTip.FastingStage
        
        if !isFasting {
            // Not fasting - show prep tips
            stage = .afterFasting
        } else if remainingMinutes <= 30 {
            // About to finish
            stage = .breaking
        } else if elapsedHours >= 12 {
            // Deep fasting
            stage = .late
        } else if elapsedHours >= 4 {
            // Middle stage
            stage = .middle
        } else {
            // Just started
            stage = .early
        }
        
        let stageTips = tips.filter { $0.fastingStage == stage }
        return stageTips.randomElement() ?? tips[0]
    }
    
    /// Get a random nutrition tip
    func getRandomTip() -> NutritionTip {
        tips.randomElement() ?? tips[0]
    }
    
    /// Get tips for a specific category
    func getTips(for category: NutritionTip.NutritionCategory) -> [NutritionTip] {
        tips.filter { $0.category == category }
    }
    
    /// Get all tips for breaking fast
    func getBreakingFastTips() -> [NutritionTip] {
        tips.filter { $0.fastingStage == .breaking }
    }
}
