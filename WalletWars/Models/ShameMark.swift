//
//  ShameMark.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class ShameMark {
    var id: UUID
    var markType: String
    var earnedAt: Date
    var clearedAt: Date?
    var isActive: Bool
    var progress: Int
    var targetProgress: Int
    var metadata: String?

    init(type: ShameMarkType, metadata: String? = nil) {
        self.id = UUID()
        self.markType = type.rawValue
        self.earnedAt = .now
        self.clearedAt = nil
        self.isActive = true
        self.progress = 0
        self.targetProgress = type.targetProgress
        self.metadata = metadata
    }

    var type: ShameMarkType? {
        ShameMarkType(rawValue: markType)
    }
}
