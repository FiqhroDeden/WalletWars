//
//  TransactionLogView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct TransactionLogView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: TransactionLogViewModel?
    @State private var showFilter = false
    @State private var showEdit = false
    @State private var selectedTransaction: Transaction?
    @State private var filterPeriod: FilterPeriod = .thisMonth
    @State private var filterCategory: Category?
    @State private var monthlyBudget: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    summaryCard
                    CategoryBudgetView()
                    transactionSections
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .background(Color.surface)
            .navigationTitle("Transactions")
            .toolbar { filterToolbar }
        }
        .sheet(isPresented: $showFilter) {
            FilterSheet(
                selectedPeriod: $filterPeriod,
                selectedCategory: $filterCategory,
                onApply: { applyFilters() }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showEdit) {
            if let tx = selectedTransaction {
                EditTransactionSheet(
                    transaction: tx,
                    onSave: { amount, note, cat, clearCat in
                        try? viewModel?.updateTransaction(tx, newAmount: amount, newNote: note, newCategory: cat, clearCategory: clearCat)
                        try? viewModel?.loadTransactions()
                    },
                    onDelete: {
                        try? viewModel?.deleteTransaction(tx)
                        try? viewModel?.loadTransactions()
                    }
                )
                .presentationDetents([.large])
            }
        }
        .task { setupAndLoad() }
    }
}

// MARK: - Summary

private extension TransactionLogView {
    var summaryCard: some View {
        MonthSummaryCard(
            totalSpent: totalSpent,
            monthlyBudget: monthlyBudget
        )
    }

    var totalSpent: Double {
        (viewModel?.transactions ?? []).reduce(0) { $0 + $1.amount }
    }
}

// MARK: - Transaction Sections

private extension TransactionLogView {
    @ViewBuilder
    var transactionSections: some View {
        let grouped = groupedTransactions
        if grouped.isEmpty {
            emptyState
        } else {
            ForEach(grouped, id: \.date) { group in
                dateSection(group)
            }
        }
    }

    func dateSection(_ group: TransactionGroup) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(group.label)
                .font(.custom("PlusJakartaSans-Bold", size: 13))
                .foregroundStyle(Color.textMid)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                ForEach(group.transactions, id: \.id) { transaction in
                    Button {
                        selectedTransaction = transaction
                        showEdit = true
                    } label: {
                        LogTransactionRow(transaction: transaction)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            selectedTransaction = transaction
                            showEdit = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            deleteTransaction(transaction)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }

                    if transaction.id != group.transactions.last?.id {
                        Divider().padding(.leading, 48)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(Color.textLight)
            Text("No transactions found")
                .font(.custom("PlusJakartaSans-SemiBold", size: 15))
                .foregroundStyle(Color.textMid)
            Text("Try adjusting your filters")
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Toolbar

private extension TransactionLogView {
    @ToolbarContentBuilder
    var filterToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showFilter = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease")
                    Text("Filter")
                        .font(.custom("PlusJakartaSans-SemiBold", size: 13))
                }
                .foregroundStyle(Color.hero)
            }
        }
    }
}

// MARK: - Grouping

private extension TransactionLogView {
    struct TransactionGroup {
        let date: Date
        let label: String
        let transactions: [Transaction]
    }

    var groupedTransactions: [TransactionGroup] {
        let calendar = Calendar.current
        let dict = Dictionary(grouping: viewModel?.transactions ?? []) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        return dict.keys.sorted(by: >).map { date in
            TransactionGroup(
                date: date,
                label: dateLabel(for: date),
                transactions: dict[date]!.sorted { $0.date > $1.date }
            )
        }
    }

    func dateLabel(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today, \(date.formatted(.dateTime.day().month(.abbreviated)))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday, \(date.formatted(.dateTime.day().month(.abbreviated)))"
        }
        return date.formatted(.dateTime.weekday(.wide).day().month(.abbreviated))
    }
}

// MARK: - Actions

private extension TransactionLogView {
    func setupAndLoad() {
        if viewModel == nil {
            viewModel = TransactionLogViewModel(context: modelContext)
        }
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        monthlyBudget = profile.monthlyBudget
        applyFilters()
    }

    func applyFilters() {
        let range = filterPeriod.dateRange
        viewModel?.filterStartDate = range.start
        viewModel?.filterEndDate = range.end
        viewModel?.filterCategory = filterCategory
        try? viewModel?.loadTransactions()
    }

    func deleteTransaction(_ transaction: Transaction) {
        try? viewModel?.deleteTransaction(transaction)
        try? viewModel?.loadTransactions()
    }
}

// MARK: - Log Transaction Row

private struct LogTransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            categoryIcon
            details
            Spacer()
            amountAndTime
        }
        .padding(.vertical, 10)
    }

    private var categoryIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(categoryColor.opacity(0.12))
                .frame(width: 36, height: 36)

            Image(systemName: transaction.category?.icon ?? "ellipsis.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(categoryColor)
        }
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(transaction.category?.name ?? "Other")
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            if let note = transaction.note {
                Text(note)
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundStyle(Color.textLight)
                    .lineLimit(1)
            }
        }
    }

    private var amountAndTime: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("-$\(transaction.amount, specifier: "%.2f")")
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.rival)

            Text(transaction.date, format: .dateTime.hour().minute())
                .font(.custom("PlusJakartaSans-Regular", size: 11))
                .foregroundStyle(Color.textLight)
        }
    }

    private var categoryColor: Color {
        Color(hex: transaction.category?.colorHex ?? "8E8E93")
    }
}
