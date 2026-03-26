//
//  CurrentWeekTrackerTests.swift
//  WalletWarsTests
//

import Testing
import SwiftData
@testable import WalletWars

struct CurrentWeekTrackerTests {

    @Test func fetchOrCreateCreatesSingleton() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        #expect(tracker.totalSpent == 0.0)
        #expect(tracker.transactionCount == 0)

        let all = try context.fetch(FetchDescriptor<CurrentWeekTracker>())
        #expect(all.count == 1)
    }

    @Test func fetchOrCreateReturnsSameInstance() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let t1 = CurrentWeekTracker.fetchOrCreate(context: context)
        let t2 = CurrentWeekTracker.fetchOrCreate(context: context)
        #expect(t1.id == t2.id)
    }

    @Test func weekStartDateIsMonday() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        let weekday = Calendar.current.component(.weekday, from: tracker.weekStartDate)
        #expect(weekday == 2) // Monday = 2
    }

    @Test func updateTotalSpent() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        tracker.totalSpent += 50
        tracker.transactionCount += 1

        #expect(tracker.totalSpent == 50.0)
        #expect(tracker.transactionCount == 1)
    }

    @Test func categorySpendingTracksByCategoryUUID() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        let testID = "test-category-uuid"
        tracker.categorySpending[testID] = 75.0

        #expect(tracker.categorySpending[testID] == 75.0)
    }

    @Test func categorySpendingAccumulatesMultipleTransactions() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        let testID = "test-category-uuid"
        tracker.categorySpending[testID] = (tracker.categorySpending[testID] ?? 0) + 25
        tracker.categorySpending[testID] = (tracker.categorySpending[testID] ?? 0) + 30

        #expect(tracker.categorySpending[testID] == 55.0)
    }

    @Test func questDepositsIncrement() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        tracker.questDeposits += 100
        tracker.questDeposits += 50

        #expect(tracker.questDeposits == 150.0)
    }
}
