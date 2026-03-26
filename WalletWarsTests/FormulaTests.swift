//
//  FormulaTests.swift
//  WalletWarsTests
//

import Testing
@testable import WalletWars

// MARK: - War Chest Formula

struct WarChestFormulaTests {

    @Test func warChestEvenDistribution() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 1500,
            remainingDaysInMonth: 15
        )
        #expect(result == 100.0)
    }

    @Test func warChestNothingSpent() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 0,
            remainingDaysInMonth: 30
        )
        #expect(result == 100.0)
    }

    @Test func warChestOverspent() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 3500,
            remainingDaysInMonth: 5
        )
        #expect(result == -100.0)
    }

    @Test func warChestLastDayOfMonth() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 2900,
            remainingDaysInMonth: 1
        )
        #expect(result == 100.0)
    }

    @Test func warChestZeroDaysRemaining() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 2000,
            remainingDaysInMonth: 0
        )
        #expect(result == 1000.0)
    }
}

// MARK: - Level Formula

struct LevelFormulaTests {

    @Test func levelZeroXP() {
        #expect(FormulaService.levelFor(xp: 0) == 1)
    }

    @Test func levelJustUnderThreshold() {
        #expect(FormulaService.levelFor(xp: 99) == 1)
    }

    @Test func levelExactlyAtLevel1() {
        #expect(FormulaService.levelFor(xp: 100) == 1)
    }

    @Test func levelExactlyAtLevel2() {
        #expect(FormulaService.levelFor(xp: 300) == 2)
    }

    @Test func levelExactlyAtLevel3() {
        #expect(FormulaService.levelFor(xp: 600) == 3)
    }

    @Test func levelExactlyAtLevel5() {
        #expect(FormulaService.levelFor(xp: 1500) == 5)
    }

    @Test func levelBetweenLevels() {
        #expect(FormulaService.levelFor(xp: 400) == 2)
    }

    @Test func levelTitleRookieSaver() {
        #expect(FormulaService.titleFor(level: 1) == "Rookie Saver")
    }

    @Test func levelTitleBudgetWarrior() {
        #expect(FormulaService.titleFor(level: 5) == "Budget Warrior")
    }

    @Test func levelTitleBetweenThresholds() {
        #expect(FormulaService.titleFor(level: 7) == "Budget Warrior")
    }
}

// MARK: - Momentum Calculation

struct MomentumTests {

    @Test func momentumPositiveImprovement() {
        let result = FormulaService.momentum(currentSaved: 130, lastWeekSaved: 100)
        #expect(result == 30.0)
    }

    @Test func momentumNegativeDecline() {
        let result = FormulaService.momentum(currentSaved: 70, lastWeekSaved: 100)
        #expect(result == -30.0)
    }

    @Test func momentumZeroLastWeek() {
        let result = FormulaService.momentum(currentSaved: 100, lastWeekSaved: 0)
        #expect(result == 0.0)
    }

    @Test func momentumClampedMax() {
        let result = FormulaService.momentum(currentSaved: 10000, lastWeekSaved: 1)
        #expect(result == 999.0)
    }

    @Test func momentumClampedMin() {
        let result = FormulaService.momentum(currentSaved: -1000, lastWeekSaved: 1)
        #expect(result == -99.0)
    }

    @Test func momentumNegativeLastWeek() {
        let result = FormulaService.momentum(currentSaved: 100, lastWeekSaved: -50)
        #expect(result == 300.0)
    }
}

// MARK: - WarChestState.from()

struct WarChestStateTests {

    @Test func warChestStateHealthy() {
        #expect(WarChestState.from(percentage: 0.9) == .healthy)
        #expect(WarChestState.from(percentage: 0.8) == .healthy)
        #expect(WarChestState.from(percentage: 1.0) == .healthy)
    }

    @Test func warChestStateCautious() {
        #expect(WarChestState.from(percentage: 0.79) == .cautious)
        #expect(WarChestState.from(percentage: 0.5) == .cautious)
        #expect(WarChestState.from(percentage: 0.4) == .cautious)
    }

    @Test func warChestStateCritical() {
        #expect(WarChestState.from(percentage: 0.39) == .critical)
        #expect(WarChestState.from(percentage: 0.1) == .critical)
        #expect(WarChestState.from(percentage: 0.0) == .critical)
    }

    @Test func warChestStateBroken() {
        #expect(WarChestState.from(percentage: -0.1) == .broken)
        #expect(WarChestState.from(percentage: -1.0) == .broken)
    }
}

// MARK: - MomentumState.from()

struct MomentumStateTests {

    @Test func momentumStateSurging() {
        #expect(MomentumState.from(percentage: 50) == .surging)
        #expect(MomentumState.from(percentage: 30) == .surging)
    }

    @Test func momentumStateClimbing() {
        #expect(MomentumState.from(percentage: 20) == .climbing)
        #expect(MomentumState.from(percentage: 10) == .climbing)
    }

    @Test func momentumStateHolding() {
        #expect(MomentumState.from(percentage: 0) == .holding)
        #expect(MomentumState.from(percentage: 5) == .holding)
        #expect(MomentumState.from(percentage: -5) == .holding)
    }

    @Test func momentumStateSlipping() {
        #expect(MomentumState.from(percentage: -15) == .slipping)
        #expect(MomentumState.from(percentage: -29) == .slipping)
    }

    @Test func momentumStateFreefalling() {
        #expect(MomentumState.from(percentage: -30) == .freefalling)
        #expect(MomentumState.from(percentage: -50) == .freefalling)
    }
}
