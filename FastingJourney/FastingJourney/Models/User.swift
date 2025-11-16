import Foundation

/// User model for authentication
struct User: Codable {
    var id: String
    var email: String
    var name: String
    var createdAt: Date
    var weight: Double? // kg
    var height: Double? // cm
    var age: Int?
    var gender: Gender?
    
    enum Gender: String, Codable {
        case male = "male"
        case female = "female"
        case other = "other"
        
        var displayName: String {
            switch self {
            case .male: return "Male"
            case .female: return "Female"
            case .other: return "Other"
            }
        }
    }
    
    init(
        id: String = UUID().uuidString,
        email: String,
        name: String,
        createdAt: Date = Date(),
        weight: Double? = nil,
        height: Double? = nil,
        age: Int? = nil,
        gender: Gender? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.createdAt = createdAt
        self.weight = weight
        self.height = height
        self.age = age
        self.gender = gender
    }
}
