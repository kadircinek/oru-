import Foundation

/// Authentication service for user registration, login, and session management
class AuthService {
    static let shared = AuthService()
    private let persistenceManager = PersistenceManager.shared
    
    private let userKey = "currentUser"
    private let passwordPrefix = "password_"
    
    private init() {}
    
    // MARK: - Current User
    
    func getCurrentUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
    
    private func saveCurrentUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
    
    private func clearCurrentUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    // MARK: - Registration
    
    func register(email: String, password: String, name: String) -> Result<User, AuthError> {
        // Validate input
        guard !email.isEmpty, isValidEmail(email) else {
            return .failure(.invalidEmail)
        }
        
        guard !password.isEmpty, password.count >= 6 else {
            return .failure(.weakPassword)
        }
        
        guard !name.isEmpty else {
            return .failure(.invalidName)
        }
        
        // Check if user already exists
        let passwordKey = passwordPrefix + email
        if UserDefaults.standard.string(forKey: passwordKey) != nil {
            return .failure(.userAlreadyExists)
        }
        
        // Save password (in production, use proper hashing/keychain)
        UserDefaults.standard.set(password, forKey: passwordKey)
        
        // Create and save user
        let user = User(email: email, name: name)
        saveCurrentUser(user)
        
        // Initialize user profile for fasting
        let profile = UserProfile()
        persistenceManager.saveUserProfile(profile)
        
        return .success(user)
    }
    
    // MARK: - Login
    
    func login(email: String, password: String) -> Result<User, AuthError> {
        guard !email.isEmpty, !password.isEmpty else {
            return .failure(.emptyFields)
        }
        
        let passwordKey = passwordPrefix + email
        guard let storedPassword = UserDefaults.standard.string(forKey: passwordKey) else {
            return .failure(.userNotFound)
        }
        
        guard storedPassword == password else {
            return .failure(.incorrectPassword)
        }
        
        // Load user data (create minimal if not exists for backward compatibility)
        if let user = loadUserData(email: email) {
            saveCurrentUser(user)
            return .success(user)
        } else {
            // Create basic user record
            let user = User(email: email, name: "User")
            saveCurrentUser(user)
            return .success(user)
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        clearCurrentUser()
    }
    
    // MARK: - Helpers
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func loadUserData(email: String) -> User? {
        // Try to load existing user metadata (if saved separately)
        let userDataKey = "userData_" + email
        if let data = UserDefaults.standard.data(forKey: userDataKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
    
    private func saveUserData(_ user: User) {
        let userDataKey = "userData_" + user.email
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDataKey)
        }
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case emptyFields
    case invalidEmail
    case weakPassword
    case invalidName
    case userAlreadyExists
    case userNotFound
    case incorrectPassword
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Please fill in all fields"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .invalidName:
            return "Please enter your name"
        case .userAlreadyExists:
            return "An account with this email already exists"
        case .userNotFound:
            return "No account found with this email"
        case .incorrectPassword:
            return "Incorrect password"
        }
    }
}
