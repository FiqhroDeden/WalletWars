//
//  TodayTransactionsList.swift
//  WalletWars
//

import SwiftUI

struct TodayTransactionsList: View {
    let transactions: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader
            transactionRows
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Header

private extension TodayTransactionsList {
    var sectionHeader: some View {
        HStack {
            Text("Tactical Log")
                .font(.custom("PlusJakartaSans-Bold", size: 14))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("VIEW ALL")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1)
                .foregroundStyle(Color.hero)
        }
    }
}

// MARK: - Rows

private extension TodayTransactionsList {
    @ViewBuilder
    var transactionRows: some View {
        if transactions.isEmpty {
            emptyState
        } else {
            LazyVStack(spacing: 0) {
                ForEach(transactions, id: \.id) { transaction in
                    TransactionRow(transaction: transaction)
                    if transaction.id != transactions.last?.id {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 28))
                .foregroundStyle(Color.textLight)
            Text("No expenses today yet")
                .font(.custom("PlusJakartaSans-Regular", size: 13))
                .foregroundStyle(Color.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

// MARK: - Transaction Row

private struct TransactionRow: View {
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
