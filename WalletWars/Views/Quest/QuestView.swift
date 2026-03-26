//
//  QuestView.swift
//  WalletWars
//

import SwiftUI

struct QuestView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Saving Quests")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Quest")
        }
    }
}
