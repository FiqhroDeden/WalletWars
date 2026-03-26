//
//  QuickCaptureSheet.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct QuickCaptureSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: QuickCaptureViewModel?
    @State private var showSuccess = false
    @Query(
        filter: #Predicate<Category> { !$0.isArchived },
        sort: \Category.sortOrder
    ) private var categories: [Category]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                amountSection
                categorySection
                noteSection
                Spacer(minLength: 8)
                saveButton
                keypadSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            .background(Color.surface)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { cancelToolbar }
            .overlay { successOverlay }
            .onAppear { setupViewModel() }
        }
    }

    private func setupViewModel() {
        if viewModel == nil {
            viewModel = QuickCaptureViewModel(context: modelContext)
        }
    }
}

// MARK: - Amount Section

private extension QuickCaptureSheet {
    var amountSection: some View {
        AmountInput(
            amountText: viewModel?.amountText ?? "",
            currencySymbol: "$"
        )
    }
}

// MARK: - Category Section

private extension QuickCaptureSheet {
    var categorySection: some View {
        CategoryGrid(
            categories: categories,
            selected: Binding(
                get: { viewModel?.selectedCategory },
                set: { viewModel?.selectedCategory = $0 }
            )
        )
        .padding(.vertical, 16)
    }
}

// MARK: - Note Section

private extension QuickCaptureSheet {
    var noteSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "pencil")
                .font(.system(size: 14))
                .foregroundStyle(Color.textLight)

            TextField(
                "Add a tactical note...",
                text: Binding(
                    get: { viewModel?.note ?? "" },
                    set: { viewModel?.note = $0 }
                )
            )
            .font(.custom("PlusJakartaSans-Regular", size: 14))
            .foregroundStyle(Color.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Save Button

private extension QuickCaptureSheet {
    var saveButton: some View {
        Button {
            saveTransaction()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 18))
                Text("Save")
                    .font(.custom("PlusJakartaSans-Bold", size: 16))
                Text("+5 XP")
                    .font(.custom("PlusJakartaSans-Bold", size: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.white.opacity(0.2), in: Capsule())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                (viewModel?.isValid ?? false)
                    ? Color.hero
                    : Color.hero.opacity(0.4),
                in: RoundedRectangle(cornerRadius: 14)
            )
        }
        .disabled(!(viewModel?.isValid ?? false))
        .padding(.vertical, 8)
        .animation(.springFast, value: viewModel?.isValid)
    }
}

// MARK: - Keypad Section

private extension QuickCaptureSheet {
    var keypadSection: some View {
        CaptureKeypad(
            text: Binding(
                get: { viewModel?.amountText ?? "" },
                set: { viewModel?.amountText = $0 }
            )
        )
    }
}

// MARK: - Cancel Toolbar

private extension QuickCaptureSheet {
    @ToolbarContentBuilder
    var cancelToolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
            .font(.custom("PlusJakartaSans-Regular", size: 16))
            .foregroundStyle(Color.textMid)
        }
    }
}

// MARK: - Success Overlay

private extension QuickCaptureSheet {
    @ViewBuilder
    var successOverlay: some View {
        if showSuccess {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.victory)
                    .symbolEffect(.bounce, value: showSuccess)

                Text("Saved!")
                    .font(.custom("PlusJakartaSans-Bold", size: 20))
                    .foregroundStyle(Color.textPrimary)

                Text("+5 XP")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 16))
                    .foregroundStyle(Color.streak)
                    .offset(y: showSuccess ? -8 : 0)
                    .opacity(showSuccess ? 1 : 0)
                    .animation(.springGentle.delay(0.2), value: showSuccess)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .transition(.opacity)
        }
    }
}

// MARK: - Actions

private extension QuickCaptureSheet {
    func saveTransaction() {
        guard let vm = viewModel else { return }
        do {
            try vm.saveTransaction()
            withAnimation(.springMedium) {
                showSuccess = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                vm.resetFields()
                dismiss()
            }
        } catch {
            // TODO: Show error alert
        }
    }
}
