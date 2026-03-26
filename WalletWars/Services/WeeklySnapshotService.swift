//
//  WeeklySnapshotService.swift
//  WalletWars
//

import Foundation
import SwiftData

enum WeeklySnapshotService {

    /// Check if the week has changed since the last tracker. If so, snapshot the old week
    /// and reset the tracker for the new week. Called on app launch.
    static func checkAndCreateIfNeeded(context: ModelContext) {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        let currentMonday = mondayOfCurrentWeek()

        // If tracker's week start matches current Monday, no action needed
        guard tracker.weekStartDate < currentMonday else { return }

        // Week has changed — snapshot the old week
        createSnapshot(from: tracker, context: context)

        // Reset tracker for new week
        tracker.weekStartDate = currentMonday
        tracker.totalSpent = 0
        tracker.totalSaved = 0
        tracker.daysUnderBudget = 0
        tracker.daysLogged = 0
        tracker.categorySpending = [:]
        tracker.questDeposits = 0
        tracker.transactionCount = 0

        // Refill streak freeze for the new week
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.streakFreezesAvailable = 1

        try? context.save()
    }

    /// Create a WeeklySnapshot from the current tracker data.
    private static func createSnapshot(from tracker: CurrentWeekTracker, context: ModelContext) {
        // Find worst category spending
        let worstCategory = tracker.categorySpending.max(by: { $0.value < $1.value })

        let snapshot = WeeklySnapshot(
            weekStartDate: tracker.weekStartDate,
            totalSpent: tracker.totalSpent,
            totalSaved: tracker.totalSaved,
            daysUnderBudget: tracker.daysUnderBudget,
            daysLogged: tracker.daysLogged,
            worstCategoryName: worstCategory?.key,
            worstCategoryPct: worstCategory?.value ?? 0
        )
        snapshot.questDeposits = tracker.questDeposits

        // Run duel comparison against previous snapshot
        if let lastSnapshot = try? DuelService.lastSnapshot(context: context) {
            let result = DuelService.compareDuel(current: tracker, lastWeek: lastSnapshot)
            snapshot.roundsWon = result.won
            snapshot.roundsLost = result.lost
            snapshot.duelResult = DuelService.duelResult(won: result.won, lost: result.lost)
            snapshot.momentumPct = FormulaService.momentum(
                currentSaved: tracker.totalSaved,
                lastWeekSaved: lastSnapshot.totalSaved
            )

            // Award duel XP
            let profile = PlayerProfile.fetchOrCreate(context: context)
            switch snapshot.duelResult {
            case .win:
                XPService.awardXP(XP.duelWin, to: profile)
                profile.duelsWonCount += 1
                profile.duelWinStreak += 1
                profile.duelWinStreakBest = max(profile.duelWinStreakBest, profile.duelWinStreak)
            case .draw:
                XPService.awardXP(XP.duelDraw, to: profile)
                profile.duelWinStreak = 0
            case .loss:
                XPService.awardXP(XP.duelLoss, to: profile)
                profile.duelWinStreak = 0
            case .none:
                break
            }
            profile.duelsPlayedCount += 1
            BadgeService.checkAndUnlock(profile: profile)
        }

        context.insert(snapshot)
    }

    /// Get Monday of the current week (ISO: Monday = first day).
    private static func mondayOfCurrentWeek() -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.dateInterval(of: .weekOfYear, for: .now)?.start ?? .now
    }
}
