# WalletWars — Task Tracker

## Sprint 0: Foundation — COMPLETE

- [x] Enums + XP constants
- [x] SwiftData models (8 models)
- [x] FormulaService (War Chest, level, momentum)
- [x] Unit tests (26 tests)
- [x] Design tokens (Color+Brand, Animation+Spring)
- [x] Plus Jakarta Sans font bundle
- [x] CategorySeedService
- [x] 5-tab TabView shell + ModelContainer wiring

## Sprint 1: Data Models CRUD + Tests — COMPLETE

- [x] Test infrastructure (TestHelpers, DailyLog.fetchOrCreate)
- [x] WarChestService + tests
- [x] QuickCaptureViewModel + transaction CRUD tests
- [x] DashboardViewModel + DailyLog/Tracker tests
- [x] TransactionLogViewModel (edit/delete with reversal)
- [x] QuestViewModel + quest lifecycle tests
- [x] ProfileViewModel + SettingsViewModel + tests
- [x] Integration verification

## Sprint 2: Quick Capture UI — COMPLETE

- [x] QuickCaptureSheet (amount input, category grid, note field, save button)
- [x] AmountInput component (numeric display, blinking cursor, transition animation)
- [x] CategoryGrid component (2x4 grid, SF Symbols, checkmark selection)
- [x] CaptureKeypad (custom 4x3 numeric keypad, haptic feedback)
- [x] FAB "+" button on DashboardView
- [x] Success state (+5 XP overlay, checkmark bounce, auto-dismiss)
- [x] Wire to QuickCaptureViewModel
- [x] Sheet presentation (.presentationDetents([.large]))

## Sprint 3: Dashboard UI — COMPLETE

- [x] WarChestCard (amount display, progress bar, state colors, glass material)
- [x] TodayTransactionsList (tactical log, transaction rows, empty state)
- [x] StreakBanner (log streak flame + budget streak shield pills)
- [x] InsightCard (Strategic Edge with sparkles icon)
- [x] DashboardView layout (ScrollView with LazyVStack, all cards)
- [x] Wire to DashboardViewModel (.task {} loading, auto-refresh on sheet dismiss)

## Sprint 4: Transaction Log UI — COMPLETE

- [x] TransactionLogView (date-grouped sections with headers)
- [x] LogTransactionRow (category icon, amount in red, note, time)
- [x] MonthSummaryCard (spent/budget progress bar, percentage)
- [x] FilterSheet (period chips, category chips, flow layout, Reset/Apply)
- [x] Delete transaction (swipe-to-delete action)
- [x] Wire to TransactionLogViewModel (.task {} loading, filter apply)
- [x] Edit transaction flow (tap row → EditTransactionSheet)
- [x] CategoryBudgetView (per-category spending bars in Log tab)

## Sprint 5: Gamification Services — COMPLETE

- [x] XPService (award XP, level recalculation, level-up detection)
- [x] StreakService (logging streak with freeze, budget streak without freeze)
- [x] BadgeService (9 profile-checkable badges, contextual unlock method)
- [x] Integrate into QuickCapture flow (XP + streaks + badges on transaction save)
- [x] Integrate into Quest flow (milestone XP + quest complete XP + badges)
- [x] Unit tests: XPServiceTests (4), StreakServiceTests (8), BadgeServiceTests (10)
- [x] XPFloatView animation component (float up + fade out)
- [x] LevelUpOverlay celebration (full-screen with auto-dismiss)

## Sprint 6: Weekly Duel — COMPLETE

- [x] DuelService (4-round comparison, result determination, round details)
- [x] DuelViewModel (load duel data, projections, momentum calculation)
- [x] DuelView (3 states: first week, mid-week battle, results)
- [x] VSCard (YOU vs PAST YOU with blue/red shields)
- [x] RoundCard (comparison bars with winner indicators)
- [x] DuelResultBanner (WIN/LOSS/DRAW with XP reward + momentum)
- [x] DuelHistoryList (horizontal scroll of past duel chips)
- [x] WeeklySnapshotService (auto-create snapshot at week boundary on app launch)
- [x] Duel XP/stats awarding on snapshot creation

## Sprint 7: Saving Quests — COMPLETE

- [x] QuestView (3 states: active quest, empty, hall of fame)
- [x] QuestProgressRing (circular progress with percentage center)
- [x] MilestoneList (checkmarks, dashed pending, completion dates)
- [x] QuestDepositSheet (amount input, deposit to quest)
- [x] NewQuestSheet (name, target, deadline toggle, date picker)
- [x] Hall of Fame section (completed quests with trophy icons)
- [x] Wire to QuestViewModel (create, deposit, abandon, load)

## Sprint 8: Profile — COMPLETE

- [x] ProfileView layout (ScrollView with all sections)
- [x] LevelCard (XP bar, level title, progress percentage)
- [x] StreakCards (log flame + budget shield, current + best)
- [x] DuelRecordCard (wins/losses with colors)
- [x] BadgeGrid (4-column grid, unlocked colorful, locked greyed with lock)
- [x] LifetimeStatsCard (transactions, quests, duels, win rate)
- [x] Wire to ProfileViewModel

## Sprint 9: Insights Engine — COMPLETE

- [x] InsightService (contextual insight generation from spending data)
- [x] Dynamic InsightCard (accepts text prop instead of hardcoded)
- [x] DashboardViewModel integration (generates insight on load)
- [x] Insight types: streak milestones, week-over-week comparison, budget tracking, level progress

## Sprint 10: Onboarding — COMPLETE

- [x] OnboardingView (3-page TabView with page indicators)
- [x] Page 1: "Your wallet has a rival" — VS shields hook
- [x] Page 2: "How WalletWars Works" — 4 feature cards (LOG, DEFEND, DUEL, LEVEL UP)
- [x] Page 3: Budget setup — amount input + "Start Fighting" CTA
- [x] OnboardingViewModel (budget input, complete onboarding flag)
- [x] ContentView conditional: fullScreenCover on first launch if !hasCompletedOnboarding

## Sprint 11: Polish — COMPLETE

- [x] SettingsView UI (budget edit, currency display, category list with add/archive)
- [x] AddCategorySheet (name, icon picker, color picker)
- [x] NotificationService (daily reminder, streak warning, cancel all)
- [x] Dashboard gear icon → Settings navigation
- [x] App icon generated (Light/Dark/Tinted via Swift script)
- [x] Dark mode verification
- [x] Accessibility polish

---

**V1 Feature-Complete: Sprints 0-11 — All done as of 2026-03-27**

## V1.0 Improvements (pre-release polish)

- [x] ToastView reusable component
- [x] War Chest card shows monthly budget source subtitle
- [x] Settings: explicit Save button + success toast for budget changes
- [x] Settings: replace dev build info with App Store review prompt
- [x] Auto-prompt review at Level 3+ (one-time via @AppStorage)
- [x] Log: green highlight animation on edited transaction row
- [x] Log: delete confirmation alert + success toast

## V1.0 Behavioral Gamification (penalties + prevention)

- [ ] ShameMark model + ShameMarkType enum
- [ ] PlayerProfile: add daysOverBudgetCount, worstDailyOverspend fields
- [ ] ShameMarkService (check/apply/clear logic + XP reward on clear)
- [ ] Overspend warning in QuickCapture (escalating: banner → confirmation)
- [ ] Budget streak break overlay (red "Shield Streak Lost" after save)
- [ ] Sharper overspend-aware insight messages in InsightService
- [ ] Overspend stats in Profile (days over budget, worst overspend)
- [ ] Shame marks display in Profile (Active Penalties section + progress bars)
- [ ] Shame mark cleared toast + XP award
- [ ] Update PRD with behavioral gamification sections
- [ ] Tests: ShameMarkService conditions + clearing logic

---

**V2+: Monetization (WalletWars Plus) — post-launch**
