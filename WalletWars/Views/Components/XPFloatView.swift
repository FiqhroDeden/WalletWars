//
//  XPFloatView.swift
//  WalletWars
//

import SwiftUI

struct XPFloatView: View {
    let amount: Int
    @Binding var isVisible: Bool
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        if isVisible {
            Text("+\(amount) XP")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 18))
                .foregroundStyle(Color.streak)
                .shadow(color: Color.streak.opacity(0.4), radius: 6)
                .offset(y: offsetY)
                .opacity(opacity)
                .onAppear { animate() }
        }
    }

    private func animate() {
        withAnimation(.easeOut(duration: AnimationDuration.xpFloat)) {
            offsetY = -40
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.xpFloat) {
            isVisible = false
            offsetY = 0
            opacity = 1
        }
    }
}
