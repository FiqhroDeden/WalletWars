//
//  StreakBanner.swift
//  WalletWars
//

import SwiftUI

struct StreakBanner: View {
    let logStreak: Int
    let budgetStreak: Int

    var body: some View {
        HStack(spacing: 12) {
            streakPill(
                icon: "flame.fill",
                label: "LOG STREAK",
                count: logStreak,
                color: Color.streak
            )

            streakPill(
                icon: "shield.fill",
                label: "BUDGET WIN",
                count: budgetStreak,
                color: Color.hero
            )
        }
    }

    private func streakPill(icon: String, label: String, count: Int, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.custom("PlusJakartaSans-Bold", size: 9))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(Color.textLight)

                Text("\(count) days")
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
        }
    }
}
