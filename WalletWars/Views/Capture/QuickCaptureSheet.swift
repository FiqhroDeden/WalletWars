//
//  QuickCaptureSheet.swift
//  WalletWars
//

import SwiftUI
import SwiftData
import StoreKit

struct QuickCaptureSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: QuickCaptureViewModel?
    @State private var showSuccess = false
    @State private var showOverBudgetWarning = false
    @State private var showOverBudgetConfirm = false
    @State private var overBudgetAmount: Double = 0
    @State private var showStreakBreak = false
    @State private var brokenStreakCount: Int = 0
    @AppStorage("hasRequestedReview") private var hasRequestedReview = false
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
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { cancelToolbar }
            .overlay { successOverlay }
            .overlay(alignment: .top) { overBudgetBanner }
            .overlay { StreakBreakOverlay(streakCount: brokenStreakCount, isShowing: $showStreakBreak) }
            .confirmationDialog(
                "You're already $\(Int(overBudgetAmount)) over budget today.",
                isPresented: $showOverBudgetConfirm,
                titleVisibility: .visible
            ) {
                Button("Spend Anyway", role: .destructive) { performSave() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Logging this will make it harder to recover your shield streak.")
            }
            .onAppear { setupViewModel() }
            .onChange(of: showStreakBreak) { _, newValue in
                if !newValue && brokenStreakCount > 0 {
                    brokenStreakCount = 0
                    viewModel?.resetFields()
                    dismiss()
                }
            }
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

        if vm.isAlreadyOverBudget() {
            // Level 2: already over budget — require confirmation
            overBudgetAmount = vm.wouldExceedBudget() ?? 0
            showOverBudgetConfirm = true
        } else if let excess = vm.wouldExceedBudget() {
            // Level 1: would exceed budget — amber warning, save immediately
            overBudgetAmount = excess
            withAnimation(.springFast) { showOverBudgetWarning = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.springFast) { showOverBudgetWarning = false }
            }
            performSave()
        } else {
            performSave()
        }
    }

    func performSave() {
        guard let vm = viewModel else { return }
        do {
            vm.capturePreSaveState()
            try vm.saveTransaction()

            // Check if budget streak broke
            if vm.didBreakBudgetStreak() {
                brokenStreakCount = vm.budgetStreakBeforeSave
            }

            withAnimation(.springMedium) {
                showSuccess = true
            }
            // Check if we should request review (before dismiss)
            let shouldRequestReview: Bool = {
                guard !hasRequestedReview else { return false }
                let profile = PlayerProfile.fetchOrCreate(context: modelContext)
                return profile.currentLevel >= 3
            }()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Show streak break overlay if applicable — user taps to dismiss
                if brokenStreakCount > 0 {
                    withAnimation(.springMedium) {
                        showStreakBreak = true
                    }
                    return
                }

                vm.resetFields()
                dismiss()

                // Request review after sheet dismisses to avoid suppression
                if shouldRequestReview {
                    hasRequestedReview = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let scene = UIApplication.shared.connectedScenes
                            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            AppStore.requestReview(in: scene)
                        }
                    }
                }
            }
        } catch {
            // TODO: Show error alert
        }
    }
}

// MARK: - Over Budget Warning

private extension QuickCaptureSheet {
    @ViewBuilder
    var overBudgetBanner: some View {
        if showOverBudgetWarning {
            HStack(spacing: 10) {
                Image(systemName: "shield.slash.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.streakLight)

                Text("This will break your shield for today.")
                    .font(.custom("PlusJakartaSans-Bold", size: 13))
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.streakDim, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.streak.opacity(0.5), lineWidth: 1)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}
