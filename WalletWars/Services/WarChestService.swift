//
//  WarChestService.swift
//  WalletWars

import Foundation
import SwiftData

enum WarChestService {

    /// Calculate remaining days in the current month (including today).
    static func remainingDaysInMonth(from date: Date = .now) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let totalDays = range.count
        let currentDay = calendar.component(.day, from: date)
        return totalDays - currentDay + 1
    }

    /// Fetch total spent this month from all transactions, excluding today.
    /// Excludes today so that dailyBudget represents today's fair share
    /// without double-counting (today's spending is tracked separately in DailyLog.totalSpent).
    static func totalSpentBeforeToday(context: ModelContext, referenceDate: Date = .now) throws -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        let startOfMonth = calendar.date(from: components)!
        let startOfToday = calendar.startOfDay(for: referenceDate)

        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && transaction.date < startOfToday
            }
        )
        let transactions = try context.fetch(descriptor)
        return transactions.reduce(0) { $0 + $1.amount }
    }

    /// Fetch total spent this month from all transactions (including today).
    static func totalSpentThisMonth(context: ModelContext, referenceDate: Date = .now) throws -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        let startOfMonth = calendar.date(from: components)!
        let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && transaction.date < startOfNextMonth
            }
        )
        let transactions = try context.fetch(descriptor)
        return transactions.reduce(0) { $0 + $1.amount }
    }

    /// Calculate today's daily budget based on monthly budget and prior days' spending.
    /// Excludes today's transactions to avoid double-counting with DailyLog.totalSpent.
    static func dailyBudgetForToday(
        monthlyBudget: Double,
        context: ModelContext,
        referenceDate: Date = .now
    ) throws -> Double {
        let spentBeforeToday = try totalSpentBeforeToday(context: context, referenceDate: referenceDate)
        let remainingDays = remainingDaysInMonth(from: referenceDate)
        return FormulaService.warChest(
            monthlyBudget: monthlyBudget,
            totalSpentThisMonth: spentBeforeToday,
            remainingDaysInMonth: remainingDays
        )
    }

    /// Determine WarChestState for a DailyLog.
    /// Uses warChest (can be negative) to detect .broken state,
    /// since warChestPct clamps to 0 via max(0,...).
    static func stateForToday(dailyLog: DailyLog) -> WarChestState {
        if dailyLog.warChest < 0 {
            return .broken
        }
        return WarChestState.from(percentage: dailyLog.warChestPct)
    }
}
