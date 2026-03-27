//
//  ShameMarkService.swift
//  WalletWars
//

import Foundation
import SwiftData

enum ShameMarkService {

    /// Check conditions and apply new shame marks after a transaction.
    static func checkAndApply(
        profile: PlayerProfile,
        dailyLog: DailyLog,
        context: ModelContext
    ) throws {
        // Shield Shattered: 3 consecutive days over budget
        if !dailyLog.isUnderBudget {
            let consecutiveOverDays = try countRecentOverBudgetDays(context: context)
            if consecutiveOverDays >= 3 {
                try applyIfNotActive(.shieldShattered, context: context)
            }
        }

        // Budget Breaker: monthly spend > 100%
        let totalSpent = try WarChestService.totalSpentThisMonth(context: context)
        if totalSpent > profile.monthlyBudget && profile.monthlyBudget > 0 {
            try applyIfNotActive(.budgetBreaker, context: context)
        }

        // Impulse Spender: 3+ transactions in worst category today
        if let worstCat = findWorstCategoryToday(context: context),
           worstCat.count >= 3 {
            try applyIfNotActive(.impulseSpender, metadata: worstCat.name, context: context)
        }
    }

    /// Check for Streak Destroyer when budget streak breaks.
    /// Call this BEFORE the streak is reset.
    static func checkStreakDestroyer(
        profile: PlayerProfile,
        context: ModelContext
    ) throws {
        if profile.budgetStreakCount >= 7 {
            try applyIfNotActive(.streakDestroyer, context: context)
        }
    }

    /// Update progress on active shame marks. Called on dashboard load.
    static func updateProgress(
        profile: PlayerProfile,
        context: ModelContext
    ) throws {
        let marks = try fetchActiveMarks(context: context)
        for mark in marks {
            guard let type = mark.type else { continue }
            switch type {
            case .shieldShattered:
                mark.progress = min(type.targetProgress, try countRecentUnderBudgetDays(context: context))
            case .budgetBreaker:
                mark.progress = min(type.targetProgress, try countRecentUnderBudgetDays(context: context))
            case .impulseSpender:
                let days = try countDaysWithoutCategory(mark.metadata ?? "", context: context)
                mark.progress = min(type.targetProgress, days)
            case .streakDestroyer:
                mark.progress = min(type.targetProgress, profile.budgetStreakCount)
            }

            if mark.progress >= mark.targetProgress {
                mark.isActive = false
                mark.clearedAt = .now
                XPService.awardXP(type.clearXP, to: profile)
            }
        }
        try context.save()
    }

    /// Update overspend stats on PlayerProfile. Called on dashboard load.
    static func updateOverspendStats(
        profile: PlayerProfile,
        context: ModelContext
    ) throws {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: .now))!
        let today = calendar.startOfDay(for: .now)

        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { log in
                log.date >= yesterday && log.date < today
            }
        )
        guard let yesterdayLog = try context.fetch(descriptor).first else { return }

        if !yesterdayLog.isUnderBudget {
            profile.daysOverBudgetCount += 1
            let overspend = yesterdayLog.totalSpent - yesterdayLog.dailyBudget
            if overspend > profile.worstDailyOverspend {
                profile.worstDailyOverspend = overspend
            }
        }
    }

    // MARK: - Public Helpers

    static func fetchActiveMarks(context: ModelContext) throws -> [ShameMark] {
        let descriptor = FetchDescriptor<ShameMark>(
            predicate: #Predicate<ShameMark> { $0.isActive }
        )
        return try context.fetch(descriptor)
    }

    // MARK: - Private Helpers

    private static func applyIfNotActive(
        _ type: ShameMarkType,
        metadata: String? = nil,
        context: ModelContext
    ) throws {
        let typeRaw = type.rawValue
        let descriptor = FetchDescriptor<ShameMark>(
            predicate: #Predicate<ShameMark> { mark in
                mark.isActive && mark.markType == typeRaw
            }
        )
        let existing = try context.fetch(descriptor)
        guard existing.isEmpty else { return }

        let mark = ShameMark(type: type, metadata: metadata)
        context.insert(mark)
    }

    private static func countRecentOverBudgetDays(context: ModelContext) throws -> Int {
        let descriptor = FetchDescriptor<DailyLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let logs = try context.fetch(descriptor)
        var count = 0
        for log in logs {
            if !log.isUnderBudget { count += 1 } else { break }
        }
        return count
    }

    private static func countRecentUnderBudgetDays(context: ModelContext) throws -> Int {
        let descriptor = FetchDescriptor<DailyLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let logs = try context.fetch(descriptor)
        var count = 0
        for log in logs {
            if log.isUnderBudget { count += 1 } else { break }
        }
        return count
    }

    private static func countDaysWithoutCategory(_ categoryName: String, context: ModelContext) throws -> Int {
        let descriptor = FetchDescriptor<DailyLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let logs = try context.fetch(descriptor)
        var count = 0
        for log in logs {
            let dayStart = log.date
            let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
            let txDescriptor = FetchDescriptor<Transaction>(
                predicate: #Predicate<Transaction> { tx in
                    tx.date >= dayStart && tx.date < dayEnd
                }
            )
            let transactions = try context.fetch(txDescriptor)
            let hasCategory = transactions.contains { $0.category?.name == categoryName }
            if !hasCategory { count += 1 } else { break }
        }
        return count
    }

    private static func findWorstCategoryToday(context: ModelContext) -> (name: String, count: Int)? {
        let dayStart = Calendar.current.startOfDay(for: .now)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { tx in
                tx.date >= dayStart && tx.date < dayEnd
            }
        )
        guard let transactions = try? context.fetch(descriptor) else { return nil }
        let grouped = Dictionary(grouping: transactions) { $0.category?.name ?? "Other" }
        guard let worst = grouped.max(by: { $0.value.count < $1.value.count }) else { return nil }
        return (name: worst.key, count: worst.value.count)
    }
}
