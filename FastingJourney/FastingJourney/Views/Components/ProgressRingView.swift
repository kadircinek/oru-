import SwiftUI

/// Circular progress ring view
struct ProgressRingView: View {
    let progress: Double // 0-100
    let lineWidth: CGFloat = 16
    let remainingTime: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(AppColors.textTertiary.opacity(0.2), lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    AppColors.gradientPrimary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            // Center content
            VStack(spacing: 12) {
                Text(isActive ? "🔥 ACTIVE 🔥" : "💤 READY")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isActive ? AppColors.accent : AppColors.textSecondary)
                    .tracking(1.5)
                
                Text(remainingTime)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.textPrimary)
                
                if isActive {
                    Text("⏱️ Time Remaining")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                } else {
                    Text("🚀 Ready to Start")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    VStack {
        ProgressRingView(progress: 45, remainingTime: "8h 30m", isActive: true)
            .frame(height: 280)
        
        ProgressRingView(progress: 0, remainingTime: "", isActive: false)
            .frame(height: 280)
    }
    .padding()
}
