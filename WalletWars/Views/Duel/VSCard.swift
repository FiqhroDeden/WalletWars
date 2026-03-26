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
        HStack(spacing: 20) {
            heroSide
            vsLabel
            rivalSide
        }
    }

    var heroSide: some View {
        VStack(spacing: 6) {
            HeroAvatar(size: 72)

            Text("YOU")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 12))
                .tracking(1)
                .foregroundStyle(Color.hero)

            Text("This Week")
                .font(.custom("PlusJakartaSans-Regular", size: 10))
                .foregroundStyle(Color.textLight)
        }
    }

    var vsLabel: some View {
        Text("VS")
            .font(.custom("PlusJakartaSans-ExtraBold", size: 20))
            .foregroundStyle(Color.textLight)
    }

    var rivalSide: some View {
        VStack(spacing: 6) {
            if hasOpponent {
                RivalAvatar(size: 72)

                Text("PAST")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 12))
                    .tracking(1)
                    .foregroundStyle(Color.rival)
            } else {
                MysteryAvatar(size: 72)

                Text("???")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 12))
                    .tracking(1)
                    .foregroundStyle(Color.textLight)
            }

            Text(hasOpponent ? "Last Week" : "No rival yet")
                .font(.custom("PlusJakartaSans-Regular", size: 10))
                .foregroundStyle(Color.textLight)
        }
    }
}
