//
//  WalletWarsApp.swift
//  WalletWars
//

import SwiftUI
import SwiftData

@main
struct WalletWarsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            Category.self,
            SavingQuest.self,
            QuestMilestone.self,
            PlayerProfile.self,
            WeeklySnapshot.self,
            CurrentWeekTracker.self,
            DailyLog.self,
            ShameMark.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
