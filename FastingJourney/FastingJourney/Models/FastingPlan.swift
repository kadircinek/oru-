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
            name: "16/8 Intermittent Fasting",
            shortDescription: "Fast for 16 hours, eat during an 8-hour window",
            detailedDescription: "16/8 is one of the most popular intermittent fasting methods. You fast for 16 consecutive hours and eat all your meals within an 8-hour eating window. For example, fast from 8 PM to 12 PM the next day. This method is beginner-friendly and works well for most people.",
            fastingHours: 16,
            eatingHours: 8,
            tags: ["Popular", "Beginner-friendly"]
        ),
        FastingPlan(
            name: "18/6 Intermittent Fasting",
            shortDescription: "Fast for 18 hours, eat during a 6-hour window",
            detailedDescription: "A more advanced version of time-restricted eating. You fast for 18 hours and have a 6-hour eating window. This requires more discipline but many find it effective for weight management and metabolic benefits. Try starting at 10 AM and eating until 4 PM.",
            fastingHours: 18,
            eatingHours: 6,
            tags: ["Intermediate", "Effective"]
        ),
        FastingPlan(
            name: "20/4 (Warrior Diet)",
            shortDescription: "Fast for 20 hours, eat during a 4-hour window",
            detailedDescription: "Also known as the Warrior Diet, this approach involves fasting for 20 hours with a 4-hour eating window. It's more intense and suited for those with fasting experience. The eating window is typically in the evening.",
            fastingHours: 20,
            eatingHours: 4,
            tags: ["Advanced", "Intense"]
        ),
        FastingPlan(
            name: "OMAD (One Meal A Day)",
            shortDescription: "Eat only one meal per day",
            detailedDescription: "OMAD involves eating only once per day, typically a substantial meal. This is an extreme form of intermittent fasting requiring significant commitment. Most people practice this once per day in the evening.",
            fastingHours: 23,
            eatingHours: 1,
            tags: ["Advanced", "Extreme"]
        ),
        FastingPlan(
            name: "5:2 Fasting",
            shortDescription: "Eat normally 5 days, restrict calories 2 days",
            detailedDescription: "Eat normally 5 days a week and restrict calorie intake to 500-600 calories on 2 non-consecutive days. This approach is less restrictive daily but requires discipline on fasting days.",
            fastingHours: nil,
            eatingHours: nil,
            isTimeBased: false,
            tags: ["Flexible", "Beginner-friendly"]
        ),
        FastingPlan(
            name: "Alternate Day Fasting",
            shortDescription: "Alternate between fasting and normal eating days",
            detailedDescription: "Alternate between fasting days (consuming 0-500 calories) and regular eating days. This pattern repeats throughout the week and can be effective for some people, though it requires consistency.",
            fastingHours: nil,
            eatingHours: nil,
            isTimeBased: false,
            tags: ["Intermediate", "Structured"]
        )
    ]
}
