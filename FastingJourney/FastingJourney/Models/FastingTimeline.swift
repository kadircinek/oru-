import Foundation
import SwiftUI

/// Represents a physiological milestone during a fasting window
struct FastingTimelineEntry: Identifiable, Codable {
    var id = UUID()
    let hourFromStart: Int               // Hour mark since fast began
    let title: String                    // Short stage title
    let detail: String                   // Description of body changes
    let systemIcon: String               // SF Symbol
    let category: StageCategory          // Grouping category
    
    enum StageCategory: String, Codable {
        case metabolic
        case hormonal
        case cellular
        case recovery
    }
    
    enum CodingKeys: String, CodingKey {
        case hourFromStart, title, detail, systemIcon, category
    }
}

/// Provides a science-informed (generalized) sequence of fasting milestones.
/// NOTE: Individual responses vary. Times are approximate based on commonly reported ranges in literature.
struct FastingTimelineProvider {
    static let entries: [FastingTimelineEntry] = [
        FastingTimelineEntry(
            hourFromStart: 0,
            title: "Fed State",
            detail: "Blood glucose from recent meal is primary fuel; insulin elevated.",
            systemIcon: "fork.knife",
            category: .metabolic
        ),
        FastingTimelineEntry(
            hourFromStart: 4,
            title: "Post-Absorptive",
            detail: "Insulin begins to fall; liver glycogen starts gradual utilization.",
            systemIcon: "drop",
            category: .metabolic
        ),
        FastingTimelineEntry(
            hourFromStart: 8,
            title: "Early Fat Mobilization",
            detail: "Lipolysis increases; body shifts toward fatty acid usage for energy.",
            systemIcon: "flame",
            category: .metabolic
        ),
        FastingTimelineEntry(
            hourFromStart: 12,
            title: "Lower Insulin / Mild Ketones",
            detail: "Insulin lower; mild ketone production may begin in some individuals.",
            systemIcon: "aqi.medium",
            category: .metabolic
        ),
        FastingTimelineEntry(
            hourFromStart: 16,
            title: "Ketogenic Shift",
            detail: "Increased fatty acid oxidation; ketone levels rising; autophagy may initiate.",
            systemIcon: "bolt.horizontal.circle",
            category: .cellular
        ),
        FastingTimelineEntry(
            hourFromStart: 20,
            title: "Growth Hormone Elevation",
            detail: "Growth hormone secretion elevated supporting fat utilization & tissue repair.",
            systemIcon: "arrow.up.circle",
            category: .hormonal
        ),
        FastingTimelineEntry(
            hourFromStart: 24,
            title: "Deep Glycogen Depletion",
            detail: "Liver glycogen low; predominant fat-derived fuels; autophagy activity increases.",
            systemIcon: "chart.line.uptrend.xyaxis",
            category: .cellular
        ),
        FastingTimelineEntry(
            hourFromStart: 30,
            title: "Enhanced Autophagy",
            detail: "Cellular cleanup intensifies; dysfunctional components tagged & recycled.",
            systemIcon: "leaf",
            category: .cellular
        ),
        FastingTimelineEntry(
            hourFromStart: 36,
            title: "Deeper Ketosis",
            detail: "Ketone levels higher; brain efficiently using ketones & conserving glucose.",
            systemIcon: "brain.head.profile",
            category: .metabolic
        ),
        FastingTimelineEntry(
            hourFromStart: 48,
            title: "Sustained Cellular Recycling",
            detail: "Prolonged autophagy & metabolic adaptation; inflammatory markers may reduce.",
            systemIcon: "arrow.triangle.2.circlepath",
            category: .cellular
        )
    ]
    
    /// Filter stages up to a given fasting duration (e.g., plan target hours) or return all if target > max.
    static func stages(upto targetHours: Int?) -> [FastingTimelineEntry] {
        guard let t = targetHours else { return entries }
        return entries.filter { $0.hourFromStart <= t }
    }
    
    /// Determines progress state for a stage given elapsed hours.
    static func status(for entry: FastingTimelineEntry, elapsedHours: Double) -> StageStatus {
        if elapsedHours >= Double(entry.hourFromStart) {
            return .reached
        } else if (Double(entry.hourFromStart) - elapsedHours) <= 2 { // within 2h upcoming window
            return .upcoming
        } else {
            return .locked
        }
    }
    
    enum StageStatus {
        case reached
        case upcoming
        case locked
    }
}
