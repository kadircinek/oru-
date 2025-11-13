import Foundation

/// Represents a single fasting session
struct FastingSession: Identifiable, Codable {
    let id: UUID
    let planId: UUID
    let startDate: Date
    var endDate: Date?
    var isCompleted: Bool
    var actualFastingHours: Double
    
    init(
        id: UUID = UUID(),
        planId: UUID,
        startDate: Date = Date(),
        endDate: Date? = nil,
        isCompleted: Bool = false,
        actualFastingHours: Double = 0
    ) {
        self.id = id
        self.planId = planId
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = isCompleted
        self.actualFastingHours = actualFastingHours
    }
}
