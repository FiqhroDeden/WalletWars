//
//  LifetimeStatsCard.swift
//  WalletWars
//

import SwiftUI

struct LifetimeStatsCard: View {
    let totalTransactions: Int
    let questsCompleted: Int
    let duelsWon: Int
    let duelsPlayed: Int
    let daysOverBudget: Int
    let worstOverspend: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LIFETIME PERFORMANCE")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            VStack(spacing: 0) {
                statRow(label: "Total Transactions", value: "\(totalTransactions)")
                Divider()
                statRow(label: "Quests Completed", value: "\(questsCompleted)")
                Divider()
                statRow(label: "Duels Won", value: "\(duelsWon) / \(duelsPlayed)")
                Divider()
                statRow(label: "Win Rate", value: winRate)
                if daysOverBudget > 0 {
                    Divider()
                    statRowRed(label: "Days Over Budget", value: "\(daysOverBudget)")
                }
                if worstOverspend > 0 {
                    Divider()
                    statRowRed(label: "Worst Overspend", value: "$\(Int(worstOverspend))")
                }
            }
            .padding(12)
            .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
            }
        }
    }

    private func statRowRed(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textMid)
            Spacer()
            Text(value)
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.rival)
                .monospacedDigit()
        }
        .padding(.vertical, 10)
    }

    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textMid)
            Spacer()
            Text(value)
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.hero)
                .monospacedDigit()
        }
        .padding(.vertical, 10)
    }

    private var winRate: String {
        guard duelsPlayed > 0 else { return "—" }
        let rate = Double(duelsWon) / Double(duelsPlayed) * 100
        return "\(Int(rate))%"
    }
}
