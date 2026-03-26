//
//  BadgeServiceTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

@MainActor
struct BadgeServiceTests {

    @Test func logger7BadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.logStreakCount = 7
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.logger7))
    }

    @Test func logger30BadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.logStreakCount = 30
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.logger30))
    }

    @Test func budget7BadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.budgetStreakCount = 7
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.budget7))
    }

    @Test func budget30BadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.budgetStreakCount = 30
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.budget30))
    }

    @Test func duelWinBadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.duelsWonCount = 1
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.duelWin))
    }

    @Test func duelStreak3BadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.duelWinStreak = 3
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.duelStreak3))
    }

    @Test func questDoneBadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.questsCompletedCount = 1
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.questDone))
    }

    @Test func quest5BadgeUnlocks() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.questsCompletedCount = 5
        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.contains(.quest5))
    }

    @Test func alreadyUnlockedNotDuplicated() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.logStreakCount = 7
        let first = BadgeService.checkAndUnlock(profile: profile)
        let second = BadgeService.checkAndUnlock(profile: profile)

        #expect(first.contains(.logger7))
        #expect(second.isEmpty || !second.contains(.logger7))
        // Only one entry in unlockedBadges
        #expect(profile.unlockedBadges.filter { $0 == BadgeType.logger7.rawValue }.count == 1)
    }

    @Test func multipleBadgesUnlockSimultaneously() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        profile.logStreakCount = 7
        profile.budgetStreakCount = 7
        profile.questsCompletedCount = 1

        let badges = BadgeService.checkAndUnlock(profile: profile)
        #expect(badges.count >= 3)
        #expect(badges.contains(.logger7))
        #expect(badges.contains(.budget7))
        #expect(badges.contains(.questDone))
    }
}
