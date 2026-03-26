//
//  Color+Brand.swift
//  WalletWars
//

import SwiftUI

extension Color {

    // MARK: - Hero Blue — "You, right now"

    static let heroBG    = Color(hex: "EBF2FF")
    static let heroLight = Color(hex: "A8C8FF")
    static let heroMid   = Color(hex: "4D8FFF")
    static let hero      = Color(hex: "1B6EF2")
    static let heroDim   = Color(hex: "0A4FBD")
    static let heroDeep  = Color(hex: "0A3578")

    // MARK: - Rival Red — "Past you, the enemy"

    static let rivalBG    = Color(hex: "FFF0ED")
    static let rivalLight = Color(hex: "FFB8AA")
    static let rivalMid   = Color(hex: "FF6B52")
    static let rival      = Color(hex: "E5432A")
    static let rivalDim   = Color(hex: "B22D18")
    static let rivalDeep  = Color(hex: "721C0F")

    // MARK: - Victory Emerald

    static let victoryBG    = Color(hex: "E6F7EF")
    static let victoryLight = Color(hex: "5CE0A0")
    static let victory      = Color(hex: "12B76A")
    static let victoryDim   = Color(hex: "0D7A48")

    // MARK: - Streak Amber

    static let streakBG    = Color(hex: "FFF6E5")
    static let streakLight = Color(hex: "FFCB57")
    static let streak      = Color(hex: "F5A623")
    static let streakDim   = Color(hex: "B87A0A")

    // MARK: - Surface Neutrals

    static let surface     = Color(hex: "F8F7F6")
    static let surfaceLow  = Color(hex: "F1F0EF")
    static let surfaceHigh = Color(hex: "E3E2E0")
    static let card        = Color.white
    static let textPrimary = Color(hex: "2E2F2F")
    static let textMid     = Color(hex: "5B5C5B")
    static let textLight   = Color(hex: "8A8B8A")

    // MARK: - War Chest State Colors

    static func warChestColor(_ state: WarChestState) -> Color {
        switch state {
        case .healthy:  return .victory
        case .cautious: return .streak
        case .critical: return .rival
        case .broken:   return .rivalDeep
        }
    }

    // MARK: - Hex Initializer

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
