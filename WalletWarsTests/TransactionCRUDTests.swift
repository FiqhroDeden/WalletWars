//
//  TransactionCRUDTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

private typealias Category = WalletWars.Category

@MainActor
struct TransactionCRUDTests {

    // MARK: - Create

    @Test func createTransactionWithCategory() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let category = Category(name: "Food", icon: "fork.knife", colorHex: "FF9500")
        context.insert(category)

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "25.50"
        vm.selectedCategory = category

        let transaction = try vm.saveTransaction()
        #expect(transaction.amount == 25.50)
        #expect(transaction.category?.name == "Food")
    }

    @Test func createTransactionWithoutCategory() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "10"

        let transaction = try vm.saveTransaction()
        #expect(transaction.amount == 10.0)
        #expect(transaction.category == nil)
    }

    @Test func createTransactionWithNote() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "15"
        vm.note = "Lunch at office"

        let transaction = try vm.saveTransaction()
        #expect(transaction.note == "Lunch at office")
    }

    @Test func noteTruncatedTo100Chars() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "10"
        vm.note = String(repeating: "a", count: 150)

        let transaction = try vm.saveTransaction()
        #expect(transaction.note?.count == 100)
    }

    @Test func emptyNoteBecomesNil() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "10"
        vm.note = "   "

        let transaction = try vm.saveTransaction()
        #expect(transaction.note == nil)
    }

    // MARK: - Validation

    @Test func invalidAmountPreventseSave() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = ""
        #expect(vm.isValid == false)
        #expect(throws: QuickCaptureError.self) {
            try vm.saveTransaction()
        }
    }

    @Test func zeroAmountIsInvalid() {
        let container = try? TestHelpers.makeContainer()
        let context = container!.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "0"
        #expect(vm.isValid == false)
    }

    @Test func negativeAmountIsInvalid() {
        let container = try? TestHelpers.makeContainer()
        let context = container!.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "-5"
        #expect(vm.isValid == false)
    }

    // MARK: - Side Effects

    @Test func saveTransactionUpdatesDailyLog() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "50"
        try vm.saveTransaction()

        let logs = try context.fetch(FetchDescriptor<DailyLog>())
        #expect(logs.count == 1)
        #expect(logs[0].totalSpent == 50.0)
        #expect(logs[0].transactionCount == 1)
    }

    @Test func saveTransactionUpdatesCurrentWeekTracker() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "30"
        try vm.saveTransaction()

        let trackers = try context.fetch(FetchDescriptor<CurrentWeekTracker>())
        #expect(trackers.count == 1)
        #expect(trackers[0].totalSpent == 30.0)
        #expect(trackers[0].transactionCount == 1)
    }

    @Test func saveTransactionUpdatesCategorySpending() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let category = Category(name: "Food", icon: "fork.knife", colorHex: "FF9500")
        context.insert(category)

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "25"
        vm.selectedCategory = category
        try vm.saveTransaction()

        let tracker = try context.fetch(FetchDescriptor<CurrentWeekTracker>()).first!
        let spending = tracker.categorySpending[category.id.uuidString]
        #expect(spending == 25.0)
    }

    @Test func saveTransactionIncrementsProfileTotalTransactions() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)
        vm.amountText = "10"
        try vm.saveTransaction()

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.totalTransactions == 1)
    }

    @Test func multipleTransactionsSameDayAccumulate() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = QuickCaptureViewModel(context: context)

        vm.amountText = "20"
        try vm.saveTransaction()
        vm.resetFields()

        vm.amountText = "30"
        try vm.saveTransaction()

        let logs = try context.fetch(FetchDescriptor<DailyLog>())
        #expect(logs.count == 1)
        #expect(logs[0].totalSpent == 50.0)
        #expect(logs[0].transactionCount == 2)

        let profile = PlayerProfile.fetchOrCreate(context: context)
        #expect(profile.totalTransactions == 2)
    }
}
