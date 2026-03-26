//
//  DuelResultBanner.swift
//  WalletWars
//

import SwiftUI

struct DuelResultBanner: View {
    let result: DuelResult
    let roundsWon: Int
    let roundsLost: Int
    let momentumPct: Double
    let momentumState: MomentumState

    var body: some View {
        VStack(spacing: 12) {
            resultHeader
            momentumRow
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(resultColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(resultColor.opacity(0.3), lineWidth: 1.5)
        }
    }
}

// MARK: - Result Header

private extension DuelResultBanner {
    var resultHeader: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: resultIcon)
                    .font(.system(size: 22))
                Text(resultText)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
            }
            .foregroundStyle(resultColor)

            Text("+\(xpReward) XP")
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.streak)
        }
    }

    var resultText: String {
        switch result {
        case .win:  "YOU WIN \(roundsWon)-\(roundsLost)!"
        case .loss: "YOU LOSE \(roundsLost)-\(roundsWon)"
        case .draw: "DRAW \(roundsWon)-\(roundsLost)"
        }
    }

    var resultIcon: String {
        switch result {
        case .win:  "trophy.fill"
        case .loss: "shield.slash.fill"
        case .draw: "equal.circle.fill"
        }
    }

    var resultColor: Color {
        switch result {
        case .win:  .victory
        case .loss: .rival
        case .draw: .streak
        }
    }

    var xpReward: Int {
        switch result {
        case .win:  XP.duelWin
        case .loss: XP.duelLoss
        case .draw: XP.duelDraw
        }
    }
}

// MARK: - Momentum

private extension DuelResultBanner {
    var momentumRow: some View {
        HStack(spacing: 6) {
            Image(systemName: momentumState.icon)
                .font(.system(size: 14))

            Text("Momentum:")
                .font(.custom("PlusJakartaSans-Regular", size: 12))

            Text(momentumState.label)
                .font(.custom("PlusJakartaSans-Bold", size: 12))

            Text(String(format: "%+.0f%%", momentumPct))
                .font(.custom("PlusJakartaSans-Bold", size: 12))
        }
        .foregroundStyle(Color.textMid)
    }
}
