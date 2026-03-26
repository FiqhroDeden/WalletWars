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
                .onAppear {
                    let context = sharedModelContainer.mainContext
                    CategorySeedService.seedIfNeeded(context: context)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
