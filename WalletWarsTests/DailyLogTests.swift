//
//  DailyLogTests.swift
//  WalletWarsTests
//

import Testing
import SwiftData
@testable import WalletWars

struct DailyLogTests {

    @Test func initializesWithStartOfDay() {
        let now = Date.now
        let log = DailyLog(date: now, dailyBudget: 100)
        let expected = Calendar.current.startOfDay(for: now)
        #expect(log.date == expected)
    }

    @Test func warChestComputedProperty() {
        let log = DailyLog(date: .now, dailyBudget: 100)
        log.totalSpent = 30
        #expect(log.warChest == 70.0)
    }

    @Test func warChestPctComputedProperty() {
        let log = DailyLog(date: .now, dailyBudget: 100)
        log.totalSpent = 20
        #expect(log.warChestPct == 0.8)
    }

    @Test func warChestPctZeroBudget() {
        let log = DailyLog(date: .now, dailyBudget: 0)
        #expect(log.warChestPct == 0.0)
    }

    @Test func warChestPctNeverNegative() {
        let log = DailyLog(date: .now, dailyBudget: 100)
        log.totalSpent = 150
        #expect(log.warChestPct == 0.0)
    }

    @Test func isUnderBudgetInitiallyTrue() {
        let log = DailyLog(date: .now, dailyBudget: 100)
        #expect(log.isUnderBudget == true)
    }

    @Test func fetchOrCreateCreatesNewLog() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let log = DailyLog.fetchOrCreate(for: .now, dailyBudget: 100, context: context)
        #expect(log.dailyBudget == 100.0)
        #expect(log.totalSpent == 0.0)

        let allLogs = try context.fetch(FetchDescriptor<DailyLog>())
        #expect(allLogs.count == 1)
    }

    @Test func fetchOrCreateReturnsSameLog() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let log1 = DailyLog.fetchOrCreate(for: .now, dailyBudget: 100, context: context)
        let log2 = DailyLog.fetchOrCreate(for: .now, dailyBudget: 200, context: context)

        #expect(log1.id == log2.id)
        // Budget should be from original creation, not overwritten
        #expect(log2.dailyBudget == 100.0)

        let allLogs = try context.fetch(FetchDescriptor<DailyLog>())
        #expect(allLogs.count == 1)
    }

    @Test func updateOnTransactionIncrementsSpent() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let log = DailyLog.fetchOrCreate(for: .now, dailyBudget: 100, context: context)
        log.totalSpent += 25
        log.transactionCount += 1
        log.isUnderBudget = log.totalSpent <= log.dailyBudget

        #expect(log.totalSpent == 25.0)
        #expect(log.transactionCount == 1)
        #expect(log.isUnderBudget == true)
        #expect(log.warChest == 75.0)
    }
}
