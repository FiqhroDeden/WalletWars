//
//  ContentView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var showOnboarding = false

    var body: some View {
        mainTabView
            .task { checkOnboarding() }
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView {
                    showOnboarding = false
                }
            }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "chart.bar.fill", value: 0) {
                DashboardView()
            }

            Tab("Log", systemImage: "list.bullet.rectangle.fill", value: 1) {
                TransactionLogView()
            }

            Tab("Duel", systemImage: "figure.fencing", value: 2) {
                DuelView()
            }

            Tab("Quest", systemImage: "flag.fill", value: 3) {
                QuestView()
            }

            Tab("Profile", systemImage: "trophy.fill", value: 4) {
                ProfileView()
            }
        }
        .tint(selectedTab == 2 ? Color.rival : Color.hero)
    }

    private func checkOnboarding() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        if !profile.hasCompletedOnboarding {
            showOnboarding = true
        }
    }
}
