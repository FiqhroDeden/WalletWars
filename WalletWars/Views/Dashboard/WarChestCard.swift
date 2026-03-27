//
//  WarChestCard.swift
//  WalletWars
//

import SwiftUI

struct WarChestCard: View {
    let amount: Double
    let state: WarChestState
    let percentRemaining: Double
    let monthlyBudget: Double

    var body: some View {
        VStack(spacing: 16) {
            headerRow
            amountDisplay
            progressSection
            stateLabel
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(stateColor.opacity(0.2), lineWidth: 1.5)
        }
    }

    private var stateColor: Color {
        Color.warChestColor(state)
    }
}

// MARK: - Header

private extension WarChestCard {
    var headerRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("WAR CHEST")
                    .font(.custom("PlusJakartaSans-Bold", size: 10))
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.textLight)

                Text("Daily Funds")
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundStyle(Color.textMid)

                Text("from $\(monthlyBudget, specifier: "%.0f")/mo budget")
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textLight)
            }

            Spacer()

            Image(systemName: "shield.fill")
                .font(.system(size: 20))
                .foregroundStyle(stateColor)
        }
    }
}

// MARK: - Amount Display

private extension WarChestCard {
    var amountDisplay: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("$")
                .font(.custom("PlusJakartaSans-Bold", size: 18))
                .foregroundStyle(Color.textMid)

            Text(formattedAmount)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 40))
                .foregroundStyle(stateColor)
                .contentTransition(.numericText())

            Text(amount >= 0 ? "remaining" : "over budget")
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(amount >= 0 ? Color.textLight : stateColor)
                .padding(.leading, 4)
        }
    }

    var formattedAmount: String {
        let absAmount = abs(amount)
        if absAmount >= 1000 {
            return String(format: "%.0f", absAmount)
        }
        return String(format: "%.2f", absAmount)
    }
}

// MARK: - Progress

private extension WarChestCard {
    var progressSection: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surfaceHigh)
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(stateColor)
                    .frame(width: max(0, geo.size.width * clampedPercent), height: 8)
                    .animation(.springMedium, value: percentRemaining)
            }
        }
        .frame(height: 8)
    }

    var clampedPercent: Double {
        max(0, min(1, percentRemaining))
    }
}

// MARK: - State Label

private extension WarChestCard {
    var stateLabel: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(stateColor)
                    .frame(width: 8, height: 8)

                Text(stateText)
                    .font(.custom("PlusJakartaSans-Bold", size: 12))
                    .foregroundStyle(stateColor)
            }

            Spacer()

            Text("\(Int(clampedPercent * 100))% capacity")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textLight)
        }
    }

    var stateText: String {
        switch state {
        case .healthy:  "Healthy"
        case .cautious: "Watch it"
        case .critical: "Almost gone"
        case .broken:   "Shield Broken!"
        }
    }
}
