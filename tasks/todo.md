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
- [ ] Edit transaction flow (deferred to polish sprint)
- [ ] CategoryBudgetView (deferred to polish sprint)

## Sprint 5: Gamification Services

- [ ] XPService (award XP for all actions)
- [ ] StreakService (logging + budget streak logic, freeze)
- [ ] BadgeService (12 badge unlock conditions)
- [ ] XPFloatView animation component
- [ ] Level-up detection + celebration
- [ ] Integrate into QuickCapture + Quest flows
- [ ] Unit tests for all services

## Sprint 6: Weekly Duel

- [ ] DuelService (snapshot creation, 4-round comparison)
- [ ] WeeklySnapshot creation at week boundary
- [ ] DuelView (VS card, round cards, momentum badge)
- [ ] DuelResultOverlay (win/loss/draw celebration)
- [ ] LiveStandingsView (current week vs last week)
- [ ] DuelHistoryList (past duel results)
- [ ] MomentumBadge component
- [ ] BGTaskScheduler for Monday snapshot
- [ ] Wire to DuelViewModel

## Sprint 7: Saving Quests

- [ ] QuestView (active quest display, progress ring)
- [ ] QuestProgressRing component
- [ ] MilestoneList (milestone checkmarks, progress)
- [ ] QuestDepositSheet (deposit amount entry)
- [ ] NewQuestSheet (name, target, deadline, milestones)
- [ ] CompletedQuestCard (Hall of Fame)
- [ ] Wire to QuestViewModel

## Sprint 8: Profile

- [ ] ProfileView layout
- [ ] LevelCard (XP bar, level title, progress to next)
- [ ] StreakCards (log + budget streak display)
- [ ] DuelRecordCard (W/L/D record, win streak)
- [ ] BadgeGrid (unlocked + locked badges)
- [ ] LifetimeStatsCard (total transactions, saved, etc.)
- [ ] Wire to ProfileViewModel

## Sprint 9: Insights Engine

- [ ] InsightService (smart suggestions, trend detection)
- [ ] Category alerts (overspending detection)
- [ ] Spending trend analysis (week-over-week)
- [ ] InsightCard variants (tip, alert, celebration)
- [ ] Integration with Dashboard

## Sprint 10: Onboarding

- [ ] OnboardingView (3-page flow)
- [ ] Page 1: Welcome + value prop
- [ ] Page 2: Budget setup (monthly budget input)
- [ ] Page 3: Category selection
- [ ] Wire to OnboardingViewModel
- [ ] Conditional show on first launch (hasCompletedOnboarding)

## Sprint 11: Polish

- [ ] Empty states (no transactions, no quests, first week)
- [ ] Dark mode support
- [ ] Accessibility (VoiceOver, Dynamic Type)
- [ ] Performance optimization (lazy loading, query optimization)
- [ ] App icon finalization
- [ ] NotificationService (daily reminder, streak warning, duel results)
- [ ] Settings UI (budget, currency, categories, notifications)

---

**V1 Total: Sprints 0-11 | Target: 22-28 days**
**V2+: Monetization (WalletWars Plus) — post-launch**
