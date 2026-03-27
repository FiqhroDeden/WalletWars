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

        // Impulse Spender: 3+ transactions in worst discretionary category today
        if let worstCat = findWorstDiscretionaryCategoryToday(context: context),
           worstCat.count >= 3 {
            try applyOrUpdateImpulseSpender(categoryName: worstCat.name, context: context)
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

    /// Check for Big Spender: single transaction exceeds 50% of daily budget.
    static func checkBigSpender(
        amount: Double,
        dailyBudget: Double,
        categoryName: String?,
        context: ModelContext
    ) throws {
        guard dailyBudget > 0, amount > dailyBudget * 0.5 else { return }
        try applyIfNotActive(.bigSpender, metadata: categoryName, context: context)
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
                let days = try countDaysWithCategoryUnderLimit(mark.metadata ?? "", limit: 2, context: context)
                mark.progress = min(type.targetProgress, days)
            case .streakDestroyer:
                mark.progress = min(type.targetProgress, profile.budgetStreakCount)
            case .bigSpender:
                let days = try countDaysWithAllTransactionsUnderBudgetPct(0.3, context: context)
                mark.progress = min(type.targetProgress, days)
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

    /// Re-evaluate impulse spender shame mark after a transaction delete.
    /// If the category no longer has 3+ transactions today, remove the mark.
    static func reverseImpulseSpenderIfNeeded(context: ModelContext) throws {
        let typeRaw = ShameMarkType.impulseSpender.rawValue
        let descriptor = FetchDescriptor<ShameMark>(
            predicate: #Predicate<ShameMark> { mark in
                mark.isActive && mark.markType == typeRaw
            }
        )
        guard let mark = try context.fetch(descriptor).first,
              let categoryName = mark.metadata else { return }

        // Count today's transactions in that category
        let dayStart = Calendar.current.startOfDay(for: .now)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        let txDescriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { tx in
                tx.date >= dayStart && tx.date < dayEnd
            }
        )
        let transactions = try context.fetch(txDescriptor)
        let categoryCount = transactions.filter { $0.category?.name == categoryName }.count

        if categoryCount < 3 {
            context.delete(mark)
        }
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

    /// Count consecutive recent days where the category had fewer than `limit` transactions.
    private static func countDaysWithCategoryUnderLimit(_ categoryName: String, limit: Int, context: ModelContext) throws -> Int {
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
            let categoryCount = transactions.filter { $0.category?.name == categoryName }.count
            if categoryCount < limit { count += 1 } else { break }
        }
        return count
    }

    /// Categories that represent daily necessities — exempt from impulse spender penalty.
    private static let essentialCategories: Set<String> = [
        "Food & Drink", "Transport", "Bills", "Health", "Education"
    ]

    /// Find the worst discretionary category today (excludes essentials like Food & Drink).
    private static func findWorstDiscretionaryCategoryToday(context: ModelContext) -> (name: String, count: Int)? {
        let dayStart = Calendar.current.startOfDay(for: .now)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { tx in
                tx.date >= dayStart && tx.date < dayEnd
            }
        )
        guard let transactions = try? context.fetch(descriptor) else { return nil }
        let grouped = Dictionary(grouping: transactions) { $0.category?.name ?? "Other" }
        // Filter out essential categories
        let discretionary = grouped.filter { !essentialCategories.contains($0.key) }
        guard let worst = discretionary.max(by: { $0.value.count < $1.value.count }) else { return nil }
        return (name: worst.key, count: worst.value.count)
    }

    /// Count consecutive recent days where ALL transactions were under a % of daily budget.
    private static func countDaysWithAllTransactionsUnderBudgetPct(_ pct: Double, context: ModelContext) throws -> Int {
        let descriptor = FetchDescriptor<DailyLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let logs = try context.fetch(descriptor)
        var count = 0
        for log in logs {
            guard log.dailyBudget > 0 else { continue }
            let threshold = log.dailyBudget * pct
            let dayStart = log.date
            let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
            let txDescriptor = FetchDescriptor<Transaction>(
                predicate: #Predicate<Transaction> { tx in
                    tx.date >= dayStart && tx.date < dayEnd
                }
            )
            let transactions = try context.fetch(txDescriptor)
            let hasOversized = transactions.contains { $0.amount > threshold }
            if transactions.isEmpty || !hasOversized { count += 1 } else { break }
        }
        return count
    }

    /// Apply impulse spender mark, or update existing one if a worse category appeared.
    private static func applyOrUpdateImpulseSpender(categoryName: String, context: ModelContext) throws {
        let typeRaw = ShameMarkType.impulseSpender.rawValue
        let descriptor = FetchDescriptor<ShameMark>(
            predicate: #Predicate<ShameMark> { mark in
                mark.isActive && mark.markType == typeRaw
            }
        )
        let existing = try context.fetch(descriptor)
        if let mark = existing.first {
            // Update to the current worst category
            if mark.metadata != categoryName {
                mark.metadata = categoryName
                mark.progress = 0
            }
        } else {
            let mark = ShameMark(type: .impulseSpender, metadata: categoryName)
            context.insert(mark)
        }
    }
}
