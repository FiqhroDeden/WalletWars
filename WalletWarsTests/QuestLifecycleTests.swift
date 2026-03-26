//
//  QuestLifecycleTests.swift
//  WalletWarsTests
//

import Testing
import SwiftData
@testable import WalletWars

@MainActor
struct QuestLifecycleTests {

    // MARK: - Creation

    @Test func createQuestSetsActiveStatus() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        let quest = try vm.createQuest(name: "Japan Trip", targetAmount: 5000)

        #expect(quest.status == .active)
        #expect(quest.name == "Japan Trip")
        #expect(quest.targetAmount == 5000)
        #expect(quest.savedAmount == 0)
        #expect(quest.activatedAt != nil)
    }

    @Test func createQuestWithAutoMilestones() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        let quest = try vm.createQuest(name: "Save", targetAmount: 1000)

        #expect(quest.milestones.count == 4)
    }

    @Test func createQuestMilestonesAt20_50_80_100Percent() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        let quest = try vm.createQuest(name: "Save", targetAmount: 1000)

        let sorted = quest.milestones.sorted { $0.sortOrder < $1.sortOrder }
        #expect(sorted[0].targetAmount == 200)  // 20%
        #expect(sorted[1].targetAmount == 500)  // 50%
        #expect(sorted[2].targetAmount == 800)  // 80%
        #expect(sorted[3].targetAmount == 1000) // 100%
    }

    @Test func createQuestEnforcesMaxOneActive() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "First", targetAmount: 1000)

        #expect(throws: QuestError.self) {
            try vm.createQuest(name: "Second", targetAmount: 2000)
        }
    }

    @Test func canCreateQuestProperty() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        #expect(vm.canCreateQuest == true)

        try vm.createQuest(name: "Quest", targetAmount: 1000)
        #expect(vm.canCreateQuest == false)
    }

    // MARK: - Deposit

    @Test func depositIncrementsSavedAmount() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 1000)

        try vm.deposit(amount: 100)
        #expect(vm.activeQuest?.savedAmount == 100)
    }

    @Test func depositTriggersFirstMilestone() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 1000)

        let completed = try vm.deposit(amount: 200)
        #expect(completed.count == 1)
        #expect(completed[0].title == "First Steps")
        #expect(completed[0].isCompleted == true)
        #expect(completed[0].completedAt != nil)
    }

    @Test func depositTriggersMultipleMilestones() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 1000)

        // Deposit enough to hit 20% and 50%
        let completed = try vm.deposit(amount: 500)
        #expect(completed.count == 2)
    }

    @Test func depositUpdatesWeekTrackerQuestDeposits() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 1000)
        try vm.deposit(amount: 100)

        let tracker = try context.fetch(FetchDescriptor<CurrentWeekTracker>()).first!
        #expect(tracker.questDeposits == 100.0)
    }

    @Test func depositWithNoActiveQuestThrows() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        #expect(throws: QuestError.self) {
            try vm.deposit(amount: 100)
        }
    }

    // MARK: - Completion

    @Test func depositToTargetCompletesQuest() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 100)
        try vm.deposit(amount: 100)

        #expect(vm.activeQuest == nil)

        let quests = try context.fetch(FetchDescriptor<SavingQuest>())
        #expect(quests[0].status == .completed)
    }

    @Test func completedQuestHasCompletionDate() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 100)
        try vm.deposit(amount: 100)

        let quest = try context.fetch(FetchDescriptor<SavingQuest>()).first!
        #expect(quest.completedAt != nil)
    }

    @Test func completedQuestIncrementsProfileCount() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 100)
        try vm.deposit(amount: 100)

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.questsCompletedCount == 1)
    }

    // MARK: - Abandon

    @Test func abandonQuestSetsAbandonedStatus() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "Save", targetAmount: 1000)
        try vm.abandonQuest()

        #expect(vm.activeQuest == nil)
        let quest = try context.fetch(FetchDescriptor<SavingQuest>()).first!
        #expect(quest.status == .abandoned)
    }

    @Test func abandonQuestAllowsNewQuestCreation() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        try vm.createQuest(name: "First", targetAmount: 1000)
        try vm.abandonQuest()

        #expect(vm.canCreateQuest == true)
        let newQuest = try vm.createQuest(name: "Second", targetAmount: 2000)
        #expect(newQuest.status == .active)
    }

    // MARK: - Progress

    @Test func questProgressComputedCorrectly() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuestViewModel(context: context)
        let quest = try vm.createQuest(name: "Save", targetAmount: 1000)
        #expect(quest.progress == 0.0)

        try vm.deposit(amount: 500)
        #expect(vm.activeQuest?.progress == 0.5)
    }
}
