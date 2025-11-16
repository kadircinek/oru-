import SwiftUI

/// App color palette - Modern Clean Design with Dark Mode support
struct AppColors {
    // MARK: - Primary Colors
    static let primary = Color(red: 0.55, green: 0.76, blue: 0.29) // Fresh lime green
    static let primaryLight = Color(red: 0.75, green: 0.88, blue: 0.55) // Light green
    static let primaryDark = Color(red: 0.35, green: 0.55, blue: 0.15) // Darker green for better contrast
    
    // MARK: - Secondary Colors
    static let accent = Color(red: 0.55, green: 0.76, blue: 0.29) // Same as primary
    static let accentLight = Color(red: 0.85, green: 0.95, blue: 0.75) // Very light green
    
    // MARK: - Background (Adaptive for Dark Mode)
    static let background = Color(.systemBackground) // Adaptive: white in light, black in dark
    static let cardBackground = Color(.secondarySystemBackground) // Adaptive card background
    static let surfaceBackground = Color(.tertiarySystemBackground) // Adaptive surface
    
    // MARK: - Text (Adaptive for Dark Mode)
    static let textPrimary = Color(.label) // Adaptive: black in light, white in dark
    static let textSecondary = Color(.secondaryLabel) // Adaptive secondary text
    static let textTertiary = Color(.tertiaryLabel) // Adaptive tertiary text
    static let textOnPrimary = Color.white // White text on colored backgrounds
    static let textOnLight = Color(red: 0.2, green: 0.2, blue: 0.2) // Dark text on light backgrounds
    
    // MARK: - Semantic
    static let success = Color(red: 0.35, green: 0.65, blue: 0.20) // Darker green for better contrast
    static let warning = Color(red: 0.95, green: 0.65, blue: 0.15) // Darker orange
    static let error = Color(red: 0.90, green: 0.25, blue: 0.25) // Darker red
    static let blue = Color(red: 0.20, green: 0.55, blue: 0.85) // Darker blue
    static let purple = Color(red: 0.55, green: 0.40, blue: 0.85) // Darker purple
    static let orange = Color(red: 0.95, green: 0.50, blue: 0.10) // Darker orange
    
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
