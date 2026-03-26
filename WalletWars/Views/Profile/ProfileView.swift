//
//  ProfileView.swift
//  WalletWars
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Profile")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Profile")
        }
    }
}
