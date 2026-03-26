//
//  BadgeGrid.swift
//  WalletWars
//

import SwiftUI

struct BadgeGrid: View {
    let unlockedBadges: [String]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MEDALS & ACHIEVEMENTS")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(BadgeType.allCases, id: \.rawValue) { badge in
                    BadgeCell(badge: badge, isUnlocked: unlockedBadges.contains(badge.rawValue))
                }
            }
        }
    }
}

// MARK: - Badge Cell

private struct BadgeCell: View {
    let badge: BadgeType
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color(hex: badge.colorHex).opacity(0.15) : Color.surfaceHigh)
                    .frame(width: 52, height: 52)

                if isUnlocked {
                    Image(systemName: badge.icon)
                        .font(.system(size: 22))
                        .foregroundStyle(Color(hex: badge.colorHex))
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.textLight)
                }
            }

            Text(badge.title)
                .font(.custom("PlusJakartaSans-Bold", size: 9))
                .foregroundStyle(isUnlocked ? Color.textPrimary : Color.textLight)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}
