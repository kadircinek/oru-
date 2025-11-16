import Foundation

/// Represents daily hydration tracking
struct HydrationEntry: Codable, Identifiable {
    var id = UUID()
    let date: Date // Midnight anchor for the day
    var consumedMl: Int
    var targetMl: Int
    var events: [HydrationEvent]
    
    init(date: Date = HydrationEntry.todayAnchor(), consumedMl: Int = 0, targetMl: Int, events: [HydrationEvent] = []) {
        self.date = date
        self.consumedMl = consumedMl
        self.targetMl = targetMl
        self.events = events
    }
    
    enum CodingKeys: String, CodingKey {
        case date, consumedMl, targetMl, events
    }
    
    static func todayAnchor() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month, .day], from: Date())
        return cal.date(from: comps) ?? Date()
    }
    
    var progress: Double { targetMl == 0 ? 0 : min(Double(consumedMl) / Double(targetMl), 1.0) }
}

struct HydrationEvent: Codable, Identifiable {
    var id = UUID()
    let timestamp: Date
    let amountMl: Int
    
    enum CodingKeys: String, CodingKey {
        case timestamp, amountMl
    }
}
