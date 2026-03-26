# WalletWars

Gamified personal finance tracker — log expenses, guard your daily budget (War Chest), compete against last week's you in weekly duels, complete saving quests. Free, offline-first, no accounts. iOS 26+ with Liquid Glass + Liquid Tactical Finance design.

**Tagline:** "Your wallet. Your rules. Your rival."

## Core principles

- **Simplicity first:** Make every change as simple as possible. Impact minimal code.
- **No laziness:** Find root causes. No temporary fixes. Senior developer standards.
- **Minimal impact:** Changes should only touch what's necessary. Avoid introducing bugs.
- **Demand elegance (balanced):** For non-trivial changes, pause and ask "is there a more elegant way?" Skip for simple obvious fixes — don't over-engineer.

## Workflow orchestration

1. **Plan mode default:** Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions). If something goes sideways, STOP and re-plan immediately — don't keep pushing.
2. **Subagent strategy:** Use subagents liberally to keep main context clean. Offload research, exploration, and parallel analysis. One task per subagent for focused execution.
3. **Self-improvement loop:** After ANY correction from the user, update `tasks/lessons.md` with the pattern. Write rules that prevent the same mistake. Review lessons at session start.
4. **Verification before done:** Never mark a task complete without proving it works. Ask yourself: "Would a staff iOS engineer approve this?" Run tests, check logs, demonstrate correctness.
5. **Autonomous bug fixing:** When given a bug report, just fix it. Don't ask for hand-holding. Point at logs, errors, failing tests — then resolve them.

## Task management

1. **Plan first:** Write plan to `tasks/todo.md` with checkable items.
2. **Verify plan:** Check in before starting implementation.
3. **Track progress:** Mark items complete as you go.
4. **Explain changes:** High-level summary at each step.
5. **Document results:** Add review section to `tasks/todo.md`.
6. **Capture lessons:** Update `tasks/lessons.md` after corrections.

## Tech stack

- Swift 6.2, SwiftUI, iOS 26+ minimum deployment
- SwiftData (`@Model` macro) for local persistence
- UserNotifications for daily reminder + streak warnings + duel results
- BGTaskScheduler for weekly snapshot creation at week boundary (Monday)
- MVVM with `@Observable` ViewModels
- Zero third-party dependencies — pure Apple frameworks only (except Plus Jakarta Sans font bundle)
- Xcode 26, Swift Testing + XCTest UI Tests

## Build & run

```
# Open project (no CLI builds — use Xcode for SwiftUI previews)
open WalletWars.xcodeproj
# Scheme: WalletWars > iPhone 16 Pro simulator
# Run tests: Cmd+U in Xcode
```

## Project structure

```
WalletWars/
├── App/                  → WalletWarsApp.swift, ContentView.swift (TabView)
├── Models/
│   ├── Transaction.swift → @Model — expense entry
│   ├── Category.swift    → @Model — spending category (8 defaults + custom)
│   ├── SavingQuest.swift → @Model — saving goal with milestones
│   ├── QuestMilestone.swift → @Model — milestone within a quest
│   ├── PlayerProfile.swift → @Model singleton — XP, level, streaks, badges, budget
│   ├── WeeklySnapshot.swift → @Model — past week stats for duel comparison
│   ├── CurrentWeekTracker.swift → @Model singleton — running weekly totals
│   ├── DailyLog.swift    → @Model — daily spending summary + War Chest
│   └── Enums.swift       → QuestStatus, DuelResult, DuelRound, MomentumState, BadgeType, WarChestState
├── ViewModels/           → @Observable VMs: Dashboard, TransactionLog, Duel, Quest, Profile, QuickCapture, Onboarding, Settings
├── Views/
│   ├── Dashboard/        → DashboardView, WarChestCard, TodayTransactionsList, StreakBanner, InsightCard
│   ├── Capture/          → QuickCaptureSheet, AmountInput, CategoryGrid
│   ├── Log/              → TransactionLogView, TransactionRow, FilterSheet, CategoryBudgetView
│   ├── Duel/             → DuelView, VSCard, RoundCard, DuelResultOverlay, MomentumBadge, LiveStandingsView, DuelHistoryList
│   ├── Quest/            → QuestView, QuestProgressRing, MilestoneList, QuestDepositSheet, NewQuestSheet, CompletedQuestCard
│   ├── Profile/          → ProfileView, LevelCard, StreakCards, DuelRecordCard, BadgeGrid, LifetimeStatsCard
│   ├── Onboarding/       → OnboardingView, OnboardingPage1/2/3
│   ├── Settings/         → SettingsView
│   └── Components/       → GlassCard, XPFloatView, ConfettiView, ProgressBar, ShieldView
├── Services/
│   ├── XPService.swift   → XP awarding, level-up detection, float animation triggers
│   ├── StreakService.swift → Dual streak calculation (logging + budget), freeze logic
│   ├── DuelService.swift → Weekly snapshot, 4-round comparison, result + momentum calculation
│   ├── BadgeService.swift → Badge unlock evaluation after each action
│   ├── WarChestService.swift → Daily budget calculation, state determination
│   ├── InsightService.swift → Smart suggestions, trend detection, category alerts
│   ├── NotificationService.swift → Local notification scheduling (daily reminder, duel results, streak warning)
│   └── CategorySeedService.swift → Default category seeding on first launch
├── Extensions/
│   ├── Color+Brand.swift → Brand color tokens
│   ├── Date+Week.swift   → Week boundary helpers (Monday start)
│   ├── View+Glass.swift  → Glass effect modifiers
│   ├── Double+Currency.swift → Currency formatting helpers
│   └── Animation+Spring.swift → Spring animation presets
├── Resources/
│   ├── Assets.xcassets   → App icon, brand colors as named colors
│   ├── Fonts/            → PlusJakartaSans-*.ttf (400, 500, 600, 700, 800)
│   └── Preview Content/  → Sample data for SwiftUI previews
├── docs/                 → PRD, data model, user flows, mockups
└── tasks/                → todo.md, lessons.md
```

## Architecture rules

- Every screen gets its own `@Observable` ViewModel. Views never access `ModelContext` directly.
- ViewModels own the `ModelContext`; pass via initializer, not environment.
- Business logic (XP awarding, War Chest formula, streak resets, duel calculations, badge unlocks, insight generation) lives in Services or ViewModel methods — NEVER in View bodies.
- Navigation uses `NavigationStack` with typed `NavigationPath`. No coordinator pattern.
- Use `@Query` in Views only for read-only lists. Mutations go through ViewModel.
- Services are stateless utility classes with static methods or lightweight `@Observable` singletons.

## SwiftUI rules — IMPORTANT

- NEVER put more than ~50 lines in a single `var body`. Extract subviews to avoid "compiler unable to type-check" errors.
- Prefer `LazyVStack` inside `ScrollView` over `List` for custom-styled item lists (War Chest cards, transaction rows, duel rounds need custom styling).
- Use `.task {}` for async work, never `onAppear` with `Task {}`.
- Always add `@MainActor` to ViewModels and any class that touches UI state.
- Use `private` on `@State` and `@Binding` properties.
- Use SF Symbols for all icons. Prefer filled variants on glass surfaces.
- Prefer `.font(.system(.body, design: .rounded))` for body text OR use Plus Jakarta Sans via custom font modifier.
- Tab bar icons: `chart.bar.fill` (Dashboard), `list.bullet.rectangle.fill` (Log), `figure.fencing` (Duel), `flag.fill` (Quest), `trophy.fill` (Profile).

## SwiftData rules — IMPORTANT

- `QuestMilestone` is a separate `@Model` with a relationship to `SavingQuest` — NOT embedded Codable.
- `PlayerProfile` and `CurrentWeekTracker` are singletons — fetch or create on first access.
- Always update `updatedAt = .now` on models that have it before any save.
- Use `#Predicate` for filtering (e.g., active quests, today's transactions), never raw string predicates.
- For previews, use in-memory container: `ModelContainer(for: Transaction.self, Category.self, SavingQuest.self, QuestMilestone.self, PlayerProfile.self, WeeklySnapshot.self, CurrentWeekTracker.self, DailyLog.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))`.
- Max 1 `SavingQuest` with `.active` status enforced in ViewModel (free tier). Check before activation.
- `Transaction.amount` is always positive. Display sign based on context (expenses show "-").
- `Category` defaults are seeded on first launch via `CategorySeedService`. Max 12 total (8 default + 4 custom).

## iOS 26 Liquid Glass — IMPORTANT

- Apply `.glassEffect()` to cards, sheets, and the tab bar for Liquid Glass look.
- NEVER apply `.background()` BEFORE `.glassEffect()` — it blocks the glass material. Glass modifier must come first.
- Use `.ultraThinMaterial` as base material for glass surfaces.
- Tab bar: use native `TabView` with `.tabViewStyle(.automatic)` — iOS 26 applies glass automatically.
- Duel tab active state uses Rival Red tint; all others use Hero Blue. Implement with custom tab bar styling.
- All animations use `spring(response:dampingFraction:)`, not `.default` or `.linear`.
- Quick Capture sheet presented as `.presentationDetents([.large])`.
- Filter sheet presented as `.presentationDetents([.medium])`.

## Design tokens

```swift
// MARK: - Brand Colors (Hero Blue vs Rival Red)

// Hero Blue — "You, right now"
static let heroBG      = Color(hex: "EBF2FF")
static let heroLight   = Color(hex: "A8C8FF")
static let heroMid     = Color(hex: "4D8FFF")
static let hero        = Color(hex: "1B6EF2")  // Primary
static let heroDim     = Color(hex: "0A4FBD")
static let heroDeep    = Color(hex: "0A3578")

// Rival Red — "Past you, the enemy"
static let rivalBG     = Color(hex: "FFF0ED")
static let rivalLight  = Color(hex: "FFB8AA")
static let rivalMid    = Color(hex: "FF6B52")
static let rival       = Color(hex: "E5432A")  // Primary
static let rivalDim    = Color(hex: "B22D18")
static let rivalDeep   = Color(hex: "721C0F")

// Victory Emerald — under budget, quest progress, wins
static let victoryBG   = Color(hex: "E6F7EF")
static let victoryLight = Color(hex: "5CE0A0")
static let victory     = Color(hex: "12B76A")  // Primary
static let victoryDim  = Color(hex: "0D7A48")

// Streak Amber — streaks, urgency, XP, rewards
static let streakBG    = Color(hex: "FFF6E5")
static let streakLight = Color(hex: "FFCB57")
static let streak      = Color(hex: "F5A623")  // Primary
static let streakDim   = Color(hex: "B87A0A")

// Surface Neutrals
static let surface     = Color(hex: "F8F7F6")
static let surfaceLow  = Color(hex: "F1F0EF")
static let surfaceHigh = Color(hex: "E3E2E0")
static let card        = Color.white
static let textPrimary = Color(hex: "2E2F2F")  // Never use pure black
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

// MARK: - Animations
static let springFast   = Animation.spring(response: 0.3, dampingFraction: 0.7)
static let springMedium = Animation.spring(response: 0.4, dampingFraction: 0.8)
static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.85)
static let xpFloatDuration: Double = 1.2
static let confettiDuration: Double = 2.0
static let duelBarDuration: Double = 0.7
```

## War Chest formula

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

/// War Chest state from percentage remaining
static func warChestState(percentage: Double) -> WarChestState {
    switch percentage {
    case 0.8...:     return .healthy   // > 80% — Victory Green
    case 0.4..<0.8:  return .cautious  // 40-80% — Streak Amber
    case 0.0..<0.4:  return .critical  // < 40% — Rival Red
    default:         return .broken    // Negative — Deep Red
    }
}
```

## XP rules quick reference

| Action | XP | Constant name |
|--------|----|---------------|
| Log a transaction | +5 | `XP.logTransaction` |
| Full day under budget | +25 | `XP.underBudget` |
| Complete quest milestone | +75 | `XP.questMilestone` |
| Complete saving quest | +500 | `XP.questComplete` |
| Win weekly duel (3+ rounds) | +200 | `XP.duelWin` |
| Draw weekly duel (2-2) | +50 | `XP.duelDraw` |
| Lose weekly duel (0-1 rounds) | +10 | `XP.duelLoss` |
| Logging streak/day | +10 | `XP.loggingStreak` |
| Budget streak/day | +30 | `XP.budgetStreak` |

## Level formula

```swift
/// XP required for a specific level: 100 × level
/// Cumulative XP for level N = sum(100 × i for i in 1...N)
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
    1: "Rookie Saver", 5: "Budget Warrior", 10: "Money Master",
    15: "Financial Knight", 20: "Wealth Guardian", 25: "Legend"
]
```

## Weekly duel logic

```swift
/// Compare current week vs last week's snapshot across 4 rounds.
/// Returns (roundsWon: Int, roundsLost: Int) — win 3+ = duel win.
///
/// Round 1: War Chest Discipline — days under budget (higher wins)
/// Round 2: Saving Power — total saved: budget - spent (higher wins)
/// Round 3: Logging Consistency — days with transactions logged (higher wins)
/// Round 4: Category Control — worst category % over budget improved (lower wins)
///
/// Momentum = ((thisWeekSaved - lastWeekSaved) / abs(lastWeekSaved)) × 100
/// Clamped to -99%...999%.
/// Named states: Surging (>+30%), Climbing (+10..+30%), Holding (-10..+10%),
///               Slipping (-30..-10%), Freefalling (<-30%)
///
/// First week (no snapshot): show "This week sets your baseline"
```

## Data model quick reference

```
Transaction (@Model): id, amount: Double (always positive), note: String? (100 max),
  date: Date, category: Category?, createdAt, updatedAt

Category (@Model): id, name: String (30 max), icon: String (SF Symbol),
  colorHex: String, budgetAmount: Double?, sortOrder: Int, isCustom: Bool,
  isArchived: Bool, transactions: [Transaction] (inverse), createdAt

SavingQuest (@Model): id, name: String (60 max), targetAmount: Double,
  savedAmount: Double, status: QuestStatus, deadline: Date?, activatedAt?,
  completedAt?, completionDays?: Int, xpEarned: Int,
  milestones: [QuestMilestone] (relationship), createdAt, updatedAt

QuestMilestone (@Model): id, title: String (100 max), targetAmount: Double,
  isCompleted: Bool, completedAt?, sortOrder: Int, quest: SavingQuest? (parent)

PlayerProfile (@Model singleton): totalXP, currentLevel, monthlyBudget: Double,
  logStreakCount, logStreakLastDate?, logStreakBest,
  budgetStreakCount, budgetStreakLastDate?, budgetStreakBest,
  streakFreezesAvailable, streakFreezeLastUsed?,
  unlockedBadges: [String], questsCompletedCount,
  duelsWonCount, duelsPlayedCount, totalTransactions,
  duelWinStreak, duelWinStreakBest,
  currencyCode: String ("IDR"/"USD"), hasCompletedOnboarding, createdAt

WeeklySnapshot (@Model): id, weekStartDate, totalSpent, totalSaved,
  daysUnderBudget, daysLogged, worstCategoryName?, worstCategoryPct,
  questDeposits, duelResult?: DuelResult, roundsWon, roundsLost,
  momentumPct, createdAt

CurrentWeekTracker (@Model singleton): id, weekStartDate, totalSpent,
  totalSaved, daysUnderBudget, daysLogged,
  categorySpending: [String: Double], questDeposits, transactionCount

DailyLog (@Model): id, date, totalSpent, dailyBudget, isUnderBudget,
  transactionCount

Enums: QuestStatus (.active/.completed/.abandoned),
  DuelResult (.win/.loss/.draw), DuelRound (4 cases),
  MomentumState (5 cases), BadgeType (12 cases), WarChestState (4 cases)
```

## Default categories

```swift
static let defaults: [(name: String, icon: String, color: String)] = [
    ("Food & Drink",    "fork.knife",            "FF9500"),
    ("Transport",       "car.fill",               "007AFF"),
    ("Shopping",        "bag.fill",               "FF2D55"),
    ("Entertainment",   "gamecontroller.fill",     "AF52DE"),
    ("Bills",           "bolt.fill",               "FFCC00"),
    ("Health",          "heart.fill",              "FF3B30"),
    ("Education",       "book.fill",               "34C759"),
    ("Other",           "ellipsis.circle.fill",    "8E8E93"),
]
```

## Badge unlock conditions

| Badge ID | Name | Condition | Color |
|----------|------|-----------|-------|
| `firstSave` | First Blood | First deposit to a saving quest | Victory Green |
| `logger7` | Week Warrior | 7-day logging streak | Amber |
| `logger30` | Log Legend | 30-day logging streak | Amber |
| `budget7` | Shield Bearer | 7-day budget streak | Blue |
| `budget30` | Iron Wall | 30-day budget streak | Blue |
| `duelWin` | Self Surpassed | First weekly duel win | Red |
| `duelStreak3` | Unstoppable | 3 consecutive duel wins | Red |
| `questDone` | Quest Conqueror | First saving quest completed | Victory Green |
| `quest5` | Five Star General | 5 saving quests completed | Gold |
| `underSpend50` | Half Spender | Spend < 50% monthly budget | Victory Green |
| `noImpulse` | Zen Master | 7 days no spending in worst category | Purple |
| `momentum3` | Rising Star | Climbing/Surging momentum 3 consecutive weeks | Blue |

## Dual streak system

```swift
/// Logging Streak: consecutive days with ≥1 transaction logged.
///   - Streak freeze: 1 per week (skip a day without breaking)
///   - XP: +10 per day
///
/// Budget Streak: consecutive days spending under daily budget (War Chest).
///   - NO streak freeze (this is the challenge)
///   - XP: +30 per day (3x logging — discipline > awareness)
///
/// Budget streak gives 3x XP because discipline > awareness.
```

## Typography

Plus Jakarta Sans is the primary font. Load via custom font bundle registered in Info.plist.

```swift
// Usage pattern
.font(.custom("PlusJakartaSans-ExtraBold", size: 28))  // Display (War Chest amount)
.font(.custom("PlusJakartaSans-Bold", size: 18))        // Headline
.font(.custom("PlusJakartaSans-Bold", size: 14))        // Title
.font(.custom("PlusJakartaSans-Regular", size: 13))     // Body
.font(.custom("PlusJakartaSans-Bold", size: 10))        // Label (use .textCase(.uppercase) + .tracking(1))
```

## Tab bar behavior

| Tab | SF Symbol | Active tint | Notes |
|-----|-----------|-------------|-------|
| Dashboard | `chart.bar.fill` | Hero Blue | Default landing tab |
| Log | `list.bullet.rectangle.fill` | Hero Blue | — |
| Duel | `figure.fencing` | **Rival Red** | Red tint = enemy territory |
| Quest | `flag.fill` | Hero Blue | — |
| Profile | `trophy.fill` | Hero Blue | — |

## Monetization (V1 Strategy)

**V1: Everything free.** No paywalls, no premium tier, no restrictions. All features fully unlocked to build trust, users, reviews, and feedback.

**V2+: Introduce WalletWars Plus** — only NEW features become premium. Nothing from v1 gets locked retroactively. Pricing: $1.99/month, $14.99/year, $29.99 lifetime.

> Golden rule: Everything available in v1 stays free forever.

## Code style

- Modern concurrency: `async/await`, `@MainActor`, `Sendable`.
- Prefer `guard` for early returns. Max 3 levels of nesting.
- File names match primary type: `DashboardView.swift`, `Transaction.swift`.
- Group with `// MARK: -` comments. Max 400 lines per file.
- Use `Logger` (from `os`) for debug logging, never `print()`.
- All user-facing strings use `LocalizedStringKey` for future localization.
- XP constants defined in a single `XP` enum for consistency.

## Git workflow

- Conventional commits: `feat:`, `fix:`, `refactor:`, `style:`, `docs:`, `test:`.
- One feature per commit. Atomic and reviewable.
- NEVER modify `.pbxproj` directly — create files, add to Xcode manually.
- Branch naming: `sprint-N/feature-name` (e.g., `sprint-1/data-models`).

## Testing

- Swift Testing (`@Test`, `#expect`) for unit tests, XCTest for UI tests.
- Test ViewModels thoroughly — they hold all business logic.
- In-memory `ModelContainer` for SwiftData tests.
- Priority test coverage: War Chest formula, XP awarding, level calculation, streak reset logic (both streaks + freeze), duel round comparison, momentum calculation, badge unlock conditions, one-active-quest enforcement, category budget tracking.

## Development roadmap (quick ref)

Full sprint breakdown in PRD Section 12. Summary:

| Sprint | Focus | Est. days |
|--------|-------|-----------|
| 0 | Foundation: structure, models, tokens, fonts, TabView | 1 |
| 1 | Data models: Transaction, Budget, Quest, Player + CRUD + tests | 2 |
| 2 | Quick Capture: transaction entry + category picker | 2 |
| 3 | Dashboard: War Chest + daily overview + insights card | 2-3 |
| 4 | Transaction Log: history list + filters + edit/delete | 2 |
| 5 | Gamification: XP, levels, streaks, badges services + tests | 2-3 |
| 6 | Weekly Duel: snapshot, comparison, DuelView, momentum | 3 |
| 7 | Saving Quests: quest CRUD, milestones, progress ring | 2-3 |
| 8 | Profile: level display, badge grid, streak display, stats | 2 |
| 9 | Insights engine: smart suggestions, trend detection | 2 |
| 10 | Onboarding: 3-page flow + budget setup | 1-2 |
| 11 | Polish: empty states, dark mode, accessibility, performance | 2-3 |
| 12 | Monetization: Plus features, paywall, restore purchases (V2 only) | — |

**V1 Total: 22-28 days**

## Reference docs

- Full requirements + roadmap: `docs/WalletWars_PRD_v1.md`
- Data model specification: `docs/WalletWars_DataModel.md`
- User flows + wireframes: `docs/WalletWars_UserFlows.md`
- Visual mockups (V1): `docs/Mockups/WalletWars_Prototype.html`
- Visual mockups (V2 War Base): `docs/Mockups/WalletWars_V2_Prototype.html`
- Design system: `docs/Mockups/liquid_warfare/DESIGN.md`

## Gotchas — add new ones as discovered

- `#Preview` with SwiftData requires wrapping in a container; use the preview helper.
- `@Query` does NOT work inside `@Observable` classes — only in SwiftUI Views.
- Enums with `Codable` must have `String` raw values for SwiftData JSON storage.
- `matchedGeometryEffect` requires source and destination in the view hierarchy simultaneously.
- iOS 26 `glassEffect` only renders in simulator on Xcode 26+ — invisible in canvas previews.
- Plus Jakarta Sans must be registered in Info.plist under "Fonts provided by application" — each weight as separate .ttf entry.
- `PlayerProfile` and `CurrentWeekTracker` singletons: always use fetch-or-create pattern, never assume they exist.
- Weekly snapshot must be created via BGTaskScheduler or on app launch (check if Monday has passed since last snapshot).
- Max 1 active saving quest enforced in ViewModel (free tier) — always check `SavingQuest.status == .active` count before allowing activation.
- `Transaction.amount` is always positive — display sign contextually ("-$24.50" for expenses).
- `DailyLog` date must be stripped of time component — use `Calendar.current.startOfDay(for:)`.
- War Chest formula divides remaining budget by remaining days — handle division by zero on last day of month.
- Category budget is optional — if user doesn't set per-category budgets, all spending comes from the shared pool.
- Streak freeze: only 1 per week for logging streak, earned automatically at week start. Budget streak has NO freeze.
- `categorySpending` in `CurrentWeekTracker` uses category UUID string as key — ensure consistency.
- Momentum calculation: use `abs(lastWeekSaved)` in denominator to handle negative saved values correctly.
- When a fix feels hacky, step back: "Knowing everything I know now, implement the elegant solution."
