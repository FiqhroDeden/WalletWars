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

## Sprint 2: Quick Capture UI — IN PROGRESS

- [ ] QuickCaptureSheet (amount input, category grid, note field, save button)
- [ ] AmountInput component (numeric display, auto-focused keyboard)
- [ ] CategoryGrid component (2x4 grid, SF Symbols, selection state)
- [ ] FAB "+" button on DashboardView
- [ ] Success state (XP float animation, War Chest update, auto-dismiss)
- [ ] Wire to QuickCaptureViewModel
- [ ] Sheet presentation (.presentationDetents([.large]))

## Sprint 3: Dashboard UI

- [ ] WarChestCard (amount display, progress bar, state colors)
- [ ] TodayTransactionsList (grouped by time, category icons)
- [ ] StreakBanner (log streak + budget streak display)
- [ ] InsightCard (smart suggestion placeholder)
- [ ] DashboardView layout (ScrollView with cards)
- [ ] Wire to DashboardViewModel

## Sprint 4: Transaction Log UI

- [ ] TransactionLogView (grouped by date, month summary)
- [ ] TransactionRow (category icon, amount, note, time)
- [ ] FilterSheet (date range, category, sort order)
- [ ] Edit transaction flow
- [ ] Delete transaction (swipe action)
- [ ] CategoryBudgetView (per-category spending)
- [ ] Wire to TransactionLogViewModel

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
