//
//  XPServiceTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

@MainActor
struct XPServiceTests {

    @Test func awardXPIncrementsTotal() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        XPService.awardXP(50, to: profile)
        #expect(profile.totalXP == 50)
    }

    @Test func awardXPRecalculatesLevel() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        // Level 1 requires 100 XP
        XPService.awardXP(100, to: profile)
        #expect(profile.currentLevel == 1)

        // Level 2 requires cumulative 300 (100 + 200)
        XPService.awardXP(200, to: profile)
        #expect(profile.currentLevel == 2)
    }

    @Test func awardXPDetectsLevelUp() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        let leveledUp1 = XPService.awardXP(50, to: profile)
        #expect(leveledUp1 == false)

        // 50 + 250 = 300 → level 2
        let leveledUp2 = XPService.awardXP(250, to: profile)
        #expect(leveledUp2 == true)
        #expect(profile.currentLevel == 2)
    }

    @Test func multipleSmallAwards() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext
        let profile = PlayerProfile.fetchOrCreate(context: context)

        for _ in 0..<20 {
            XPService.awardXP(XP.logTransaction, to: profile)
        }
        #expect(profile.totalXP == 100) // 20 * 5
        #expect(profile.currentLevel == 1)
    }
}
