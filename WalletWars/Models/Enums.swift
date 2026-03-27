//
//  Enums.swift
//  WalletWars
//

import Foundation

// MARK: - Quest Status

enum QuestStatus: String, Codable, CaseIterable {
    case active
    case completed
    case abandoned
}

// MARK: - Duel Result

enum DuelResult: String, Codable, CaseIterable {
    case win
    case loss
    case draw
}

// MARK: - Duel Round

enum DuelRound: String, Codable, CaseIterable {
    case warChestDiscipline
    case savingPower
    case loggingConsistency
    case categoryControl

    var title: String {
        switch self {
        case .warChestDiscipline: "War Chest Discipline"
        case .savingPower:        "Saving Power"
        case .loggingConsistency: "Logging Consistency"
        case .categoryControl:    "Category Control"
        }
    }

    var icon: String {
        switch self {
        case .warChestDiscipline: "shield.fill"
        case .savingPower:        "banknote.fill"
        case .loggingConsistency: "pencil.and.list.clipboard"
        case .categoryControl:    "chart.pie.fill"
        }
    }
}

// MARK: - Momentum State

enum MomentumState: String, Codable {
    case surging
    case climbing
    case holding
    case slipping
    case freefalling

    var label: String {
        switch self {
        case .surging:     "Surging"
        case .climbing:    "Climbing"
        case .holding:     "Holding"
        case .slipping:    "Slipping"
        case .freefalling: "Freefalling"
        }
    }

    var icon: String {
        switch self {
        case .surging:     "arrow.up.right.circle.fill"
        case .climbing:    "arrow.up.right"
        case .holding:     "arrow.right"
        case .slipping:    "arrow.down.right"
        case .freefalling: "arrow.down.right.circle.fill"
        }
    }

    var colorName: String {
        switch self {
        case .surging:     "victory"
        case .climbing:    "victoryLight"
        case .holding:     "streak"
        case .slipping:    "rivalLight"
        case .freefalling: "rival"
        }
    }

    static func from(percentage: Double) -> MomentumState {
        switch percentage {
        case 30...:        return .surging
        case 10..<30:      return .climbing
        case -10..<10:     return .holding
        case -30 ..< -10:  return .slipping
        default:           return .freefalling
        }
    }
}

// MARK: - Badge Type

enum BadgeType: String, Codable, CaseIterable {
    case firstSave
    case logger7
    case logger30
    case budget7
    case budget30
    case duelWin
    case duelStreak3
    case questDone
    case quest5
    case underSpend50
    case noImpulse
    case momentum3

    var title: String {
        switch self {
        case .firstSave:    "First Blood"
        case .logger7:      "Week Warrior"
        case .logger30:     "Log Legend"
        case .budget7:      "Shield Bearer"
        case .budget30:     "Iron Wall"
        case .duelWin:      "Self Surpassed"
        case .duelStreak3:  "Unstoppable"
        case .questDone:    "Quest Conqueror"
        case .quest5:       "Five Star General"
        case .underSpend50: "Half Spender"
        case .noImpulse:    "Zen Master"
        case .momentum3:    "Rising Star"
        }
    }

    var icon: String {
        switch self {
        case .firstSave:    "drop.fill"
        case .logger7:      "flame.fill"
        case .logger30:     "flame.circle.fill"
        case .budget7:      "shield.fill"
        case .budget30:     "shield.checkered"
        case .duelWin:      "figure.fencing"
        case .duelStreak3:  "bolt.shield.fill"
        case .questDone:    "flag.checkered"
        case .quest5:       "star.fill"
        case .underSpend50: "wallet.bifold.fill"
        case .noImpulse:    "brain.head.profile.fill"
        case .momentum3:    "arrow.up.right.circle.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .firstSave, .questDone, .underSpend50:
            return "12B76A"
        case .logger7, .logger30:
            return "F5A623"
        case .budget7, .budget30, .momentum3:
            return "1B6EF2"
        case .duelWin, .duelStreak3:
            return "E5432A"
        case .quest5:
            return "FFCC00"
        case .noImpulse:
            return "AF52DE"
        }
    }
}

// MARK: - War Chest State

enum WarChestState: String, Codable {
    case healthy
    case cautious
    case critical
    case broken

    var colorName: String {
        switch self {
        case .healthy:  "victory"
        case .cautious: "streak"
        case .critical: "rival"
        case .broken:   "rivalDeep"
        }
    }

    static func from(percentage: Double) -> WarChestState {
        switch percentage {
        case 0.8...:     return .healthy
        case 0.4..<0.8:  return .cautious
        case 0.0..<0.4:  return .critical
        default:         return .broken
        }
    }
}

// MARK: - Shame Marks

enum ShameMarkType: String, Codable, CaseIterable {
    case shieldShattered
    case budgetBreaker
    case impulseSpender
    case streakDestroyer
    case bigSpender

    var title: String {
        switch self {
        case .shieldShattered: "Shield Shattered"
        case .budgetBreaker:   "Budget Breaker"
        case .impulseSpender:  "Impulse Spender"
        case .streakDestroyer: "Streak Destroyer"
        case .bigSpender:      "Big Spender"
        }
    }

    var icon: String {
        switch self {
        case .shieldShattered: "shield.slash.fill"
        case .budgetBreaker:   "exclamationmark.triangle.fill"
        case .impulseSpender:  "flame.fill"
        case .streakDestroyer: "bolt.slash.fill"
        case .bigSpender:      "creditcard.trianglebadge.exclamationmark.fill"
        }
    }

    var targetProgress: Int {
        switch self {
        case .shieldShattered: 5
        case .budgetBreaker:   7
        case .impulseSpender:  3
        case .streakDestroyer: 7
        case .bigSpender:      3
        }
    }

    var clearXP: Int {
        switch self {
        case .shieldShattered: 50
        case .budgetBreaker:   75
        case .impulseSpender:  50
        case .streakDestroyer: 50
        case .bigSpender:      50
        }
    }

    var clearDescription: String {
        switch self {
        case .shieldShattered: "Stay under daily budget for \(targetProgress) days"
        case .budgetBreaker:   "Stay under daily budget for \(targetProgress) days"
        case .impulseSpender:  "Keep this category under 2 transactions/day for \(targetProgress) days"
        case .streakDestroyer: "Rebuild a \(targetProgress)-day budget streak"
        case .bigSpender:      "Keep all transactions under 30% of daily budget for \(targetProgress) days"
        }
    }
}

// MARK: - XP Constants

enum XP {
    static let logTransaction: Int = 5
    static let underBudget: Int = 25
    static let questMilestone: Int = 75
    static let questComplete: Int = 500
    static let duelWin: Int = 200
    static let duelDraw: Int = 50
    static let duelLoss: Int = 10
    static let loggingStreak: Int = 10
    static let budgetStreak: Int = 30
    static let shameMarkCleared: Int = 50
}
