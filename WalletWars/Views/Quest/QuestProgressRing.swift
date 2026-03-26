//
//  QuestProgressRing.swift
//  WalletWars
//

import SwiftUI

struct QuestProgressRing: View {
    let progress: Double
    let savedAmount: Double
    let targetAmount: Double

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.victory.opacity(0.15), lineWidth: 10)

            // Progress ring
            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(Color.victory, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.springMedium, value: progress)

            // Center content
            VStack(spacing: 4) {
                Text("\(Int(clampedProgress * 100))%")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 36))
                    .foregroundStyle(Color.victory)
                    .contentTransition(.numericText())

                HStack(spacing: 4) {
                    Text(String(format: "$%.0f", savedAmount))
                        .font(.custom("PlusJakartaSans-Bold", size: 14))
                        .foregroundStyle(Color.textPrimary)

                    Text("/")
                        .foregroundStyle(Color.textLight)

                    Text(String(format: "$%.0f", targetAmount))
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundStyle(Color.textMid)
                }
            }
        }
        .frame(width: 160, height: 160)
    }

    private var clampedProgress: Double {
        max(0, min(1, progress))
    }
}
