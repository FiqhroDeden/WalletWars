//
//  ProfileViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    var profile: PlayerProfile?
    var currentLevel: Int = 1
    var levelTitle: String = "Rookie Saver"
    var totalXP: Int = 0

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Load profile data.
    func loadProfile() {
        let p = PlayerProfile.fetchOrCreate(context: context)
        profile = p
        totalXP = p.totalXP
        currentLevel = p.currentLevel
        levelTitle = FormulaService.titleFor(level: p.currentLevel)
    }

    var totalTransactions: Int { profile?.totalTransactions ?? 0 }
    var questsCompleted: Int { profile?.questsCompletedCount ?? 0 }
    var duelsWon: Int { profile?.duelsWonCount ?? 0 }
    var duelsPlayed: Int { profile?.duelsPlayedCount ?? 0 }
    var logStreakCurrent: Int { profile?.logStreakCount ?? 0 }
    var logStreakBest: Int { profile?.logStreakBest ?? 0 }
    var budgetStreakCurrent: Int { profile?.budgetStreakCount ?? 0 }
    var budgetStreakBest: Int { profile?.budgetStreakBest ?? 0 }
    var unlockedBadges: [String] { profile?.unlockedBadges ?? [] }
}
