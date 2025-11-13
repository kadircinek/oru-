import SwiftUI

/// App typography system
extension Font {
    // MARK: - Display
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)
    static let displaySmall = Font.system(size: 24, weight: .bold, design: .default)
    
    // MARK: - Headlines
    static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .default)
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .default)
    static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .default)
    
    // MARK: - Title
    static let titleLarge = Font.system(size: 20, weight: .semibold, design: .default)
    static let titleMedium = Font.system(size: 18, weight: .semibold, design: .default)
    static let titleSmall = Font.system(size: 16, weight: .semibold, design: .default)
    
    // MARK: - Body
    static let bodyLarge = Font.system(size: 18, weight: .regular, design: .default)
    static let bodyRegular = Font.system(size: 16, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)
    
    // MARK: - Label
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
    
    // MARK: - Caption
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .default)
    static let captionMedium = Font.system(size: 11, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .default)
}

/// App text styling helpers
struct AppTypography {
    // MARK: - Spacing
    static let xxSmall: CGFloat = 4
    static let xSmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 20
    static let xLarge: CGFloat = 24
    static let xxLarge: CGFloat = 32
    
    // MARK: - Corner Radius
    static let xSmallRadius: CGFloat = 6
    static let smallRadius: CGFloat = 8
    static let mediumRadius: CGFloat = 12
    static let largeRadius: CGFloat = 16
    static let xLargeRadius: CGFloat = 24
    static let xxLargeRadius: CGFloat = 32
    
    // MARK: - Shadow
    static let shadowSmall = Shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    static let shadowMedium = Shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    static let shadowLarge = Shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
}

/// Shadow definition
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
