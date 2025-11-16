import SwiftUI
import Combine

/// ViewModel for weight tracking
class WeightTrackingViewModel: ObservableObject {
    @Published var entries: [WeightEntry] = []
    @Published var stats: WeightStats
    @Published var selectedTimeRange: TimeRange = .month
    @Published var preferredUnit: WeightEntry.WeightUnit = .kg
    
    let manager = WeightTrackingManager.shared
    
    init() {
        self.stats = manager.getStats()
        self.entries = manager.entries
        self.preferredUnit = manager.preferredUnit
        
        // Observe manager changes
        manager.$entries
            .assign(to: &$entries)
        
        manager.$entries
            .sink { [weak self] _ in
                self?.stats = self?.manager.getStats() ?? WeightStats(
                    startWeight: nil,
                    currentWeight: nil,
                    lowestWeight: nil,
                    highestWeight: nil,
                    totalLoss: 0,
                    averageWeeklyLoss: 0,
                    entries: []
                )
            }
            .store(in: &cancellables)
        
        manager.$preferredUnit
            .assign(to: &$preferredUnit)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func addEntry(weight: Double, date: Date, note: String?) {
        let entry = WeightEntry(
            date: date,
            weight: weight,
            unit: preferredUnit,
            note: note
        )
        manager.addEntry(entry)
    }
    
    func updateEntry(_ entry: WeightEntry) {
        manager.updateEntry(entry)
    }
    
    func deleteEntry(_ entry: WeightEntry) {
        manager.deleteEntry(entry)
    }
    
    func setPreferredUnit(_ unit: WeightEntry.WeightUnit) {
        manager.setPreferredUnit(unit)
    }
    
    func getChartData() -> [(date: Date, weight: Double)] {
        switch selectedTimeRange {
        case .week:
            return manager.getWeightData(days: 7)
        case .month:
            return manager.getWeightData(days: 30)
        case .threeMonths:
            return manager.getWeightData(days: 90)
        case .year:
            return manager.getWeightData(days: 365)
        case .all:
            return manager.getWeightData(days: 3650) // ~10 years
        }
    }
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
        case year = "Year"
        case all = "All"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .threeMonths: return 90
            case .year: return 365
            case .all: return 3650
            }
        }
    }
}
