//
//  QuestMilestone.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class QuestMilestone {
    var id: UUID
    var title: String
    var targetAmount: Double
    var isCompleted: Bool
    var completedAt: Date?
    var sortOrder: Int
    var quest: SavingQuest?

    init(
        title: String,
        targetAmount: Double,
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.targetAmount = targetAmount
        self.isCompleted = false
        self.completedAt = nil
        self.sortOrder = sortOrder
    }

    static func autoMilestones(for target: Double) -> [(String, Double)] {
        [
            ("First Steps",    target * 0.2),
            ("Halfway There",  target * 0.5),
            ("Almost There",   target * 0.8),
            ("Quest Complete", target * 1.0),
        ]
    }
}
