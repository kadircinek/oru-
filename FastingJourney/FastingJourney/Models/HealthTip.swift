import Foundation

/// Health tip model for fasting guidance
struct HealthTip: Identifiable, Codable {
    let id: String
    let category: TipCategory
    let title: String
    let description: String
    let icon: String
    let fastingHourRange: ClosedRange<Int>? // nil means applies to all hours
    
    init(id: String = UUID().uuidString, category: TipCategory, title: String, description: String, icon: String, fastingHourRange: ClosedRange<Int>? = nil) {
        self.id = id
        self.category = category
        self.title = title
        self.description = description
        self.icon = icon
        self.fastingHourRange = fastingHourRange
    }
    
    enum TipCategory: String, Codable, CaseIterable {
        case nutrition = "Nutrition"
        case hydration = "Hydration"
        case exercise = "Exercise"
        case mental = "Mental Health"
        case general = "General"
        case science = "Science"
        
        var emoji: String {
            switch self {
            case .nutrition: return "🍎"
            case .hydration: return "💧"
            case .exercise: return "🏃"
            case .mental: return "🧠"
            case .general: return "💡"
            case .science: return "🔬"
            }
        }
        
        var color: String {
            switch self {
            case .nutrition: return "green"
            case .hydration: return "blue"
            case .exercise: return "orange"
            case .mental: return "purple"
            case .general: return "primary"
            case .science: return "accent"
            }
        }
    }
}

/// Health tips data provider
class HealthTipsProvider {
    static let shared = HealthTipsProvider()
    
    private init() {}
    
    // MARK: - All Tips Library
    
    var allTips: [HealthTip] {
        return nutritionTips + hydrationTips + exerciseTips + mentalTips + generalTips + scienceTips
    }
    
    // MARK: - Nutrition Tips
    
    private var nutritionTips: [HealthTip] {
        [
            HealthTip(
                category: .nutrition,
                title: "Break Your Fast Gently",
                description: "Start with light foods like fruits or soup. Your stomach has shrunk during fasting, heavy meals can cause discomfort.",
                icon: "🥗"
            ),
            HealthTip(
                category: .nutrition,
                title: "Prioritize Protein",
                description: "Protein-rich foods keep you fuller longer and help maintain muscle mass during fasting periods.",
                icon: "🥚"
            ),
            HealthTip(
                category: .nutrition,
                title: "Avoid Sugar Spikes",
                description: "Breaking fast with sugary foods causes energy crashes. Choose complex carbs and protein instead.",
                icon: "🍬"
            ),
            HealthTip(
                category: .nutrition,
                title: "Healthy Fats Matter",
                description: "Include avocado, nuts, and olive oil in your eating window. They support hormone balance and satiety.",
                icon: "🥑"
            ),
            HealthTip(
                category: .nutrition,
                title: "Fiber is Your Friend",
                description: "Vegetables and whole grains help digestion and keep you satisfied longer between fasting periods.",
                icon: "🥦"
            )
        ]
    }
    
    // MARK: - Hydration Tips
    
    private var hydrationTips: [HealthTip] {
        [
            HealthTip(
                category: .hydration,
                title: "Water First Thing",
                description: "Start your eating window with a glass of water. It helps rehydration and aids digestion.",
                icon: "💧"
            ),
            HealthTip(
                category: .hydration,
                title: "Sip Throughout the Day",
                description: "Drink 250ml water every hour during eating window. Consistent hydration is key.",
                icon: "🚰"
            ),
            HealthTip(
                category: .hydration,
                title: "Coffee ≠ Water",
                description: "Caffeine doesn't count toward hydration. Drink extra water if you consume coffee or tea.",
                icon: "☕"
            ),
            HealthTip(
                category: .hydration,
                title: "Electrolytes Matter",
                description: "During longer fasts, consider electrolyte supplements or mineral water to maintain balance.",
                icon: "⚡"
            ),
            HealthTip(
                category: .hydration,
                title: "Herbal Teas Count",
                description: "Caffeine-free herbal teas contribute to hydration and can help curb hunger during fasting.",
                icon: "🫖"
            )
        ]
    }
    
    // MARK: - Exercise Tips
    
    private var exerciseTips: [HealthTip] {
        [
            HealthTip(
                category: .exercise,
                title: "Light Movement is Best",
                description: "Walking, yoga, or light stretching during fasting helps circulation without depleting energy.",
                icon: "🚶",
                fastingHourRange: 0...24
            ),
            HealthTip(
                category: .exercise,
                title: "Timing Your Workout",
                description: "Intense workouts are best done just before breaking your fast for optimal recovery.",
                icon: "🏋️"
            ),
            HealthTip(
                category: .exercise,
                title: "Listen to Your Body",
                description: "If you feel dizzy or weak during exercise while fasting, stop and rest. Safety first!",
                icon: "❤️"
            ),
            HealthTip(
                category: .exercise,
                title: "Fasted Cardio Benefits",
                description: "Light cardio during fasting can enhance fat burning, but keep intensity moderate.",
                icon: "🏃"
            ),
            HealthTip(
                category: .exercise,
                title: "Post-Fast Strength Training",
                description: "Schedule strength training in your eating window for better performance and recovery.",
                icon: "💪"
            )
        ]
    }
    
    // MARK: - Mental Health Tips
    
    private var mentalTips: [HealthTip] {
        [
            HealthTip(
                category: .mental,
                title: "Fasting & Meditation",
                description: "Fasting enhances focus and mindfulness. Try meditation during your fast for mental clarity.",
                icon: "🧘",
                fastingHourRange: 8...24
            ),
            HealthTip(
                category: .mental,
                title: "Mental Clarity Peak",
                description: "Many people experience peak mental clarity after 16 hours of fasting due to ketone production.",
                icon: "🧠",
                fastingHourRange: 16...24
            ),
            HealthTip(
                category: .mental,
                title: "Manage Stress",
                description: "High stress can trigger hunger. Practice deep breathing or take a walk when feeling stressed.",
                icon: "😌"
            ),
            HealthTip(
                category: .mental,
                title: "Sleep Quality",
                description: "Fasting can improve sleep quality. Try to finish eating 2-3 hours before bedtime.",
                icon: "😴"
            ),
            HealthTip(
                category: .mental,
                title: "Stay Busy",
                description: "Keep your mind occupied during fasting. Work on projects, read, or engage in hobbies.",
                icon: "📚"
            )
        ]
    }
    
    // MARK: - General Tips
    
    private var generalTips: [HealthTip] {
        [
            HealthTip(
                category: .general,
                title: "Start Slow",
                description: "If you're new to fasting, start with 12-14 hours and gradually increase as your body adapts.",
                icon: "🌱",
                fastingHourRange: 0...4
            ),
            HealthTip(
                category: .general,
                title: "First Hours are Hardest",
                description: "Initial hunger pangs are normal. They usually pass within 20-30 minutes. Stay strong!",
                icon: "💪",
                fastingHourRange: 0...6
            ),
            HealthTip(
                category: .general,
                title: "Consistency is Key",
                description: "Regular fasting schedules help your body adapt. Stick to similar timing each day.",
                icon: "📅"
            ),
            HealthTip(
                category: .general,
                title: "Social Situations",
                description: "Plan your fasting window around social events. Flexibility is okay occasionally!",
                icon: "👥"
            ),
            HealthTip(
                category: .general,
                title: "Track Your Progress",
                description: "Keep notes on how you feel. This helps identify what works best for your body.",
                icon: "📊"
            )
        ]
    }
    
    // MARK: - Science Tips
    
    private var scienceTips: [HealthTip] {
        [
            HealthTip(
                category: .science,
                title: "Autophagy Activation",
                description: "After 12-16 hours, your body starts autophagy - cellular cleanup and renewal process.",
                icon: "🔬",
                fastingHourRange: 12...24
            ),
            HealthTip(
                category: .science,
                title: "Fat Burning Mode",
                description: "Around 4-8 hours in, your body switches from glucose to fat burning as primary energy source.",
                icon: "🔥",
                fastingHourRange: 4...12
            ),
            HealthTip(
                category: .science,
                title: "Ketosis State",
                description: "Deep ketosis typically begins after 16+ hours, producing ketones that fuel your brain.",
                icon: "⚡",
                fastingHourRange: 16...24
            ),
            HealthTip(
                category: .science,
                title: "Growth Hormone Boost",
                description: "Fasting can increase growth hormone levels by up to 5x, aiding fat loss and muscle gain.",
                icon: "📈"
            ),
            HealthTip(
                category: .science,
                title: "Insulin Sensitivity",
                description: "Regular fasting improves insulin sensitivity, helping regulate blood sugar levels.",
                icon: "🩸"
            )
        ]
    }
    
    // MARK: - Helper Methods
    
    /// Get tips for specific fasting hour
    func getTipsForHour(_ hour: Int) -> [HealthTip] {
        return allTips.filter { tip in
            if let range = tip.fastingHourRange {
                return range.contains(hour)
            }
            return true
        }
    }
    
    /// Get tips by category
    func getTips(for category: HealthTip.TipCategory) -> [HealthTip] {
        return allTips.filter { $0.category == category }
    }
    
    /// Get random tip
    func getRandomTip() -> HealthTip {
        return allTips.randomElement() ?? allTips[0]
    }
    
    /// Get daily tip (changes each day)
    func getDailyTip() -> HealthTip {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % allTips.count
        return allTips[index]
    }
    
    /// Get most relevant tip for current fasting state
    func getCurrentTip(fastingHours: Int) -> HealthTip {
        let relevantTips = getTipsForHour(fastingHours)
        return relevantTips.randomElement() ?? getRandomTip()
    }
}
