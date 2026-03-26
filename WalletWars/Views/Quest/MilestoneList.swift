//
//  MilestoneList.swift
//  WalletWars
//

import SwiftUI

struct MilestoneList: View {
    let milestones: [QuestMilestone]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("QUEST MILESTONES")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            VStack(spacing: 0) {
                ForEach(sortedMilestones, id: \.id) { milestone in
                    MilestoneRow(milestone: milestone)
                    if milestone.id != sortedMilestones.last?.id {
                        Divider().padding(.leading, 44)
                    }
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

    private var sortedMilestones: [QuestMilestone] {
        milestones.sorted { $0.sortOrder < $1.sortOrder }
    }
}

// MARK: - Milestone Row

private struct MilestoneRow: View {
    let milestone: QuestMilestone

    var body: some View {
        HStack(spacing: 12) {
            statusIcon
            details
            Spacer()
            amountLabel
        }
        .padding(.vertical, 10)
    }

    private var statusIcon: some View {
        ZStack {
            if milestone.isCompleted {
                Circle()
                    .fill(Color.victory)
                    .frame(width: 28, height: 28)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            } else {
                Circle()
                    .strokeBorder(Color.textLight, style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                    .frame(width: 28, height: 28)
            }
        }
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(milestone.title)
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(milestone.isCompleted ? Color.textPrimary : Color.textMid)

            if let completedAt = milestone.completedAt {
                Text(completedAt, format: .dateTime.month(.abbreviated).day())
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.victory)
            }
        }
    }

    private var amountLabel: some View {
        Text(String(format: "$%.0f", milestone.targetAmount))
            .font(.custom("PlusJakartaSans-Bold", size: 13))
            .foregroundStyle(milestone.isCompleted ? Color.victory : Color.textLight)
    }
}
