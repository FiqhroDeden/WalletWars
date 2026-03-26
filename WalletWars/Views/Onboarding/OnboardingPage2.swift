//
//  OnboardingPage2.swift
//  WalletWars
//

import SwiftUI

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("How WalletWars Works")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                .foregroundStyle(.white)

            VStack(spacing: 14) {
                featureRow(icon: "pencil.and.list.clipboard", title: "LOG", desc: "Record expenses in 5 seconds", color: Color.hero)
                featureRow(icon: "shield.fill", title: "DEFEND", desc: "Guard your War Chest — your daily budget", color: Color.victory)
                featureRow(icon: "figure.fencing", title: "DUEL", desc: "Every Monday, battle last week's you", color: Color.rival)
                featureRow(icon: "trophy.fill", title: "LEVEL UP", desc: "Earn XP, unlock badges, rise in rank", color: Color.streak)
            }

            Spacer()
        }
        .padding(24)
    }

    private func featureRow(icon: String, title: String, desc: String, color: Color) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 13))
                    .tracking(1)
                    .foregroundStyle(color)
                Text(desc)
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()
        }
        .padding(14)
        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 14))
    }
}
