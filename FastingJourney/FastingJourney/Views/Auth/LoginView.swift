import SwiftUI

/// Login screen with modern design
struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var currentTipIndex = 0
    
    // Health tips and motivational messages
    private let healthTips = [
        "💚 Healthy eating improves your quality of life",
        "🥗 Balanced nutrition boosts your energy levels",
        "💧 Drinking plenty of water speeds up your metabolism",
        "🏃‍♀️ Regular movement is the key to healthy living",
        "🌱 Small steps create big changes",
        "⭐️ Every day is a new opportunity to start fresh",
        "🎯 Focus on your goals, success will follow",
        "💪 A strong body starts with a strong mind"
    ]
    
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
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
                        // Logo and welcome
                        VStack(spacing: 16) {
                            // Healthy eating icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [AppColors.primary.opacity(0.2), AppColors.accent.opacity(0.2)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                
                                Text("🥗")
                                    .font(.system(size: 64))
                            }
                            
                            Text("Welcome Back")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            Text("Sign in to continue your fasting journey")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            // Health tip veya motivasyon
                            VStack(spacing: 8) {
                                Text(healthTips[currentTipIndex])
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.primary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(AppColors.primary.opacity(0.1))
                                    )
                                    .animation(.easeInOut, value: currentTipIndex)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.top, 50)
                        
                        // Login form
                        VStack(spacing: 20) {
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
                                        TextField("Enter your password", text: $password)
                                    } else {
                                        SecureField("Enter your password", text: $password)
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
                            
                            // Error message
                            if let error = authViewModel.errorMessage {
                                Text(error)
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 4)
                            }
                            
                            // Login button
                            Button(action: {
                                _ = authViewModel.login(email: email, password: password)
                            }) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Sign In")
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
                            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                            .opacity((authViewModel.isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 24)
                        
                        // Register link
                        VStack(spacing: 16) {
                            Text("Don't have an account?")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                            
                            NavigationLink(destination: RegisterView().environmentObject(authViewModel)) {
                                Text("Create Account")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                    .padding(.vertical, 14)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primary, lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .onReceive(timer) { _ in
                withAnimation {
                    currentTipIndex = (currentTipIndex + 1) % healthTips.count
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
