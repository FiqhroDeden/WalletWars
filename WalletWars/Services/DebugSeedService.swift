//
//  DebugSeedService.swift
//  WalletWars
//

#if DEBUG

import Foundation
import SwiftData

enum DebugSeedService {

    /// Seed realistic sample data for debug builds only.
    /// Skips if data already exists.
    static func seedIfNeeded(context: ModelContext) {
        let profile = PlayerProfile.fetchOrCreate(context: context)
        guard profile.totalTransactions == 0 else { return }

        // Seed categories first
        CategorySeedService.seedIfNeeded(context: context)
        let categories = (try? context.fetch(FetchDescriptor<Category>())) ?? []

        seedProfile(profile)
        seedTransactions(context: context, categories: categories)
        seedDailyLogs(context: context, profile: profile)
        seedCurrentWeekTracker(context: context, categories: categories)
        seedWeeklySnapshots(context: context)
        seedQuest(context: context)

        try? context.save()
    }

    // MARK: - Profile

    private static func seedProfile(_ profile: PlayerProfile) {
        profile.totalXP = 1850
        profile.currentLevel = 8
        profile.monthlyBudget = 5000
        profile.logStreakCount = 14
        profile.logStreakLastDate = Calendar.current.startOfDay(for: .now)
        profile.logStreakBest = 14
        profile.budgetStreakCount = 5
        profile.budgetStreakLastDate = Calendar.current.startOfDay(for: .now)
        profile.budgetStreakBest = 8
        profile.streakFreezesAvailable = 1
        profile.unlockedBadges = [
            BadgeType.logger7.rawValue,
            BadgeType.budget7.rawValue,
            BadgeType.duelWin.rawValue,
        ]
        profile.questsCompletedCount = 1
        profile.duelsWonCount = 1
        profile.duelsPlayedCount = 2
        profile.totalTransactions = 30
        profile.duelWinStreak = 1
        profile.duelWinStreakBest = 1
        profile.currencyCode = "USD"
        profile.hasCompletedOnboarding = true
    }

    // MARK: - Transactions

    private static func seedTransactions(context: ModelContext, categories: [Category]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        let entries: [(daysAgo: Int, catIndex: Int, amount: Double, note: String?, hour: Int)] = [
            // Today
            (0, 0, 12.50, "Lunch at office", 12),
            (0, 1, 8.00, "Ride to work", 8),
            (0, 2, 45.00, "New headphones", 14),
            // Yesterday
            (1, 0, 28.00, "Sushi dinner", 19),
            (1, 0, 10.00, nil, 12),
            (1, 1, 7.00, nil, 8),
            (1, 3, 15.99, "Netflix + Spotify", 21),
            // 2 days ago
            (2, 0, 15.00, "Ramen", 13),
            (2, 4, 120.00, "Electricity bill", 10),
            (2, 2, 32.00, "T-shirt", 16),
            // 3 days ago
            (3, 0, 8.50, "Coffee & pastry", 9),
            (3, 1, 12.00, nil, 17),
            (3, 5, 25.00, "Gym membership", 11),
            // 4 days ago
            (4, 0, 18.00, "Pizza night", 20),
            (4, 7, 5.00, nil, 15),
            (4, 2, 89.00, "Running shoes", 14),
            // 5 days ago
            (5, 0, 11.00, nil, 12),
            (5, 1, 9.00, "Bus pass", 7),
            (5, 6, 35.00, "Online course", 20),
            // 6 days ago
            (6, 0, 22.00, "Brunch", 11),
            (6, 3, 12.99, "Game subscription", 22),
            // 7 days ago (last week)
            (7, 0, 14.00, nil, 12),
            (7, 1, 8.00, nil, 8),
            (7, 4, 85.00, "Internet bill", 9),
            // 8-13 days ago
            (8, 0, 9.50, "Coffee", 10),
            (8, 2, 65.00, "Backpack", 15),
            (9, 0, 16.00, "Thai food", 19),
            (9, 5, 15.00, "Vitamins", 12),
            (10, 0, 12.00, nil, 12),
            (11, 0, 20.00, "Birthday dinner", 20),
            (12, 1, 10.00, nil, 8),
        ]

        for entry in entries {
            let date = calendar.date(byAdding: .day, value: -entry.daysAgo, to: today)!
            let transactionDate = calendar.date(bySettingHour: entry.hour, minute: Int.random(in: 0...59), second: 0, of: date)!
            let catIndex = min(entry.catIndex, categories.count - 1)
            let transaction = Transaction(
                amount: entry.amount,
                note: entry.note,
                date: transactionDate,
                category: categories.isEmpty ? nil : categories[catIndex]
            )
            context.insert(transaction)
        }
    }

    // MARK: - Daily Logs

    private static func seedDailyLogs(context: ModelContext, profile: PlayerProfile) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        // Create daily logs for the last 14 days
        let dailySpending: [(daysAgo: Int, spent: Double, txCount: Int)] = [
            (0, 65.50, 3),
            (1, 60.99, 4),
            (2, 167.00, 3),
            (3, 45.50, 3),
            (4, 112.00, 3),
            (5, 55.00, 3),
            (6, 34.99, 2),
            (7, 107.00, 3),
            (8, 74.50, 2),
            (9, 31.00, 2),
            (10, 12.00, 1),
            (11, 20.00, 1),
            (12, 10.00, 1),
            (13, 45.00, 2),
        ]

        let dailyBudget = profile.monthlyBudget / 30.0

        for day in dailySpending {
            let date = calendar.date(byAdding: .day, value: -day.daysAgo, to: today)!
            let log = DailyLog(date: date, dailyBudget: dailyBudget)
            log.totalSpent = day.spent
            log.transactionCount = day.txCount
            log.isUnderBudget = day.spent <= dailyBudget
            context.insert(log)
        }
    }

    // MARK: - Current Week Tracker

    private static func seedCurrentWeekTracker(context: ModelContext, categories: [Category]) {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        tracker.totalSpent = 540.98
        tracker.totalSaved = 4459.02
        tracker.daysUnderBudget = 3
        tracker.daysLogged = 4
        tracker.transactionCount = 16
        tracker.questDeposits = 200

        // Category spending
        if categories.count >= 8 {
            tracker.categorySpending = [
                categories[0].id.uuidString: 180.00, // Food
                categories[1].id.uuidString: 44.00,  // Transport
                categories[2].id.uuidString: 166.00, // Shopping
                categories[3].id.uuidString: 28.98,  // Entertainment
                categories[4].id.uuidString: 120.00, // Bills
            ]
        }
    }

    // MARK: - Weekly Snapshots

    private static func seedWeeklySnapshots(context: ModelContext) {
        let calendar = Calendar.current
        var cal = calendar
        cal.firstWeekday = 2

        // Last week snapshot (won 3-1)
        let lastMonday = cal.date(byAdding: .weekOfYear, value: -1, to: cal.dateInterval(of: .weekOfYear, for: .now)!.start)!
        let snapshot1 = WeeklySnapshot(
            weekStartDate: lastMonday,
            totalSpent: 890,
            totalSaved: 4110,
            daysUnderBudget: 5,
            daysLogged: 7,
            worstCategoryName: "Shopping",
            worstCategoryPct: 130
        )
        snapshot1.duelResult = .win
        snapshot1.roundsWon = 3
        snapshot1.roundsLost = 1
        snapshot1.momentumPct = 18
        context.insert(snapshot1)

        // Two weeks ago snapshot (draw 2-2)
        let twoWeeksAgo = cal.date(byAdding: .weekOfYear, value: -1, to: lastMonday)!
        let snapshot2 = WeeklySnapshot(
            weekStartDate: twoWeeksAgo,
            totalSpent: 1050,
            totalSaved: 3950,
            daysUnderBudget: 4,
            daysLogged: 6,
            worstCategoryName: "Food & Drink",
            worstCategoryPct: 95
        )
        snapshot2.duelResult = .draw
        snapshot2.roundsWon = 2
        snapshot2.roundsLost = 2
        snapshot2.momentumPct = -5
        context.insert(snapshot2)
    }

    // MARK: - Quest

    private static func seedQuest(context: ModelContext) {
        let quest = SavingQuest(
            name: "Japan Trip",
            targetAmount: 5000,
            deadline: Calendar.current.date(byAdding: .month, value: 6, to: .now)
        )
        quest.savedAmount = 2100
        quest.xpEarned = 150
        context.insert(quest)

        // Milestones
        let milestoneData: [(String, Double, Bool)] = [
            ("First Steps", 1000, true),
            ("Halfway There", 2500, false),
            ("Almost There", 4000, false),
            ("Quest Complete", 5000, false),
        ]

        for (index, data) in milestoneData.enumerated() {
            let milestone = QuestMilestone(
                title: data.0,
                targetAmount: data.1,
                sortOrder: index
            )
            milestone.quest = quest
            if data.2 {
                milestone.isCompleted = true
                milestone.completedAt = Calendar.current.date(byAdding: .day, value: -10, to: .now)
            }
            context.insert(milestone)
        }
    }
}

#endif
