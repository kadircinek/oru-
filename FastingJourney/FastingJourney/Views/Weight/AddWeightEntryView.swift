import SwiftUI

/// View for adding/editing weight entry
struct AddWeightEntryView: View {
    @ObservedObject var viewModel: WeightTrackingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var weight: String = ""
    @State private var selectedDate = Date()
    @State private var note: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Weight Input
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Weight", systemImage: "scalemass.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack(spacing: 12) {
                            TextField("0.0", text: $weight)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(AppColors.primary)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.surfaceBackground)
                                )
                            
                            Text(viewModel.preferredUnit.symbol)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    
                    // MARK: - Date Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Date", systemImage: "calendar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            in: ...Date(),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .tint(AppColors.primary)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    
                    // MARK: - Note
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Note (Optional)", systemImage: "note.text")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        TextField("How are you feeling?", text: $note, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.surfaceBackground)
                            )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Add Weight")
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
                        saveEntry()
                    }
                    .foregroundColor(AppColors.primary)
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        guard let weightValue = Double(weight), weightValue > 0 else {
            return false
        }
        return true
    }
    
    private func saveEntry() {
        guard let weightValue = Double(weight) else { return }
        
        viewModel.addEntry(
            weight: weightValue,
            date: selectedDate,
            note: note.isEmpty ? nil : note
        )
        
        dismiss()
    }
}

#Preview {
    AddWeightEntryView(viewModel: WeightTrackingViewModel())
}
