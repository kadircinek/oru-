import SwiftUI

/// App color palette - Nature Green Theme
struct AppColors {
    // MARK: - Primary Colors (Forest Green)
    static let primary = Color(red: 0.25, green: 0.55, blue: 0.3) // Deep forest green
    static let primaryLight = Color(red: 0.45, green: 0.75, blue: 0.5) // Light sage green
    static let primaryDark = Color(red: 0.15, green: 0.4, blue: 0.2) // Dark forest
    
    // MARK: - Secondary Colors (Earthy Accent)
    static let accent = Color(red: 0.6, green: 0.75, blue: 0.3) // Fresh moss green
    static let accentLight = Color(red: 0.8, green: 0.9, blue: 0.5) // Lime green
    
    // MARK: - Background (Warm Natural Tones)
    static let background = Color(red: 0.95, green: 0.97, blue: 0.92) // Soft cream-green
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 0.96) // Pale mint
    static let surfaceBackground = Color(red: 0.92, green: 0.96, blue: 0.88) // Light sage
    
    // MARK: - Text
    static let textPrimary = Color.black
    static let textSecondary = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let textTertiary = Color(red: 0.8, green: 0.8, blue: 0.8)
    
    // MARK: - Semantic
    static let success = Color(red: 0.2, green: 0.7, blue: 0.3) // Natural green
    static let warning = Color(red: 0.95, green: 0.75, blue: 0.2) // Golden yellow
    static let error = Color(red: 0.85, green: 0.35, blue: 0.35) // Warm red
    
    // MARK: - Gradients (Nature Green Theme)
    static let gradientPrimary = LinearGradient(
        gradient: Gradient(colors: [primaryLight, primary]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientWarm = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.6, green: 0.8, blue: 0.3),
            Color(red: 0.45, green: 0.7, blue: 0.25)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCool = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.3, green: 0.6, blue: 0.4),
            Color(red: 0.2, green: 0.45, blue: 0.3)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
