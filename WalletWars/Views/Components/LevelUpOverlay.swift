//
//  LevelUpOverlay.swift
//  WalletWars
//

import SwiftUI

struct LevelUpOverlay: View {
    let newLevel: Int
    let levelTitle: String
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.5
    @State private var textOpacity: Double = 0

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.6).ignoresSafeArea()
                celebrationContent
            }
            .transition(.opacity)
            .onAppear { animateIn() }
        }
    }
}

// MARK: - Content

private extension LevelUpOverlay {
    var celebrationContent: some View {
        VStack(spacing: 16) {
            // Star burst
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.streak)
                .symbolEffect(.bounce, value: isPresented)

            // LEVEL UP text
            Text("LEVEL UP!")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 36))
                .foregroundStyle(Color.victory)

            // Level number + title
            VStack(spacing: 4) {
                Text("Level \(newLevel)")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                    .foregroundStyle(.white)

                Text(levelTitle)
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
                    .foregroundStyle(Color.hero)
            }
            .opacity(textOpacity)
        }
        .scaleEffect(scale)
        .padding(40)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Animation

private extension LevelUpOverlay {
    func animateIn() {
        withAnimation(.springMedium) {
            scale = 1.0
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.3)) {
            textOpacity = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.springGentle) {
                isPresented = false
            }
        }
    }
}
