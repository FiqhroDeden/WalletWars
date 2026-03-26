//
//  NewQuestSheet.swift
//  WalletWars
//

import SwiftUI

struct NewQuestSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var targetAmountText: String = ""
    @State private var hasDeadline: Bool = false
    @State private var deadline: Date = Calendar.current.date(byAdding: .month, value: 3, to: .now)!
    let onCreate: (String, Double, Date?) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    nameSection
                    targetSection
                    deadlineSection
                    createButton
                }
                .padding(20)
            }
            .background(Color.surface)
            .navigationTitle("New Quest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.textMid)
                }
            }
        }
    }
}

// MARK: - Sections

private extension NewQuestSheet {
    var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("QUEST NAME")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            TextField("e.g. Japan Trip", text: $name)
                .font(.custom("PlusJakartaSans-Regular", size: 16))
                .padding(14)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    var targetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TARGET AMOUNT")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            TextField("5000", text: $targetAmountText)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 28))
                .foregroundStyle(Color.victory)
                .keyboardType(.decimalPad)
                .padding(14)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    var deadlineSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $hasDeadline) {
                Text("Set deadline")
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundStyle(Color.textPrimary)
            }
            .tint(Color.victory)

            if hasDeadline {
                DatePicker(
                    "Deadline",
                    selection: $deadline,
                    in: Date.now...,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .font(.custom("PlusJakartaSans-Regular", size: 14))
            }
        }
    }

    var createButton: some View {
        Button {
            if let target = Double(targetAmountText), target > 0, !name.isEmpty {
                onCreate(name, target, hasDeadline ? deadline : nil)
                dismiss()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "flag.fill")
                Text("Start Quest")
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isFormValid ? Color.victory : Color.victory.opacity(0.4), in: RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!isFormValid)
        .padding(.top, 8)
    }

    var isFormValid: Bool {
        !name.isEmpty && (Double(targetAmountText) ?? 0) > 0
    }
}
