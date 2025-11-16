import Foundation

/// Provides motivational quotes for fasting journey
struct MotivationalQuotesProvider {
    static let shared = MotivationalQuotesProvider()
    
    private let quotes: [String] = [
        "Stay strong! Every hour is an achievement. 💪",
        "You're doing great! Your body thanks you. 🌟",
        "Discipline is the path to freedom. Keep going! 🎯",
        "You can do this! You're stronger every moment. ⚡️",
        "You're showing amazing willpower! 🏆",
        "Today's success is tomorrow's habit. 🌱",
        "Every difficulty has its ease. Be patient. 🧘",
        "Believe in yourself, success is near! 🚀",
        "Your body is healing, you're getting stronger. 💚",
        "Focus on your goal, success is with you! 🎪",
        "You're doing perfectly! Keep it up! 👏",
        "With your willpower, you can move mountains! ⛰️",
        "Every hour brings you one step closer! 🏃",
        "Success is in your hands, don't let go! 🔥",
        "Your self-respect is growing! 🙏",
        "Healthy life, happy life! 😊",
        "You're a champion! 🥇",
        "No giving up! The goal is so close! 🎯",
        "Every challenge is temporary, success is permanent! 💎",
        "Amazing performance! 🌟"
    ]
    
    /// Get a random motivational quote
    func getRandomQuote() -> String {
        quotes.randomElement() ?? "Keep going! 💪"
    }
    
    /// Get a motivational quote for a specific fasting hour
    func getQuoteForHour(_ hour: Int) -> String {
        switch hour {
        case 0...4:
            return "Great start! Keep it up! 🌅"
        case 5...8:
            return "You're doing awesome! Your body started burning fat! 🔥"
        case 9...12:
            return "Autophagy initiated! Major cellular repairs happening! 🧬"
        case 13...16:
            return "Incredible willpower! Metabolic miracles are occurring! ⚡️"
        case 17...20:
            return "You're a champion! Your body is being reborn! 🏆"
        default:
            return "You're legendary! Keep going! 🌟"
        }
    }
}
