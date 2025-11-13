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
            VStack(spacing: 8) {
                if isActive {
                    Text(remainingTime)
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Remaining")
                        .font(.captionLarge)
                        .foregroundColor(AppColors.textSecondary)
                } else {
                    VStack(spacing: 4) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(AppColors.primary)
                        
                        Text("Tap to Start")
                            .font(.bodySmall)
                            .foregroundColor(AppColors.textSecondary)
                    }
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
