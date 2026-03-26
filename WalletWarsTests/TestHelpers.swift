//
//  TestHelpers.swift
//  WalletWarsTests
//

import SwiftData
@testable import WalletWars

private typealias Category = WalletWars.Category

enum TestHelpers {
    /// Creates an in-memory ModelContainer with all WalletWars models.
    static func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: Transaction.self, Category.self, SavingQuest.self,
            QuestMilestone.self, PlayerProfile.self, WeeklySnapshot.self,
            CurrentWeekTracker.self, DailyLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
}
