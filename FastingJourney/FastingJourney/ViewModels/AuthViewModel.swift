import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init() {
        // Check if user is already logged in
        loadUser()
    }
    
    func loadUser() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    func login(email: String, password: String) -> Bool {
        // Simple authentication logic
        let user = User(email: email, name: "User")
        currentUser = user
        isAuthenticated = true
        
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
        
        return true
    }
    
    func register(
        name: String,
        email: String,
        password: String,
        weight: Double? = nil,
        height: Double? = nil,
        age: Int? = nil,
        gender: User.Gender? = nil
    ) -> Bool {
        // Simple registration logic with user metrics
        let user = User(
            email: email,
            name: name,
            weight: weight,
            height: height,
            age: age,
            gender: gender
        )
        currentUser = user
        isAuthenticated = true
        
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
        
        // Auto-assign optimal fasting plan based on user data
        if let weight = weight, let height = height {
            assignOptimalPlan(weight: weight, height: height, age: age)
        }
        
        return true
    }
    
    // MARK: - Optimal Plan Assignment
    
    private func assignOptimalPlan(weight: Double, height: Double, age: Int?) {
        // Calculate BMI
        let heightInMeters = height / 100.0
        let bmi = weight / (heightInMeters * heightInMeters)
        
        // Get optimal plan based on BMI and age
        let optimalPlan = getOptimalPlanForUser(bmi: bmi, age: age)
        
        // Save the plan
        PersistenceManager.shared.saveActivePlan(optimalPlan)
        
        // Post notification to update plan view model
        NotificationCenter.default.post(name: NSNotification.Name("PlanAssigned"), object: optimalPlan)
    }
    
    private func getOptimalPlanForUser(bmi: Double, age: Int?) -> FastingPlan {
        let plans = FastingPlan.allPlans
        
        // Determine difficulty level based on BMI and age
        // BMI Categories:
        // < 18.5: Underweight -> Start gentle (12/12 or 14/10)
        // 18.5-24.9: Normal -> Moderate approach (14/10 or 16/8)
        // 25-29.9: Overweight -> More aggressive (16/8 or 18/6)
        // >= 30: Obese -> Start with proven method (16/8)
        
        // Age factor: Older users start gentler
        let isYounger = (age ?? 30) < 50
        
        if bmi < 18.5 {
            // Underweight: Start very gentle
            return plans.first { $0.fastingHours == 12 } ?? plans[0]
        } else if bmi < 25 {
            // Normal weight: Start with moderate
            if isYounger {
                return plans.first { $0.fastingHours == 16 } ?? plans[2] // 16/8
            } else {
                return plans.first { $0.fastingHours == 14 } ?? plans[1] // 14/10
            }
        } else if bmi < 30 {
            // Overweight: More aggressive approach
            if isYounger {
                return plans.first { $0.fastingHours == 16 } ?? plans[2] // 16/8
            } else {
                return plans.first { $0.fastingHours == 16 } ?? plans[2] // 16/8
            }
        } else {
            // Obese: Start with proven 16/8 method
            return plans.first { $0.fastingHours == 16 } ?? plans[2]
        }
    }
    
    func updateUserInfo(
        weight: Double,
        height: Double,
        age: Int,
        gender: User.Gender
    ) {
        guard var user = currentUser else { return }
        
        // Update user properties
        user.weight = weight
        user.height = height
        user.age = age
        user.gender = gender
        
        // Save to UserDefaults
        currentUser = user
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
