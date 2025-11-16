import SwiftUI

/// Main buddy list view
struct BuddyListView: View {
    @StateObject private var viewModel = BuddyViewModel()
    @State private var showingInvite = false
    @State private var showingProfile = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // User Profile Card
                        userProfileCard
                        
                        // Pending Invitations
                        if !viewModel.pendingInvitations.isEmpty {
                            pendingInvitationsSection
                        }
                        
                        // Active Session
                        if let session = viewModel.currentSession {
                            activeSessionCard(session)
                        }
                        
                        // Buddies List
                        buddiesSection
                        
                        // Empty State
                        if viewModel.buddies.isEmpty {
                            emptyStateView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Fasting Buddies")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingInvite = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search buddies")
            .sheet(isPresented: $showingInvite) {
                InviteBuddyView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingProfile) {
                UserProfileEditView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - User Profile Card
    
    private var userProfileCard: some View {
        HStack(spacing: 16) {
            Text(viewModel.manager.currentUserEmoji)
                .font(.system(size: 50))
                .frame(width: 70, height: 70)
                .background(
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.manager.currentUserName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(viewModel.buddies.count) buddies")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button {
                showingProfile = true
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(AppColors.primary.opacity(0.1))
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
    }
    
    // MARK: - Pending Invitations
    
    private var pendingInvitationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Invitations")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            ForEach(viewModel.pendingInvitations) { invitation in
                InvitationCard(invitation: invitation, viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Active Session Card
    
    private func activeSessionCard(_ session: BuddySession) -> some View {
        NavigationLink(destination: BuddySessionView(session: session, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🔥")
                        .font(.system(size: 30))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Active Session")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(session.planName)
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary)
                            .frame(width: geometry.size.width * session.progress, height: 8)
                    }
                }
                .frame(height: 8)
                
                Text("\(Int(session.progress * 100))% complete")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        colors: [AppColors.primary.opacity(0.1), AppColors.primary.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
            )
        }
    }
    
    // MARK: - Buddies Section
    
    private var buddiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Buddies")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if viewModel.buddies.isEmpty {
                    Button("Add Demo") {
                        viewModel.addDemoBuddies()
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primary)
                }
            }
            
            ForEach(viewModel.filteredBuddies) { buddy in
                NavigationLink(destination: BuddyDetailView(buddy: buddy, viewModel: viewModel)) {
                    BuddyCard(buddy: buddy)
                }
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("🤝")
                .font(.system(size: 80))
            
            Text("No Buddies Yet")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Invite friends to fast together and support each other on your health journey!")
                .font(.system(size: 15))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingInvite = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                    Text("Invite Buddy")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.primary)
                )
            }
        }
        .padding(.vertical, 60)
    }
}

// MARK: - Buddy Card

struct BuddyCard: View {
    let buddy: FastingBuddy
    
    var body: some View {
        HStack(spacing: 16) {
            Text(buddy.profileEmoji)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(statusColor.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(buddy.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    
                    Text(buddy.status.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                if let plan = buddy.currentPlan {
                    Text(plan)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(AppColors.primary.opacity(0.1))
                        )
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
        )
    }
    
    private var statusColor: Color {
        switch buddy.status {
        case .fasting: return AppColors.primary
        case .eating: return AppColors.success
        case .offline: return AppColors.textSecondary
        }
    }
}

// MARK: - Invitation Card

struct InvitationCard: View {
    let invitation: BuddyInvitation
    let viewModel: BuddyViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(invitation.fromUserEmoji)
                    .font(.system(size: 35))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(invitation.fromUserName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("wants to be your fasting buddy")
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
            
            if let message = invitation.message {
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.surfaceBackground)
                    )
            }
            
            HStack(spacing: 12) {
                Button {
                    viewModel.acceptInvitation(invitation)
                } label: {
                    Text("Accept")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.primary)
                        )
                }
                
                Button {
                    viewModel.rejectInvitation(invitation)
                } label: {
                    Text("Decline")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.surfaceBackground)
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
        )
    }
}

#Preview {
    BuddyListView()
}
