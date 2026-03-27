//
//  DashboardViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class DashboardViewModel {
    var todayLog: DailyLog?
    var warChestAmount: Double = 0
    var warChestState: WarChestState = .healthy
    var todayTransactions: [Transaction] = []
    var logStreak: Int = 0
    var budgetStreak: Int = 0
    var monthlyBudget: Double = 0
    var insightText: String = "Every transaction logged is a step toward financial mastery."

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Load all dashboard data. Called from .task {} in DashboardView.
    func loadDashboard() throws {
        let profile = PlayerProfile.fetchOrCreate(context: context)
        monthlyBudget = profile.monthlyBudget
        logStreak = profile.logStreakCount
        budgetStreak = profile.budgetStreakCount

        // Load or create today's DailyLog
        let dailyBudget = try WarChestService.dailyBudgetForToday(
            monthlyBudget: profile.monthlyBudget,
            context: context
        )
        let log = DailyLog.fetchOrCreate(for: .now, dailyBudget: dailyBudget, context: context)
        todayLog = log
        warChestAmount = log.warChest
        warChestState = WarChestService.stateForToday(dailyLog: log)

        // Load today's transactions
        todayTransactions = try loadTodayTransactions()

        // Generate insight
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        let lastSnapshot = try? DuelService.lastSnapshot(context: context)
        insightText = InsightService.generateInsight(
            tracker: tracker,
            lastSnapshot: lastSnapshot,
            profile: profile,
            todayLog: todayLog
        )

        // Update overspend stats (checks yesterday)
        try ShameMarkService.updateOverspendStats(profile: profile, context: context)

        // Update shame mark progress
        try ShameMarkService.updateProgress(profile: profile, context: context)

        // Check and apply shame marks based on current state
        try ShameMarkService.checkAndApply(profile: profile, dailyLog: log, context: context)

        try context.save()
    }

    /// Fetch today's transactions sorted by date descending.
    private func loadTodayTransactions() throws -> [Transaction] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: .now)
        let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { transaction in
                transaction.date >= startOfDay && transaction.date < nextDay
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
}
