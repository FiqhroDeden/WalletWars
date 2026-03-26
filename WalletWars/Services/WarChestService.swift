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

    /// Fetch total spent this month from all transactions.
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

    /// Calculate today's daily budget based on monthly budget and month-to-date spending.
    static func dailyBudgetForToday(
        monthlyBudget: Double,
        context: ModelContext,
        referenceDate: Date = .now
    ) throws -> Double {
        let totalSpent = try totalSpentThisMonth(context: context, referenceDate: referenceDate)
        let remainingDays = remainingDaysInMonth(from: referenceDate)
        return FormulaService.warChest(
            monthlyBudget: monthlyBudget,
            totalSpentThisMonth: totalSpent,
            remainingDaysInMonth: remainingDays
        )
    }

    /// Determine WarChestState for a DailyLog.
    static func stateForToday(dailyLog: DailyLog) -> WarChestState {
        WarChestState.from(percentage: dailyLog.warChestPct)
    }
}
