//
//  PlayerProfileTests.swift
//  WalletWarsTests
//

import Testing
import SwiftData
@testable import WalletWars

struct PlayerProfileTests {

    @Test func fetchOrCreateCreatesSingleton() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.totalXP == 0)
        #expect(profile.currentLevel == 1)

        let all = try context.fetch(FetchDescriptor<PlayerProfile>())
        #expect(all.count == 1)
    }

    @Test func fetchOrCreateReturnsSameInstance() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let p1 = PlayerProfile.fetchOrCreate(context: context)
        let p2 = PlayerProfile.fetchOrCreate(context: context)
        #expect(p1.id == p2.id)
    }

    @Test func defaultValuesCorrect() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.monthlyBudget == 0)
        #expect(profile.currencyCode == "IDR")
        #expect(profile.hasCompletedOnboarding == false)
        #expect(profile.unlockedBadges.isEmpty)
        #expect(profile.logStreakCount == 0)
        #expect(profile.budgetStreakCount == 0)
    }

    @Test func updateMonthlyBudget() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        vm.updateBudget(3000)

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.monthlyBudget == 3000)
        #expect(vm.monthlyBudget == 3000)
    }

    @Test func updateCurrencyCode() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        vm.updateCurrency("USD")

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.currencyCode == "USD")
        #expect(vm.currencyCode == "USD")
    }

    @Test func incrementTotalTransactions() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.totalTransactions += 1
        profile.totalTransactions += 1

        #expect(profile.totalTransactions == 2)
    }

    @Test func incrementQuestsCompletedCount() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.questsCompletedCount += 1

        #expect(profile.questsCompletedCount == 1)
    }
}
