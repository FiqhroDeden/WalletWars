//
//  TransactionLogViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class TransactionLogViewModel {
    var transactions: [Transaction] = []
    var filterStartDate: Date?
    var filterEndDate: Date?
    var filterCategory: Category?

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Load

    /// Fetch transactions matching current filters. Sorted by date descending.
    func loadTransactions() throws {
        var descriptor = FetchDescriptor<Transaction>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        if let start = filterStartDate, let end = filterEndDate {
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= start && transaction.date < end
            }
        } else if let start = filterStartDate {
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= start
            }
        }

        transactions = try context.fetch(descriptor)

        // Apply category filter in-memory (SwiftData predicate on optional
        // relationship can be problematic)
        if let filterCat = filterCategory {
            transactions = transactions.filter { $0.category?.id == filterCat.id }
        }
    }

    // MARK: - Update

    /// Update a transaction's amount, note, or category.
    /// Reverses old values from DailyLog/CurrentWeekTracker, applies new values.
    func updateTransaction(
        _ transaction: Transaction,
        newAmount: Double? = nil,
        newNote: String? = nil,
        newCategory: Category? = nil,
        clearCategory: Bool = false
    ) throws {
        let oldAmount = transaction.amount
        let oldCategoryID = transaction.category?.id

        // Reverse old effects
        try reverseDailyLogEffect(amount: oldAmount, date: transaction.date)
        reverseWeekTrackerEffect(amount: oldAmount, categoryID: oldCategoryID, transactionDate: transaction.date)

        // Apply updates
        if let amount = newAmount {
            transaction.amount = amount
        }
        if let note = newNote {
            let stripped = note.trimmingCharacters(in: .whitespacesAndNewlines)
            transaction.note = stripped.isEmpty ? nil : String(stripped.prefix(100))
        }
        if clearCategory {
            transaction.category = nil
        } else if let category = newCategory {
            transaction.category = category
        }
        transaction.updatedAt = .now

        // Apply new effects
        try applyDailyLogEffect(amount: transaction.amount, date: transaction.date)
        applyWeekTrackerEffect(amount: transaction.amount, categoryID: transaction.category?.id, transactionDate: transaction.date)

        try context.save()
    }

    // MARK: - Delete

    /// Delete a transaction. Reverses its effects on DailyLog and CurrentWeekTracker.
    func deleteTransaction(_ transaction: Transaction) throws {
        // Reverse effects
        try reverseDailyLogEffect(amount: transaction.amount, date: transaction.date)
        reverseWeekTrackerEffect(amount: transaction.amount, categoryID: transaction.category?.id, transactionDate: transaction.date)

        // Decrement profile count
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.totalTransactions = max(0, profile.totalTransactions - 1)

        // Delete
        context.delete(transaction)

        // Re-evaluate impulse spender penalty after deletion
        try ShameMarkService.reverseImpulseSpenderIfNeeded(context: context)

        try context.save()
    }

    // MARK: - Private Helpers

    /// Reverse a transaction's effect on its DailyLog.
    private func reverseDailyLogEffect(amount: Double, date: Date) throws {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { log in
                log.date >= startOfDay && log.date < nextDay
            }
        )
        guard let log = try context.fetch(descriptor).first else { return }
        log.totalSpent = max(0, log.totalSpent - amount)
        log.transactionCount = max(0, log.transactionCount - 1)
        log.isUnderBudget = log.totalSpent <= log.dailyBudget
    }

    /// Apply a transaction's effect on DailyLog.
    private func applyDailyLogEffect(amount: Double, date: Date) throws {
        let profile = PlayerProfile.fetchOrCreate(context: context)
        let dailyBudget = try WarChestService.dailyBudgetForToday(
            monthlyBudget: profile.monthlyBudget,
            context: context
        )
        let log = DailyLog.fetchOrCreate(for: date, dailyBudget: dailyBudget, context: context)
        log.totalSpent += amount
        log.transactionCount += 1
        log.isUnderBudget = log.totalSpent <= log.dailyBudget
    }

    /// Reverse a transaction's effect on CurrentWeekTracker.
    /// Only reverses if the transaction falls within the current week.
    private func reverseWeekTrackerEffect(amount: Double, categoryID: UUID?, transactionDate: Date) {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        guard transactionDate >= tracker.weekStartDate else { return }

        tracker.totalSpent = max(0, tracker.totalSpent - amount)
        tracker.transactionCount = max(0, tracker.transactionCount - 1)
        if let catID = categoryID {
            let key = catID.uuidString
            let current = tracker.categorySpending[key] ?? 0
            tracker.categorySpending[key] = max(0, current - amount)
        }
    }

    /// Apply a transaction's effect on CurrentWeekTracker.
    /// Only applies if the transaction falls within the current week.
    private func applyWeekTrackerEffect(amount: Double, categoryID: UUID?, transactionDate: Date) {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        guard transactionDate >= tracker.weekStartDate else { return }

        tracker.totalSpent += amount
        tracker.transactionCount += 1
        if let catID = categoryID {
            let key = catID.uuidString
            tracker.categorySpending[key] = (tracker.categorySpending[key] ?? 0) + amount
        }
    }
}
