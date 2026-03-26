# Sprint 0: Foundation — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Set up the WalletWars project foundation — all SwiftData models, enums, design tokens, font bundle, 5-tab shell, category seeding, and unit tests for core formulas.

**Architecture:** MVVM with `@Observable` ViewModels. SwiftData `@Model` for persistence. Services are stateless utilities with static methods. All source files live under `WalletWars/` in organized subdirectories (Models/, ViewModels/, Views/, Services/, Extensions/). The existing boilerplate (Item.swift, ContentView.swift) will be replaced.

**Tech Stack:** Swift 6.2, SwiftUI, SwiftData, iOS 26+, Swift Testing (`@Test`, `#expect`), Plus Jakarta Sans font bundle.

---

## File Structure

```
WalletWars/
├── App/
│   └── WalletWarsApp.swift          (modify — replace Item container with real models)
├── Models/
│   ├── Enums.swift                  (create — QuestStatus, DuelResult, DuelRound, MomentumState, BadgeType, WarChestState, XP)
│   ├── Transaction.swift            (create — @Model)
│   ├── Category.swift               (create — @Model)
│   ├── SavingQuest.swift            (create — @Model)
│   ├── QuestMilestone.swift         (create — @Model)
│   ├── PlayerProfile.swift          (create — @Model)
│   ├── WeeklySnapshot.swift         (create — @Model)
│   ├── CurrentWeekTracker.swift     (create — @Model)
│   └── DailyLog.swift               (create — @Model)
├── Views/
│   ├── ContentView.swift            (modify — replace with 5-tab TabView)
│   ├── Dashboard/
│   │   └── DashboardView.swift      (create — placeholder)
│   ├── Log/
│   │   └── TransactionLogView.swift (create — placeholder)
│   ├── Duel/
│   │   └── DuelView.swift           (create — placeholder)
│   ├── Quest/
│   │   └── QuestView.swift          (create — placeholder)
│   └── Profile/
│       └── ProfileView.swift        (create — placeholder)
├── ViewModels/                      (create directory — empty for Sprint 0)
├── Services/
│   ├── CategorySeedService.swift    (create — default category seeding)
│   └── FormulaService.swift         (create — War Chest, level, momentum formulas)
├── Extensions/
│   ├── Color+Brand.swift            (create — all brand color tokens)
│   └── Animation+Spring.swift       (create — spring animation presets)
├── Resources/
│   └── Fonts/                       (create — Plus Jakarta Sans .ttf files)
WalletWarsTests/
└── FormulaTests.swift               (create — tests for level, War Chest, momentum, WarChestState, MomentumState)
```

**Files to delete:** `WalletWars/Item.swift` (boilerplate placeholder)

---

## Task 1: Create Enums

**Files:**
- Create: `WalletWars/Models/Enums.swift`

- [ ] **Step 1: Create Models directory and Enums.swift**

```swift
//
//  Enums.swift
//  WalletWars
//

import Foundation

// MARK: - Quest Status

enum QuestStatus: String, Codable, CaseIterable {
    case active
    case completed
    case abandoned
}

// MARK: - Duel Result

enum DuelResult: String, Codable, CaseIterable {
    case win
    case loss
    case draw
}

// MARK: - Duel Round

enum DuelRound: String, Codable, CaseIterable {
    case warChestDiscipline
    case savingPower
    case loggingConsistency
    case categoryControl

    var title: String {
        switch self {
        case .warChestDiscipline: "War Chest Discipline"
        case .savingPower:        "Saving Power"
        case .loggingConsistency: "Logging Consistency"
        case .categoryControl:    "Category Control"
        }
    }

    var icon: String {
        switch self {
        case .warChestDiscipline: "shield.fill"
        case .savingPower:        "banknote.fill"
        case .loggingConsistency: "pencil.and.list.clipboard"
        case .categoryControl:    "chart.pie.fill"
        }
    }
}

// MARK: - Momentum State

enum MomentumState: String, Codable {
    case surging
    case climbing
    case holding
    case slipping
    case freefalling

    var label: String {
        switch self {
        case .surging:     "Surging"
        case .climbing:    "Climbing"
        case .holding:     "Holding"
        case .slipping:    "Slipping"
        case .freefalling: "Freefalling"
        }
    }

    var icon: String {
        switch self {
        case .surging:     "arrow.up.right.circle.fill"
        case .climbing:    "arrow.up.right"
        case .holding:     "arrow.right"
        case .slipping:    "arrow.down.right"
        case .freefalling: "arrow.down.right.circle.fill"
        }
    }

    var colorName: String {
        switch self {
        case .surging:     "victory"
        case .climbing:    "victoryLight"
        case .holding:     "streak"
        case .slipping:    "rivalLight"
        case .freefalling: "rival"
        }
    }

    static func from(percentage: Double) -> MomentumState {
        switch percentage {
        case 30...:        return .surging
        case 10..<30:      return .climbing
        case -10..<10:     return .holding
        case -30 ..< -10:  return .slipping
        default:           return .freefalling
        }
    }
}

// MARK: - Badge Type

enum BadgeType: String, Codable, CaseIterable {
    case firstSave
    case logger7
    case logger30
    case budget7
    case budget30
    case duelWin
    case duelStreak3
    case questDone
    case quest5
    case underSpend50
    case noImpulse
    case momentum3

    var title: String {
        switch self {
        case .firstSave:    "First Blood"
        case .logger7:      "Week Warrior"
        case .logger30:     "Log Legend"
        case .budget7:      "Shield Bearer"
        case .budget30:     "Iron Wall"
        case .duelWin:      "Self Surpassed"
        case .duelStreak3:  "Unstoppable"
        case .questDone:    "Quest Conqueror"
        case .quest5:       "Five Star General"
        case .underSpend50: "Half Spender"
        case .noImpulse:    "Zen Master"
        case .momentum3:    "Rising Star"
        }
    }

    var icon: String {
        switch self {
        case .firstSave:    "drop.fill"
        case .logger7:      "flame.fill"
        case .logger30:     "flame.circle.fill"
        case .budget7:      "shield.fill"
        case .budget30:     "shield.checkered"
        case .duelWin:      "figure.fencing"
        case .duelStreak3:  "bolt.shield.fill"
        case .questDone:    "flag.checkered"
        case .quest5:       "star.fill"
        case .underSpend50: "wallet.bifold.fill"
        case .noImpulse:    "brain.head.profile.fill"
        case .momentum3:    "arrow.up.right.circle.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .firstSave, .questDone, .underSpend50:
            return "12B76A"
        case .logger7, .logger30:
            return "F5A623"
        case .budget7, .budget30, .momentum3:
            return "1B6EF2"
        case .duelWin, .duelStreak3:
            return "E5432A"
        case .quest5:
            return "FFCC00"
        case .noImpulse:
            return "AF52DE"
        }
    }
}

// MARK: - War Chest State

enum WarChestState: String, Codable {
    case healthy
    case cautious
    case critical
    case broken

    var colorName: String {
        switch self {
        case .healthy:  "victory"
        case .cautious: "streak"
        case .critical: "rival"
        case .broken:   "rivalDeep"
        }
    }

    static func from(percentage: Double) -> WarChestState {
        switch percentage {
        case 0.8...:     return .healthy
        case 0.4..<0.8:  return .cautious
        case 0.0..<0.4:  return .critical
        default:         return .broken
        }
    }
}

// MARK: - XP Constants

enum XP {
    static let logTransaction: Int = 5
    static let underBudget: Int = 25
    static let questMilestone: Int = 75
    static let questComplete: Int = 500
    static let duelWin: Int = 200
    static let duelDraw: Int = 50
    static let duelLoss: Int = 10
    static let loggingStreak: Int = 10
    static let budgetStreak: Int = 30
}
```

- [ ] **Step 2: Build to verify compilation**

Run: `xcodebuild -project WalletWars.xcodeproj -scheme WalletWars -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED (Note: Item.swift still referenced, ignore warnings)

- [ ] **Step 3: Commit**

```bash
git add WalletWars/Models/Enums.swift
git commit -m "feat: add all game enums and XP constants"
```

---

## Task 2: Create SwiftData Models — Transaction and Category

**Files:**
- Create: `WalletWars/Models/Transaction.swift`
- Create: `WalletWars/Models/Category.swift`

- [ ] **Step 1: Create Transaction.swift**

```swift
//
//  Transaction.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var note: String?
    var date: Date
    var category: Category?
    var createdAt: Date
    var updatedAt: Date

    init(
        amount: Double,
        note: String? = nil,
        date: Date = .now,
        category: Category? = nil
    ) {
        self.id = UUID()
        self.amount = amount
        self.note = note
        self.date = date
        self.category = category
        self.createdAt = .now
        self.updatedAt = .now
    }
}
```

- [ ] **Step 2: Create Category.swift**

```swift
//
//  Category.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var icon: String
    var colorHex: String
    var budgetAmount: Double?
    var sortOrder: Int
    var isCustom: Bool
    var isArchived: Bool
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]
    var createdAt: Date

    init(
        name: String,
        icon: String,
        colorHex: String,
        budgetAmount: Double? = nil,
        sortOrder: Int = 0,
        isCustom: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.budgetAmount = budgetAmount
        self.sortOrder = sortOrder
        self.isCustom = isCustom
        self.isArchived = false
        self.transactions = []
        self.createdAt = .now
    }
}
```

- [ ] **Step 3: Commit**

```bash
git add WalletWars/Models/Transaction.swift WalletWars/Models/Category.swift
git commit -m "feat: add Transaction and Category SwiftData models"
```

---

## Task 3: Create SwiftData Models — SavingQuest and QuestMilestone

**Files:**
- Create: `WalletWars/Models/SavingQuest.swift`
- Create: `WalletWars/Models/QuestMilestone.swift`

- [ ] **Step 1: Create SavingQuest.swift**

```swift
//
//  SavingQuest.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class SavingQuest {
    var id: UUID
    var name: String
    var targetAmount: Double
    var savedAmount: Double
    var status: QuestStatus
    var deadline: Date?
    var activatedAt: Date?
    var completedAt: Date?
    var completionDays: Int?
    var xpEarned: Int
    @Relationship(deleteRule: .cascade, inverse: \QuestMilestone.quest)
    var milestones: [QuestMilestone]
    var createdAt: Date
    var updatedAt: Date

    init(
        name: String,
        targetAmount: Double,
        deadline: Date? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.targetAmount = targetAmount
        self.savedAmount = 0
        self.status = .active
        self.deadline = deadline
        self.activatedAt = .now
        self.completedAt = nil
        self.completionDays = nil
        self.xpEarned = 0
        self.milestones = []
        self.createdAt = .now
        self.updatedAt = .now
    }

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, savedAmount / targetAmount)
    }

    var daysRemaining: Int? {
        guard let deadline else { return nil }
        return Calendar.current.dateComponents([.day], from: .now, to: deadline).day
    }
}
```

- [ ] **Step 2: Create QuestMilestone.swift**

```swift
//
//  QuestMilestone.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class QuestMilestone {
    var id: UUID
    var title: String
    var targetAmount: Double
    var isCompleted: Bool
    var completedAt: Date?
    var sortOrder: Int
    var quest: SavingQuest?

    init(
        title: String,
        targetAmount: Double,
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.targetAmount = targetAmount
        self.isCompleted = false
        self.completedAt = nil
        self.sortOrder = sortOrder
    }

    static func autoMilestones(for target: Double) -> [(String, Double)] {
        [
            ("First Steps",    target * 0.2),
            ("Halfway There",  target * 0.5),
            ("Almost There",   target * 0.8),
            ("Quest Complete", target * 1.0),
        ]
    }
}
```

- [ ] **Step 3: Commit**

```bash
git add WalletWars/Models/SavingQuest.swift WalletWars/Models/QuestMilestone.swift
git commit -m "feat: add SavingQuest and QuestMilestone SwiftData models"
```

---

## Task 4: Create SwiftData Models — PlayerProfile, WeeklySnapshot, CurrentWeekTracker, DailyLog

**Files:**
- Create: `WalletWars/Models/PlayerProfile.swift`
- Create: `WalletWars/Models/WeeklySnapshot.swift`
- Create: `WalletWars/Models/CurrentWeekTracker.swift`
- Create: `WalletWars/Models/DailyLog.swift`

- [ ] **Step 1: Create PlayerProfile.swift**

```swift
//
//  PlayerProfile.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class PlayerProfile {
    var id: UUID
    var totalXP: Int
    var currentLevel: Int
    var monthlyBudget: Double

    // Logging Streak
    var logStreakCount: Int
    var logStreakLastDate: Date?
    var logStreakBest: Int

    // Budget Streak
    var budgetStreakCount: Int
    var budgetStreakLastDate: Date?
    var budgetStreakBest: Int

    // Streak Freeze
    var streakFreezesAvailable: Int
    var streakFreezeLastUsed: Date?

    // Badges
    var unlockedBadges: [String]

    // Stats
    var questsCompletedCount: Int
    var duelsWonCount: Int
    var duelsPlayedCount: Int
    var totalTransactions: Int
    var duelWinStreak: Int
    var duelWinStreakBest: Int

    // Settings
    var currencyCode: String
    var hasCompletedOnboarding: Bool

    var createdAt: Date

    init() {
        self.id = UUID()
        self.totalXP = 0
        self.currentLevel = 1
        self.monthlyBudget = 0
        self.logStreakCount = 0
        self.logStreakLastDate = nil
        self.logStreakBest = 0
        self.budgetStreakCount = 0
        self.budgetStreakLastDate = nil
        self.budgetStreakBest = 0
        self.streakFreezesAvailable = 0
        self.streakFreezeLastUsed = nil
        self.unlockedBadges = []
        self.questsCompletedCount = 0
        self.duelsWonCount = 0
        self.duelsPlayedCount = 0
        self.totalTransactions = 0
        self.duelWinStreak = 0
        self.duelWinStreakBest = 0
        self.currencyCode = "IDR"
        self.hasCompletedOnboarding = false
        self.createdAt = .now
    }

    static func fetchOrCreate(context: ModelContext) -> PlayerProfile {
        let descriptor = FetchDescriptor<PlayerProfile>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let profile = PlayerProfile()
        context.insert(profile)
        return profile
    }
}
```

- [ ] **Step 2: Create WeeklySnapshot.swift**

```swift
//
//  WeeklySnapshot.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class WeeklySnapshot {
    var id: UUID
    var weekStartDate: Date
    var totalSpent: Double
    var totalSaved: Double
    var daysUnderBudget: Int
    var daysLogged: Int
    var worstCategoryName: String?
    var worstCategoryPct: Double
    var questDeposits: Double
    var duelResult: DuelResult?
    var roundsWon: Int
    var roundsLost: Int
    var momentumPct: Double
    var createdAt: Date

    init(
        weekStartDate: Date,
        totalSpent: Double,
        totalSaved: Double,
        daysUnderBudget: Int,
        daysLogged: Int,
        worstCategoryName: String? = nil,
        worstCategoryPct: Double = 0
    ) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.totalSpent = totalSpent
        self.totalSaved = totalSaved
        self.daysUnderBudget = daysUnderBudget
        self.daysLogged = daysLogged
        self.worstCategoryName = worstCategoryName
        self.worstCategoryPct = worstCategoryPct
        self.questDeposits = 0
        self.duelResult = nil
        self.roundsWon = 0
        self.roundsLost = 0
        self.momentumPct = 0
        self.createdAt = .now
    }
}
```

- [ ] **Step 3: Create CurrentWeekTracker.swift**

```swift
//
//  CurrentWeekTracker.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class CurrentWeekTracker {
    var id: UUID
    var weekStartDate: Date
    var totalSpent: Double
    var totalSaved: Double
    var daysUnderBudget: Int
    var daysLogged: Int
    var categorySpending: [String: Double]
    var questDeposits: Double
    var transactionCount: Int

    init(weekStartDate: Date) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.totalSpent = 0
        self.totalSaved = 0
        self.daysUnderBudget = 0
        self.daysLogged = 0
        self.categorySpending = [:]
        self.questDeposits = 0
        self.transactionCount = 0
    }

    static func fetchOrCreate(context: ModelContext) -> CurrentWeekTracker {
        let descriptor = FetchDescriptor<CurrentWeekTracker>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        let today = Date.now
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let tracker = CurrentWeekTracker(weekStartDate: weekStart)
        context.insert(tracker)
        return tracker
    }
}
```

- [ ] **Step 4: Create DailyLog.swift**

```swift
//
//  DailyLog.swift
//  WalletWars
//

import Foundation
import SwiftData

@Model
final class DailyLog {
    var id: UUID
    var date: Date
    var totalSpent: Double
    var dailyBudget: Double
    var isUnderBudget: Bool
    var transactionCount: Int

    init(date: Date, dailyBudget: Double) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.totalSpent = 0
        self.dailyBudget = dailyBudget
        self.isUnderBudget = true
        self.transactionCount = 0
    }

    var warChest: Double {
        dailyBudget - totalSpent
    }

    var warChestPct: Double {
        guard dailyBudget > 0 else { return 0 }
        return max(0, warChest / dailyBudget)
    }
}
```

- [ ] **Step 5: Commit**

```bash
git add WalletWars/Models/PlayerProfile.swift WalletWars/Models/WeeklySnapshot.swift WalletWars/Models/CurrentWeekTracker.swift WalletWars/Models/DailyLog.swift
git commit -m "feat: add PlayerProfile, WeeklySnapshot, CurrentWeekTracker, DailyLog models"
```

---

## Task 5: Create FormulaService

**Files:**
- Create: `WalletWars/Services/FormulaService.swift`

- [ ] **Step 1: Create Services directory and FormulaService.swift**

```swift
//
//  FormulaService.swift
//  WalletWars
//

import Foundation

enum FormulaService {

    // MARK: - War Chest

    /// Daily budget remaining for today.
    /// Returns the even distribution of remaining monthly budget across remaining days.
    static func warChest(
        monthlyBudget: Double,
        totalSpentThisMonth: Double,
        remainingDaysInMonth: Int
    ) -> Double {
        let remaining = monthlyBudget - totalSpentThisMonth
        guard remainingDaysInMonth > 0 else { return remaining }
        return remaining / Double(remainingDaysInMonth)
    }

    // MARK: - Level

    /// XP required for a specific level: 100 x level.
    /// Cumulative XP for level N = sum(100 x i for i in 1...N).
    static func levelFor(xp: Int) -> Int {
        var level = 0
        var remaining = xp
        while remaining >= (level + 1) * 100 {
            level += 1
            remaining -= level * 100
        }
        return max(1, level)
    }

    static let levelTitles: [Int: String] = [
        1: "Rookie Saver",
        5: "Budget Warrior",
        10: "Money Master",
        15: "Financial Knight",
        20: "Wealth Guardian",
        25: "Legend",
    ]

    /// Title for a given level — finds the highest threshold at or below the level.
    static func titleFor(level: Int) -> String {
        let sortedKeys = levelTitles.keys.sorted(by: >)
        for key in sortedKeys {
            if level >= key {
                return levelTitles[key]!
            }
        }
        return "Rookie Saver"
    }

    // MARK: - Momentum

    /// Momentum percentage comparing current week's savings to last week's.
    /// Clamped to -99%...999%.
    static func momentum(
        currentSaved: Double,
        lastWeekSaved: Double
    ) -> Double {
        guard lastWeekSaved != 0 else { return 0 }
        let pct = ((currentSaved - lastWeekSaved) / abs(lastWeekSaved)) * 100
        return max(-99, min(999, pct))
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add WalletWars/Services/FormulaService.swift
git commit -m "feat: add FormulaService with War Chest, level, and momentum formulas"
```

---

## Task 6: Write Unit Tests for Formulas

**Files:**
- Create: `WalletWarsTests/FormulaTests.swift`
- Delete: `WalletWarsTests/WalletWarsTests.swift` (boilerplate)

- [ ] **Step 1: Delete boilerplate test and create FormulaTests.swift**

Delete `WalletWarsTests/WalletWarsTests.swift`.

Create `WalletWarsTests/FormulaTests.swift`:

```swift
//
//  FormulaTests.swift
//  WalletWarsTests
//

import Testing
@testable import WalletWars

// MARK: - War Chest Formula

struct WarChestFormulaTests {

    @Test func warChestEvenDistribution() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 1500,
            remainingDaysInMonth: 15
        )
        #expect(result == 100.0)
    }

    @Test func warChestNothingSpent() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 0,
            remainingDaysInMonth: 30
        )
        #expect(result == 100.0)
    }

    @Test func warChestOverspent() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 3500,
            remainingDaysInMonth: 5
        )
        #expect(result == -100.0)
    }

    @Test func warChestLastDayOfMonth() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 2900,
            remainingDaysInMonth: 1
        )
        #expect(result == 100.0)
    }

    @Test func warChestZeroDaysRemaining() {
        let result = FormulaService.warChest(
            monthlyBudget: 3000,
            totalSpentThisMonth: 2000,
            remainingDaysInMonth: 0
        )
        // When 0 days remaining, return full remaining amount
        #expect(result == 1000.0)
    }
}

// MARK: - Level Formula

struct LevelFormulaTests {

    @Test func levelZeroXP() {
        #expect(FormulaService.levelFor(xp: 0) == 1)
    }

    @Test func levelJustUnderThreshold() {
        // Level 1 requires 100 XP
        #expect(FormulaService.levelFor(xp: 99) == 1)
    }

    @Test func levelExactlyAtLevel1() {
        // 100 XP = level 1 (need 100 for level 1)
        #expect(FormulaService.levelFor(xp: 100) == 1)
    }

    @Test func levelExactlyAtLevel2() {
        // Level 2 requires cumulative: 100 + 200 = 300
        #expect(FormulaService.levelFor(xp: 300) == 2)
    }

    @Test func levelExactlyAtLevel3() {
        // Level 3 requires cumulative: 100 + 200 + 300 = 600
        #expect(FormulaService.levelFor(xp: 600) == 3)
    }

    @Test func levelExactlyAtLevel5() {
        // Level 5 requires: 100+200+300+400+500 = 1500
        #expect(FormulaService.levelFor(xp: 1500) == 5)
    }

    @Test func levelBetweenLevels() {
        // 400 XP: level 1 (100) + level 2 (200) = 300, remaining 100 < 300 for level 3
        #expect(FormulaService.levelFor(xp: 400) == 2)
    }

    @Test func levelTitleRookieSaver() {
        #expect(FormulaService.titleFor(level: 1) == "Rookie Saver")
    }

    @Test func levelTitleBudgetWarrior() {
        #expect(FormulaService.titleFor(level: 5) == "Budget Warrior")
    }

    @Test func levelTitleBetweenThresholds() {
        // Level 7 is between 5 (Budget Warrior) and 10 (Money Master)
        #expect(FormulaService.titleFor(level: 7) == "Budget Warrior")
    }
}

// MARK: - Momentum Calculation

struct MomentumTests {

    @Test func momentumPositiveImprovement() {
        let result = FormulaService.momentum(currentSaved: 130, lastWeekSaved: 100)
        #expect(result == 30.0)
    }

    @Test func momentumNegativeDecline() {
        let result = FormulaService.momentum(currentSaved: 70, lastWeekSaved: 100)
        #expect(result == -30.0)
    }

    @Test func momentumZeroLastWeek() {
        let result = FormulaService.momentum(currentSaved: 100, lastWeekSaved: 0)
        #expect(result == 0.0)
    }

    @Test func momentumClampedMax() {
        // Massive improvement should cap at 999
        let result = FormulaService.momentum(currentSaved: 10000, lastWeekSaved: 1)
        #expect(result == 999.0)
    }

    @Test func momentumClampedMin() {
        // Massive decline should cap at -99
        let result = FormulaService.momentum(currentSaved: -1000, lastWeekSaved: 1)
        #expect(result == -99.0)
    }

    @Test func momentumNegativeLastWeek() {
        // Last week saved was negative (overspent), this week positive
        let result = FormulaService.momentum(currentSaved: 100, lastWeekSaved: -50)
        // (100 - (-50)) / abs(-50) * 100 = 150/50*100 = 300
        #expect(result == 300.0)
    }
}

// MARK: - WarChestState.from()

struct WarChestStateTests {

    @Test func warChestStateHealthy() {
        #expect(WarChestState.from(percentage: 0.9) == .healthy)
        #expect(WarChestState.from(percentage: 0.8) == .healthy)
        #expect(WarChestState.from(percentage: 1.0) == .healthy)
    }

    @Test func warChestStateCautious() {
        #expect(WarChestState.from(percentage: 0.79) == .cautious)
        #expect(WarChestState.from(percentage: 0.5) == .cautious)
        #expect(WarChestState.from(percentage: 0.4) == .cautious)
    }

    @Test func warChestStateCritical() {
        #expect(WarChestState.from(percentage: 0.39) == .critical)
        #expect(WarChestState.from(percentage: 0.1) == .critical)
        #expect(WarChestState.from(percentage: 0.0) == .critical)
    }

    @Test func warChestStateBroken() {
        #expect(WarChestState.from(percentage: -0.1) == .broken)
        #expect(WarChestState.from(percentage: -1.0) == .broken)
    }
}

// MARK: - MomentumState.from()

struct MomentumStateTests {

    @Test func momentumStateSurging() {
        #expect(MomentumState.from(percentage: 50) == .surging)
        #expect(MomentumState.from(percentage: 30) == .surging)
    }

    @Test func momentumStateClimbing() {
        #expect(MomentumState.from(percentage: 20) == .climbing)
        #expect(MomentumState.from(percentage: 10) == .climbing)
    }

    @Test func momentumStateHolding() {
        #expect(MomentumState.from(percentage: 0) == .holding)
        #expect(MomentumState.from(percentage: 5) == .holding)
        #expect(MomentumState.from(percentage: -5) == .holding)
    }

    @Test func momentumStateSlipping() {
        #expect(MomentumState.from(percentage: -15) == .slipping)
        #expect(MomentumState.from(percentage: -29) == .slipping)
    }

    @Test func momentumStateFreefalling() {
        #expect(MomentumState.from(percentage: -30) == .freefalling)
        #expect(MomentumState.from(percentage: -50) == .freefalling)
    }
}
```

- [ ] **Step 2: Run tests to verify they pass**

Run: `xcodebuild test -project WalletWars.xcodeproj -scheme WalletWars -destination 'platform=iOS Simulator,name=iPhone 16 Pro' 2>&1 | grep -E '(Test Suite|Test Case|passed|failed|BUILD)'`
Expected: All tests pass.

- [ ] **Step 3: Commit**

```bash
git add WalletWarsTests/FormulaTests.swift
git rm WalletWarsTests/WalletWarsTests.swift
git commit -m "test: add formula tests for War Chest, level, momentum, WarChestState, MomentumState"
```

---

## Task 7: Create Design Tokens — Color+Brand.swift

**Files:**
- Create: `WalletWars/Extensions/Color+Brand.swift`

- [ ] **Step 1: Create Extensions directory and Color+Brand.swift**

```swift
//
//  Color+Brand.swift
//  WalletWars
//

import SwiftUI

extension Color {

    // MARK: - Hero Blue — "You, right now"

    static let heroBG    = Color(hex: "EBF2FF")
    static let heroLight = Color(hex: "A8C8FF")
    static let heroMid   = Color(hex: "4D8FFF")
    static let hero      = Color(hex: "1B6EF2")
    static let heroDim   = Color(hex: "0A4FBD")
    static let heroDeep  = Color(hex: "0A3578")

    // MARK: - Rival Red — "Past you, the enemy"

    static let rivalBG    = Color(hex: "FFF0ED")
    static let rivalLight = Color(hex: "FFB8AA")
    static let rivalMid   = Color(hex: "FF6B52")
    static let rival      = Color(hex: "E5432A")
    static let rivalDim   = Color(hex: "B22D18")
    static let rivalDeep  = Color(hex: "721C0F")

    // MARK: - Victory Emerald

    static let victoryBG    = Color(hex: "E6F7EF")
    static let victoryLight = Color(hex: "5CE0A0")
    static let victory      = Color(hex: "12B76A")
    static let victoryDim   = Color(hex: "0D7A48")

    // MARK: - Streak Amber

    static let streakBG    = Color(hex: "FFF6E5")
    static let streakLight = Color(hex: "FFCB57")
    static let streak      = Color(hex: "F5A623")
    static let streakDim   = Color(hex: "B87A0A")

    // MARK: - Surface Neutrals

    static let surface     = Color(hex: "F8F7F6")
    static let surfaceLow  = Color(hex: "F1F0EF")
    static let surfaceHigh = Color(hex: "E3E2E0")
    static let card        = Color.white
    static let textPrimary = Color(hex: "2E2F2F")
    static let textMid     = Color(hex: "5B5C5B")
    static let textLight   = Color(hex: "8A8B8A")

    // MARK: - War Chest State Colors

    static func warChestColor(_ state: WarChestState) -> Color {
        switch state {
        case .healthy:  return .victory
        case .cautious: return .streak
        case .critical: return .rival
        case .broken:   return .rivalDeep
        }
    }

    // MARK: - Hex Initializer

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add WalletWars/Extensions/Color+Brand.swift
git commit -m "feat: add brand color tokens with hex initializer"
```

---

## Task 8: Create Design Tokens — Animation+Spring.swift

**Files:**
- Create: `WalletWars/Extensions/Animation+Spring.swift`

- [ ] **Step 1: Create Animation+Spring.swift**

```swift
//
//  Animation+Spring.swift
//  WalletWars
//

import SwiftUI

extension Animation {
    static let springFast   = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let springMedium = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.85)
}

enum AnimationDuration {
    static let xpFloat: Double = 1.2
    static let confetti: Double = 2.0
    static let duelBar: Double = 0.7
}
```

- [ ] **Step 2: Commit**

```bash
git add WalletWars/Extensions/Animation+Spring.swift
git commit -m "feat: add spring animation presets and duration constants"
```

---

## Task 9: Set Up Plus Jakarta Sans Font Bundle

**Files:**
- Create: `WalletWars/Resources/Fonts/` directory with .ttf files
- Modify: `WalletWars/Info.plist` (or add one if using Xcode-generated plist)

**Important:** Font files (.ttf) must be added to the Xcode project manually via Xcode's "Add Files" dialog so they appear in the "Copy Bundle Resources" build phase. This task creates the directory structure and documents what needs to be done in Xcode.

- [ ] **Step 1: Create Fonts directory**

```bash
mkdir -p WalletWars/Resources/Fonts
```

- [ ] **Step 2: Download Plus Jakarta Sans font files**

Download the Plus Jakarta Sans font family from Google Fonts. The needed weights are:
- PlusJakartaSans-Regular.ttf (400)
- PlusJakartaSans-Medium.ttf (500)
- PlusJakartaSans-SemiBold.ttf (600)
- PlusJakartaSans-Bold.ttf (700)
- PlusJakartaSans-ExtraBold.ttf (800)

Place them in `WalletWars/Resources/Fonts/`.

- [ ] **Step 3: Register fonts in Info.plist**

Add an `Info.plist` to the WalletWars target (if not already present) with the key `UIAppFonts` (Fonts provided by application):

```xml
<key>UIAppFonts</key>
<array>
    <string>PlusJakartaSans-Regular.ttf</string>
    <string>PlusJakartaSans-Medium.ttf</string>
    <string>PlusJakartaSans-SemiBold.ttf</string>
    <string>PlusJakartaSans-Bold.ttf</string>
    <string>PlusJakartaSans-ExtraBold.ttf</string>
</array>
```

- [ ] **Step 4: Add font files to Xcode project**

In Xcode: File > Add Files to "WalletWars" > select all .ttf files in Resources/Fonts/ > check "Copy items if needed" and target "WalletWars". Verify they appear in Build Phases > Copy Bundle Resources.

- [ ] **Step 5: Commit**

```bash
git add WalletWars/Resources/Fonts/ WalletWars/Info.plist
git commit -m "feat: add Plus Jakarta Sans font bundle"
```

---

## Task 10: Create CategorySeedService

**Files:**
- Create: `WalletWars/Services/CategorySeedService.swift`

- [ ] **Step 1: Create CategorySeedService.swift**

```swift
//
//  CategorySeedService.swift
//  WalletWars
//

import Foundation
import SwiftData

enum CategorySeedService {

    static let defaults: [(name: String, icon: String, color: String)] = [
        ("Food & Drink",  "fork.knife",          "FF9500"),
        ("Transport",     "car.fill",             "007AFF"),
        ("Shopping",      "bag.fill",             "FF2D55"),
        ("Entertainment", "gamecontroller.fill",   "AF52DE"),
        ("Bills",         "bolt.fill",             "FFCC00"),
        ("Health",        "heart.fill",            "FF3B30"),
        ("Education",     "book.fill",             "34C759"),
        ("Other",         "ellipsis.circle.fill",  "8E8E93"),
    ]

    /// Seeds default categories if none exist. Call on first launch.
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Category>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        for (index, entry) in defaults.enumerated() {
            let category = Category(
                name: entry.name,
                icon: entry.icon,
                colorHex: entry.color,
                sortOrder: index,
                isCustom: false
            )
            context.insert(category)
        }
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add WalletWars/Services/CategorySeedService.swift
git commit -m "feat: add CategorySeedService for default category seeding"
```

---

## Task 11: Create Placeholder Tab Views

**Files:**
- Create: `WalletWars/Views/Dashboard/DashboardView.swift`
- Create: `WalletWars/Views/Log/TransactionLogView.swift`
- Create: `WalletWars/Views/Duel/DuelView.swift`
- Create: `WalletWars/Views/Quest/QuestView.swift`
- Create: `WalletWars/Views/Profile/ProfileView.swift`

- [ ] **Step 1: Create all 5 placeholder views**

Create directory structure and files:

`WalletWars/Views/Dashboard/DashboardView.swift`:
```swift
//
//  DashboardView.swift
//  WalletWars
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Dashboard")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("WalletWars")
        }
    }
}
```

`WalletWars/Views/Log/TransactionLogView.swift`:
```swift
//
//  TransactionLogView.swift
//  WalletWars
//

import SwiftUI

struct TransactionLogView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Transaction Log")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Transactions")
        }
    }
}
```

`WalletWars/Views/Duel/DuelView.swift`:
```swift
//
//  DuelView.swift
//  WalletWars
//

import SwiftUI

struct DuelView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Weekly Duel")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Duel")
        }
    }
}
```

`WalletWars/Views/Quest/QuestView.swift`:
```swift
//
//  QuestView.swift
//  WalletWars
//

import SwiftUI

struct QuestView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Saving Quests")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Quest")
        }
    }
}
```

`WalletWars/Views/Profile/ProfileView.swift`:
```swift
//
//  ProfileView.swift
//  WalletWars
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Profile")
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Profile")
        }
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add WalletWars/Views/
git commit -m "feat: add placeholder views for all 5 tabs"
```

---

## Task 12: Build 5-Tab TabView and Wire Up App Entry Point

**Files:**
- Modify: `WalletWars/ContentView.swift` (replace boilerplate with TabView)
- Modify: `WalletWars/WalletWarsApp.swift` (replace Item container with real models)
- Delete: `WalletWars/Item.swift` (boilerplate)

- [ ] **Step 1: Replace ContentView.swift with 5-tab TabView**

Replace the entire contents of `WalletWars/ContentView.swift`:

```swift
//
//  ContentView.swift
//  WalletWars
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "chart.bar.fill", value: 0) {
                DashboardView()
            }

            Tab("Log", systemImage: "list.bullet.rectangle.fill", value: 1) {
                TransactionLogView()
            }

            Tab("Duel", systemImage: "figure.fencing", value: 2) {
                DuelView()
            }
            .tint(Color.rival)

            Tab("Quest", systemImage: "flag.fill", value: 3) {
                QuestView()
            }

            Tab("Profile", systemImage: "trophy.fill", value: 4) {
                ProfileView()
            }
        }
        .tint(Color.hero)
    }
}
```

- [ ] **Step 2: Replace WalletWarsApp.swift with real ModelContainer**

Replace the entire contents of `WalletWars/WalletWarsApp.swift`:

```swift
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
```

- [ ] **Step 3: Delete Item.swift**

```bash
rm WalletWars/Item.swift
```

- [ ] **Step 4: Build to verify everything compiles**

Run: `xcodebuild -project WalletWars.xcodeproj -scheme WalletWars -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 5: Run tests to verify they still pass**

Run: `xcodebuild test -project WalletWars.xcodeproj -scheme WalletWars -destination 'platform=iOS Simulator,name=iPhone 16 Pro' 2>&1 | grep -E '(passed|failed|BUILD)'`
Expected: All tests pass, BUILD SUCCEEDED

- [ ] **Step 6: Commit**

```bash
git rm WalletWars/Item.swift
git add WalletWars/ContentView.swift WalletWars/WalletWarsApp.swift
git commit -m "feat: wire up 5-tab TabView shell with real ModelContainer and category seeding"
```

---

## Task 13: Create ViewModels Directory (empty scaffold)

**Files:**
- Create: `WalletWars/ViewModels/.gitkeep`

- [ ] **Step 1: Create empty ViewModels directory**

```bash
mkdir -p WalletWars/ViewModels
touch WalletWars/ViewModels/.gitkeep
```

- [ ] **Step 2: Commit**

```bash
git add WalletWars/ViewModels/.gitkeep
git commit -m "feat: scaffold ViewModels directory for Sprint 1"
```

---

## Post-Sprint Verification

After all tasks are complete, run the full build + test suite:

```bash
# Full build
xcodebuild -project WalletWars.xcodeproj -scheme WalletWars -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -10

# Full test
xcodebuild test -project WalletWars.xcodeproj -scheme WalletWars -destination 'platform=iOS Simulator,name=iPhone 16 Pro' 2>&1 | grep -E '(Test Suite|passed|failed|BUILD)'
```

Expected:
- BUILD SUCCEEDED
- All FormulaTests pass (War Chest, level, momentum, WarChestState, MomentumState)
- App launches with 5-tab TabView
- Duel tab shows Rival Red tint
- Default categories seeded on first launch
