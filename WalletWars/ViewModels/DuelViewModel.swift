//
//  DuelViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class DuelViewModel {
    var currentTracker: CurrentWeekTracker?
    var lastSnapshot: WeeklySnapshot?
    var roundDetails: [RoundDetail] = []
    var duelResult: DuelResult?
    var roundsWon: Int = 0
    var roundsLost: Int = 0
    var momentumPct: Double = 0
    var momentumState: MomentumState = .holding
    var duelHistory: [WeeklySnapshot] = []
    var hasOpponent: Bool { lastSnapshot != nil }
    var weekDayNumber: Int = 1

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Load

    /// Load all duel data.
    func loadDuel() throws {
        currentTracker = CurrentWeekTracker.fetchOrCreate(context: context)
        lastSnapshot = try DuelService.lastSnapshot(context: context)
        duelHistory = try DuelService.allSnapshots(context: context)

        // Calculate current week day number
        let calendar = Calendar.current
        if let start = currentTracker?.weekStartDate {
            weekDayNumber = (calendar.dateComponents([.day], from: start, to: .now).day ?? 0) + 1
        }

        // Compare if we have an opponent
        if let tracker = currentTracker, let last = lastSnapshot {
            let result = DuelService.compareDuel(current: tracker, lastWeek: last)
            roundsWon = result.won
            roundsLost = result.lost
            duelResult = DuelService.duelResult(won: result.won, lost: result.lost)
            roundDetails = DuelService.roundDetails(current: tracker, lastWeek: last)

            // Momentum
            momentumPct = FormulaService.momentum(
                currentSaved: tracker.totalSaved,
                lastWeekSaved: last.totalSaved
            )
            momentumState = MomentumState.from(percentage: momentumPct)
        }
    }

    // MARK: - Computed Labels

    var weekLabel: String {
        guard let start = currentTracker?.weekStartDate else { return "This Week" }
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .day, value: 6, to: start)!
        return "\(start.formatted(.dateTime.month(.abbreviated).day())) - \(end.formatted(.dateTime.month(.abbreviated).day()))"
    }

    var projectionLabel: String {
        if !hasOpponent { return "Building your baseline..." }
        switch duelResult {
        case .win:   return "Projection: WIN \(roundsWon)-\(roundsLost)"
        case .loss:  return "Projection: LOSS \(roundsLost)-\(roundsWon)"
        case .draw:  return "Projection: DRAW \(roundsWon)-\(roundsLost)"
        case .none:  return ""
        }
    }
}
