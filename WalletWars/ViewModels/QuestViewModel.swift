//
//  QuestViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class QuestViewModel {
    var activeQuest: SavingQuest?
    var completedQuests: [SavingQuest] = []

    var canCreateQuest: Bool {
        activeQuest == nil
    }

    var depositAmountText: String = ""

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Load

    /// Load active quest and completed quests.
    func loadQuests() throws {
        let activeRaw = QuestStatus.active.rawValue
        let activeDescriptor = FetchDescriptor<SavingQuest>(
            predicate: #Predicate<SavingQuest> { quest in
                quest.status.rawValue == activeRaw
            }
        )
        activeQuest = try context.fetch(activeDescriptor).first

        let completedRaw = QuestStatus.completed.rawValue
        let completedDescriptor = FetchDescriptor<SavingQuest>(
            predicate: #Predicate<SavingQuest> { quest in
                quest.status.rawValue == completedRaw
            },
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        completedQuests = try context.fetch(completedDescriptor)
    }

    // MARK: - Create

    /// Create a new quest with auto-generated milestones.
    /// Enforces max 1 active quest. Throws if an active quest already exists.
    @discardableResult
    func createQuest(name: String, targetAmount: Double, deadline: Date? = nil) throws -> SavingQuest {
        // Enforce max 1 active
        let activeRawValue = QuestStatus.active.rawValue
        let activeDescriptor = FetchDescriptor<SavingQuest>(
            predicate: #Predicate<SavingQuest> { quest in
                quest.status.rawValue == activeRawValue
            }
        )
        let activeCount = try context.fetchCount(activeDescriptor)
        guard activeCount == 0 else {
            throw QuestError.activeQuestExists
        }

        let quest = SavingQuest(name: name, targetAmount: targetAmount, deadline: deadline)
        context.insert(quest)

        // Auto-generate milestones
        let milestoneData = QuestMilestone.autoMilestones(for: targetAmount)
        for (index, data) in milestoneData.enumerated() {
            let milestone = QuestMilestone(
                title: data.0,
                targetAmount: data.1,
                sortOrder: index
            )
            milestone.quest = quest
            context.insert(milestone)
        }

        try context.save()
        activeQuest = quest
        return quest
    }

    // MARK: - Deposit

    /// Deposit amount to active quest.
    /// Auto-checks milestones and auto-completes if target reached.
    /// Returns list of newly completed milestones.
    @discardableResult
    func deposit(amount: Double) throws -> [QuestMilestone] {
        guard let quest = activeQuest else {
            throw QuestError.noActiveQuest
        }
        guard amount > 0 else {
            throw QuestError.invalidAmount
        }

        quest.savedAmount = min(quest.savedAmount + amount, quest.targetAmount)
        quest.updatedAt = .now

        // Update CurrentWeekTracker
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        tracker.questDeposits += amount

        // Check milestones
        let newlyCompleted = checkMilestones(quest)

        // Check quest completion
        if quest.savedAmount >= quest.targetAmount {
            completeQuest(quest)
        }

        try context.save()
        return newlyCompleted
    }

    // MARK: - Abandon

    /// Abandon the active quest.
    func abandonQuest() throws {
        guard let quest = activeQuest else {
            throw QuestError.noActiveQuest
        }

        quest.status = .abandoned
        quest.updatedAt = .now
        activeQuest = nil

        try context.save()
    }

    // MARK: - Private Helpers

    /// Check and mark milestones as completed based on current savedAmount.
    /// Returns newly completed milestones.
    private func checkMilestones(_ quest: SavingQuest) -> [QuestMilestone] {
        var newlyCompleted: [QuestMilestone] = []

        for milestone in quest.milestones.sorted(by: { $0.sortOrder < $1.sortOrder }) {
            if !milestone.isCompleted && quest.savedAmount >= milestone.targetAmount {
                milestone.isCompleted = true
                milestone.completedAt = .now
                newlyCompleted.append(milestone)
                // TODO: Sprint 5 — Award XP.questMilestone here
            }
        }

        return newlyCompleted
    }

    /// Mark quest as completed.
    private func completeQuest(_ quest: SavingQuest) {
        quest.status = .completed
        quest.completedAt = .now
        if let activatedAt = quest.activatedAt {
            quest.completionDays = Calendar.current.dateComponents(
                [.day], from: activatedAt, to: .now
            ).day
        }

        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.questsCompletedCount += 1
        // TODO: Sprint 5 — Award XP.questComplete here

        activeQuest = nil
    }
}

enum QuestError: Error, LocalizedError {
    case activeQuestExists
    case noActiveQuest
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .activeQuestExists: "You already have an active quest. Complete or abandon it first."
        case .noActiveQuest: "No active quest to deposit to."
        case .invalidAmount: "Please enter an amount greater than zero."
        }
    }
}
