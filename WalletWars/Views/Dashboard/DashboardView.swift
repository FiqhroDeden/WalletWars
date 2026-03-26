//
//  DashboardView.swift
//  WalletWars
//

import SwiftUI

struct DashboardView: View {
    @State private var showCapture = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    Text("Dashboard")
                        .font(.custom("PlusJakartaSans-Bold", size: 18))
                        .foregroundStyle(Color.textPrimary)
                        .padding(.top, 20)
                }
                .navigationTitle("WalletWars")

                fabButton
            }
        }
        .sheet(isPresented: $showCapture) {
            QuickCaptureSheet()
                .presentationDetents([.large])
                .interactiveDismissDisabled(false)
        }
    }

    private var fabButton: some View {
        Button {
            showCapture = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.hero, in: Circle())
                .shadow(color: Color.hero.opacity(0.35), radius: 12, y: 6)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
}
