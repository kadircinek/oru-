import Foundation

/// Represents a nutrition tip or meal recommendation
struct NutritionTip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let category: NutritionCategory
    let fastingStage: FastingStage
    let macros: MacroBreakdown?
    let foods: [String]
    
    enum NutritionCategory: String {
        case breakFast = "Breaking Fast"
        case mealPrep = "Meal Prep"
        case hydration = "Hydration"
        case macros = "Macros"
        case supplements = "Supplements"
        case timing = "Timing"
        
        var emoji: String {
            switch self {
            case .breakFast: return "🍽️"
            case .mealPrep: return "📦"
            case .hydration: return "💧"
            case .macros: return "⚖️"
            case .supplements: return "💊"
            case .timing: return "⏰"
            }
        }
        
        var color: String {
            switch self {
            case .breakFast: return "orange"
            case .mealPrep: return "purple"
            case .hydration: return "blue"
            case .macros: return "green"
            case .supplements: return "pink"
            case .timing: return "yellow"
            }
        }
    }
    
    enum FastingStage {
        case beforeFasting   // Before starting fast
        case early           // 0-4 hours
        case middle          // 4-12 hours
        case late            // 12-16 hours
        case breaking        // Time to break fast
        case afterFasting    // After fasting
    }
    
    struct MacroBreakdown {
        let protein: Int  // grams
        let carbs: Int    // grams
        let fats: Int     // grams
        let calories: Int
        
        var proteinPercent: Int { (protein * 4 * 100) / calories }
        var carbsPercent: Int { (carbs * 4 * 100) / calories }
        var fatsPercent: Int { (fats * 9 * 100) / calories }
    }
}
