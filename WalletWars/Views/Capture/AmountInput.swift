//
//  AmountInput.swift
//  WalletWars
//

import SwiftUI

struct AmountInput: View {
    let amountText: String
    let currencySymbol: String

    var body: some View {
        VStack(spacing: 4) {
            Text("BATTLE EXPENSE")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .textCase(.uppercase)
                .tracking(2)
                .foregroundStyle(Color.textLight)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(currencySymbol)
                    .font(.custom("PlusJakartaSans-Bold", size: 24))
                    .foregroundStyle(Color.textMid)

                Text(displayAmount)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 48))
                    .foregroundStyle(Color.textPrimary)
                    .contentTransition(.numericText())
                    .animation(.springFast, value: amountText)

                // Blinking cursor
                Rectangle()
                    .fill(Color.hero)
                    .frame(width: 2, height: 36)
                    .opacity(amountText.isEmpty ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(), value: amountText.isEmpty)
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 8)
    }

    private var displayAmount: String {
        amountText.isEmpty ? "0" : amountText
    }
}
