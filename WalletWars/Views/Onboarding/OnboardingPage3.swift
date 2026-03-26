//
//  OnboardingPage3.swift
//  WalletWars
//

import SwiftUI

struct OnboardingPage3: View {
    @Binding var budgetText: String
    let canComplete: Bool
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            headerText
            budgetInput
            helperText
            Spacer()
            startButton
        }
        .padding(24)
    }
}

// MARK: - Header

private extension OnboardingPage3 {
    var headerText: some View {
        VStack(spacing: 8) {
            Text("Set Your Monthly Budget")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                .foregroundStyle(.white)

            Text("What's your monthly spending budget?")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundStyle(.white.opacity(0.6))
        }
        .multilineTextAlignment(.center)
    }
}

// MARK: - Budget Input

private extension OnboardingPage3 {
    var budgetInput: some View {
        HStack(spacing: 4) {
            Text("$")
                .font(.custom("PlusJakartaSans-Bold", size: 28))
                .foregroundStyle(.white.opacity(0.5))

            TextField("5,000", text: $budgetText)
                .font(.custom("PlusJakartaSans-ExtraBold", size: 42))
                .foregroundStyle(Color.victory)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 260)
    }

    var helperText: some View {
        Label("You can change this at any time", systemImage: "lightbulb.fill")
            .font(.custom("PlusJakartaSans-Regular", size: 13))
            .foregroundStyle(Color.streak.opacity(0.8))
    }
}

// MARK: - Start Button

private extension OnboardingPage3 {
    var startButton: some View {
        Button(action: onComplete) {
            HStack(spacing: 8) {
                Image(systemName: "figure.fencing")
                Text("Start Fighting")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 17))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                canComplete ? Color.victory : Color.victory.opacity(0.3),
                in: RoundedRectangle(cornerRadius: 16)
            )
        }
        .disabled(!canComplete)
        .padding(.bottom, 16)
    }
}
