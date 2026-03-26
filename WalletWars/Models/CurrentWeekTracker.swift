//
//  CurrentWeekTracker.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class CurrentWeekTracker {
    var id: UUID
    var weekStartDate: Date
    var totalSpent: Double
    var totalSaved: Double
    var daysUnderBudget: Int
    var daysLogged: Int
    var categorySpending: [String: Double]
    var questDeposits: Double
    var transactionCount: Int

    init(weekStartDate: Date) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.totalSpent = 0
        self.totalSaved = 0
        self.daysUnderBudget = 0
        self.daysLogged = 0
        self.categorySpending = [:]
        self.questDeposits = 0
        self.transactionCount = 0
    }

    static func fetchOrCreate(context: ModelContext) -> CurrentWeekTracker {
        let descriptor = FetchDescriptor<CurrentWeekTracker>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        let today = Date.now
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let tracker = CurrentWeekTracker(weekStartDate: weekStart)
        context.insert(tracker)
        return tracker
    }
}
