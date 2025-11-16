import SwiftUI

/// Registration screen with modern design
struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var weight = ""
    @State private var height = ""
    @State private var age = ""
    @State private var selectedGender: User.Gender = .male
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [AppColors.background, AppColors.accentLight.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Logo and title
                    VStack(spacing: 12) {
                        Text("🌱")
                            .font(.system(size: 72))
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Start your fasting journey today")
                            .font(.system(size: 15))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Registration form
                    VStack(spacing: 20) {
                        // Name field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(width: 20)
                                TextField("Enter your name", text: $name)
                                    .textContentType(.name)
                            }
                            .padding(16)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.accentLight, lineWidth: 1)
                            )
                        }
                        
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(width: 20)
                                TextField("Enter your email", text: $email)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding(16)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.accentLight, lineWidth: 1)
                            )
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(width: 20)
                                
                                if showPassword {
                                    TextField("At least 6 characters", text: $password)
                                } else {
                                    SecureField("At least 6 characters", text: $password)
                                }
                                
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding(16)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.accentLight, lineWidth: 1)
                            )
                        }
                        
                        // Confirm password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(width: 20)
                                
                                if showConfirmPassword {
                                    TextField("Re-enter password", text: $confirmPassword)
                                } else {
                                    SecureField("Re-enter password", text: $confirmPassword)
                                }
                                
                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding(16)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.accentLight, lineWidth: 1)
                            )
                        }
                        
                        // Personal info section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("📊 Personal Info (For Calorie Calculation)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.top, 8)
                            
                            Text("Enter your info to calculate calorie burn")
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.textSecondary)
                            
                            // Weight and Height
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Weight (kg) *")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "scalemass.fill")
                                            .foregroundColor(AppColors.textSecondary)
                                            .frame(width: 16)
                                        TextField("70", text: $weight)
                                            .keyboardType(.decimalPad)
                                    }
                                    .padding(12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppColors.accentLight, lineWidth: 1)
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Height (cm) *")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "ruler.fill")
                                            .foregroundColor(AppColors.textSecondary)
                                            .frame(width: 16)
                                        TextField("170", text: $height)
                                            .keyboardType(.decimalPad)
                                    }
                                    .padding(12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppColors.accentLight, lineWidth: 1)
                                    )
                                }
                            }
                            
                            // Age
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Age *")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(AppColors.textSecondary)
                                        .frame(width: 16)
                                    TextField("25", text: $age)
                                        .keyboardType(.numberPad)
                                }
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.accentLight, lineWidth: 1)
                                )
                            }
                            
                            // Gender
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender *")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Picker("", selection: $selectedGender) {
                                    Text("👨 Male").tag(User.Gender.male)
                                    Text("👩 Female").tag(User.Gender.female)
                                    Text("⚧ Other").tag(User.Gender.other)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        .padding(16)
                        .background(AppColors.cardBackground.opacity(0.5))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.accentLight.opacity(0.5), lineWidth: 1)
                        )
                        
                        // Error message
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                                .padding(.horizontal, 4)
                        }
                        
                        // Register button
                        Button(action: handleRegister) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Account")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.primary, AppColors.accent]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(authViewModel.isLoading || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                        .opacity((authViewModel.isLoading || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) ? 0.6 : 1.0)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    // Back to login
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Text("Already have an account?")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                            Text("Sign In")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.textPrimary)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
    }
    
    private func handleRegister() {
        // Validate passwords match
        guard password == confirmPassword else {
            authViewModel.errorMessage = "Passwords don't match"
            return
        }
        
        // Parse numeric values
        let weightValue = Double(weight)
        let heightValue = Double(height)
        let ageValue = Int(age)
        
        // Validate required fields
        guard let weight = weightValue, weight > 0 else {
            authViewModel.errorMessage = "Please enter a valid weight"
            return
        }
        guard let height = heightValue, height > 0 else {
            authViewModel.errorMessage = "Please enter a valid height"
            return
        }
        guard let age = ageValue, age > 0 else {
            authViewModel.errorMessage = "Please enter a valid age"
            return
        }
        
        // Register with all user data
        _ = authViewModel.register(
            name: name,
            email: email,
            password: password,
            weight: weightValue,
            height: heightValue,
            age: ageValue,
            gender: selectedGender
        )
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
