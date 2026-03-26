//
//  PlayerProfile.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class PlayerProfile {
    var id: UUID
    var totalXP: Int
    var currentLevel: Int
    var monthlyBudget: Double

    // Logging Streak
    var logStreakCount: Int
    var logStreakLastDate: Date?
    var logStreakBest: Int

    // Budget Streak
    var budgetStreakCount: Int
    var budgetStreakLastDate: Date?
    var budgetStreakBest: Int

    // Streak Freeze
    var streakFreezesAvailable: Int
    var streakFreezeLastUsed: Date?

    // Badges
    var unlockedBadges: [String]

    // Stats
    var questsCompletedCount: Int
    var duelsWonCount: Int
    var duelsPlayedCount: Int
    var totalTransactions: Int
    var duelWinStreak: Int
    var duelWinStreakBest: Int

    // Settings
    var currencyCode: String
    var hasCompletedOnboarding: Bool

    var createdAt: Date

    init() {
        self.id = UUID()
        self.totalXP = 0
        self.currentLevel = 1
        self.monthlyBudget = 0
        self.logStreakCount = 0
        self.logStreakLastDate = nil
        self.logStreakBest = 0
        self.budgetStreakCount = 0
        self.budgetStreakLastDate = nil
        self.budgetStreakBest = 0
        self.streakFreezesAvailable = 0
        self.streakFreezeLastUsed = nil
        self.unlockedBadges = []
        self.questsCompletedCount = 0
        self.duelsWonCount = 0
        self.duelsPlayedCount = 0
        self.totalTransactions = 0
        self.duelWinStreak = 0
        self.duelWinStreakBest = 0
        self.currencyCode = "IDR"
        self.hasCompletedOnboarding = false
        self.createdAt = .now
    }

    static func fetchOrCreate(context: ModelContext) -> PlayerProfile {
        let descriptor = FetchDescriptor<PlayerProfile>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let profile = PlayerProfile()
        context.insert(profile)
        return profile
    }
}
