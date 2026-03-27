//
//  ProfileView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ProfileViewModel?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    levelSection
                    streakSection
                    duelRecordSection
                    badgeSection
                    if !(viewModel?.activeShameMarks.isEmpty ?? true) {
                        penaltiesSection
                    }
                    statsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .background(Color.surface)
            .navigationTitle("Profile")
        }
        .task { setupAndLoad() }
    }
}

// MARK: - Level

private extension ProfileView {
    var levelSection: some View {
        LevelCard(
            level: viewModel?.currentLevel ?? 1,
            title: viewModel?.levelTitle ?? "Rookie Saver",
            totalXP: viewModel?.totalXP ?? 0
        )
    }
}

// MARK: - Streaks

private extension ProfileView {
    var streakSection: some View {
        HStack(spacing: 12) {
            streakCard(
                icon: "flame.fill",
                label: "LOGGING",
                current: viewModel?.logStreakCurrent ?? 0,
                best: viewModel?.logStreakBest ?? 0,
                color: Color.streak
            )
            streakCard(
                icon: "shield.fill",
                label: "BUDGET",
                current: viewModel?.budgetStreakCurrent ?? 0,
                best: viewModel?.budgetStreakBest ?? 0,
                color: Color.hero
            )
        }
    }

    func streakCard(icon: String, label: String, current: Int, best: Int, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)

            Text(label)
                .font(.custom("PlusJakartaSans-Bold", size: 9))
                .tracking(1)
                .foregroundStyle(Color.textLight)

            Text("\(current)")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 28))
                .foregroundStyle(Color.textPrimary)

            Text("days")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textMid)

            Text("Best: \(best)")
                .font(.custom("PlusJakartaSans-Regular", size: 11))
                .foregroundStyle(Color.textLight)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Duel Record

private extension ProfileView {
    var duelRecordSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DUEL RECORD")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            HStack(spacing: 16) {
                duelStat(value: viewModel?.duelsWon ?? 0, label: "Wins", color: Color.victory)
                duelStat(value: (viewModel?.duelsPlayed ?? 0) - (viewModel?.duelsWon ?? 0), label: "Losses", color: Color.rival)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    func duelStat(value: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                .foregroundStyle(color)
                .monospacedDigit()
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textMid)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Badges

private extension ProfileView {
    var badgeSection: some View {
        BadgeGrid(unlockedBadges: viewModel?.unlockedBadges ?? [])
    }
}

// MARK: - Penalties

private extension ProfileView {
    var penaltiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ACTIVE PENALTIES")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.rival)

            VStack(spacing: 0) {
                ForEach(viewModel?.activeShameMarks ?? [], id: \.id) { mark in
                    ShameMarkCard(mark: mark)
                    if mark.id != viewModel?.activeShameMarks.last?.id {
                        Divider().padding(.leading, 48)
                    }
                }
            }
            .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.rival.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

// MARK: - Stats

private extension ProfileView {
    var statsSection: some View {
        LifetimeStatsCard(
            totalTransactions: viewModel?.totalTransactions ?? 0,
            questsCompleted: viewModel?.questsCompleted ?? 0,
            duelsWon: viewModel?.duelsWon ?? 0,
            duelsPlayed: viewModel?.duelsPlayed ?? 0,
            daysOverBudget: viewModel?.daysOverBudget ?? 0,
            worstOverspend: viewModel?.worstOverspend ?? 0
        )
    }
}

// MARK: - Actions

private extension ProfileView {
    func setupAndLoad() {
        if viewModel == nil {
            viewModel = ProfileViewModel(context: modelContext)
        }
        viewModel?.loadProfile()
    }
}
