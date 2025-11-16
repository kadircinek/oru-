import SwiftUI

struct PersonalInfoEditView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var selectedGender: User.Gender = .male
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Info Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color.blue)
                        Text("Update Your Profile")
                            .font(.headline)
                    }
                    Text("This information is used for calorie tracking and personalized features.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // Weight Field
                VStack(alignment: .leading, spacing: 8) {
                    Label("Weight (kg) *", systemImage: "scalemass.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your weight", text: $weight)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                // Height Field
                VStack(alignment: .leading, spacing: 8) {
                    Label("Height (cm) *", systemImage: "ruler.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your height", text: $height)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                // Age Field
                VStack(alignment: .leading, spacing: 8) {
                    Label("Age *", systemImage: "calendar")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your age", text: $age)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                // Gender Picker
                VStack(alignment: .leading, spacing: 8) {
                    Label("Gender *", systemImage: "person.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker("Gender", selection: $selectedGender) {
                        ForEach([User.Gender.male, User.Gender.female, User.Gender.other], id: \.self) { gender in
                            Text(gender.displayName).tag(gender)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Save Button
                Button(action: savePersonalInfo) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Changes")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Personal Info")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadUserData)
        .alert("Message", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadUserData() {
        if let user = authViewModel.currentUser {
            if let w = user.weight {
                weight = String(format: "%.1f", w)
            }
            if let h = user.height {
                height = String(format: "%.1f", h)
            }
            if let a = user.age {
                age = String(a)
            }
            if let g = user.gender {
                selectedGender = g
            }
        }
    }
    
    private func savePersonalInfo() {
        // Validate fields
        guard let weightValue = Double(weight), weightValue > 0 else {
            alertMessage = "Please enter a valid weight"
            showAlert = true
            return
        }
        
        guard let heightValue = Double(height), heightValue > 0 else {
            alertMessage = "Please enter a valid height"
            showAlert = true
            return
        }
        
        guard let ageValue = Int(age), ageValue > 0, ageValue < 150 else {
            alertMessage = "Please enter a valid age"
            showAlert = true
            return
        }
        
        // Update user info
        authViewModel.updateUserInfo(
            weight: weightValue,
            height: heightValue,
            age: ageValue,
            gender: selectedGender
        )
        
        alertMessage = "Personal info updated successfully!"
        showAlert = true
        
        // Dismiss after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

#Preview {
    NavigationView {
        PersonalInfoEditView()
            .environmentObject(AuthViewModel())
    }
}
