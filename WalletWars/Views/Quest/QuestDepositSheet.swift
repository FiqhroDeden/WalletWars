//
//  QuestDepositSheet.swift
//  WalletWars
//

import SwiftUI

struct QuestDepositSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amountText: String = ""
    let questName: String
    let onDeposit: (Double) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                questLabel
                amountInput
                depositButton
                Spacer()
            }
            .padding(20)
            .background(Color.surface)
            .navigationTitle("Deposit")
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

// MARK: - Subviews

private extension QuestDepositSheet {
    var questLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: "flag.fill")
                .foregroundStyle(Color.victory)
            Text(questName)
                .font(.custom("PlusJakartaSans-Bold", size: 16))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.top, 8)
    }

    var amountInput: some View {
        VStack(spacing: 8) {
            TextField("0.00", text: $amountText)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 40))
                .foregroundStyle(Color.victory)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)

            Text("Amount to deposit")
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textLight)
        }
    }

    var depositButton: some View {
        Button {
            if let amount = Double(amountText), amount > 0 {
                onDeposit(amount)
                dismiss()
            }
        } label: {
            Text("Deposit to Quest")
                .font(.custom("PlusJakartaSans-Bold", size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.victory, in: RoundedRectangle(cornerRadius: 14))
        }
        .disabled(Double(amountText) == nil || (Double(amountText) ?? 0) <= 0)
    }
}
