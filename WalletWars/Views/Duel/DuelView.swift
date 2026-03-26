//
//  DuelView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct DuelView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DuelViewModel?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    vsCard
                    duelContent
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .background(Color.surface)
            .navigationTitle("Duel")
        }
        .task { setupAndLoad() }
    }
}

// MARK: - VS Card

private extension DuelView {
    var vsCard: some View {
        VSCard(
            hasOpponent: viewModel?.hasOpponent ?? false,
            weekLabel: viewModel?.weekLabel ?? "This Week"
        )
    }
}

// MARK: - Content Router

private extension DuelView {
    @ViewBuilder
    var duelContent: some View {
        if let vm = viewModel {
            if !vm.hasOpponent {
                firstWeekView
            } else {
                battleView(vm)
            }
        }
    }
}

// MARK: - First Week

private extension DuelView {
    var firstWeekView: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.fencing")
                .font(.system(size: 36))
                .foregroundStyle(Color.textLight)

            Text("This week sets your baseline.")
                .font(.custom("PlusJakartaSans-Bold", size: 16))
                .foregroundStyle(Color.textPrimary)

            Text("Your rival appears next Monday.")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(Color.textMid)

            if let tracker = viewModel?.currentTracker {
                baselineStats(tracker)
            }
        }
        .padding(.vertical, 24)
    }

    func baselineStats(_ tracker: CurrentWeekTracker) -> some View {
        VStack(spacing: 10) {
            statRow(label: "Days logged", value: "\(tracker.daysLogged) / 7")
            statRow(label: "Days under budget", value: "\(tracker.daysUnderBudget) / \(viewModel?.weekDayNumber ?? 1)")
            statRow(label: "Total saved", value: String(format: "$%.2f", tracker.totalSaved))
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textMid)
            Spacer()
            Text(value)
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.textPrimary)
        }
    }
}

// MARK: - Battle View

private extension DuelView {
    func battleView(_ vm: DuelViewModel) -> some View {
        VStack(spacing: 16) {
            // Round cards
            ForEach(Array(vm.roundDetails.enumerated()), id: \.offset) { index, detail in
                RoundCard(detail: detail, roundNumber: index + 1)
            }

            // Result banner
            if let result = vm.duelResult {
                DuelResultBanner(
                    result: result,
                    roundsWon: vm.roundsWon,
                    roundsLost: vm.roundsLost,
                    momentumPct: vm.momentumPct,
                    momentumState: vm.momentumState
                )
            }

            // Projection
            Text(vm.projectionLabel)
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.hero)
                .padding(.vertical, 4)

            // History
            if !vm.duelHistory.isEmpty {
                DuelHistoryList(snapshots: vm.duelHistory)
            }
        }
    }
}

// MARK: - Actions

private extension DuelView {
    func setupAndLoad() {
        if viewModel == nil {
            viewModel = DuelViewModel(context: modelContext)
        }
        try? viewModel?.loadDuel()
    }
}
