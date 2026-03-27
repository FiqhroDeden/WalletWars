//
//  ShameMarkServiceTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

@MainActor
struct ShameMarkServiceTests {

    @Test func applyShieldShatteredAfter3OverBudgetDays() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.monthlyBudget = 1000

        // Create 3 consecutive over-budget daily logs
        for dayOffset in -2...0 {
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Calendar.current.startOfDay(for: .now))!
            let log = DailyLog(date: date, dailyBudget: 100)
            log.totalSpent = 150
            log.isUnderBudget = false
            context.insert(log)
        }
        try context.save()

        let todayLog = DailyLog.fetchOrCreate(for: .now, dailyBudget: 100, context: context)
        todayLog.totalSpent = 150
        todayLog.isUnderBudget = false

        try ShameMarkService.checkAndApply(profile: profile, dailyLog: todayLog, context: context)
        try context.save()

        let marks = try ShameMarkService.fetchActiveMarks(context: context)
        #expect(marks.contains { $0.markType == ShameMarkType.shieldShattered.rawValue })
    }

    @Test func applyBudgetBreakerWhenOverMonthlyBudget() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.monthlyBudget = 1000

        let tx = Transaction(amount: 1100, date: .now)
        context.insert(tx)
        try context.save()

        let todayLog = DailyLog(date: .now, dailyBudget: 100)
        todayLog.isUnderBudget = false

        try ShameMarkService.checkAndApply(profile: profile, dailyLog: todayLog, context: context)
        try context.save()

        let marks = try ShameMarkService.fetchActiveMarks(context: context)
        #expect(marks.contains { $0.markType == ShameMarkType.budgetBreaker.rawValue })
    }

    @Test func streakDestroyerAppliedWhenBreaking7DayStreak() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.budgetStreakCount = 7

        try ShameMarkService.checkStreakDestroyer(profile: profile, context: context)
        try context.save()

        let marks = try ShameMarkService.fetchActiveMarks(context: context)
        #expect(marks.contains { $0.markType == ShameMarkType.streakDestroyer.rawValue })
    }

    @Test func shameMarkClearsWithProgress() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)
        let initialXP = profile.totalXP

        let mark = ShameMark(type: .shieldShattered)
        context.insert(mark)
        try context.save()

        // Create 5 consecutive under-budget days
        for dayOffset in -4...0 {
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Calendar.current.startOfDay(for: .now))!
            let log = DailyLog(date: date, dailyBudget: 100)
            log.totalSpent = 50
            log.isUnderBudget = true
            context.insert(log)
        }
        try context.save()

        try ShameMarkService.updateProgress(profile: profile, context: context)

        #expect(mark.isActive == false)
        #expect(mark.clearedAt != nil)
        #expect(profile.totalXP == initialXP + ShameMarkType.shieldShattered.clearXP)
    }

    @Test func duplicateShameMarkNotApplied() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.monthlyBudget = 1000

        let existing = ShameMark(type: .budgetBreaker)
        context.insert(existing)

        let tx = Transaction(amount: 1100, date: .now)
        context.insert(tx)
        try context.save()

        let todayLog = DailyLog(date: .now, dailyBudget: 100)
        todayLog.isUnderBudget = false

        try ShameMarkService.checkAndApply(profile: profile, dailyLog: todayLog, context: context)
        try context.save()

        let marks = try ShameMarkService.fetchActiveMarks(context: context)
        let budgetBreakers = marks.filter { $0.markType == ShameMarkType.budgetBreaker.rawValue }
        #expect(budgetBreakers.count == 1)
    }
}
