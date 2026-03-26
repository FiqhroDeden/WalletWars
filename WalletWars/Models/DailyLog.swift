//
//  DailyLog.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class DailyLog {
    var id: UUID
    var date: Date
    var totalSpent: Double
    var dailyBudget: Double
    var isUnderBudget: Bool
    var transactionCount: Int

    init(date: Date, dailyBudget: Double) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.totalSpent = 0
        self.dailyBudget = dailyBudget
        self.isUnderBudget = true
        self.transactionCount = 0
    }

    var warChest: Double {
        dailyBudget - totalSpent
    }

    var warChestPct: Double {
        guard dailyBudget > 0 else { return 0 }
        return max(0, warChest / dailyBudget)
    }
}
