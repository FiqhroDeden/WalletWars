//
//  DuelHistoryList.swift
//  WalletWars
//

import SwiftUI

struct DuelHistoryList: View {
    let snapshots: [WeeklySnapshot]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("DUEL HISTORY")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)
                .padding(.leading, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(snapshots, id: \.id) { snapshot in
                        historyChip(snapshot)
                    }
                }
            }
        }
    }

    private func historyChip(_ snapshot: WeeklySnapshot) -> some View {
        let weekNum = weekNumber(for: snapshot.weekStartDate)
        let color = chipColor(snapshot.duelResult)
        let label = chipLabel(snapshot)

        return VStack(spacing: 4) {
            Text("W\(weekNum)")
                .font(.custom("PlusJakartaSans-Bold", size: 11))
                .foregroundStyle(color)

            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 10))
                .foregroundStyle(Color.textMid)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
    }

    private func weekNumber(for date: Date) -> Int {
        Calendar.current.component(.weekOfYear, from: date)
    }

    private func chipColor(_ result: DuelResult?) -> Color {
        switch result {
        case .win:  return .victory
        case .loss: return .rival
        case .draw: return .streak
        case .none: return .textLight
        }
    }

    private func chipLabel(_ snapshot: WeeklySnapshot) -> String {
        guard let result = snapshot.duelResult else { return "—" }
        switch result {
        case .win:  return "Win \(snapshot.roundsWon)-\(snapshot.roundsLost)"
        case .loss: return "Loss \(snapshot.roundsLost)-\(snapshot.roundsWon)"
        case .draw: return "Draw \(snapshot.roundsWon)-\(snapshot.roundsLost)"
        }
    }
}
