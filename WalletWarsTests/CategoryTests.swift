//
//  CategoryTests.swift
//  WalletWarsTests
//

import Testing
import Foundation
import SwiftData
@testable import WalletWars

@MainActor
struct CategoryTests {

    // MARK: - Seeding

    @Test func seedDefaultsCreates8Categories() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        CategorySeedService.seedIfNeeded(context: context)

        let all = try context.fetch(FetchDescriptor<Category>())
        #expect(all.count == 8)
    }

    @Test func seedDefaultsIdempotent() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        CategorySeedService.seedIfNeeded(context: context)
        CategorySeedService.seedIfNeeded(context: context)

        let all = try context.fetch(FetchDescriptor<Category>())
        #expect(all.count == 8)
    }

    @Test func defaultCategoriesAreNotCustom() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        CategorySeedService.seedIfNeeded(context: context)

        let all = try context.fetch(FetchDescriptor<Category>())
        for cat in all {
            #expect(cat.isCustom == false)
        }
    }

    @Test func defaultCategoriesHaveCorrectSortOrder() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        CategorySeedService.seedIfNeeded(context: context)

        let all = try context.fetch(FetchDescriptor<Category>())
        let sorted = all.sorted { $0.sortOrder < $1.sortOrder }
        #expect(sorted[0].name == "Food & Drink")
        #expect(sorted[7].name == "Other")
    }

    // MARK: - Custom Categories

    @Test func addCustomCategory() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        let cat = try vm.addCategory(name: "Pets", icon: "pawprint.fill", colorHex: "AA55CC")

        #expect(cat != nil)
        #expect(cat?.name == "Pets")
        #expect(cat?.isCustom == true)
    }

    @Test func customCategoryMarkedAsCustom() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        let cat = try vm.addCategory(name: "Pets", icon: "pawprint.fill", colorHex: "AA55CC")

        #expect(cat?.isCustom == true)
        #expect(cat?.isArchived == false)
    }

    @Test func maxTwelveTotalEnforced() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        // Seed 8 defaults
        CategorySeedService.seedIfNeeded(context: context)

        let vm = SettingsViewModel(context: context)
        try vm.loadSettings()

        // Add 4 custom (should work)
        for i in 1...4 {
            let result = try vm.addCategory(name: "Custom\(i)", icon: "star", colorHex: "AABBCC")
            #expect(result != nil)
        }

        // 13th should fail
        let extra = try vm.addCategory(name: "TooMany", icon: "star", colorHex: "AABBCC")
        #expect(extra == nil)
    }

    @Test func addCustomAtMaxLimitReturnsNil() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        // Insert 12 categories directly
        for i in 0..<12 {
            let cat = Category(name: "Cat\(i)", icon: "star", colorHex: "AABB00", sortOrder: i)
            context.insert(cat)
        }
        try context.save()

        let vm = SettingsViewModel(context: context)
        let result = try vm.addCategory(name: "Overflow", icon: "star", colorHex: "FF0000")
        #expect(result == nil)
    }

    // MARK: - Archive

    @Test func archiveCustomCategory() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        let cat = try vm.addCategory(name: "Pets", icon: "pawprint.fill", colorHex: "AA55CC")!
        try vm.archiveCategory(cat)

        #expect(cat.isArchived == true)
    }

    @Test func archiveCategoryExcludesFromFetch() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        _ = try vm.addCategory(name: "Pets", icon: "pawprint.fill", colorHex: "AA55CC")
        _ = try vm.addCategory(name: "Gifts", icon: "gift.fill", colorHex: "BB55DD")
        try vm.loadSettings()

        let toArchive = vm.categories.first { $0.name == "Pets" }!
        try vm.archiveCategory(toArchive)

        #expect(vm.categories.count == 1)
        #expect(vm.categories[0].name == "Gifts")
    }

    @Test func cannotArchiveDefaultCategory() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        CategorySeedService.seedIfNeeded(context: context)

        let vm = SettingsViewModel(context: context)
        try vm.loadSettings()

        let defaultCat = vm.categories.first!
        try vm.archiveCategory(defaultCat)

        // Should still not be archived (isCustom is false)
        #expect(defaultCat.isArchived == false)
    }

    @Test func archivedCategoryDoesNotCountTowardLimit() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        // Seed 8 defaults + 4 custom = 12
        CategorySeedService.seedIfNeeded(context: context)
        let vm = SettingsViewModel(context: context)
        try vm.loadSettings()

        for i in 1...4 {
            _ = try vm.addCategory(name: "Custom\(i)", icon: "star", colorHex: "AABBCC")
        }

        // At limit — archive one custom
        let customCat = vm.categories.first { $0.isCustom }!
        try vm.archiveCategory(customCat)

        // Now should be able to add one more
        let result = try vm.addCategory(name: "Replacement", icon: "star", colorHex: "DDEEFF")
        #expect(result != nil)
    }

    // MARK: - Reorder

    @Test func reorderUpdatesSortOrder() throws {
        let container = try TestHelpers.makeContainer()
        let context = container.mainContext

        let vm = SettingsViewModel(context: context)
        let cat1 = try vm.addCategory(name: "A", icon: "star", colorHex: "AA0000")!
        let cat2 = try vm.addCategory(name: "B", icon: "star", colorHex: "BB0000")!

        // Reverse order
        vm.reorderCategories([cat2, cat1])

        #expect(cat2.sortOrder == 0)
        #expect(cat1.sortOrder == 1)
    }
}
