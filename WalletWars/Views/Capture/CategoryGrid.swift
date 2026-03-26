//
//  CategoryGrid.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct CategoryGrid: View {
    let categories: [Category]
    @Binding var selected: Category?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories, id: \.id) { category in
                CategoryCell(
                    category: category,
                    isSelected: selected?.id == category.id
                )
                .onTapGesture {
                    withAnimation(.springFast) {
                        if selected?.id == category.id {
                            selected = nil
                        } else {
                            selected = category
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Category Cell

private struct CategoryCell: View {
    let category: Category
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: category.colorHex).opacity(isSelected ? 0.25 : 0.12))
                    .frame(width: 56, height: 56)

                Image(systemName: category.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color(hex: category.colorHex))

                // Selection checkmark
                if isSelected {
                    Circle()
                        .fill(Color(hex: category.colorHex))
                        .frame(width: 20, height: 20)
                        .overlay {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 20, y: -20)
                        .transition(.scale.combined(with: .opacity))
                }
            }

            Text(category.name.split(separator: " ").first.map(String.init) ?? category.name)
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .textCase(.uppercase)
                .tracking(0.5)
                .foregroundStyle(isSelected ? Color.textPrimary : Color.textMid)
                .lineLimit(1)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.springFast, value: isSelected)
    }
}
