//
//  BadgeService.swift
//  WalletWars
//

import Foundation

enum BadgeService {

    // MARK: - Check & Unlock

    /// Check all badge conditions and unlock any newly earned badges.
    /// Returns array of newly unlocked badge types.
    @discardableResult
    static func checkAndUnlock(profile: PlayerProfile) -> [BadgeType] {
        var newlyUnlocked: [BadgeType] = []

        for badge in BadgeType.allCases {
            if !profile.unlockedBadges.contains(badge.rawValue),
               isConditionMet(badge, profile: profile) {
                profile.unlockedBadges.append(badge.rawValue)
                newlyUnlocked.append(badge)
            }
        }

        return newlyUnlocked
    }

    // MARK: - Contextual Unlock

    /// Unlock a specific badge immediately (for events with external data:
    /// firstSave, underSpend50, noImpulse, momentum3).
    /// Returns true if the badge was newly unlocked (was not already earned).
    @discardableResult
    static func unlock(_ badge: BadgeType, for profile: PlayerProfile) -> Bool {
        guard !profile.unlockedBadges.contains(badge.rawValue) else { return false }
        profile.unlockedBadges.append(badge.rawValue)
        return true
    }

    // MARK: - Private

    private static func isConditionMet(_ badge: BadgeType, profile: PlayerProfile) -> Bool {
        switch badge {
        case .firstSave:
            // Triggered contextually on first quest deposit — skip in general check
            return false
        case .logger7:
            return profile.logStreakCount >= 7
        case .logger30:
            return profile.logStreakCount >= 30
        case .budget7:
            return profile.budgetStreakCount >= 7
        case .budget30:
            return profile.budgetStreakCount >= 30
        case .duelWin:
            return profile.duelsWonCount >= 1
        case .duelStreak3:
            return profile.duelWinStreak >= 3
        case .questDone:
            return profile.questsCompletedCount >= 1
        case .quest5:
            return profile.questsCompletedCount >= 5
        case .underSpend50:
            // Requires monthly spending totals — checked contextually at month end
            return false
        case .noImpulse:
            // Requires category spending history — checked contextually in InsightService
            return false
        case .momentum3:
            // Requires weekly snapshot history — checked contextually in DuelService
            return false
        }
    }
}
