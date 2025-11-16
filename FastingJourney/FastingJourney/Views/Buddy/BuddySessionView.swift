import SwiftUI

/// Active buddy session view with chat
struct BuddySessionView: View {
    let session: BuddySession
    @ObservedObject var viewModel: BuddyViewModel
    @State private var newMessage = ""
    @State private var showingEncouragement = false
    @State private var showingCompleteAlert = false
    @FocusState private var isMessageFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Session Header
            sessionHeader
            
            // Messages
            messagesSection
            
            // Input Bar
            messageInputBar
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Fasting Together")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEncouragement) {
            EncouragementSheet(viewModel: viewModel)
        }
        .alert("Complete Fast?", isPresented: $showingCompleteAlert) {
            Button("Not Yet", role: .cancel) {}
            Button("Complete") {
                viewModel.completeCurrentSession()
            }
        } message: {
            Text("Congratulations! Mark this fasting session as complete?")
        }
    }
    
    // MARK: - Session Header
    
    private var sessionHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach(session.buddies.prefix(3), id: \.self) { userId in
                    if userId == viewModel.manager.currentUserId {
                        Text(viewModel.manager.currentUserEmoji)
                            .font(.system(size: 32))
                    } else if let buddy = viewModel.buddies.first(where: { $0.userId == userId }) {
                        Text(buddy.profileEmoji)
                            .font(.system(size: 32))
                    }
                }
            }
            
            Text(session.planName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            // Progress
            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(AppColors.primary.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(AppColors.primary)
                            .frame(width: geometry.size.width * session.progress, height: 12)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    Text("\(Int(session.progress * 100))% Complete")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                    
                    Spacer()
                    
                    Text(timeRemaining)
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    showingEncouragement = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "hand.thumbsup.fill")
                        Text("Encourage")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(AppColors.primary.opacity(0.1))
                    )
                }
                
                if session.progress >= 0.95 {
                    Button {
                        showingCompleteAlert = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Complete")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(AppColors.success)
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Messages Section
    
    private var messagesSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(session.messages) { message in
                        MessageBubble(message: message, isCurrentUser: message.userId == viewModel.manager.currentUserId)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .onChange(of: session.messages.count) { _ in
                if let lastMessage = session.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    // MARK: - Message Input Bar
    
    private var messageInputBar: some View {
        HStack(spacing: 12) {
            TextField("Send message...", text: $newMessage)
                .focused($isMessageFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(AppColors.surfaceBackground)
                )
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(newMessage.isEmpty ? AppColors.textSecondary : AppColors.primary)
            }
            .disabled(newMessage.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
    }
    
    private var timeRemaining: String {
        let remaining = session.endTime.timeIntervalSinceNow
        if remaining < 0 { return "Completed" }
        
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        return "\(hours)h \(minutes)m left"
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        viewModel.sendMessage(newMessage)
        newMessage = ""
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: BuddyMessage
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer(minLength: 60) }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser {
                    Text(message.userName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text(message.message)
                    .font(.system(size: 15))
                    .foregroundColor(isCurrentUser ? .white : AppColors.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(bubbleColor)
                    )
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            if !isCurrentUser { Spacer(minLength: 60) }
        }
    }
    
    private var bubbleColor: Color {
        switch message.type {
        case .text: return isCurrentUser ? AppColors.primary : AppColors.surfaceBackground
        case .encouragement: return AppColors.warning.opacity(0.3)
        case .milestone: return AppColors.success.opacity(0.3)
        case .system: return AppColors.textSecondary.opacity(0.2)
        }
    }
}

// MARK: - Encouragement Sheet

struct EncouragementSheet: View {
    @ObservedObject var viewModel: BuddyViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(EncouragementMessage.allCases, id: \.self) { message in
                        Button {
                            viewModel.sendEncouragement(message)
                            dismiss()
                        } label: {
                            Text(message.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
                                )
                        }
                    }
                }
                .padding(20)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Send Encouragement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
}
