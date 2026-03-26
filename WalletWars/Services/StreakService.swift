//
//  StreakService.swift
//  WalletWars
//

import Foundation

enum StreakService {

    // MARK: - Logging Streak

    /// Update logging streak when a transaction is logged.
    /// Awards +10 XP per streak day. Handles freeze (1/week for logging only).
    static func updateLoggingStreak(profile: PlayerProfile) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        // Already logged today — skip
        if let lastDate = profile.logStreakLastDate,
           calendar.isDate(lastDate, inSameDayAs: today) {
            return
        }

        // Check if yesterday was logged (continue streak)
        if let lastDate = profile.logStreakLastDate {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if calendar.isDate(lastDate, inSameDayAs: yesterday) {
                // Continue streak
                profile.logStreakCount += 1
            } else {
                // Gap detected — try freeze
                if profile.streakFreezesAvailable > 0 {
                    let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
                    if calendar.isDate(lastDate, inSameDayAs: twoDaysAgo) {
                        // Freeze covers 1-day gap
                        profile.streakFreezesAvailable -= 1
                        profile.streakFreezeLastUsed = .now
                        profile.logStreakCount += 1
                    } else {
                        // Gap too large, reset
                        profile.logStreakCount = 1
                    }
                } else {
                    // No freeze available, reset
                    profile.logStreakCount = 1
                }
            }
        } else {
            // First ever log
            profile.logStreakCount = 1
        }

        profile.logStreakLastDate = today
        profile.logStreakBest = max(profile.logStreakBest, profile.logStreakCount)

        // Award streak XP
        XPService.awardXP(XP.loggingStreak, to: profile)
    }

    // MARK: - Budget Streak

    /// Update budget streak when a day ends under budget.
    /// Awards +30 XP per streak day. NO freeze for budget streak.
    static func updateBudgetStreak(profile: PlayerProfile) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        // Already counted today — skip
        if let lastDate = profile.budgetStreakLastDate,
           calendar.isDate(lastDate, inSameDayAs: today) {
            return
        }

        // Check if yesterday was under budget (continue streak)
        if let lastDate = profile.budgetStreakLastDate {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if calendar.isDate(lastDate, inSameDayAs: yesterday) {
                profile.budgetStreakCount += 1
            } else {
                // Gap — no freeze for budget streak, reset
                profile.budgetStreakCount = 1
            }
        } else {
            // First under-budget day
            profile.budgetStreakCount = 1
        }

        profile.budgetStreakLastDate = today
        profile.budgetStreakBest = max(profile.budgetStreakBest, profile.budgetStreakCount)

        // Award streak XP (3x logging because discipline > awareness)
        XPService.awardXP(XP.budgetStreak, to: profile)
    }

    /// Break budget streak — called when over budget. Resets to 0.
    static func breakBudgetStreak(profile: PlayerProfile) {
        profile.budgetStreakCount = 0
    }

    // MARK: - Streak Freeze Refill

    /// Refill streak freeze at week boundary (Monday). Called on app launch/week check.
    static func refillStreakFreeze(profile: PlayerProfile) {
        profile.streakFreezesAvailable = 1
    }
}
