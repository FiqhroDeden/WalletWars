//
//  EditTransactionSheet.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct EditTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    let transaction: Transaction
    let onSave: (Double?, String?, Category?, Bool) -> Void
    let onDelete: () -> Void

    @State private var amountText: String
    @State private var noteText: String
    @State private var selectedCategory: Category?
    @State private var showDeleteConfirm = false

    @Query(
        filter: #Predicate<Category> { !$0.isArchived },
        sort: \Category.sortOrder
    ) private var categories: [Category]

    init(transaction: Transaction, onSave: @escaping (Double?, String?, Category?, Bool) -> Void, onDelete: @escaping () -> Void) {
        self.transaction = transaction
        self.onSave = onSave
        self.onDelete = onDelete
        _amountText = State(initialValue: String(format: "%.2f", transaction.amount))
        _noteText = State(initialValue: transaction.note ?? "")
        _selectedCategory = State(initialValue: transaction.category)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    amountSection
                    categorySection
                    noteSection
                    saveButton
                    deleteButton
                }
                .padding(20)
            }
            .background(Color.surface)
            .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { cancelToolbar }
            .confirmationDialog("Delete this transaction?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    onDelete()
                    dismiss()
                }
            } message: {
                Text("This will reverse its effects on your daily log and tracker.")
            }
        }
    }
}

// MARK: - Sections

private extension EditTransactionSheet {
    var amountSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AMOUNT")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            TextField("0.00", text: $amountText)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 32))
                .foregroundStyle(Color.rival)
                .keyboardType(.decimalPad)
                .padding(14)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CATEGORY")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            CategoryGrid(categories: categories, selected: $selectedCategory)
        }
    }

    var noteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NOTE")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            TextField("Add a note...", text: $noteText)
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .padding(14)
                .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    var saveButton: some View {
        Button {
            let newAmount = Double(amountText)
            let newNote: String? = noteText.isEmpty ? nil : noteText
            let clearCat = selectedCategory == nil && transaction.category != nil
            onSave(newAmount, newNote, selectedCategory, clearCat)
            dismiss()
        } label: {
            Text("Save Changes")
                .font(.custom("PlusJakartaSans-Bold", size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.hero, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    var deleteButton: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            Text("Delete Transaction")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(Color.rival)
        }
    }

    @ToolbarContentBuilder
    var cancelToolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
                .foregroundStyle(Color.textMid)
        }
    }
}
