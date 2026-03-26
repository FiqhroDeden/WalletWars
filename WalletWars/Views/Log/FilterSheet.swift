//
//  FilterSheet.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPeriod: FilterPeriod
    @Binding var selectedCategory: Category?
    @Query(
        filter: #Predicate<Category> { !$0.isArchived },
        sort: \Category.sortOrder
    ) private var categories: [Category]
    let onApply: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    periodSection
                    categorySection
                }
                .padding(20)
            }
            .background(Color.surface)
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedPeriod = .thisMonth
                        selectedCategory = nil
                    }
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundStyle(Color.textMid)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .font(.custom("PlusJakartaSans-Bold", size: 14))
                    .foregroundStyle(Color.hero)
                }
            }
        }
    }
}

// MARK: - Period Section

private extension FilterSheet {
    var periodSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PERIOD")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            HStack(spacing: 8) {
                ForEach(FilterPeriod.allCases, id: \.self) { period in
                    periodChip(period)
                }
            }
        }
    }

    func periodChip(_ period: FilterPeriod) -> some View {
        let isSelected = selectedPeriod == period
        return Button {
            withAnimation(.springFast) { selectedPeriod = period }
        } label: {
            Text(period.label)
                .font(.custom("PlusJakartaSans-SemiBold", size: 13))
                .foregroundStyle(isSelected ? .white : Color.textMid)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.hero : Color.surfaceLow,
                    in: Capsule()
                )
        }
    }
}

// MARK: - Category Section

private extension FilterSheet {
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CATEGORY")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            FlowLayout(spacing: 8) {
                allCategoryChip
                ForEach(categories, id: \.id) { category in
                    categoryChip(category)
                }
            }
        }
    }

    var allCategoryChip: some View {
        let isSelected = selectedCategory == nil
        return Button {
            withAnimation(.springFast) { selectedCategory = nil }
        } label: {
            Text("All")
                .font(.custom("PlusJakartaSans-SemiBold", size: 13))
                .foregroundStyle(isSelected ? .white : Color.textMid)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.hero : Color.surfaceLow, in: Capsule())
        }
    }

    func categoryChip(_ category: Category) -> some View {
        let isSelected = selectedCategory?.id == category.id
        let catColor = Color(hex: category.colorHex)
        return Button {
            withAnimation(.springFast) { selectedCategory = category }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                Text(category.name)
                    .font(.custom("PlusJakartaSans-SemiBold", size: 13))
            }
            .foregroundStyle(isSelected ? .white : catColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ? catColor : catColor.opacity(0.1),
                in: Capsule()
            )
        }
    }
}

// MARK: - Filter Period Enum

enum FilterPeriod: CaseIterable {
    case today, thisWeek, thisMonth, all

    var label: String {
        switch self {
        case .today: "Today"
        case .thisWeek: "Week"
        case .thisMonth: "Month"
        case .all: "All"
        }
    }

    var dateRange: (start: Date?, end: Date?) {
        let calendar = Calendar.current
        let now = Date.now
        switch self {
        case .today:
            let start = calendar.startOfDay(for: now)
            return (start, calendar.date(byAdding: .day, value: 1, to: start))
        case .thisWeek:
            var cal = calendar
            cal.firstWeekday = 2
            let start = cal.dateInterval(of: .weekOfYear, for: now)?.start
            return (start, nil)
        case .thisMonth:
            let comps = calendar.dateComponents([.year, .month], from: now)
            let start = calendar.date(from: comps)
            return (start, nil)
        case .all:
            return (nil, nil)
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
