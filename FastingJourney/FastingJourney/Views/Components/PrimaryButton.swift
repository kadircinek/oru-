import SwiftUI

/// Primary filled button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var isLoading: Bool = false
    var fullWidth: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(AppColors.background)
                }
                
                Text(title)
                    .font(.titleSmall)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: 48)
            .foregroundColor(AppColors.background)
            .background(AppColors.primary)
            .cornerRadius(AppTypography.mediumRadius)
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .disabled(!isEnabled || isLoading)
    }
}

#Preview {
    PrimaryButton(title: "Get Started", action: {})
        .padding()
}
