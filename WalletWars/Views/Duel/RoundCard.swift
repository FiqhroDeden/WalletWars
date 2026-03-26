//
//  RoundCard.swift
//  WalletWars
//

import SwiftUI

struct RoundCard: View {
    let detail: RoundDetail
    let roundNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            roundHeader
            comparisonBars
            winnerLabel
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Header

private extension RoundCard {
    var roundHeader: some View {
        HStack(spacing: 8) {
            Image(systemName: detail.round.icon)
                .font(.system(size: 14))
                .foregroundStyle(Color.textMid)

            Text("ROUND \(roundNumber)")
                .font(.custom("PlusJakartaSans-Bold", size: 9))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            Text(detail.round.title)
                .font(.custom("PlusJakartaSans-SemiBold", size: 12))
                .foregroundStyle(Color.textPrimary)
        }
    }
}

// MARK: - Bars

private extension RoundCard {
    var comparisonBars: some View {
        VStack(spacing: 6) {
            barRow(label: detail.currentLabel, value: currentPct, color: Color.hero, side: "YOU")
            barRow(label: detail.lastWeekLabel, value: lastWeekPct, color: Color.rival, side: "PAST")
        }
    }

    func barRow(label: String, value: Double, color: Color, side: String) -> some View {
        HStack(spacing: 8) {
            Text(side)
                .font(.custom("PlusJakartaSans-Bold", size: 9))
                .tracking(0.5)
                .foregroundStyle(color)
                .frame(width: 32, alignment: .leading)

            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: max(4, geo.size.width * value), height: 6)
            }
            .frame(height: 6)

            Text(label)
                .font(.custom("PlusJakartaSans-Bold", size: 12))
                .foregroundStyle(Color.textPrimary)
                .frame(width: 60, alignment: .trailing)
        }
    }

    var maxValue: Double {
        max(detail.currentValue, detail.lastWeekValue, 1)
    }

    var currentPct: Double {
        detail.currentValue / maxValue
    }

    var lastWeekPct: Double {
        detail.lastWeekValue / maxValue
    }
}

// MARK: - Winner

private extension RoundCard {
    var winnerLabel: some View {
        HStack {
            Spacer()
            switch detail.winner {
            case .current:
                Label("YOU WIN", systemImage: "checkmark.circle.fill")
                    .font(.custom("PlusJakartaSans-Bold", size: 11))
                    .foregroundStyle(Color.hero)
            case .lastWeek:
                Label("PAST WINS", systemImage: "xmark.circle.fill")
                    .font(.custom("PlusJakartaSans-Bold", size: 11))
                    .foregroundStyle(Color.rival)
            case .tie:
                Label("TIED", systemImage: "equal.circle.fill")
                    .font(.custom("PlusJakartaSans-Bold", size: 11))
                    .foregroundStyle(Color.streak)
            }
        }
    }
}
