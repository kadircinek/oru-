import SwiftUI

/// App color palette - Modern Clean Design
struct AppColors {
    // MARK: - Primary Colors
    static let primary = Color(red: 0.55, green: 0.76, blue: 0.29) // Fresh lime green
    static let primaryLight = Color(red: 0.75, green: 0.88, blue: 0.55) // Light green
    static let primaryDark = Color(red: 0.40, green: 0.60, blue: 0.20) // Dark green
    
    // MARK: - Secondary Colors
    static let accent = Color(red: 0.55, green: 0.76, blue: 0.29) // Same as primary
    static let accentLight = Color(red: 0.85, green: 0.95, blue: 0.75) // Very light green
    
    // MARK: - Background
    static let background = Color(red: 0.98, green: 0.98, blue: 0.98) // Off-white
    static let cardBackground = Color.white
    static let surfaceBackground = Color(red: 0.96, green: 0.96, blue: 0.96)
    
    // MARK: - Text
    static let textPrimary = Color.black
    static let textSecondary = Color(red: 0.55, green: 0.55, blue: 0.55)
    static let textTertiary = Color(red: 0.75, green: 0.75, blue: 0.75)
    
    // MARK: - Semantic
    static let success = Color(red: 0.55, green: 0.76, blue: 0.29)
    static let warning = Color(red: 1.0, green: 0.73, blue: 0.25)
    static let error = Color(red: 1.0, green: 0.34, blue: 0.34)
    static let blue = Color(red: 0.30, green: 0.69, blue: 0.95)
    static let purple = Color(red: 0.67, green: 0.55, blue: 0.95)
    static let orange = Color(red: 1.0, green: 0.60, blue: 0.20)
    
    // MARK: - Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(red: 0.55, green: 0.76, blue: 0.29), Color(red: 0.65, green: 0.85, blue: 0.35)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gradientOrange = LinearGradient(
        colors: [Color(red: 1.0, green: 0.73, blue: 0.25), Color(red: 1.0, green: 0.60, blue: 0.20)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gradientPurple = LinearGradient(
        colors: [Color(red: 0.67, green: 0.55, blue: 0.95), Color(red: 0.77, green: 0.65, blue: 0.95)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gradientBlue = LinearGradient(
        colors: [Color(red: 0.30, green: 0.69, blue: 0.95), Color(red: 0.40, green: 0.78, blue: 0.98)],
        startPoint: .leading,
        endPoint: .trailing
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
