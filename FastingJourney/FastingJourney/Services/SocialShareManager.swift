import SwiftUI
import UIKit

/// Manages social media sharing of progress and achievements
@MainActor
class SocialShareManager {
    static let shared = SocialShareManager()
    
    private init() {}
    
    // MARK: - Share Progress Card
    
    /// Creates and shares a beautiful progress card
    func shareProgress(
        title: String,
        stats: [ShareStat],
        emoji: String = "🔥",
        backgroundColor: Color = AppColors.primary,
        completion: @escaping (UIImage?) -> Void
    ) {
        let renderer = ImageRenderer(content: ProgressShareCard(
            title: title,
            stats: stats,
            emoji: emoji,
            backgroundColor: backgroundColor
        ))
        
        renderer.scale = 3.0 // High quality
        
        DispatchQueue.main.async {
            completion(renderer.uiImage)
        }
    }
    
    /// Shares weight progress
    func shareWeightProgress(
        currentWeight: Double,
        startWeight: Double,
        unit: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        let loss = startWeight - currentWeight
        let lossText = loss > 0 ? "-\(String(format: "%.1f", loss))" : "+\(String(format: "%.1f", abs(loss)))"
        
        let stats = [
            ShareStat(label: "Current", value: "\(String(format: "%.1f", currentWeight)) \(unit)", icon: "scalemass.fill"),
            ShareStat(label: "Progress", value: "\(lossText) \(unit)", icon: "arrow.down.circle.fill"),
            ShareStat(label: "Start", value: "\(String(format: "%.1f", startWeight)) \(unit)", icon: "flag.fill")
        ]
        
        shareProgress(
            title: "Weight Loss Journey",
            stats: stats,
            emoji: "💪",
            backgroundColor: AppColors.success,
            completion: completion
        )
    }
    
    /// Shares fasting achievement
    func shareFastingAchievement(
        hoursCompleted: Int,
        totalFasts: Int,
        streak: Int,
        completion: @escaping (UIImage?) -> Void
    ) {
        let stats = [
            ShareStat(label: "Last Fast", value: "\(hoursCompleted)h", icon: "clock.fill"),
            ShareStat(label: "Total Fasts", value: "\(totalFasts)", icon: "checkmark.circle.fill"),
            ShareStat(label: "Streak", value: "\(streak) days", icon: "flame.fill")
        ]
        
        shareProgress(
            title: "Fasting Journey",
            stats: stats,
            emoji: "🔥",
            backgroundColor: AppColors.primary,
            completion: completion
        )
    }
    
    /// Shares milestone achievement
    func shareMilestone(
        title: String,
        description: String,
        emoji: String = "🎉",
        completion: @escaping (UIImage?) -> Void
    ) {
        let stats = [
            ShareStat(label: "Achievement Unlocked", value: description, icon: "star.fill")
        ]
        
        shareProgress(
            title: title,
            stats: stats,
            emoji: emoji,
            backgroundColor: AppColors.warning,
            completion: completion
        )
    }
    
    /// Shares buddy session
    func shareBuddySession(
        buddyName: String,
        planName: String,
        duration: TimeInterval,
        completion: @escaping (UIImage?) -> Void
    ) {
        let hours = Int(duration / 3600)
        let stats = [
            ShareStat(label: "Fasting With", value: buddyName, icon: "person.2.fill"),
            ShareStat(label: "Plan", value: planName, icon: "calendar"),
            ShareStat(label: "Duration", value: "\(hours)h", icon: "clock.fill")
        ]
        
        shareProgress(
            title: "Fasting Together",
            stats: stats,
            emoji: "🤝",
            backgroundColor: AppColors.primary,
            completion: completion
        )
    }
    
    // MARK: - Share Actions
    
    /// Presents system share sheet
    func presentShareSheet(image: UIImage?, text: String, from viewController: UIViewController?) {
        guard let image = image else { return }
        
        let textToShare = "\(text)\n\n#FastingJourney #IntermittentFasting #HealthyLifestyle"
        let itemsToShare: [Any] = [textToShare, image]
        
        let activityVC = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        
        // Exclude some activities
        activityVC.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks
        ]
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController?.view
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
                                       y: UIScreen.main.bounds.height / 2,
                                       width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController?.present(activityVC, animated: true)
    }
    
    /// Saves image to photo library
    func saveToPhotos(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        completion(true, nil)
    }
}

// MARK: - Share Stat Model

struct ShareStat {
    let label: String
    let value: String
    let icon: String
}

// MARK: - Progress Share Card View

struct ProgressShareCard: View {
    let title: String
    let stats: [ShareStat]
    let emoji: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 60))
                
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                LinearGradient(
                    colors: [backgroundColor, backgroundColor.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Stats
            VStack(spacing: 20) {
                ForEach(stats.indices, id: \.self) { index in
                    HStack(spacing: 16) {
                        Image(systemName: stats[index].icon)
                            .font(.system(size: 24))
                            .foregroundColor(backgroundColor)
                            .frame(width: 40)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stats[index].label)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text(stats[index].value)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    if index < stats.count - 1 {
                        Divider()
                            .padding(.horizontal, 24)
                    }
                }
            }
            .padding(.vertical, 30)
            .background(Color(.systemBackground))
            
            // Footer
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 16))
                    .foregroundColor(backgroundColor)
                
                Text("Fasting Journey")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(.systemGray6))
        }
        .frame(width: 400, height: 600)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
    }
}

// MARK: - SwiftUI Helper for Sharing

struct ShareButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.primary.opacity(0.1))
            )
        }
    }
}

// MARK: - View Controller Helper

extension View {
    func getViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return nil
        }
        
        var currentVC = rootVC
        while let presentedVC = currentVC.presentedViewController {
            currentVC = presentedVC
        }
        
        return currentVC
    }
}
