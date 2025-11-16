import Foundation

/// Manages weight tracking data
class WeightTrackingManager: ObservableObject {
    static let shared = WeightTrackingManager()
    
    @Published var entries: [WeightEntry] = []
    @Published var preferredUnit: WeightEntry.WeightUnit = .kg
    
    private let coreData = CoreDataManager.shared
    private let entriesKey = "weight_entries"
    private let unitKey = "preferred_weight_unit"
    
    private var useCoreData: Bool {
        return UserDefaults.standard.bool(forKey: "HasMigratedToCoreData")
    }
    
    init() {
        loadEntries()
        loadPreferredUnit()
    }
    
    // MARK: - CRUD Operations
    
    func addEntry(_ entry: WeightEntry) {
        entries.append(entry)
        entries.sort { $0.date > $1.date }
        saveEntries()
        
        // Also save to CoreData if migrated
        if useCoreData {
            coreData.saveWeightEntry(entry)
        }
    }
    
    func updateEntry(_ entry: WeightEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries.sort { $0.date > $1.date }
            saveEntries()
            
            // Also update in CoreData if migrated
            if useCoreData {
                coreData.saveWeightEntry(entry)
            }
        }
    }
    
    func deleteEntry(_ entry: WeightEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
        
        // Also delete from CoreData if migrated
        if useCoreData {
            coreData.deleteWeightEntry(entry)
        }
    }
    
    func deleteEntry(at offsets: IndexSet) {
        let entriesToDelete = offsets.map { entries[$0] }
        entries.remove(atOffsets: offsets)
        saveEntries()
        
        // Also delete from CoreData if migrated
        if useCoreData {
            entriesToDelete.forEach { coreData.deleteWeightEntry($0) }
        }
    }
    
    // MARK: - Statistics
    
    func getStats() -> WeightStats {
        let sortedEntries = entries.sorted { $0.date < $1.date }
        
        let startWeight = sortedEntries.first?.weightIn(preferredUnit)
        let currentWeight = sortedEntries.last?.weightIn(preferredUnit)
        let lowestWeight = sortedEntries.map { $0.weightIn(preferredUnit) }.min()
        let highestWeight = sortedEntries.map { $0.weightIn(preferredUnit) }.max()
        
        let totalLoss: Double
        if let start = startWeight, let current = currentWeight {
            totalLoss = start - current
        } else {
            totalLoss = 0
        }
        
        // Calculate average weekly loss
        let averageWeeklyLoss: Double
        if let firstDate = sortedEntries.first?.date,
           let lastDate = sortedEntries.last?.date,
           let start = startWeight,
           let current = currentWeight {
            let weeks = Calendar.current.dateComponents([.weekOfYear], from: firstDate, to: lastDate).weekOfYear ?? 1
            averageWeeklyLoss = weeks > 0 ? (start - current) / Double(weeks) : 0
        } else {
            averageWeeklyLoss = 0
        }
        
        return WeightStats(
            startWeight: startWeight,
            currentWeight: currentWeight,
            lowestWeight: lowestWeight,
            highestWeight: highestWeight,
            totalLoss: totalLoss,
            averageWeeklyLoss: averageWeeklyLoss,
            entries: sortedEntries
        )
    }
    
    // MARK: - Data for Charts
    
    func getWeightData(days: Int = 30) -> [(date: Date, weight: Double)] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        return entries
            .filter { $0.date >= cutoffDate }
            .sorted { $0.date < $1.date }
            .map { (date: $0.date, weight: $0.weightIn(preferredUnit)) }
    }
    
    func getWeeklyAverages(weeks: Int = 12) -> [(week: Date, avgWeight: Double)] {
        let cutoffDate = Calendar.current.date(byAdding: .weekOfYear, value: -weeks, to: Date()) ?? Date()
        let relevantEntries = entries.filter { $0.date >= cutoffDate }
        
        let calendar = Calendar.current
        var weeklyData: [Date: [Double]] = [:]
        
        for entry in relevantEntries {
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? entry.date
            if weeklyData[weekStart] == nil {
                weeklyData[weekStart] = []
            }
            weeklyData[weekStart]?.append(entry.weightIn(preferredUnit))
        }
        
        return weeklyData.map { (week: $0.key, avgWeight: $0.value.reduce(0, +) / Double($0.value.count)) }
            .sorted { $0.week < $1.week }
    }
    
    // MARK: - Persistence
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if useCoreData {
            // Load from CoreData
            entries = coreData.fetchWeightEntries().sorted { $0.date > $1.date }
        } else {
            // Load from UserDefaults
            if let data = UserDefaults.standard.data(forKey: entriesKey),
               let decoded = try? JSONDecoder().decode([WeightEntry].self, from: data) {
                entries = decoded.sorted { $0.date > $1.date }
            }
        }
    }
    
    func setPreferredUnit(_ unit: WeightEntry.WeightUnit) {
        preferredUnit = unit
        UserDefaults.standard.set(unit.rawValue, forKey: unitKey)
    }
    
    private func loadPreferredUnit() {
        if let unitString = UserDefaults.standard.string(forKey: unitKey),
           let unit = WeightEntry.WeightUnit(rawValue: unitString) {
            preferredUnit = unit
        }
    }
}
