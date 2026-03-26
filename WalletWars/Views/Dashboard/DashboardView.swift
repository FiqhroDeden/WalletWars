//
//  DashboardView.swift
//  WalletWars
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Dashboard")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("WalletWars")
        }
    }
}
