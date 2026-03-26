//
//  StreakServiceTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

@MainActor
struct StreakServiceTests {

    // MARK: - Logging Streak

    @Test func firstLogStartsStreak() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        StreakService.updateLoggingStreak(profile: profile)
        #expect(profile.logStreakCount == 1)
        #expect(profile.logStreakLastDate != nil)
    }

    @Test func sameLogDoesNotDouble() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        StreakService.updateLoggingStreak(profile: profile)
        StreakService.updateLoggingStreak(profile: profile)
        #expect(profile.logStreakCount == 1)
    }

    @Test func loggingStreakAwardsXP() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        // First log — starts streak, awards XP
        StreakService.updateLoggingStreak(profile: profile)
        // XP includes logging streak award
        #expect(profile.totalXP > 0)
    }

    @Test func logStreakBestTracked() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.logStreakCount = 10
        profile.logStreakBest = 5
        profile.logStreakLastDate = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))

        StreakService.updateLoggingStreak(profile: profile)
        #expect(profile.logStreakBest == 11)
    }

    // MARK: - Budget Streak

    @Test func firstBudgetDayStartsStreak() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        StreakService.updateBudgetStreak(profile: profile)
        #expect(profile.budgetStreakCount == 1)
    }

    @Test func budgetStreakAwardsXP() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        StreakService.updateBudgetStreak(profile: profile)
        #expect(profile.totalXP > 0)
    }

    @Test func breakBudgetStreakResetsToZero() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.budgetStreakCount = 5
        StreakService.breakBudgetStreak(profile: profile)
        #expect(profile.budgetStreakCount == 0)
    }

    @Test func budgetStreakBestTracked() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.budgetStreakCount = 8
        profile.budgetStreakBest = 3
        profile.budgetStreakLastDate = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))

        StreakService.updateBudgetStreak(profile: profile)
        #expect(profile.budgetStreakBest == 9)
    }
}
