//
//  DashboardView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DashboardViewModel?
    @State private var showCapture = false
    var onSwitchToLog: (() -> Void)?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                dashboardContent
                fabButton
            }
            .navigationTitle("WalletWars")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.textMid)
                    }
                }
            }
        }
        .sheet(isPresented: $showCapture) {
            QuickCaptureSheet()
                .presentationDetents([.large])
                .onDisappear { refreshDashboard() }
        }
        .task { setupAndLoad() }
    }
}

// MARK: - Content

private extension DashboardView {
    var dashboardContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                warChestSection
                streakSection
                transactionsSection
                insightSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
        .background(Color.surface)
    }
}

// MARK: - War Chest

private extension DashboardView {
    var warChestSection: some View {
        WarChestCard(
            amount: viewModel?.warChestAmount ?? 0,
            state: viewModel?.warChestState ?? .healthy,
            percentRemaining: viewModel?.todayLog?.warChestPct ?? 1.0,
            monthlyBudget: viewModel?.monthlyBudget ?? 0
        )
    }
}

// MARK: - Streaks

private extension DashboardView {
    var streakSection: some View {
        StreakBanner(
            logStreak: viewModel?.logStreak ?? 0,
            budgetStreak: viewModel?.budgetStreak ?? 0
        )
    }
}

// MARK: - Transactions

private extension DashboardView {
    var transactionsSection: some View {
        TodayTransactionsList(
            transactions: viewModel?.todayTransactions ?? [],
            onViewAll: onSwitchToLog
        )
    }
}

// MARK: - Insight

private extension DashboardView {
    var insightSection: some View {
        InsightCard(text: viewModel?.insightText ?? "Every transaction logged is a step toward financial mastery.")
    }
}

// MARK: - FAB

private extension DashboardView {
    var fabButton: some View {
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

// MARK: - Actions

private extension DashboardView {
    func setupAndLoad() {
        if viewModel == nil {
            viewModel = DashboardViewModel(context: modelContext)
        }
        refreshDashboard()
    }

    func refreshDashboard() {
        try? viewModel?.loadDashboard()
    }
}
