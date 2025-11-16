import SwiftUI

struct HydrationRingView: View {
    let progress: Double
    let consumedMl: Int
    let targetMl: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.textTertiary.opacity(0.2), lineWidth: 20)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColors.accent.gradient, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)
            
            VStack(spacing: 8) {
                Text("💧")
                    .font(.system(size: 36))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(progress >= 1.0 ? AppColors.success : AppColors.blue)
                
                Text("Hydrated!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                HStack(spacing: 4) {
                    Text("\(consumedMl)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppColors.blue)
                    Text("/")
                        .foregroundColor(AppColors.textTertiary)
                    Text("\(targetMl) ml")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                if progress >= 1.0 {
                    Text("🎉 Goal Complete!")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.success)
                        .padding(.top, 4)
                }
            }
        }
    }
}

#Preview {
    HydrationRingView(progress: 0.65, consumedMl: 1625, targetMl: 2500)
        .frame(width: 220, height: 220)
        .padding()
}
