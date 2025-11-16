import SwiftUI

/// View for editing user profile
struct UserProfileEditView: View {
    @ObservedObject var viewModel: BuddyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var selectedEmoji: String
    
    let emojis = ["😊", "😎", "🤗", "💪", "🔥", "⭐", "🌟", "✨", "🎯", "🚀", "👤", "👨", "👩", "🧑", "👨‍💼", "👩‍💼"]
    
    init(viewModel: BuddyViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: viewModel.manager.currentUserName)
        _selectedEmoji = State(initialValue: viewModel.manager.currentUserEmoji)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current Preview
                    VStack(spacing: 16) {
                        Text(selectedEmoji)
                            .font(.system(size: 80))
                            .frame(width: 120, height: 120)
                            .background(
                                Circle()
                                    .fill(AppColors.primary.opacity(0.1))
                            )
                        
                        Text(name.isEmpty ? "Your Name" : name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .padding(.vertical, 20)
                    
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Your Name", systemImage: "person.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        TextField("Enter your name", text: $name)
                            .font(.system(size: 17))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.surfaceBackground)
                            )
                    }
                    .padding(.horizontal, 20)
                    
                    // Emoji Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Profile Emoji", systemImage: "face.smiling")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                            ForEach(emojis, id: \.self) { emoji in
                                Button {
                                    selectedEmoji = emoji
                                } label: {
                                    Text(emoji)
                                        .font(.system(size: 40))
                                        .frame(width: 60, height: 60)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedEmoji == emoji ? AppColors.primary.opacity(0.2) : AppColors.surfaceBackground)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedEmoji == emoji ? AppColors.primary : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .foregroundColor(AppColors.primary)
                    .fontWeight(.semibold)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveProfile() {
        viewModel.updateUserProfile(name: name, emoji: selectedEmoji)
        dismiss()
    }
}

#Preview {
    UserProfileEditView(viewModel: BuddyViewModel())
}
