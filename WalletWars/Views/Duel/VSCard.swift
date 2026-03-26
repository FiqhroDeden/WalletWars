//
//  VSCard.swift
//  WalletWars
//

import SwiftUI

struct VSCard: View {
    let hasOpponent: Bool
    let weekLabel: String

    var body: some View {
        VStack(spacing: 16) {
            weekHeader
            avatarRow
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
        }
    }
}

// MARK: - Header

private extension VSCard {
    var weekHeader: some View {
        VStack(spacing: 4) {
            Text("WEEKLY DUEL")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 12))
                .tracking(3)
                .foregroundStyle(Color.textLight)

            Text(weekLabel)
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textMid)
        }
    }
}

// MARK: - Avatars

private extension VSCard {
    var avatarRow: some View {
        HStack(spacing: 24) {
            avatarShield(
                label: "YOU",
                subtitle: "This Week",
                color: Color.hero,
                icon: "shield.fill"
            )

            Text("VS")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 20))
                .foregroundStyle(Color.textLight)

            if hasOpponent {
                avatarShield(
                    label: "PAST",
                    subtitle: "Last Week",
                    color: Color.rival,
                    icon: "shield.fill"
                )
            } else {
                avatarShield(
                    label: "???",
                    subtitle: "No rival yet",
                    color: Color.textLight,
                    icon: "questionmark.circle.fill"
                )
            }
        }
    }

    func avatarShield(label: String, subtitle: String, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
            }

            Text(label)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 12))
                .tracking(1)
                .foregroundStyle(color)

            Text(subtitle)
                .font(.custom("PlusJakartaSans-Regular", size: 10))
                .foregroundStyle(Color.textLight)
        }
    }
}
