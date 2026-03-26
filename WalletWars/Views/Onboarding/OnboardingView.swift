//
//  OnboardingView.swift
//  WalletWars
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: OnboardingViewModel?
    @State private var currentPage = 0
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            background
            TabView(selection: $currentPage) {
                OnboardingPage1()
                    .tag(0)
                OnboardingPage2()
                    .tag(1)
                page3
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .onAppear { setupViewModel() }
    }
}

// MARK: - Background

private extension OnboardingView {
    var background: some View {
        LinearGradient(
            colors: [Color(hex: "090E1C"), Color(hex: "0D1530")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Page 3

private extension OnboardingView {
    var page3: some View {
        OnboardingPage3(
            budgetText: Binding(
                get: { viewModel?.budgetText ?? "" },
                set: { viewModel?.budgetText = $0 }
            ),
            canComplete: viewModel?.canComplete ?? false,
            onComplete: {
                viewModel?.completeOnboarding()
                onComplete()
            }
        )
    }
}

// MARK: - Setup

private extension OnboardingView {
    func setupViewModel() {
        if viewModel == nil {
            viewModel = OnboardingViewModel(context: modelContext)
        }
    }
}
