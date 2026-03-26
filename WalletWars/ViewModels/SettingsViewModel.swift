//
//  SettingsViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    var monthlyBudget: Double = 0
    var currencyCode: String = "IDR"
    var categories: [Category] = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Load settings state.
    func loadSettings() throws {
        let profile = PlayerProfile.fetchOrCreate(context: context)
        monthlyBudget = profile.monthlyBudget
        currencyCode = profile.currencyCode
        categories = try fetchCategories()
    }

    /// Update monthly budget on PlayerProfile.
    func updateBudget(_ newBudget: Double) {
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.monthlyBudget = newBudget
        monthlyBudget = newBudget
    }

    /// Update currency code on PlayerProfile.
    func updateCurrency(_ code: String) {
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.currencyCode = code
        currencyCode = code
    }

    /// Add a custom category. Enforces max 12 total (8 default + 4 custom).
    /// Returns the new Category, or nil if at limit.
    func addCategory(name: String, icon: String, colorHex: String) throws -> Category? {
        let currentCount = try context.fetchCount(
            FetchDescriptor<Category>(
                predicate: #Predicate<Category> { !$0.isArchived }
            )
        )
        guard currentCount < 12 else { return nil }

        let maxSort = categories.map(\.sortOrder).max() ?? -1
        let category = Category(
            name: name,
            icon: icon,
            colorHex: colorHex,
            sortOrder: maxSort + 1,
            isCustom: true
        )
        context.insert(category)
        try context.save()
        categories = try fetchCategories()
        return category
    }

    /// Archive a category. Only custom categories can be archived.
    func archiveCategory(_ category: Category) throws {
        guard category.isCustom else { return }
        category.isArchived = true
        try context.save()
        categories = try fetchCategories()
    }

    /// Reorder categories by updating sortOrder.
    func reorderCategories(_ reordered: [Category]) {
        for (index, category) in reordered.enumerated() {
            category.sortOrder = index
        }
        categories = reordered
    }

    /// Fetch non-archived categories sorted by sortOrder.
    private func fetchCategories() throws -> [Category] {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate<Category> { !$0.isArchived },
            sortBy: [SortDescriptor(\.sortOrder)]
        )
        return try context.fetch(descriptor)
    }
}
