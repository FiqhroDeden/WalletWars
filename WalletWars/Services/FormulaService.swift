//
//  FormulaService.swift
//  WalletWars
//

import Foundation

enum FormulaService {

    // MARK: - War Chest

    /// Daily budget remaining for today.
    /// Returns the even distribution of remaining monthly budget across remaining days.
    static func warChest(
        monthlyBudget: Double,
        totalSpentThisMonth: Double,
        remainingDaysInMonth: Int
    ) -> Double {
        let remaining = monthlyBudget - totalSpentThisMonth
        guard remainingDaysInMonth > 0 else { return remaining }
        return remaining / Double(remainingDaysInMonth)
    }

    // MARK: - Level

    /// XP required for a specific level: 100 x level.
    /// Cumulative XP for level N = sum(100 x i for i in 1...N).
    static func levelFor(xp: Int) -> Int {
        var level = 0
        var remaining = xp
        while remaining >= (level + 1) * 100 {
            level += 1
            remaining -= level * 100
        }
        return max(1, level)
    }

    static let levelTitles: [Int: String] = [
        1: "Rookie Saver",
        5: "Budget Warrior",
        10: "Money Master",
        15: "Financial Knight",
        20: "Wealth Guardian",
        25: "Legend",
    ]

    /// Title for a given level — finds the highest threshold at or below the level.
    static func titleFor(level: Int) -> String {
        let sortedKeys = levelTitles.keys.sorted(by: >)
        for key in sortedKeys {
            if level >= key {
                return levelTitles[key]!
            }
        }
        return "Rookie Saver"
    }

    // MARK: - Momentum

    /// Momentum percentage comparing current week's savings to last week's.
    /// Clamped to -99%...999%.
    static func momentum(
        currentSaved: Double,
        lastWeekSaved: Double
    ) -> Double {
        guard lastWeekSaved != 0 else { return 0 }
        let pct = ((currentSaved - lastWeekSaved) / abs(lastWeekSaved)) * 100
        return max(-99, min(999, pct))
    }
}
