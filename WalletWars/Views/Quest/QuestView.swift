//
//  QuestView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct QuestView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: QuestViewModel?
    @State private var showDeposit = false
    @State private var showNewQuest = false
    @State private var showAbandonConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    questContent
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .background(Color.surface)
            .navigationTitle("Quest")
            .toolbar { newQuestToolbar }
        }
        .sheet(isPresented: $showDeposit) { depositSheet }
        .sheet(isPresented: $showNewQuest) { newQuestSheet }
        .task { setupAndLoad() }
    }
}

// MARK: - Content Router

private extension QuestView {
    @ViewBuilder
    var questContent: some View {
        if let quest = viewModel?.activeQuest {
            activeQuestSection(quest)
        } else {
            emptyState
        }

        if let completed = viewModel?.completedQuests, !completed.isEmpty {
            hallOfFame(completed)
        }
    }
}

// MARK: - Active Quest

private extension QuestView {
    func activeQuestSection(_ quest: SavingQuest) -> some View {
        VStack(spacing: 16) {
            // Quest name
            Text(quest.name)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                .foregroundStyle(Color.textPrimary)

            // Progress ring
            QuestProgressRing(
                progress: quest.progress,
                savedAmount: quest.savedAmount,
                targetAmount: quest.targetAmount
            )

            // Deadline
            if let days = quest.daysRemaining {
                Label("\(days) days remaining", systemImage: "calendar")
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(Color.textMid)
            }

            // Deposit button
            Button {
                showDeposit = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Deposit to Quest")
                        .font(.custom("PlusJakartaSans-Bold", size: 15))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.victory, in: RoundedRectangle(cornerRadius: 14))
            }

            // Milestones
            MilestoneList(milestones: quest.milestones)

            // Abandon
            Button {
                showAbandonConfirm = true
            } label: {
                Text("Abandon Quest")
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(Color.rival)
            }
            .padding(.top, 4)
            .confirmationDialog(
                "Abandon \"\(quest.name)\"?",
                isPresented: $showAbandonConfirm,
                titleVisibility: .visible
            ) {
                Button("Abandon Quest", role: .destructive) {
                    try? viewModel?.abandonQuest()
                    try? viewModel?.loadQuests()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Your progress will be lost. This cannot be undone.")
            }
        }
    }
}

// MARK: - Empty State

private extension QuestView {
    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "flag.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.victory.opacity(0.4))

            Text("No Active Quest")
                .font(.custom("PlusJakartaSans-Bold", size: 18))
                .foregroundStyle(Color.textPrimary)

            Text("Start a saving quest to set a goal\nand track your progress.")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)

            Button {
                showNewQuest = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Start a Quest")
                        .font(.custom("PlusJakartaSans-Bold", size: 15))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .frame(height: 48)
                .background(Color.victory, in: Capsule())
            }
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Hall of Fame

private extension QuestView {
    func hallOfFame(_ quests: [SavingQuest]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("HALL OF FAME")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            ForEach(quests, id: \.id) { quest in
                completedCard(quest)
            }
        }
    }

    func completedCard(_ quest: SavingQuest) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color.streak)

            VStack(alignment: .leading, spacing: 2) {
                Text(quest.name)
                    .font(.custom("PlusJakartaSans-Bold", size: 14))
                    .foregroundStyle(Color.textPrimary)

                if let days = quest.completionDays {
                    Text("Completed in \(days) days")
                        .font(.custom("PlusJakartaSans-Regular", size: 12))
                        .foregroundStyle(Color.textMid)
                }
            }

            Spacer()

            Text(String(format: "$%.0f", quest.targetAmount))
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.victory)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Sheets

private extension QuestView {
    var depositSheet: some View {
        QuestDepositSheet(questName: viewModel?.activeQuest?.name ?? "") { amount in
            _ = try? viewModel?.deposit(amount: amount)
            try? viewModel?.loadQuests()
        }
        .presentationDetents([.medium])
    }

    var newQuestSheet: some View {
        NewQuestSheet { name, target, deadline in
            _ = try? viewModel?.createQuest(name: name, targetAmount: target, deadline: deadline)
            try? viewModel?.loadQuests()
        }
        .presentationDetents([.large])
    }
}

// MARK: - Toolbar

private extension QuestView {
    @ToolbarContentBuilder
    var newQuestToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel?.canCreateQuest ?? false {
                Button {
                    showNewQuest = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.hero)
                }
            }
        }
    }
}

// MARK: - Actions

private extension QuestView {
    func setupAndLoad() {
        if viewModel == nil {
            viewModel = QuestViewModel(context: modelContext)
        }
        try? viewModel?.loadQuests()
    }
}
