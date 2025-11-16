import SwiftUI

/// Comprehensive health tips library view
struct HealthTipsView: View {
    @State private var selectedCategory: HealthTip.TipCategory? = nil
    @State private var searchText = ""
    
    private var filteredTips: [HealthTip] {
        let tips: [HealthTip]
        if let category = selectedCategory {
            tips = HealthTipsProvider.shared.getTips(for: category)
        } else {
            tips = HealthTipsProvider.shared.allTips
        }
        
        if searchText.isEmpty {
            return tips
        } else {
            return tips.filter { tip in
                tip.title.localizedCaseInsensitiveContains(searchText) ||
                tip.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Health Tips")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Expert guidance for your fasting journey")
                            .font(.system(size: 15))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.textSecondary)
                        TextField("Search tips...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryPill(
                                emoji: "📚",
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(HealthTip.TipCategory.allCases, id: \.self) { category in
                                CategoryPill(
                                    emoji: category.emoji,
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Tips Grid
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTips) { tip in
                            HealthTipCard(tip: tip)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if filteredTips.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "text.magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(AppColors.textSecondary)
                            Text("No tips found")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            Text("Try a different search or category")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, 40)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supporting Views

struct CategoryPill: View {
    let emoji: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ?
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.primary, AppColors.accent]),
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.cardBackground, AppColors.cardBackground]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : AppColors.accentLight, lineWidth: 1)
            )
        }
    }
}

struct HealthTipCard: View {
    let tip: HealthTip
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Text(tip.icon)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(tip.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Text(tip.category.emoji)
                            .font(.system(size: 18))
                    }
                    
                    Text(tip.description)
                        .font(.system(size: 15))
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Text(tip.category.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AppColors.primary.opacity(0.1))
                            .cornerRadius(8)
                        
                        if let range = tip.fastingHourRange {
                            Text("⏱️ Hour \(range.lowerBound)-\(range.upperBound)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AppColors.accent.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        HealthTipsView()
    }
}
