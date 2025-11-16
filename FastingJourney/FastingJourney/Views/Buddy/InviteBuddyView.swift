import SwiftUI

/// View for inviting a new buddy
struct InviteBuddyView: View {
    @ObservedObject var viewModel: BuddyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var message = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Illustration
                    VStack(spacing: 16) {
                        Text("🤝")
                            .font(.system(size: 80))
                        
                        Text("Invite a Buddy")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Fast together and support each other!")
                            .font(.system(size: 15))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 20)
                    
                    // Form
                    VStack(alignment: .leading, spacing: 20) {
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Email Address", systemImage: "envelope.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("friend@example.com", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.surfaceBackground)
                                )
                        }
                        
                        // Message
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Personal Message (Optional)", systemImage: "text.bubble.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Let's fast together!", text: $message, axis: .vertical)
                                .lineLimit(3...6)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.surfaceBackground)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Send Button
                    Button {
                        sendInvitation()
                    } label: {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send Invitation")
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(email.isEmpty ? AppColors.textSecondary : AppColors.primary)
                        )
                    }
                    .disabled(email.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .padding(.vertical, 20)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
            .alert("Invitation Sent!", isPresented: $showingSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your buddy invitation has been sent successfully!")
            }
        }
    }
    
    private func sendInvitation() {
        viewModel.sendInvitation(email: email, message: message.isEmpty ? nil : message)
        showingSuccess = true
    }
}

#Preview {
    InviteBuddyView(viewModel: BuddyViewModel())
}
