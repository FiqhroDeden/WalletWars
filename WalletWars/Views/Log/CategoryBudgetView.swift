//
//  CategoryBudgetView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct CategoryBudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<Category> { !$0.isArchived },
        sort: \Category.sortOrder
    ) private var categories: [Category]
    var onSelectCategory: ((Category) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            categoryRows
        }
    }

    private var tracker: CurrentWeekTracker? {
        try? modelContext.fetch(FetchDescriptor<CurrentWeekTracker>()).first
    }
}

// MARK: - Header

private extension CategoryBudgetView {
    var headerRow: some View {
        HStack {
            Text("CATEGORY SPENDING")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(2)
                .foregroundStyle(Color.textLight)

            Spacer()

            Text("\(categories.count) categories")
                .font(.custom("PlusJakartaSans-Regular", size: 12))
                .foregroundStyle(Color.textLight)
        }
    }
}

// MARK: - Rows

private extension CategoryBudgetView {
    var categoryRows: some View {
        VStack(spacing: 0) {
            ForEach(categories, id: \.id) { category in
                let spent = spending(for: category)
                let budget = category.budgetAmount ?? 0

                Button {
                    onSelectCategory?(category)
                } label: {
                    CategoryBudgetRow(
                        category: category,
                        spent: spent,
                        budget: budget
                    )
                }
                .buttonStyle(.plain)

                if category.id != categories.last?.id {
                    Divider().padding(.leading, 48)
                }
            }
        }
        .padding(12)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
        }
    }

    func spending(for category: Category) -> Double {
        tracker?.categorySpending[category.id.uuidString] ?? 0
    }
}

// MARK: - Row

private struct CategoryBudgetRow: View {
    let category: Category
    let spent: Double
    let budget: Double

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 10) {
                icon
                nameAndAmount
                Spacer()
                spentLabel
            }

            if budget > 0 {
                progressBar
            }
        }
        .padding(.vertical, 10)
    .contentShape(Rectangle())
    }

    private var icon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: category.colorHex).opacity(0.12))
                .frame(width: 32, height: 32)
            Image(systemName: category.icon)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: category.colorHex))
        }
    }

    private var nameAndAmount: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(category.name)
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(Color.textPrimary)

            if budget > 0 {
                Text("Budget: $\(budget, specifier: "%.0f")")
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textLight)
            } else {
                Text("No budget set")
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textLight)
            }
        }
    }

    private var spentLabel: some View {
        Text("$\(spent, specifier: "%.0f")")
            .font(.custom("PlusJakartaSans-Bold", size: 14))
            .foregroundStyle(spent > 0 ? stateColor : Color.textLight)
            .monospacedDigit()
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.surfaceHigh)
                    .frame(height: 4)

                RoundedRectangle(cornerRadius: 3)
                    .fill(stateColor)
                    .frame(width: max(0, geo.size.width * min(pct, 1.0)), height: 4)
            }
        }
        .frame(height: 4)
    }

    private var pct: Double {
        guard budget > 0 else { return 0 }
        return spent / budget
    }

    private var stateColor: Color {
        switch pct {
        case ..<0.5:   return .victory
        case 0.5..<0.8: return .streak
        default:        return .rival
        }
    }
}
