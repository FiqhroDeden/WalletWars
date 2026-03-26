//
//  InsightService.swift
//  WalletWars
//

import Foundation

enum InsightService {

    /// Generate a contextual spending insight based on current data.
    static func generateInsight(
        tracker: CurrentWeekTracker,
        lastSnapshot: WeeklySnapshot?,
        profile: PlayerProfile
    ) -> String {
        var insights: [String] = []

        // Streak-based insights
        if profile.logStreakCount >= 7 {
            insights.append("You've logged \(profile.logStreakCount) days in a row. That's discipline worth celebrating.")
        }
        if profile.budgetStreakCount >= 3 {
            insights.append("Budget streak: \(profile.budgetStreakCount) days under budget. Keep the shield up!")
        }

        // Week comparison insights
        if let last = lastSnapshot {
            if tracker.totalSpent < last.totalSpent * 0.8 {
                let pct = Int((1 - tracker.totalSpent / max(1, last.totalSpent)) * 100)
                insights.append("Spending is \(pct)% lower than last week so far. Strong defense.")
            }
            if tracker.daysLogged > last.daysLogged {
                insights.append("You're logging more consistently than last week. Every entry counts.")
            }
            if tracker.totalSaved > last.totalSaved {
                insights.append("You've saved more than last week already. Momentum is building.")
            }
        }

        // Transaction count insights
        if tracker.transactionCount == 0 {
            insights.append("No expenses logged today. Tap + to start tracking your battle.")
        }
        if profile.totalTransactions >= 50 {
            insights.append("Over \(profile.totalTransactions) transactions tracked. You're building a powerful data arsenal.")
        }

        // Level insights
        if profile.currentLevel >= 5 {
            let title = FormulaService.titleFor(level: profile.currentLevel)
            insights.append("Level \(profile.currentLevel) — \(title). Your financial discipline is leveling up.")
        }

        // Budget insights
        if tracker.totalSpent > 0, profile.monthlyBudget > 0 {
            let monthPct = tracker.totalSpent / profile.monthlyBudget
            if monthPct < 0.3 {
                insights.append("On track to finish well under budget this month. Stay tactical.")
            }
        }

        // Fallback
        if insights.isEmpty {
            insights.append("Every transaction logged is a step toward financial mastery. Keep going.")
        }

        return insights.randomElement()!
    }
}
