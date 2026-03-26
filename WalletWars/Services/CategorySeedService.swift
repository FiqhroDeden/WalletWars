//
//  CategorySeedService.swift
//  WalletWars
//

import Foundation
import SwiftData

enum CategorySeedService {

    static let defaults: [(name: String, icon: String, color: String)] = [
        ("Food & Drink",  "fork.knife",          "FF9500"),
        ("Transport",     "car.fill",             "007AFF"),
        ("Shopping",      "bag.fill",             "FF2D55"),
        ("Entertainment", "gamecontroller.fill",   "AF52DE"),
        ("Bills",         "bolt.fill",             "FFCC00"),
        ("Health",        "heart.fill",            "FF3B30"),
        ("Education",     "book.fill",             "34C759"),
        ("Other",         "ellipsis.circle.fill",  "8E8E93"),
    ]

    /// Seeds default categories if none exist. Call on first launch.
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Category>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        for (index, entry) in defaults.enumerated() {
            let category = Category(
                name: entry.name,
                icon: entry.icon,
                colorHex: entry.color,
                sortOrder: index,
                isCustom: false
            )
            context.insert(category)
        }
    }
}
