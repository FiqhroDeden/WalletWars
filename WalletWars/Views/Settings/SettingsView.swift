//
//  SettingsView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SettingsViewModel?
    @State private var showAddCategory = false
    @State private var editingBudget: String = ""
    @State private var showBudgetSaved = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                budgetSection
                currencySection
                categoriesSection
                aboutSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .background(Color.surface)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCategory) { addCategorySheet }
        .task { setupAndLoad() }
        .overlay {
            ToastView(icon: "checkmark.circle.fill", message: "Budget updated", isShowing: $showBudgetSaved)
                .animation(.springMedium, value: showBudgetSaved)
        }
    }
}

// MARK: - Budget

private extension SettingsView {
    var budgetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("MONTHLY BUDGET")

            HStack {
                Text("$")
                    .font(.custom("PlusJakartaSans-Bold", size: 20))
                    .foregroundStyle(Color.textMid)

                TextField("0", text: $editingBudget)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 28))
                    .foregroundStyle(Color.hero)
                    .keyboardType(.decimalPad)

                if budgetHasChanged {
                    Button {
                        saveBudget()
                    } label: {
                        Text("Save")
                            .font(.custom("PlusJakartaSans-Bold", size: 14))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.hero, in: Capsule())
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
            .animation(.springFast, value: budgetHasChanged)
        }
    }
}

// MARK: - Currency

private extension SettingsView {
    var currencySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("CURRENCY")

            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.hero)

                Text(viewModel?.currencyCode ?? "IDR")
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Text("Default")
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundStyle(Color.textLight)
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Categories

private extension SettingsView {
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("CATEGORIES")

            VStack(spacing: 0) {
                ForEach(viewModel?.categories ?? [], id: \.id) { category in
                    categoryRow(category)
                    if category.id != viewModel?.categories.last?.id {
                        Divider().padding(.leading, 48)
                    }
                }
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))

            Button {
                showAddCategory = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Category")
                        .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                }
                .foregroundStyle(Color.hero)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
        }
    }

    func categoryRow(_ category: Category) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: category.colorHex).opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: category.colorHex))
            }

            Text(category.name)
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            if category.isCustom {
                Text("Custom")
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textLight)
            }
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing) {
            if category.isCustom {
                Button(role: .destructive) {
                    try? viewModel?.archiveCategory(category)
                } label: {
                    Label("Archive", systemImage: "archivebox.fill")
                }
            }
        }
    }
}

// MARK: - About

private extension SettingsView {
    var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("ABOUT")

            VStack(spacing: 0) {
                aboutRow(label: "Version", value: "1.0.0")
                Divider()
                aboutRow(label: "Build", value: "Sprint 11")
                Divider()
                aboutRow(label: "Made with", value: "SwiftUI + SwiftData")
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    func aboutRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(Color.textMid)
            Spacer()
            Text(value)
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Add Category Sheet

private extension SettingsView {
    var addCategorySheet: some View {
        AddCategorySheet { name, icon, color in
            _ = try? viewModel?.addCategory(name: name, icon: icon, colorHex: color)
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Helpers

private extension SettingsView {
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.custom("PlusJakartaSans-Bold", size: 10))
            .tracking(2)
            .foregroundStyle(Color.textLight)
    }

    var budgetHasChanged: Bool {
        guard let current = viewModel?.monthlyBudget else { return false }
        let currentStr = current > 0 ? String(format: "%.0f", current) : ""
        return editingBudget != currentStr
    }

    func saveBudget() {
        guard let value = Double(editingBudget) else { return }
        viewModel?.updateBudget(value)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        withAnimation(.springMedium) {
            showBudgetSaved = true
        }
    }

    func setupAndLoad() {
        if viewModel == nil {
            viewModel = SettingsViewModel(context: modelContext)
        }
        try? viewModel?.loadSettings()
        let budget = viewModel?.monthlyBudget ?? 0
        editingBudget = budget > 0 ? String(format: "%.0f", budget) : ""
    }
}

// MARK: - Add Category Sheet View

struct AddCategorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var icon = "star.fill"
    @State private var colorHex = "007AFF"
    let onCreate: (String, String, String) -> Void

    private let iconOptions = ["star.fill", "heart.fill", "cart.fill", "gift.fill", "pawprint.fill", "cup.and.saucer.fill", "tshirt.fill", "airplane"]
    private let colorOptions = ["007AFF", "FF2D55", "AF52DE", "FF9500", "34C759", "FF3B30", "FFCC00", "8E8E93"]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                TextField("Category name", text: $name)
                    .font(.custom("PlusJakartaSans-SemiBold", size: 16))
                    .padding(14)
                    .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))

                iconPicker
                colorPicker
                Spacer()
            }
            .padding(20)
            .background(Color.surface)
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.textMid)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !name.isEmpty else { return }
                        onCreate(name, icon, colorHex)
                        dismiss()
                    }
                    .font(.custom("PlusJakartaSans-Bold", size: 14))
                    .foregroundStyle(Color.hero)
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private var iconPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ICON")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            HStack(spacing: 10) {
                ForEach(iconOptions, id: \.self) { opt in
                    Button {
                        icon = opt
                    } label: {
                        Image(systemName: opt)
                            .font(.system(size: 18))
                            .foregroundStyle(icon == opt ? Color(hex: colorHex) : Color.textLight)
                            .frame(width: 36, height: 36)
                            .background(
                                icon == opt ? Color(hex: colorHex).opacity(0.15) : Color.surfaceLow,
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                    }
                }
            }
        }
    }

    private var colorPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("COLOR")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            HStack(spacing: 10) {
                ForEach(colorOptions, id: \.self) { hex in
                    Button {
                        colorHex = hex
                    } label: {
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 32, height: 32)
                            .overlay {
                                if colorHex == hex {
                                    Circle().strokeBorder(.white, lineWidth: 2.5)
                                }
                            }
                    }
                }
            }
        }
    }
}
