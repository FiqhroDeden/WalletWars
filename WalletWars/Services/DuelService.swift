//
//  DuelService.swift
//  WalletWars
//

import Foundation
import SwiftData

enum DuelService {

    /// Compare current week vs last week's snapshot across 4 rounds.
    static func compareDuel(
        current: CurrentWeekTracker,
        lastWeek: WeeklySnapshot
    ) -> (won: Int, lost: Int) {
        var won = 0
        var lost = 0

        // Round 1: War Chest Discipline (days under budget — higher wins)
        if current.daysUnderBudget > lastWeek.daysUnderBudget { won += 1 }
        else if current.daysUnderBudget < lastWeek.daysUnderBudget { lost += 1 }

        // Round 2: Saving Power (total saved — higher wins)
        if current.totalSaved > lastWeek.totalSaved { won += 1 }
        else if current.totalSaved < lastWeek.totalSaved { lost += 1 }

        // Round 3: Logging Consistency (days logged — higher wins)
        if current.daysLogged > lastWeek.daysLogged { won += 1 }
        else if current.daysLogged < lastWeek.daysLogged { lost += 1 }

        // Round 4: Category Control (worst category % — lower wins)
        let currentWorstPct = worstCategoryPercentage(current)
        if currentWorstPct < lastWeek.worstCategoryPct { won += 1 }
        else if currentWorstPct > lastWeek.worstCategoryPct { lost += 1 }

        return (won, lost)
    }

    /// Determine duel result from round scores.
    static func duelResult(won: Int, lost: Int) -> DuelResult {
        if won >= 3 { return .win }
        if lost >= 3 { return .loss }
        return .draw
    }

    /// Get round details for display.
    static func roundDetails(
        current: CurrentWeekTracker,
        lastWeek: WeeklySnapshot
    ) -> [RoundDetail] {
        let currentWorstPct = worstCategoryPercentage(current)
        return [
            RoundDetail(
                round: .warChestDiscipline,
                currentValue: Double(current.daysUnderBudget),
                lastWeekValue: Double(lastWeek.daysUnderBudget),
                currentLabel: "\(current.daysUnderBudget) days",
                lastWeekLabel: "\(lastWeek.daysUnderBudget) days",
                higherWins: true
            ),
            RoundDetail(
                round: .savingPower,
                currentValue: current.totalSaved,
                lastWeekValue: lastWeek.totalSaved,
                currentLabel: String(format: "$%.0f", current.totalSaved),
                lastWeekLabel: String(format: "$%.0f", lastWeek.totalSaved),
                higherWins: true
            ),
            RoundDetail(
                round: .loggingConsistency,
                currentValue: Double(current.daysLogged),
                lastWeekValue: Double(lastWeek.daysLogged),
                currentLabel: "\(current.daysLogged)/7",
                lastWeekLabel: "\(lastWeek.daysLogged)/7",
                higherWins: true
            ),
            RoundDetail(
                round: .categoryControl,
                currentValue: currentWorstPct,
                lastWeekValue: lastWeek.worstCategoryPct,
                currentLabel: "\(Int(currentWorstPct))%",
                lastWeekLabel: "\(Int(lastWeek.worstCategoryPct))%",
                higherWins: false // Lower is better for category control
            ),
        ]
    }

    /// Calculate worst category overspend percentage from tracker.
    private static func worstCategoryPercentage(_ tracker: CurrentWeekTracker) -> Double {
        // If no category spending data, return 0
        guard !tracker.categorySpending.isEmpty else { return 0 }
        // Return highest spending value as a simple percentage proxy
        return tracker.categorySpending.values.max() ?? 0
    }

    /// Fetch the most recent weekly snapshot.
    static func lastSnapshot(context: ModelContext) throws -> WeeklySnapshot? {
        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    /// Fetch all snapshots for duel history.
    static func allSnapshots(context: ModelContext) throws -> [WeeklySnapshot] {
        let descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
}

// MARK: - RoundDetail

/// Round detail for UI display.
struct RoundDetail {
    let round: DuelRound
    let currentValue: Double
    let lastWeekValue: Double
    let currentLabel: String
    let lastWeekLabel: String
    let higherWins: Bool

    var winner: RoundWinner {
        if higherWins {
            if currentValue > lastWeekValue { return .current }
            if currentValue < lastWeekValue { return .lastWeek }
        } else {
            if currentValue < lastWeekValue { return .current }
            if currentValue > lastWeekValue { return .lastWeek }
        }
        return .tie
    }

    enum RoundWinner {
        case current, lastWeek, tie
    }
}
