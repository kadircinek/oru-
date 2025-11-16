import Foundation
import Combine

/// Manages fasting buddy connections and sessions
class BuddyManager: ObservableObject {
    static let shared = BuddyManager()
    
    @Published var buddies: [FastingBuddy] = []
    @Published var pendingInvitations: [BuddyInvitation] = []
    @Published var activeSessions: [BuddySession] = []
    @Published var currentUserId: String = "user_\(UUID().uuidString.prefix(8))"
    @Published var currentUserName: String = "You"
    @Published var currentUserEmoji: String = "😊"
    
    private let buddiesKey = "fasting_buddies"
    private let invitationsKey = "buddy_invitations"
    private let sessionsKey = "buddy_sessions"
    private let userIdKey = "current_user_id"
    private let userNameKey = "current_user_name"
    private let userEmojiKey = "current_user_emoji"
    
    private init() {
        loadData()
        startAutoCleanup()
    }
    
    // MARK: - Data Persistence
    
    private func loadData() {
        // Load user info
        if let userId = UserDefaults.standard.string(forKey: userIdKey) {
            currentUserId = userId
        } else {
            UserDefaults.standard.set(currentUserId, forKey: userIdKey)
        }
        
        if let userName = UserDefaults.standard.string(forKey: userNameKey) {
            currentUserName = userName
        }
        
        if let userEmoji = UserDefaults.standard.string(forKey: userEmojiKey) {
            currentUserEmoji = userEmoji
        }
        
        // Load buddies
        if let data = UserDefaults.standard.data(forKey: buddiesKey),
           let decoded = try? JSONDecoder().decode([FastingBuddy].self, from: data) {
            buddies = decoded
        }
        
        // Load invitations
        if let data = UserDefaults.standard.data(forKey: invitationsKey),
           let decoded = try? JSONDecoder().decode([BuddyInvitation].self, from: data) {
            pendingInvitations = decoded.filter { $0.status == .pending }
        }
        
        // Load sessions
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([BuddySession].self, from: data) {
            activeSessions = decoded.filter { $0.isActive }
        }
    }
    
    private func saveBuddies() {
        if let encoded = try? JSONEncoder().encode(buddies) {
            UserDefaults.standard.set(encoded, forKey: buddiesKey)
        }
    }
    
    private func saveInvitations() {
        if let encoded = try? JSONEncoder().encode(pendingInvitations) {
            UserDefaults.standard.set(encoded, forKey: invitationsKey)
        }
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(activeSessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    // MARK: - User Profile
    
    func updateUserProfile(name: String, emoji: String) {
        currentUserName = name
        currentUserEmoji = emoji
        UserDefaults.standard.set(name, forKey: userNameKey)
        UserDefaults.standard.set(emoji, forKey: userEmojiKey)
    }
    
    // MARK: - Buddy Management
    
    func sendInvitation(to email: String, message: String?) {
        // In a real app, this would send via backend
        // For demo, create a mock invitation
        let invitation = BuddyInvitation(
            fromUserId: currentUserId,
            fromUserName: currentUserName,
            fromUserEmoji: currentUserEmoji,
            message: message
        )
        
        // Simulate: Auto-accept for demo purposes after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.acceptInvitation(invitation)
        }
    }
    
    func acceptInvitation(_ invitation: BuddyInvitation) {
        // Remove from pending
        pendingInvitations.removeAll { $0.id == invitation.id }
        
        // Add as buddy
        let buddy = FastingBuddy(
            userId: invitation.fromUserId,
            name: invitation.fromUserName,
            profileEmoji: invitation.fromUserEmoji,
            status: .offline
        )
        
        buddies.append(buddy)
        saveBuddies()
        saveInvitations()
    }
    
    func rejectInvitation(_ invitation: BuddyInvitation) {
        pendingInvitations.removeAll { $0.id == invitation.id }
        saveInvitations()
    }
    
    func removeBuddy(_ buddy: FastingBuddy) {
        buddies.removeAll { $0.id == buddy.id }
        saveBuddies()
    }
    
    func updateBuddyStatus(_ buddyId: UUID, status: FastingBuddy.BuddyStatus) {
        if let index = buddies.firstIndex(where: { $0.id == buddyId }) {
            buddies[index] = FastingBuddy(
                id: buddies[index].id,
                userId: buddies[index].userId,
                name: buddies[index].name,
                profileEmoji: buddies[index].profileEmoji,
                currentPlan: buddies[index].currentPlan,
                status: status,
                connectedDate: buddies[index].connectedDate,
                lastActive: Date(),
                currentSessionId: buddies[index].currentSessionId
            )
            saveBuddies()
        }
    }
    
    // MARK: - Session Management
    
    func startSession(with buddyIds: [String], planName: String, duration: TimeInterval) -> BuddySession {
        let session = BuddySession(
            buddies: [currentUserId] + buddyIds,
            planName: planName,
            duration: duration,
            createdBy: currentUserId
        )
        
        activeSessions.append(session)
        saveSessions()
        
        // Add system message
        addMessage(to: session.id, message: "Session started! Let's do this together! 🚀", type: .system)
        
        return session
    }
    
    func completeSession(_ sessionId: UUID) {
        if let index = activeSessions.firstIndex(where: { $0.id == sessionId }) {
            var session = activeSessions[index]
            if !session.completedBy.contains(currentUserId) {
                session.completedBy.append(currentUserId)
                activeSessions[index] = session
                saveSessions()
                
                addMessage(to: sessionId, message: "\(currentUserName) completed the fast! 🎉", type: .milestone)
            }
        }
    }
    
    func abandonSession(_ sessionId: UUID) {
        if let index = activeSessions.firstIndex(where: { $0.id == sessionId }) {
            var session = activeSessions[index]
            if !session.abandonedBy.contains(currentUserId) {
                session.abandonedBy.append(currentUserId)
                activeSessions[index] = session
                saveSessions()
            }
        }
    }
    
    func getActiveSession() -> BuddySession? {
        activeSessions.first { $0.buddies.contains(currentUserId) && $0.isActive }
    }
    
    // MARK: - Messaging
    
    func addMessage(to sessionId: UUID, message: String, type: BuddyMessage.MessageType = .text) {
        if let index = activeSessions.firstIndex(where: { $0.id == sessionId }) {
            let buddyMessage = BuddyMessage(
                userId: currentUserId,
                userName: currentUserName,
                message: message,
                type: type
            )
            
            activeSessions[index].messages.append(buddyMessage)
            saveSessions()
        }
    }
    
    func sendEncouragement(to sessionId: UUID, message: EncouragementMessage) {
        addMessage(to: sessionId, message: message.rawValue, type: .encouragement)
    }
    
    // MARK: - Statistics
    
    func getBuddyStats(_ buddy: FastingBuddy) -> BuddyStats {
        let completedSessions = activeSessions.filter {
            $0.completedBy.contains(buddy.userId)
        }.count
        
        let totalSessions = activeSessions.filter {
            $0.buddies.contains(buddy.userId)
        }.count
        
        let successRate = totalSessions > 0 ? Double(completedSessions) / Double(totalSessions) : 0
        
        return BuddyStats(
            totalSessions: totalSessions,
            completedSessions: completedSessions,
            successRate: successRate,
            longestStreak: 0, // TODO: Calculate
            currentStreak: 0  // TODO: Calculate
        )
    }
    
    // MARK: - Auto Cleanup
    
    private func startAutoCleanup() {
        // Clean up expired sessions every hour
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.cleanupExpiredSessions()
        }
    }
    
    private func cleanupExpiredSessions() {
        activeSessions.removeAll { !$0.isActive }
        saveSessions()
    }
    
    // MARK: - Demo Data
    
    func addDemoBuddies() {
        let demoBuddies = [
            FastingBuddy(
                userId: "demo_1",
                name: "Sarah",
                profileEmoji: "👩",
                currentPlan: "16:8",
                status: .fasting
            ),
            FastingBuddy(
                userId: "demo_2",
                name: "Mike",
                profileEmoji: "👨",
                currentPlan: "18:6",
                status: .eating
            ),
            FastingBuddy(
                userId: "demo_3",
                name: "Emma",
                profileEmoji: "👩‍🦰",
                currentPlan: "20:4",
                status: .offline
            )
        ]
        
        buddies.append(contentsOf: demoBuddies)
        saveBuddies()
    }
}

// MARK: - Supporting Types

struct BuddyStats {
    let totalSessions: Int
    let completedSessions: Int
    let successRate: Double
    let longestStreak: Int
    let currentStreak: Int
}
