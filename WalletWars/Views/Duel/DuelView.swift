//
//  DuelView.swift
//  WalletWars
//

import SwiftUI

struct DuelView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Weekly Duel")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Duel")
        }
    }
}
