import Foundation

/// Calculates calories burned during fasting based on user metrics
class CalorieCalculator {
    static let shared = CalorieCalculator()
    
    private init() {}
    
    // MARK: - BMR Calculation
    
    /// Calculate Basal Metabolic Rate using Mifflin-St Jeor Equation
    func calculateBMR(weight: Double, height: Double, age: Int, gender: User.Gender) -> Double {
        switch gender {
        case .male:
            // Men: BMR = 10W + 6.25H - 5A + 5
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
        case .female:
            // Women: BMR = 10W + 6.25H - 5A - 161
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
        case .other:
            // Average of male and female
            let male = (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
            let female = (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
            return (male + female) / 2
        }
    }
    
    // MARK: - Fasting Calories
    
    /// Calculate total calories burned during fasting period
    func calculateFastingCalories(user: User, fastingHours: Double) -> Double {
        guard let weight = user.weight,
              let height = user.height,
              let age = user.age,
              let gender = user.gender else {
            return 0
        }
        
        let bmr = calculateBMR(weight: weight, height: height, age: age, gender: gender)
        
        // Hourly BMR (base calories per hour)
        let hourlyBMR = bmr / 24.0
        
        // Apply fasting metabolism boost
        let metabolismBoost = calculateMetabolismBoost(fastingHours: fastingHours)
        
        // Total calories = hourly rate * hours * boost
        return hourlyBMR * fastingHours * metabolismBoost
    }
    
    // MARK: - Metabolism Boost
    
    /// Calculate metabolism boost based on fasting duration
    /// - Fasting increases metabolism through various hormonal changes
    private func calculateMetabolismBoost(fastingHours: Double) -> Double {
        switch fastingHours {
        case 0..<4:
            return 1.0 // Normal metabolism (glucose burning)
        case 4..<8:
            return 1.05 // 5% boost (glycogen depletion starts)
        case 8..<12:
            return 1.10 // 10% boost (fat burning increases)
        case 12..<16:
            return 1.15 // 15% boost (ketosis begins)
        case 16..<24:
            return 1.20 // 20% boost (full ketosis)
        case 24..<48:
            return 1.25 // 25% boost (deep ketosis + autophagy)
        default:
            return 1.30 // 30% boost (extended fasting benefits)
        }
    }
    
    // MARK: - Fat Calculation
    
    /// Calculate estimated fat burned (1 gram of fat = 9 calories)
    func calculateFatBurned(caloriesBurned: Double) -> Double {
        return caloriesBurned / 9.0
    }
    
    /// Calculate percentage of calories from fat vs carbs
    func calculateFatBurningPercentage(fastingHours: Double) -> Double {
        switch fastingHours {
        case 0..<4:
            return 0.30 // 30% fat, 70% carbs
        case 4..<8:
            return 0.50 // 50% fat, 50% carbs
        case 8..<12:
            return 0.70 // 70% fat, 30% carbs
        case 12..<16:
            return 0.85 // 85% fat (ketosis)
        default:
            return 0.95 // 95% fat (deep ketosis)
        }
    }
    
    // MARK: - Daily Needs
    
    /// Calculate total daily calorie needs based on activity level
    func calculateDailyCalorieNeeds(user: User, activityLevel: ActivityLevel = .sedentary) -> Double {
        guard let weight = user.weight,
              let height = user.height,
              let age = user.age,
              let gender = user.gender else {
            return 0
        }
        
        let bmr = calculateBMR(weight: weight, height: height, age: age, gender: gender)
        return bmr * activityLevel.multiplier
    }
    
    // MARK: - Activity Level
    
    enum ActivityLevel: String, CaseIterable {
        case sedentary = "sedentary"
        case light = "light"
        case moderate = "moderate"
        case active = "active"
        case extreme = "extreme"
        
        var displayName: String {
            switch self {
            case .sedentary: return "Sedentary (Office Work)"
            case .light: return "Lightly Active (Exercise 1-3 days/week)"
            case .moderate: return "Moderately Active (Exercise 3-5 days/week)"
            case .active: return "Very Active (Exercise 6-7 days/week)"
            case .extreme: return "Extremely Active (Exercise twice/day)"
            }
        }
        
        var multiplier: Double {
            switch self {
            case .sedentary: return 1.2
            case .light: return 1.375
            case .moderate: return 1.55
            case .active: return 1.725
            case .extreme: return 1.9
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get calorie burn rate per hour for current fasting state
    func getHourlyBurnRate(user: User, fastingHours: Double) -> Double {
        guard let weight = user.weight,
              let height = user.height,
              let age = user.age,
              let gender = user.gender else {
            return 0
        }
        
        let bmr = calculateBMR(weight: weight, height: height, age: age, gender: gender)
        let hourlyBMR = bmr / 24.0
        let boost = calculateMetabolismBoost(fastingHours: fastingHours)
        
        return hourlyBMR * boost
    }
    
    /// Format calories for display
    func formatCalories(_ calories: Double) -> String {
        return String(format: "%.0f", calories)
    }
    
    /// Format fat for display
    func formatFat(_ grams: Double) -> String {
        return String(format: "%.1f", grams)
    }
}
