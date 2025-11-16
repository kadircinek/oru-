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
        
        return true
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
