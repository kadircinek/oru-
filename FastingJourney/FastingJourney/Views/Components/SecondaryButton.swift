import SwiftUI

/// Secondary outlined button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var fullWidth: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.titleSmall)
                .fontWeight(.semibold)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .frame(height: 48)
                .foregroundColor(AppColors.primary)
                .background(AppColors.cardBackground)
                .border(AppColors.primary, width: 2)
                .cornerRadius(AppTypography.mediumRadius)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

#Preview {
    SecondaryButton(title: "Cancel", action: {})
        .padding()
}
