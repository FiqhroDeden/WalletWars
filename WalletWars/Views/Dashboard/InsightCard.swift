//
//  InsightCard.swift
//  WalletWars
//

import SwiftUI

struct InsightCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 18))
                .foregroundStyle(Color.streak)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text("Strategic Edge")
                    .font(.custom("PlusJakartaSans-Bold", size: 12))
                    .foregroundStyle(Color.textPrimary)

                Text(text)
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(Color.textMid)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.streak.opacity(0.15), lineWidth: 1)
        }
    }
}
