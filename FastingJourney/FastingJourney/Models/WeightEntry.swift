import Foundation

/// Represents a weight measurement entry
struct WeightEntry: Identifiable, Codable {
    let id: String
    let date: Date
    let weight: Double // in kg
    let unit: WeightUnit
    let note: String?
    
    init(
        id: String = UUID().uuidString,
        date: Date = Date(),
        weight: Double,
        unit: WeightUnit = .kg,
        note: String? = nil
    ) {
        self.id = id
        self.date = date
        self.weight = weight
        self.unit = unit
        self.note = note
    }
    
    /// Get weight in specified unit
    func weightIn(_ targetUnit: WeightUnit) -> Double {
        if unit == targetUnit {
            return weight
        }
        
        // Convert to kg first, then to target
        let weightInKg = unit == .kg ? weight : weight / 2.20462
        return targetUnit == .kg ? weightInKg : weightInKg * 2.20462
    }
    
    enum WeightUnit: String, Codable, CaseIterable {
        case kg = "kg"
        case lbs = "lbs"
        
        var symbol: String { rawValue }
    }
}

/// Weight tracking statistics
struct WeightStats {
    let startWeight: Double?
    let currentWeight: Double?
    let lowestWeight: Double?
    let highestWeight: Double?
    let totalLoss: Double
    let averageWeeklyLoss: Double
    let entries: [WeightEntry]
    
    var progressPercentage: Double {
        guard let start = startWeight, let current = currentWeight, start > 0 else {
            return 0
        }
        return ((start - current) / start) * 100
    }
}
