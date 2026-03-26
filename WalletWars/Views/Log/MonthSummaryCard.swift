//
//  MonthSummaryCard.swift
//  WalletWars
//

import SwiftUI

struct MonthSummaryCard: View {
    let totalSpent: Double
    let monthlyBudget: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            amountRow
            progressBar
            percentLabel
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var percentage: Double {
        guard monthlyBudget > 0 else { return 0 }
        return min(totalSpent / monthlyBudget, 1.5)
    }

    private var progressColor: Color {
        switch percentage {
        case ..<0.5:  return .victory
        case 0.5..<0.8: return .streak
        case 0.8..<1.0: return .rival
        default: return .rivalDeep
        }
    }
}

// MARK: - Subviews

private extension MonthSummaryCard {
    var headerRow: some View {
        HStack {
            Text("THIS MONTH")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .textCase(.uppercase)
                .tracking(2)
                .foregroundStyle(Color.textLight)

            Spacer()

            Text(Date.now, format: .dateTime.month(.wide).year())
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textLight)
        }
    }

    var amountRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("Spent: ")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(Color.textMid)

            Text("$\(totalSpent, specifier: "%.0f")")
                .font(.custom("PlusJakartaSans-Bold", size: 20))
                .foregroundStyle(Color.textPrimary)

            Text("/ $\(monthlyBudget, specifier: "%.0f")")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(Color.textLight)
        }
    }

    var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surfaceHigh)
                    .frame(height: 6)

                RoundedRectangle(cornerRadius: 4)
                    .fill(progressColor)
                    .frame(width: max(0, geo.size.width * min(percentage, 1.0)), height: 6)
            }
        }
        .frame(height: 6)
    }

    var percentLabel: some View {
        Text("\(Int(percentage * 100))% of budget")
            .font(.custom("PlusJakartaSans-Regular", size: 12))
            .foregroundStyle(progressColor)
    }
}
