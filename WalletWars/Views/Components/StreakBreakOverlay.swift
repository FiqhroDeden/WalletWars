//
//  StreakBreakOverlay.swift
//  WalletWars
//

import SwiftUI

struct StreakBreakOverlay: View {
    let streakCount: Int
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            VStack(spacing: 12) {
                Image(systemName: "shield.slash.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.rival)
                    .symbolEffect(.bounce, value: isShowing)

                Text("Shield Streak Lost")
                    .font(.custom("PlusJakartaSans-Bold", size: 20))
                    .foregroundStyle(Color.rival)

                Text("\(streakCount) day streak broken")
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundStyle(Color.textMid)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.rivalBG.opacity(0.9))
            .background(.ultraThinMaterial)
            .transition(.opacity)
        }
    }
}
