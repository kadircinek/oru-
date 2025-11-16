import Foundation

/// ViewModel for managing fasting plans
class FastingPlanViewModel: ObservableObject {
    @Published var allPlans: [FastingPlan] = FastingPlan.allPlans
    @Published var selectedPlan: FastingPlan?
    @Published var filteredPlans: [FastingPlan] = FastingPlan.allPlans
    @Published var searchText: String = ""
    @Published var selectedFilter: PlanFilter = .all
    
    private let persistenceManager = PersistenceManager.shared
    
    enum PlanFilter {
        case all
        case beginner
        case advanced
    }
    
    init() {
        loadSelectedPlan()
        filterPlans()
        
        // Listen for auto-assigned plans from registration
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("PlanAssigned"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let plan = notification.object as? FastingPlan {
                self?.selectedPlan = plan
            }
        }
    }
    
    // MARK: - Plan Selection
    
    func selectPlan(_ plan: FastingPlan) {
        selectedPlan = plan
        persistenceManager.saveActivePlan(plan)
    }
    
    private func loadSelectedPlan() {
        selectedPlan = persistenceManager.loadActivePlan()
    }
    
    // MARK: - Filtering
    
    func setFilter(_ filter: PlanFilter) {
        selectedFilter = filter
        filterPlans()
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        filterPlans()
    }
    
    private func filterPlans() {
        var filtered = allPlans
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { plan in
                plan.name.localizedCaseInsensitiveContains(searchText) ||
                plan.shortDescription.localizedCaseInsensitiveContains(searchText) ||
                plan.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Apply difficulty filter
        switch selectedFilter {
        case .all:
            break
        case .beginner:
            filtered = filtered.filter { ($0.fastingHours ?? 0) <= 16 }
        case .advanced:
            filtered = filtered.filter { ($0.fastingHours ?? 0) > 16 }
        }
        
        filteredPlans = filtered
    }
    
    // MARK: - Difficulty Classification
    
    func difficultyLevel(for plan: FastingPlan) -> String {
        guard let hours = plan.fastingHours else { return "Flexible" }
        
        switch hours {
        case 0...14:
            return "Beginner"
        case 15...18:
            return "Intermediate"
        default:
            return "Advanced"
        }
    }
}
