//
//  WarChestServiceTests.swift
//  WalletWarsTests
//

import Testing
import SwiftData
@testable import WalletWars

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
}
