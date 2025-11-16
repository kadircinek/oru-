import SwiftUI
import Combine

/// ViewModel for buddy system
class BuddyViewModel: ObservableObject {
    @Published var buddies: [FastingBuddy] = []
    @Published var pendingInvitations: [BuddyInvitation] = []
    @Published var activeSessions: [BuddySession] = []
    @Published var currentSession: BuddySession?
    @Published var searchText: String = ""
    
    let manager = BuddyManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observe manager changes
        manager.$buddies
            .assign(to: &$buddies)
        
        manager.$pendingInvitations
            .assign(to: &$pendingInvitations)
        
        manager.$activeSessions
            .assign(to: &$activeSessions)
        
        manager.$activeSessions
            .map { [weak self] sessions in
                sessions.first { $0.buddies.contains(self?.manager.currentUserId ?? "") && $0.isActive }
            }
            .assign(to: &$currentSession)
    }
    
    // MARK: - Filtered Data
    
    var filteredBuddies: [FastingBuddy] {
        if searchText.isEmpty {
            return buddies
        }
        return buddies.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var fastingBuddies: [FastingBuddy] {
        buddies.filter { $0.status == .fasting }
    }
    
    var onlineBuddies: [FastingBuddy] {
        buddies.filter { $0.status != .offline }
    }
    
    // MARK: - Actions
    
    func sendInvitation(email: String, message: String?) {
        manager.sendInvitation(to: email, message: message)
    }
    
    func acceptInvitation(_ invitation: BuddyInvitation) {
        manager.acceptInvitation(invitation)
    }
    
    func rejectInvitation(_ invitation: BuddyInvitation) {
        manager.rejectInvitation(invitation)
    }
    
    func removeBuddy(_ buddy: FastingBuddy) {
        manager.removeBuddy(buddy)
    }
    
    func startSessionWith(_ buddyIds: [String], planName: String, duration: TimeInterval) {
        _ = manager.startSession(with: buddyIds, planName: planName, duration: duration)
    }
    
    func completeCurrentSession() {
        if let sessionId = currentSession?.id {
            manager.completeSession(sessionId)
        }
    }
    
    func abandonCurrentSession() {
        if let sessionId = currentSession?.id {
            manager.abandonSession(sessionId)
        }
    }
    
    func sendMessage(_ message: String) {
        if let sessionId = currentSession?.id {
            manager.addMessage(to: sessionId, message: message)
        }
    }
    
    func sendEncouragement(_ message: EncouragementMessage) {
        if let sessionId = currentSession?.id {
            manager.sendEncouragement(to: sessionId, message: message)
        }
    }
    
    func getBuddyStats(_ buddy: FastingBuddy) -> BuddyStats {
        manager.getBuddyStats(buddy)
    }
    
    func addDemoBuddies() {
        manager.addDemoBuddies()
    }
    
    func updateUserProfile(name: String, emoji: String) {
        manager.updateUserProfile(name: name, emoji: emoji)
    }
}
