//
//  QuickCaptureViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class QuickCaptureViewModel {
    // Input state
    var amountText: String = ""
    var selectedCategory: Category?
    var note: String = ""

    // Computed validation
    var parsedAmount: Double? {
        guard let value = Double(amountText), value > 0 else { return nil }
        return value
    }

    var isValid: Bool {
        parsedAmount != nil
    }

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Save a new transaction. Updates DailyLog, CurrentWeekTracker, and PlayerProfile.
    /// Returns the created Transaction.
    @discardableResult
    func saveTransaction() throws -> Transaction {
        guard let amount = parsedAmount else {
            throw QuickCaptureError.invalidAmount
        }

        let trimmedNote: String? = {
            let stripped = note.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !stripped.isEmpty else { return nil }
            return String(stripped.prefix(100))
        }()

        // 1. Create transaction
        let transaction = Transaction(
            amount: amount,
            note: trimmedNote,
            date: .now,
            category: selectedCategory
        )
        context.insert(transaction)

        // 2. Update DailyLog
        let profile = PlayerProfile.fetchOrCreate(context: context)
        let dailyBudget = try WarChestService.dailyBudgetForToday(
            monthlyBudget: profile.monthlyBudget,
            context: context
        )
        let dailyLog = DailyLog.fetchOrCreate(for: .now, dailyBudget: dailyBudget, context: context)
        dailyLog.totalSpent += amount
        dailyLog.transactionCount += 1
        dailyLog.isUnderBudget = dailyLog.totalSpent <= dailyLog.dailyBudget

        // 3. Update CurrentWeekTracker
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        tracker.totalSpent += amount
        tracker.totalSaved = profile.monthlyBudget - tracker.totalSpent
        tracker.transactionCount += 1
        if let categoryID = selectedCategory?.id {
            let key = categoryID.uuidString
            tracker.categorySpending[key] = (tracker.categorySpending[key] ?? 0) + amount
        }

        // 4. Update PlayerProfile
        profile.totalTransactions += 1
        // TODO: Sprint 5 — Award XP.logTransaction here

        try context.save()
        return transaction
    }

    /// Reset input fields after successful save.
    func resetFields() {
        amountText = ""
        selectedCategory = nil
        note = ""
    }
}

enum QuickCaptureError: Error, LocalizedError {
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .invalidAmount: "Please enter a valid amount greater than zero."
        }
    }
}
