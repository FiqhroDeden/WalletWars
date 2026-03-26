//
//  LevelCard.swift
//  WalletWars
//

import SwiftUI

struct LevelCard: View {
    let level: Int
    let title: String
    let totalXP: Int

    var body: some View {
        VStack(spacing: 14) {
            headerRow
            xpProgressBar
            xpLabels
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.hero.opacity(0.2), lineWidth: 1.5)
        }
    }
}

// MARK: - Header

private extension LevelCard {
    var headerRow: some View {
        VStack(spacing: 4) {
            Text("TACTICAL STATUS")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("Level \(level)")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 28))
                    .foregroundStyle(Color.textPrimary)

                Text("—")
                    .foregroundStyle(Color.textLight)

                Text(title)
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.hero)
            }

            Text("\(Int(progressPct * 100))%")
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.hero)
        }
    }
}

// MARK: - Progress

private extension LevelCard {
    var xpProgressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.hero.opacity(0.15))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.hero)
                    .frame(width: max(4, geo.size.width * progressPct), height: 8)
                    .animation(.springMedium, value: totalXP)
            }
        }
        .frame(height: 8)
    }

    var xpLabels: some View {
        HStack {
            Text("\(xpInCurrentLevel) XP")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textMid)

            Spacer()

            Text("\(xpForNextLevel) XP to Level \(level + 1)")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textLight)
        }
    }

    var xpForNextLevel: Int {
        (level + 1) * 100
    }

    var cumulativeXPForCurrentLevel: Int {
        (1...max(1, level)).reduce(0) { $0 + $1 * 100 }
    }

    var xpInCurrentLevel: Int {
        totalXP - cumulativeXPForCurrentLevel
    }

    var progressPct: Double {
        guard xpForNextLevel > 0 else { return 0 }
        return max(0, min(1, Double(xpInCurrentLevel) / Double(xpForNextLevel)))
    }
}
