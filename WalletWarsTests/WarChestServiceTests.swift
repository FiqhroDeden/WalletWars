//
//  WarChestServiceTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

@MainActor
struct WarChestServiceTests {

    // MARK: - remainingDaysInMonth

    @Test func remainingDaysFirstDayOfMonth() {
        // First day of a 31-day month
        let calendar = Calendar.current
        let components = DateComponents(year: 2026, month: 3, day: 1)
        let date = calendar.date(from: components)!
        let result = WarChestService.remainingDaysInMonth(from: date)
        #expect(result == 31)
    }

    @Test func remainingDaysLastDayOfMonth() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2026, month: 3, day: 31)
        let date = calendar.date(from: components)!
        let result = WarChestService.remainingDaysInMonth(from: date)
        #expect(result == 1)
    }

    @Test func remainingDaysMidMonth() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2026, month: 3, day: 15)
        let date = calendar.date(from: components)!
        let result = WarChestService.remainingDaysInMonth(from: date)
        #expect(result == 17) // 31 - 15 + 1
    }

    // MARK: - totalSpentThisMonth

    @Test func totalSpentSumsCorrectly() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let calendar = Calendar.current
        let components = DateComponents(year: 2026, month: 3, day: 15)
        let midMonth = calendar.date(from: components)!

        // Add transactions in March
        let t1 = Transaction(amount: 100, date: midMonth)
        let t2 = Transaction(amount: 50, date: midMonth)
        context.insert(t1)
        context.insert(t2)
        try context.save()

        let total = try WarChestService.totalSpentThisMonth(context: context, referenceDate: midMonth)
        #expect(total == 150.0)
    }

    @Test func totalSpentExcludesPreviousMonth() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let calendar = Calendar.current
        let marchDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 15))!
        let febDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 15))!

        // Transaction in February
        let old = Transaction(amount: 200, date: febDate)
        // Transaction in March
        let current = Transaction(amount: 75, date: marchDate)
        context.insert(old)
        context.insert(current)
        try context.save()

        let total = try WarChestService.totalSpentThisMonth(context: context, referenceDate: marchDate)
        #expect(total == 75.0)
    }

    @Test func totalSpentEmptyMonth() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let total = try WarChestService.totalSpentThisMonth(context: context)
        #expect(total == 0.0)
    }

    // MARK: - totalSpentBeforeToday

    @Test func totalSpentBeforeTodayExcludesToday() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let calendar = Calendar.current
        let yesterday = calendar.date(from: DateComponents(year: 2026, month: 3, day: 14))!
        let today = calendar.date(from: DateComponents(year: 2026, month: 3, day: 15))!

        // Transaction yesterday and today
        let t1 = Transaction(amount: 100, date: yesterday)
        let t2 = Transaction(amount: 50, date: today)
        context.insert(t1)
        context.insert(t2)
        try context.save()

        // totalSpentBeforeToday should only include yesterday
        let beforeToday = try WarChestService.totalSpentBeforeToday(context: context, referenceDate: today)
        #expect(beforeToday == 100.0)

        // totalSpentThisMonth should include both
        let total = try WarChestService.totalSpentThisMonth(context: context, referenceDate: today)
        #expect(total == 150.0)
    }

    // MARK: - dailyBudgetForToday

    @Test func dailyBudgetIntegration() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let calendar = Calendar.current
        // March 1, 2026 — 31 days, nothing spent
        let date = calendar.date(from: DateComponents(year: 2026, month: 3, day: 1))!

        let budget = try WarChestService.dailyBudgetForToday(
            monthlyBudget: 3100,
            context: context,
            referenceDate: date
        )
        #expect(budget == 100.0) // 3100 / 31
    }

    @Test func dailyBudgetExcludesTodaySpending() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let calendar = Calendar.current
        let today = calendar.date(from: DateComponents(year: 2026, month: 3, day: 27))!
        // 5 remaining days, budget $1500

        // Spend $100 yesterday
        let yesterday = calendar.date(from: DateComponents(year: 2026, month: 3, day: 26))!
        let t1 = Transaction(amount: 100, date: yesterday)
        context.insert(t1)

        // Spend $50 today
        let t2 = Transaction(amount: 50, date: today)
        context.insert(t2)
        try context.save()

        // dailyBudget should be based on prior days only: (1500 - 100) / 5 = 280
        let budget = try WarChestService.dailyBudgetForToday(
            monthlyBudget: 1500,
            context: context,
            referenceDate: today
        )
        #expect(budget == 280.0)

        // warChest = dailyBudget - todaySpent = 280 - 50 = 230
        let log = DailyLog.fetchOrCreate(for: today, dailyBudget: budget, context: context)
        log.totalSpent = 50
        #expect(log.warChest == 230.0)

        // Spend another $75 today — warChest should drop by exactly $75
        log.totalSpent = 125
        // dailyBudget stays 280 (today's spending excluded from formula)
        #expect(log.warChest == 155.0) // 280 - 125 = 155, dropped by exactly 75 ✓
    }

    // MARK: - stateForToday

    @Test func stateForTodayHealthy() {
        let log = DailyLog(date: .now, dailyBudget: 100)
        log.totalSpent = 10 // 90% remaining
        #expect(WarChestService.stateForToday(dailyLog: log) == .healthy)
    }

    @Test func stateForTodayBroken() {
        let log = DailyLog(date: .now, dailyBudget: 100)
        log.totalSpent = 150 // over budget
        #expect(WarChestService.stateForToday(dailyLog: log) == .broken)
    }

    // MARK: - DailyLog budget refresh

    @Test func dailyLogUpdatesbudgetOnRefetch() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2026, month: 3, day: 27))!
        // 5 remaining days, budget $1000, no spending yet → $200/day
        let log1 = DailyLog.fetchOrCreate(for: date, dailyBudget: 200, context: context)
        #expect(log1.dailyBudget == 200)
        #expect(log1.warChest == 200)

        // Simulate spending $100
        log1.totalSpent = 100
        #expect(log1.warChest == 100) // 200 - 100

        // After spending, the monthly remaining changed so dailyBudget recalculates to 180
        // fetchOrCreate should UPDATE the dailyBudget on the existing log
        let log2 = DailyLog.fetchOrCreate(for: date, dailyBudget: 180, context: context)
        #expect(log2.id == log1.id) // same log
        #expect(log2.dailyBudget == 180) // updated, not stale 200
        #expect(log2.warChest == 80) // 180 - 100, NOT 200 - 100

        // Simulate spending another $50
        log2.totalSpent = 150
        // Recalculate: dailyBudget drops to 170
        let log3 = DailyLog.fetchOrCreate(for: date, dailyBudget: 170, context: context)
        #expect(log3.dailyBudget == 170)
        #expect(log3.warChest == 20) // 170 - 150 — still positive, always decreasing
    }
}
