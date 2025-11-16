import Foundation

/// Represents a fasting buddy connection
struct FastingBuddy: Identifiable, Codable, Equatable {
    let id: UUID
    let userId: String
    let name: String
    let profileEmoji: String
    let currentPlan: String?
    let status: BuddyStatus
    let connectedDate: Date
    var lastActive: Date
    var currentSessionId: UUID?
    
    init(
        id: UUID = UUID(),
        userId: String,
        name: String,
        profileEmoji: String = "👤",
        currentPlan: String? = nil,
        status: BuddyStatus = .offline,
        connectedDate: Date = Date(),
        lastActive: Date = Date(),
        currentSessionId: UUID? = nil
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.profileEmoji = profileEmoji
        self.currentPlan = currentPlan
        self.status = status
        self.connectedDate = connectedDate
        self.lastActive = lastActive
        self.currentSessionId = currentSessionId
    }
    
    enum BuddyStatus: String, Codable {
        case fasting = "Fasting"
        case eating = "Eating"
        case offline = "Offline"
    }
}

/// Buddy invitation
struct BuddyInvitation: Identifiable, Codable {
    let id: UUID
    let fromUserId: String
    let fromUserName: String
    let fromUserEmoji: String
    let message: String?
    let sentDate: Date
    var status: InvitationStatus
    
    init(
        id: UUID = UUID(),
        fromUserId: String,
        fromUserName: String,
        fromUserEmoji: String = "👤",
        message: String? = nil,
        sentDate: Date = Date(),
        status: InvitationStatus = .pending
    ) {
        self.id = id
        self.fromUserId = fromUserId
        self.fromUserName = fromUserName
        self.fromUserEmoji = fromUserEmoji
        self.message = message
        self.sentDate = sentDate
        self.status = status
    }
    
    enum InvitationStatus: String, Codable {
        case pending = "Pending"
        case accepted = "Accepted"
        case rejected = "Rejected"
        case expired = "Expired"
    }
}

/// Shared fasting session between buddies
struct BuddySession: Identifiable, Codable {
    let id: UUID
    let buddies: [String] // User IDs
    let planName: String
    let startTime: Date
    let duration: TimeInterval
    let createdBy: String
    var completedBy: [String] // User IDs who completed
    var abandonedBy: [String] // User IDs who abandoned
    var messages: [BuddyMessage]
    
    var endTime: Date {
        startTime.addingTimeInterval(duration)
    }
    
    var isActive: Bool {
        Date() < endTime && !buddies.allSatisfy { completedBy.contains($0) || abandonedBy.contains($0) }
    }
    
    var progress: Double {
        let elapsed = Date().timeIntervalSince(startTime)
        return min(max(elapsed / duration, 0), 1)
    }
    
    init(
        id: UUID = UUID(),
        buddies: [String],
        planName: String,
        startTime: Date = Date(),
        duration: TimeInterval,
        createdBy: String,
        completedBy: [String] = [],
        abandonedBy: [String] = [],
        messages: [BuddyMessage] = []
    ) {
        self.id = id
        self.buddies = buddies
        self.planName = planName
        self.startTime = startTime
        self.duration = duration
        self.createdBy = createdBy
        self.completedBy = completedBy
        self.abandonedBy = abandonedBy
        self.messages = messages
    }
}

/// Chat message between buddies during session
struct BuddyMessage: Identifiable, Codable {
    let id: UUID
    let userId: String
    let userName: String
    let message: String
    let timestamp: Date
    let type: MessageType
    
    init(
        id: UUID = UUID(),
        userId: String,
        userName: String,
        message: String,
        timestamp: Date = Date(),
        type: MessageType = .text
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.message = message
        self.timestamp = timestamp
        self.type = type
    }
    
    enum MessageType: String, Codable {
        case text = "text"
        case encouragement = "encouragement"
        case milestone = "milestone"
        case system = "system"
    }
}

/// Quick encouragement messages
enum EncouragementMessage: String, CaseIterable {
    case youGotThis = "You got this! 💪"
    case stayStrong = "Stay strong! 🔥"
    case almostThere = "Almost there! 🎯"
    case keepGoing = "Keep going! 🚀"
    case proudOfYou = "Proud of you! ⭐"
    case wereInThisTogether = "We're in this together! 🤝"
    case dontGiveUp = "Don't give up! 💎"
    case youreAmazing = "You're amazing! ✨"
}
