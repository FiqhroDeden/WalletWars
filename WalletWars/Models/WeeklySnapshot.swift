//
//  WeeklySnapshot.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class WeeklySnapshot {
    var id: UUID
    var weekStartDate: Date
    var totalSpent: Double
    var totalSaved: Double
    var daysUnderBudget: Int
    var daysLogged: Int
    var worstCategoryName: String?
    var worstCategoryPct: Double
    var questDeposits: Double
    var duelResult: DuelResult?
    var roundsWon: Int
    var roundsLost: Int
    var momentumPct: Double
    var createdAt: Date

    init(
        weekStartDate: Date,
        totalSpent: Double,
        totalSaved: Double,
        daysUnderBudget: Int,
        daysLogged: Int,
        worstCategoryName: String? = nil,
        worstCategoryPct: Double = 0
    ) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.totalSpent = totalSpent
        self.totalSaved = totalSaved
        self.daysUnderBudget = daysUnderBudget
        self.daysLogged = daysLogged
        self.worstCategoryName = worstCategoryName
        self.worstCategoryPct = worstCategoryPct
        self.questDeposits = 0
        self.duelResult = nil
        self.roundsWon = 0
        self.roundsLost = 0
        self.momentumPct = 0
        self.createdAt = .now
    }
}
