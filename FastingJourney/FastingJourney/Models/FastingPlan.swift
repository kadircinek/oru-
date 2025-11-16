import Foundation

/// Represents a fasting protocol/plan
struct FastingPlan: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let shortDescription: String
    let detailedDescription: String
    let fastingHours: Int?
    let eatingHours: Int?
    let isTimeBased: Bool
    let tags: [String]
    
    init(
        id: UUID = UUID(),
        name: String,
        shortDescription: String,
        detailedDescription: String,
        fastingHours: Int? = nil,
        eatingHours: Int? = nil,
        isTimeBased: Bool = true,
        tags: [String] = []
    ) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.detailedDescription = detailedDescription
        self.fastingHours = fastingHours
        self.eatingHours = eatingHours
        self.isTimeBased = isTimeBased
        self.tags = tags
    }
}

/// Predefined fasting plans
extension FastingPlan {
    static let allPlans: [FastingPlan] = [
        FastingPlan(
            name: "12/12 Circadian Rhythm",
            shortDescription: "Fast for 12 hours, eat during a 12-hour window",
            detailedDescription: "Perfect for beginners! This natural eating pattern aligns with your body's circadian rhythm. Fast for 12 hours (including sleep) and eat during a 12-hour window. For example, stop eating at 8 PM and start again at 8 AM. This helps your body establish a healthy metabolic rhythm.",
            fastingHours: 12,
            eatingHours: 12,
            tags: ["Beginner-friendly", "Natural", "Easy Start"]
        ),
        FastingPlan(
            name: "14/10 Intermittent Fasting",
            shortDescription: "Fast for 14 hours, eat during a 10-hour window",
            detailedDescription: "A gentle step up from 12/12, this method is ideal for those transitioning to intermittent fasting. You fast for 14 hours and have a 10-hour eating window. Many find this sustainable long-term. Try eating from 9 AM to 7 PM.",
            fastingHours: 14,
            eatingHours: 10,
            tags: ["Beginner-friendly", "Sustainable", "Gradual"]
        ),
        FastingPlan(
            name: "16/8 Intermittent Fasting",
            shortDescription: "Fast for 16 hours, eat during an 8-hour window",
            detailedDescription: "16/8 is one of the most popular intermittent fasting methods. You fast for 16 consecutive hours and eat all your meals within an 8-hour eating window. For example, fast from 8 PM to 12 PM the next day. This method is beginner-friendly and works well for most people. Great for weight loss and metabolic health.",
            fastingHours: 16,
            eatingHours: 8,
            tags: ["Popular", "Proven", "Effective"]
        ),
        FastingPlan(
            name: "18/6 Intermittent Fasting",
            shortDescription: "Fast for 18 hours, eat during a 6-hour window",
            detailedDescription: "A more advanced version of time-restricted eating. You fast for 18 hours and have a 6-hour eating window. This requires more discipline but many find it effective for weight management and metabolic benefits. Try starting at 1 PM and eating until 7 PM. Enhanced autophagy benefits.",
            fastingHours: 18,
            eatingHours: 6,
            tags: ["Intermediate", "Effective", "Autophagy"]
        ),
        FastingPlan(
            name: "20/4 (Warrior Diet)",
            shortDescription: "Fast for 20 hours, eat during a 4-hour window",
            detailedDescription: "Also known as the Warrior Diet, this approach involves fasting for 20 hours with a 4-hour eating window. It's more intense and suited for those with fasting experience. The eating window is typically in the evening (4 PM - 8 PM). Inspired by ancient warrior eating patterns. Maximizes fat burning and mental clarity.",
            fastingHours: 20,
            eatingHours: 4,
            tags: ["Advanced", "Intense", "Fat Burning"]
        ),
        FastingPlan(
            name: "OMAD (One Meal A Day)",
            shortDescription: "Eat only one meal per day within 1-2 hours",
            detailedDescription: "OMAD involves eating only once per day within a 1-2 hour window, typically a substantial, nutrient-dense meal. This is an advanced form of intermittent fasting requiring significant commitment and experience. Most people practice this in the evening (6 PM - 8 PM). Maximizes autophagy and metabolic benefits. Not recommended for beginners.",
            fastingHours: 23,
            eatingHours: 1,
            tags: ["Advanced", "Extreme", "Maximum Results"]
        ),
        FastingPlan(
            name: "Eat-Stop-Eat (24-Hour Fast)",
            shortDescription: "Fast for 24 hours, once or twice per week",
            detailedDescription: "Practice a full 24-hour fast once or twice per week. For example, finish dinner at 7 PM and don't eat again until 7 PM the next day. On non-fasting days, eat normally. This approach offers powerful metabolic benefits and is easier to fit into a weekly schedule. Stay well-hydrated during fasting periods.",
            fastingHours: 24,
            eatingHours: nil,
            isTimeBased: true,
            tags: ["Intermediate", "Weekly", "Flexible"]
        ),
        FastingPlan(
            name: "36-Hour Extended Fast",
            shortDescription: "Fast for 36 hours for deeper metabolic benefits",
            detailedDescription: "An extended fast lasting 36 hours. Finish dinner one day and don't eat again until breakfast two days later. This longer fasting period triggers deeper autophagy and cellular repair. Only for experienced fasters. Drink plenty of water, herbal tea, and consider electrolytes. Not recommended more than once per week.",
            fastingHours: 36,
            eatingHours: nil,
            isTimeBased: true,
            tags: ["Advanced", "Extended", "Autophagy"]
        ),
        FastingPlan(
            name: "5:2 Fasting",
            shortDescription: "Eat normally 5 days, restrict calories 2 days",
            detailedDescription: "Eat normally 5 days a week and restrict calorie intake to 500-600 calories on 2 non-consecutive days (e.g., Monday and Thursday). This approach is less restrictive daily but requires discipline on fasting days. Choose nutrient-dense, low-calorie foods on fasting days. Good for those who prefer weekly flexibility over daily restrictions.",
            fastingHours: nil,
            eatingHours: nil,
            isTimeBased: false,
            tags: ["Flexible", "Weekly Pattern", "Moderate"]
        ),
        FastingPlan(
            name: "Alternate Day Fasting",
            shortDescription: "Alternate between fasting and normal eating days",
            detailedDescription: "Alternate between fasting days (consuming 0-500 calories) and regular eating days. This pattern repeats throughout the week. On fasting days, you can have minimal calories or do a complete fast. This can be effective for weight loss and metabolic health, though it requires consistency and may not suit everyone's lifestyle.",
            fastingHours: nil,
            eatingHours: nil,
            isTimeBased: false,
            tags: ["Intermediate", "Structured", "Consistent"]
        ),
        FastingPlan(
            name: "Spontaneous Meal Skipping",
            shortDescription: "Skip meals intuitively when not hungry",
            detailedDescription: "A flexible, intuitive approach to fasting. Skip meals when you're not truly hungry or when it's convenient. This could mean skipping breakfast one day, lunch another, or occasionally skipping dinner. No strict schedule - listen to your body's hunger signals. Great for those who want fasting benefits without rigid schedules.",
            fastingHours: nil,
            eatingHours: nil,
            isTimeBased: false,
            tags: ["Flexible", "Intuitive", "Beginner-friendly"]
        )
    ]
}
