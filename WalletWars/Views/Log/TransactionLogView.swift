//
//  TransactionLogView.swift
//  WalletWars
//

import SwiftUI

struct TransactionLogView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Transaction Log")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Transactions")
        }
    }
}
