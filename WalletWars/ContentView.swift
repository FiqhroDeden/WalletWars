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
    @State private var isReady = false

    var body: some View {
        Group {
            if isReady {
                mainTabView
            } else {
                launchScreen
            }
        }
        .task { initialize() }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                showOnboarding = false
            }
        }
    }

    private var launchScreen: some View {
        ZStack {
            Color.surface.ignoresSafeArea()
            VStack(spacing: 12) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.hero)
                Text("WalletWars")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                    .foregroundStyle(Color.textPrimary)
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

    private func initialize() {
        // 1. Seed categories (fast, idempotent)
        CategorySeedService.seedIfNeeded(context: modelContext)

        // 2. Debug seed data (only first launch, only DEBUG)
        #if DEBUG
        DebugSeedService.seedIfNeeded(context: modelContext)
        #endif

        // 3. Check onboarding AFTER seeding completes
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        if !profile.hasCompletedOnboarding {
            showOnboarding = true
        }

        // 4. Show main UI
        isReady = true
    }
}
