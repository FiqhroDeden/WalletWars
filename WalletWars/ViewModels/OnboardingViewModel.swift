//
//  OnboardingViewModel.swift
//  WalletWars
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    var budgetText: String = ""
    var currentPage: Int = 0

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    var parsedBudget: Double? {
        guard let value = Double(budgetText), value > 0 else { return nil }
        return value
    }

    var canComplete: Bool {
        parsedBudget != nil
    }

    /// Complete onboarding: set budget and flag.
    func completeOnboarding() {
        guard let budget = parsedBudget else { return }
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.monthlyBudget = budget
        profile.hasCompletedOnboarding = true
        try? context.save()
    }
}
