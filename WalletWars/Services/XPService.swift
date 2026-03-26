//
//  XPService.swift
//  WalletWars
//

import Foundation

enum XPService {

    /// Award XP to a player profile. Recalculates level.
    /// Returns true if the player leveled up.
    @discardableResult
    static func awardXP(_ amount: Int, to profile: PlayerProfile) -> Bool {
        let previousLevel = profile.currentLevel
        profile.totalXP += amount
        profile.currentLevel = FormulaService.levelFor(xp: profile.totalXP)
        return profile.currentLevel > previousLevel
    }
}
