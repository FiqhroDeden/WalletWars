//
//  OnboardingPage1.swift
//  WalletWars
//

import SwiftUI

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            shieldBattle
            tagline
            subtitle
            Spacer()
        }
        .padding(24)
    }
}

// MARK: - Shields

private extension OnboardingPage1 {
    var shieldBattle: some View {
        HStack(spacing: 28) {
            shieldAvatar(label: "YOU", color: Color.hero, icon: "shield.fill")

            Text("VS")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                .foregroundStyle(.white.opacity(0.4))

            shieldAvatar(label: "PAST", color: Color.rival, icon: "shield.fill")
        }
    }

    func shieldAvatar(label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 72, height: 72)
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 11))
                .tracking(2)
                .foregroundStyle(color)
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
