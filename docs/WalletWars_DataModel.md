# WalletWars — Data Model Specification

## Overview

SwiftData models for WalletWars. Offline-first, zero network, all data on device.

---

## Entity Relationship Diagram

```
┌──────────────────┐     ┌──────────────────┐
│   Transaction    │     │    Category       │
│──────────────────│     │──────────────────│
│ id: UUID         │     │ id: UUID         │
│ amount: Double   │────►│ name: String     │
│ note: String?    │     │ icon: String     │
│ date: Date       │     │ color: String    │
│ category: Cat    │     │ budgetAmount: D? │
│ createdAt: Date  │     │ sortOrder: Int   │
│                  │     │ isCustom: Bool   │
└──────────────────┘     └──────────────────┘

┌──────────────────┐     ┌──────────────────┐
│   SavingQuest    │     │ QuestMilestone   │
│──────────────────│     │──────────────────│
│ id: UUID         │     │ id: UUID         │
│ name: String     │     │ title: String    │
│ targetAmount: D  │     │ targetAmount: D  │
│ savedAmount: D   │────►│ isCompleted: Bool│
│ status: QStatus  │     │ completedAt: D?  │
│ deadline: Date?  │     │ sortOrder: Int   │
│ activatedAt: D?  │     │ quest: SavingQ   │
│ completedAt: D?  │     └──────────────────┘
│ milestones: [QM] │
│ createdAt: Date  │
└──────────────────┘

┌──────────────────┐     ┌──────────────────┐
│  PlayerProfile   │     │ WeeklySnapshot   │
│──────────────────│     │──────────────────│
│ (singleton)      │     │ id: UUID         │
│ totalXP: Int     │     │ weekStartDate: D │
│ currentLevel: Int│     │ totalSpent: D    │
│ monthlyBudget: D │     │ totalSaved: D    │
│ logStreak: Int   │     │ daysUnderBudget  │
│ logStreakLastD: D?│     │ daysLogged: Int  │
│ budgetStreak: Int│     │ categoryWorst: S?│
│ budgetStreakLD: D?│     │ categoryWorstPct │
│ streakFreezes: I │     │ questDeposits: D │
│ streakFreezeLD:D?│     │ duelResult: DR?  │
│ unlockedBadges   │     │ createdAt: Date  │
│ questsDoneCount  │     └──────────────────┘
│ hasOnboarded     │
│ currencyCode: S  │     ┌──────────────────┐
│ createdAt: Date  │     │CurrentWeekTracker│
└──────────────────┘     │──────────────────│
                         │ (singleton)      │
                         │ weekStartDate: D │
                         │ totalSpent: D    │
                         │ totalSaved: D    │
                         │ daysUnderBudget  │
                         │ daysLogged: Int  │
                         │ categorySpend:{} │
                         │ questDeposits: D │
                         │ transactionCount │
                         └──────────────────┘

┌──────────────────┐
│   DailyLog       │
│──────────────────│
│ id: UUID         │
│ date: Date       │
│ totalSpent: D    │
│ dailyBudget: D   │
│ isUnderBudget: B │
│ transactionCnt:I │
│ hasLoggedToday: B│
└──────────────────┘
```

---

## Model Definitions

### Transaction

```swift
@Model
final class Transaction {
    var id: UUID
    var amount: Double              // Always positive
    var note: String?               // Optional memo (max 100 chars)
    var date: Date                  // Transaction date (user can backdate)
    var category: Category?         // Relationship
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

**Validation Rules:**
- `amount` > 0
- `note` max 100 characters
- `date` cannot be in the future (max: end of today)

---

### Category

```swift
@Model
final class Category {
    var id: UUID
    var name: String                // Max 30 chars
    var icon: String                // SF Symbol name
    var colorHex: String            // Hex color string
    var budgetAmount: Double?       // Optional per-category budget
    var sortOrder: Int
    var isCustom: Bool              // false = default category
    var isArchived: Bool            // Soft delete
    var transactions: [Transaction] // Inverse relationship
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

**Default Categories:**

```swift
static let defaults: [(name: String, icon: String, color: String)] = [
    ("Food & Drink",    "fork.knife",            "FF9500"),  // Orange
    ("Transport",       "car.fill",               "007AFF"),  // Blue
    ("Shopping",        "bag.fill",               "FF2D55"),  // Pink
    ("Entertainment",   "gamecontroller.fill",     "AF52DE"),  // Purple
    ("Bills",           "bolt.fill",               "FFCC00"),  // Yellow
    ("Health",          "heart.fill",              "FF3B30"),  // Red
    ("Education",       "book.fill",               "34C759"),  // Green
    ("Other",           "ellipsis.circle.fill",    "8E8E93"),  // Gray
]
```

**Rules:**
- Max 12 categories total (8 default + 4 custom)
- Default categories cannot be deleted, only archived
- Custom categories can be fully deleted if no transactions reference them

---

### SavingQuest

```swift
@Model
final class SavingQuest {
    var id: UUID
    var name: String                // Max 60 chars
    var targetAmount: Double        // Goal amount
    var savedAmount: Double         // Current progress
    var status: QuestStatus         // .active, .completed, .abandoned
    var deadline: Date?             // Optional target date
    var activatedAt: Date?
    var completedAt: Date?
    var completionDays: Int?        // Days from activation to completion
    var xpEarned: Int
    var milestones: [QuestMilestone] // Relationship
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

    /// Progress percentage (0.0 - 1.0)
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, savedAmount / targetAmount)
    }

    /// Days remaining until deadline (nil if no deadline)
    var daysRemaining: Int? {
        guard let deadline else { return nil }
        return Calendar.current.dateComponents([.day], from: .now, to: deadline).day
    }
}
```

**Rules:**
- Max 1 active quest (free), up to 3 (Plus)
- `savedAmount` <= `targetAmount` (clamped)
- When `savedAmount` >= `targetAmount` → auto-complete

---

### QuestMilestone

```swift
@Model
final class QuestMilestone {
    var id: UUID
    var title: String               // Max 100 chars
    var targetAmount: Double        // Amount needed to unlock this milestone
    var isCompleted: Bool
    var completedAt: Date?
    var sortOrder: Int
    var quest: SavingQuest?         // Parent relationship

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
}
```

**Auto-Generated Milestones:**
When a quest is created, if user doesn't set custom milestones, auto-generate:

```swift
static func autoMilestones(for target: Double) -> [(String, Double)] {
    [
        ("First Steps",    target * 0.2),   // 20%
        ("Halfway There",  target * 0.5),   // 50%
        ("Almost There",   target * 0.8),   // 80%
        ("Quest Complete", target * 1.0),   // 100%
    ]
}
```

---

### PlayerProfile (Singleton)

```swift
@Model
final class PlayerProfile {
    var id: UUID
    var totalXP: Int
    var currentLevel: Int
    var monthlyBudget: Double       // Total monthly budget

    // Logging Streak
    var logStreakCount: Int
    var logStreakLastDate: Date?
    var logStreakBest: Int           // Personal record

    // Budget Streak
    var budgetStreakCount: Int
    var budgetStreakLastDate: Date?
    var budgetStreakBest: Int        // Personal record

    // Streak Freeze
    var streakFreezesAvailable: Int  // Max 1 per week earned
    var streakFreezeLastUsed: Date?

    // Badges
    var unlockedBadges: [String]     // Badge IDs

    // Stats
    var questsCompletedCount: Int
    var duelsWonCount: Int
    var duelsPlayedCount: Int
    var totalTransactions: Int
    var duelWinStreak: Int           // Current consecutive wins
    var duelWinStreakBest: Int        // Personal record

    // Settings
    var currencyCode: String         // "IDR", "USD", etc.
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
}
```

**Singleton Pattern:**
```swift
static func fetchOrCreate(context: ModelContext) -> PlayerProfile {
    let descriptor = FetchDescriptor<PlayerProfile>()
    if let existing = try? context.fetch(descriptor).first {
        return existing
    }
    let profile = PlayerProfile()
    context.insert(profile)
    return profile
}
```

---

### WeeklySnapshot

```swift
@Model
final class WeeklySnapshot {
    var id: UUID
    var weekStartDate: Date          // Monday of the week
    var totalSpent: Double           // Total spending that week
    var totalSaved: Double           // Budget - Spent (can be negative)
    var daysUnderBudget: Int         // Out of 7
    var daysLogged: Int              // Out of 7
    var worstCategoryName: String?   // Category with highest overspend %
    var worstCategoryPct: Double     // % over budget for worst category
    var questDeposits: Double        // Amount deposited to quests
    var duelResult: DuelResult?      // .win, .loss, .draw (nil for first week)
    var roundsWon: Int               // 0-4
    var roundsLost: Int              // 0-4
    var momentumPct: Double          // Momentum percentage
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

---

### CurrentWeekTracker (Singleton)

```swift
@Model
final class CurrentWeekTracker {
    var id: UUID
    var weekStartDate: Date          // Monday of current week
    var totalSpent: Double
    var totalSaved: Double           // Computed: weeklyBudget - totalSpent
    var daysUnderBudget: Int
    var daysLogged: Int
    var categorySpending: [String: Double]  // categoryId: totalSpent
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
}
```

---

### DailyLog

```swift
@Model
final class DailyLog {
    var id: UUID
    var date: Date                   // Calendar date (time stripped)
    var totalSpent: Double
    var dailyBudget: Double          // War Chest for that day
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

    /// Remaining budget for the day
    var warChest: Double {
        dailyBudget - totalSpent
    }

    /// War Chest percentage remaining (0.0 - 1.0)
    var warChestPct: Double {
        guard dailyBudget > 0 else { return 0 }
        return max(0, warChest / dailyBudget)
    }
}
```

---

## Enums

```swift
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
    case warChestDiscipline  // Days under budget
    case savingPower         // Total saved (budget - spent)
    case loggingConsistency  // Days with transactions logged
    case categoryControl     // Worst category improvement

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
enum MomentumState: String {
    case surging     // > +30%
    case climbing    // +10% to +30%
    case holding     // -10% to +10%
    case slipping    // -30% to -10%
    case freefalling // < -30%

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

    var color: String {
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
        case 30...:         return .surging
        case 10..<30:       return .climbing
        case -10..<10:      return .holding
        case -30 ..< -10:   return .slipping
        default:            return .freefalling
        }
    }
}

// MARK: - Badge Type
enum BadgeType: String, Codable, CaseIterable {
    case firstSave       // First quest deposit
    case logger7         // 7-day logging streak
    case logger30        // 30-day logging streak
    case budget7         // 7-day budget streak
    case budget30        // 30-day budget streak
    case duelWin         // First duel win
    case duelStreak3     // 3 consecutive duel wins
    case questDone       // First quest completed
    case quest5          // 5 quests completed
    case underSpend50    // Spend < 50% of monthly budget
    case noImpulse       // 7 days no spending in worst category
    case momentum3       // 3 weeks Climbing/Surging momentum

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
            return "12B76A" // Victory Green
        case .logger7, .logger30:
            return "F5A623" // Streak Amber
        case .budget7, .budget30, .momentum3:
            return "1B6EF2" // Hero Blue
        case .duelWin, .duelStreak3:
            return "E5432A" // Rival Red
        case .quest5:
            return "FFCC00" // Gold
        case .noImpulse:
            return "AF52DE" // Purple
        }
    }
}

// MARK: - War Chest State
enum WarChestState {
    case healthy    // > 80% remaining
    case cautious   // 40-80% remaining
    case critical   // < 40% remaining
    case broken     // Over budget (negative)

    var color: String {
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
```

---

## XP Constants

```swift
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

---

## War Chest Formula

```swift
/// Daily budget remaining for today
static func warChest(
    monthlyBudget: Double,
    totalSpentThisMonth: Double,
    remainingDaysInMonth: Int
) -> Double {
    let remaining = monthlyBudget - totalSpentThisMonth
    guard remainingDaysInMonth > 0 else { return remaining }
    return remaining / Double(remainingDaysInMonth)
}
```

---

## Weekly Duel Comparison

```swift
/// Compare current week vs last week snapshot across 4 rounds.
/// Returns (roundsWon, roundsLost).
static func compareDuel(
    current: CurrentWeekTracker,
    lastWeek: WeeklySnapshot
) -> (won: Int, lost: Int) {
    var won = 0
    var lost = 0

    // Round 1: War Chest Discipline (days under budget)
    if current.daysUnderBudget > lastWeek.daysUnderBudget { won += 1 }
    else if current.daysUnderBudget < lastWeek.daysUnderBudget { lost += 1 }

    // Round 2: Saving Power (total saved)
    if current.totalSaved > lastWeek.totalSaved { won += 1 }
    else if current.totalSaved < lastWeek.totalSaved { lost += 1 }

    // Round 3: Logging Consistency (days logged)
    if current.daysLogged > lastWeek.daysLogged { won += 1 }
    else if current.daysLogged < lastWeek.daysLogged { lost += 1 }

    // Round 4: Category Control (worst category improvement)
    // Lower worstCategoryPct = better
    let currentWorstPct = currentWorstCategoryPercentage(current)
    if currentWorstPct < lastWeek.worstCategoryPct { won += 1 }
    else if currentWorstPct > lastWeek.worstCategoryPct { lost += 1 }

    return (won, lost)
}

/// Momentum calculation
static func momentum(
    currentSaved: Double,
    lastWeekSaved: Double
) -> Double {
    guard lastWeekSaved != 0 else { return 0 }
    let pct = ((currentSaved - lastWeekSaved) / abs(lastWeekSaved)) * 100
    return max(-99, min(999, pct))
}
```

---

## SwiftData Container Setup

```swift
// Production
let container = try ModelContainer(for:
    Transaction.self,
    Category.self,
    SavingQuest.self,
    QuestMilestone.self,
    PlayerProfile.self,
    WeeklySnapshot.self,
    CurrentWeekTracker.self,
    DailyLog.self
)

// Preview / Testing
let container = try ModelContainer(for:
    Transaction.self,
    Category.self,
    SavingQuest.self,
    QuestMilestone.self,
    PlayerProfile.self,
    WeeklySnapshot.self,
    CurrentWeekTracker.self,
    DailyLog.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
)
```

---

## Query Patterns

```swift
// All transactions for today
#Predicate<Transaction> { $0.date >= startOfToday && $0.date < startOfTomorrow }

// All transactions this month
#Predicate<Transaction> { $0.date >= startOfMonth && $0.date < startOfNextMonth }

// Active saving quest
#Predicate<SavingQuest> { $0.status == .active }

// Completed quests (Hall of Fame)
#Predicate<SavingQuest> { $0.status == .completed }

// Weekly snapshots sorted by date (duel history)
FetchDescriptor<WeeklySnapshot>(sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)])

// Today's daily log
#Predicate<DailyLog> { $0.date == startOfToday }

// Transactions by category
#Predicate<Transaction> { $0.category?.id == targetCategoryId }
```

---

## Relationships Summary

```
Transaction ──many-to-one──► Category
SavingQuest ──one-to-many──► QuestMilestone
PlayerProfile (singleton, no relationships)
CurrentWeekTracker (singleton, no relationships)
WeeklySnapshot (standalone, sorted by date)
DailyLog (standalone, one per day)
```

---

## Data Lifecycle

```
App Launch:
  1. Fetch-or-create PlayerProfile singleton
  2. Fetch-or-create CurrentWeekTracker singleton
  3. Check if Monday has passed → create WeeklySnapshot + run duel
  4. Fetch-or-create today's DailyLog
  5. Seed default categories if first launch

Transaction Logged:
  1. Create Transaction
  2. Update DailyLog (totalSpent, transactionCount, isUnderBudget)
  3. Update CurrentWeekTracker (totalSpent, daysLogged, categorySpending)
  4. Update PlayerProfile (totalXP += 5, check streaks)
  5. Check badge conditions
  6. Update War Chest display

Week Boundary (Monday):
  1. Snapshot CurrentWeekTracker → new WeeklySnapshot
  2. Compare with previous WeeklySnapshot → DuelResult
  3. Award duel XP
  4. Reset CurrentWeekTracker for new week
  5. Check streak freeze availability (refill 1)
  6. Check duel-related badges

Quest Deposit:
  1. Update SavingQuest.savedAmount
  2. Check milestone completion → award XP per milestone
  3. Check quest completion → award XP + badge
  4. Update CurrentWeekTracker.questDeposits
```
