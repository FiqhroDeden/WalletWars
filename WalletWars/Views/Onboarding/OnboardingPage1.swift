//
//  OnboardingPage1.swift
//  WalletWars
//

import SwiftUI

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            battleScene
            tagline
            subtitle
            Spacer()
        }
        .padding(24)
    }
}

// MARK: - Battle Scene

private extension OnboardingPage1 {
    var battleScene: some View {
        HStack(spacing: 20) {
            VStack(spacing: 8) {
                HeroAvatar(size: 96)
                Text("YOU")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 11))
                    .tracking(2)
                    .foregroundStyle(Color.hero)
            }

            Text("VS")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                .foregroundStyle(.white.opacity(0.4))

            VStack(spacing: 8) {
                RivalAvatar(size: 96)
                Text("PAST")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 11))
                    .tracking(2)
                    .foregroundStyle(Color.rival)
            }
        }
    }
}

// MARK: - Text

private extension OnboardingPage1 {
    var tagline: some View {
        Text("Your wallet has a rival")
            .font(.custom("PlusJakartaSans-ExtraBold", size: 28))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }

    var subtitle: some View {
        Text("Track spending. Beat last week.\nLevel up your finances.")
            .font(.custom("PlusJakartaSans-Regular", size: 15))
            .foregroundStyle(.white.opacity(0.6))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
}
