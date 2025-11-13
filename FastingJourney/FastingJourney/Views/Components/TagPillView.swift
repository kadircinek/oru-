import SwiftUI

/// Small rounded tag/pill
struct TagPillView: View {
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        Text(text)
            .font(.labelSmall)
            .foregroundColor(isSelected ? AppColors.background : AppColors.primary)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(isSelected ? AppColors.primary : AppColors.primaryLight.opacity(0.2))
            .cornerRadius(12)
    }
}

#Preview {
    HStack(spacing: 8) {
        TagPillView(text: "Popular", isSelected: false)
        TagPillView(text: "Beginner-friendly", isSelected: true)
        TagPillView(text: "Advanced", isSelected: false)
    }
    .padding()
}
