//
//  Category.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var icon: String
    var colorHex: String
    var budgetAmount: Double?
    var sortOrder: Int
    var isCustom: Bool
    var isArchived: Bool
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]
    var createdAt: Date

    init(
        name: String,
        icon: String,
        colorHex: String,
        budgetAmount: Double? = nil,
        sortOrder: Int = 0,
        isCustom: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.budgetAmount = budgetAmount
        self.sortOrder = sortOrder
        self.isCustom = isCustom
        self.isArchived = false
        self.transactions = []
        self.createdAt = .now
    }
}
