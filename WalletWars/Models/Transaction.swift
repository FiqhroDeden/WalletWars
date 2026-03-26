//
//  Transaction.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var note: String?
    var date: Date
    var category: Category?
    var createdAt: Date
    var updatedAt: Date

    init(
        amount: Double,
        note: String? = nil,
        date: Date = .now,
        category: Category? = nil
    ) {
        self.id = UUID()
        self.amount = amount
        self.note = note
        self.date = date
        self.category = category
        self.createdAt = .now
        self.updatedAt = .now
    }
}
