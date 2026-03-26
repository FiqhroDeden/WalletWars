//
//  Animation+Spring.swift
//  WalletWars
//

import SwiftUI

extension Animation {
    static let springFast   = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let springMedium = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.85)
}

enum AnimationDuration {
    static let xpFloat: Double = 1.2
    static let confetti: Double = 2.0
    static let duelBar: Double = 0.7
}
