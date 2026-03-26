//
//  SavingQuest.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class SavingQuest {
    var id: UUID
    var name: String
    var targetAmount: Double
    var savedAmount: Double
    var status: QuestStatus
    var deadline: Date?
    var activatedAt: Date?
    var completedAt: Date?
    var completionDays: Int?
    var xpEarned: Int
    @Relationship(deleteRule: .cascade, inverse: \QuestMilestone.quest)
    var milestones: [QuestMilestone]
    var createdAt: Date
    var updatedAt: Date

    init(
        name: String,
        targetAmount: Double,
        deadline: Date? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.targetAmount = targetAmount
        self.savedAmount = 0
        self.status = .active
        self.deadline = deadline
        self.activatedAt = .now
        self.completedAt = nil
        self.completionDays = nil
        self.xpEarned = 0
        self.milestones = []
        self.createdAt = .now
        self.updatedAt = .now
    }

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, savedAmount / targetAmount)
    }

    var daysRemaining: Int? {
        guard let deadline else { return nil }
        return Calendar.current.dateComponents([.day], from: .now, to: deadline).day
    }
}
