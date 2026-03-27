//
//  ShameMarkCard.swift
//  WalletWars
//

import SwiftUI

struct ShameMarkCard: View {
    let mark: ShameMark

    var body: some View {
        if let type = mark.type {
            HStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.rival)
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(type.title)
                        .font(.custom("PlusJakartaSans-Bold", size: 14))
                        .foregroundStyle(Color.rival)

                    Text(type.clearDescription)
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                        .foregroundStyle(Color.textMid)

                    ProgressView(value: Double(mark.progress), total: Double(mark.targetProgress))
                        .tint(Color.rival)

                    Text("\(mark.progress)/\(mark.targetProgress)")
                        .font(.custom("PlusJakartaSans-Regular", size: 11))
                        .foregroundStyle(Color.textLight)
                }
            }
            .padding(12)
        }
    }
}
