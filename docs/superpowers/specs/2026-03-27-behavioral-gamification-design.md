# V1.0 Behavioral Gamification — Design Spec

> Penalties, prevention, and redemption mechanics to complement the existing reward system.

---

## 1. Overspend Warning in QuickCapture (Prevention)

**Goal:** Add friction before overspending — escalating based on repeat behavior.

**Trigger:** User taps Save and the transaction would push `DailyLog.totalSpent + amount > DailyLog.dailyBudget`.

**Behavior:**
- **First overspend of the day** (`DailyLog.isUnderBudget == true` before this transaction):
  - Amber warning banner slides in below the amount display
  - Text: "This will break your shield for today."
  - Icon: `exclamationmark.shield.fill` in Streak Amber
  - User can still tap Save immediately — banner is informational only

- **Second+ overspend** (`DailyLog.isUnderBudget == false` already):
  - Confirmation dialog appears on Save tap
  - Title: "Over Budget"
  - Message: "You're already $X over budget today. Spend anyway?"
  - Actions: "Cancel" (default) + "Spend Anyway" (destructive, red)
  - Only proceeds to save if user confirms

**Detection:** Check in `QuickCaptureSheet.saveTransaction()` BEFORE calling `vm.saveTransaction()`. Read current DailyLog state to determine which warning level to show.

---

## 2. Sharper Insight Messages (Emotional Weight)

**Goal:** InsightService generates messages that create emotional stakes, not just information.

**New insight categories added to `InsightService.generateInsight()`:**

| Condition | Message |
|---|---|
| DailyLog.isUnderBudget == false | "You spent ${overAmount} more than your daily shield allows. That's tomorrow's budget eaten today." |
| Monthly spend > 80% of budget | "You've burned through {pct}% of your monthly budget with {days} days left. The walls are closing in." |
| Budget streak just broke (was > 0, now 0) | "Your {count}-day budget streak just shattered. Building it back starts tomorrow." |
| Category spend > 90% of category budget | "{category} is at {pct}% of budget. One more transaction and it's over." |
| Active shame marks > 0 | "You have {count} active penalty mark(s). Good behavior clears them." |

**Priority:** Overspend/warning insights take priority over positive insights. If the user is over budget, they should NOT see a cheerful message.

**Tone:** Concerned commander, not judgmental parent. Military theme. Factual but emotionally weighted.

---

## 3. Budget Streak Break Overlay (Consequence)

**Goal:** Make streak breaks painful and visible — not a silent reset.

**Trigger:** When `QuickCaptureViewModel.saveTransaction()` detects that the save caused `DailyLog.isUnderBudget` to flip from `true` to `false`.

**Display:** After the +5 XP success overlay (1s), show a second overlay:
- Background: Rival Red gradient with `ultraThinMaterial`
- Icon: `shield.slash.fill` (SF Symbol) in Rival Red, 48pt
- Text: "Shield Streak Lost" in Bold
- Subtitle: "{count} day streak broken" showing what they lost
- Auto-dismiss after 1.5s

**Implementation:** Track `wasUnderBudget` before save, compare after. If flipped, show streak break overlay after success overlay completes.

---

## 4. Overspend Stats in Profile (Public Record)

**Goal:** Track and display negative stats alongside positive ones.

**New fields on `PlayerProfile`:**
- `daysOverBudgetCount: Int` — lifetime total of days where daily spending exceeded daily budget
- `worstDailyOverspend: Double` — single largest daily overspend amount (dailyLog.totalSpent - dailyLog.dailyBudget)

**Updated when:** During dashboard load, check yesterday's DailyLog. If `isUnderBudget == false`, increment `daysOverBudgetCount` and update `worstDailyOverspend` if applicable.

**Display in ProfileView LifetimeStatsCard:**
- Add "Days Over Budget" row with Rival Red text
- Add "Worst Overspend" row with Rival Red text
- These appear after the positive stats

---

## 5. Shame Marks (Penalty Badges with Redemption)

**Goal:** Temporary penalty marks earned through bad behavior, cleared through good behavior. Creates a recovery quest loop.

### Shame Mark Definitions

| ID | Name | Icon | Earned When | Cleared By | Clear XP |
|---|---|---|---|---|---|
| `shieldShattered` | Shield Shattered | `shield.slash.fill` | Over budget 3 consecutive days | 5 consecutive days under budget | +50 |
| `budgetBreaker` | Budget Breaker | `exclamationmark.triangle.fill` | Monthly spend > 100% of budget | 7 consecutive days under budget | +75 |
| `impulseSpender` | Impulse Spender | `flame.fill` | 3+ transactions in worst category in one day | 3 days with 0 transactions in that category | +50 |
| `streakDestroyer` | Streak Destroyer | `bolt.slash.fill` | Break a budget streak of 7+ days | Rebuild a 7-day budget streak | +50 |

### Data Model

New `@Model` class `ShameMark`:
```
ShameMark (@Model):
  id: UUID
  markType: String (raw value of ShameMarkType enum)
  earnedAt: Date
  clearedAt: Date?
  isActive: Bool
  progress: Int (current progress toward clearing)
  targetProgress: Int (required to clear)
  metadata: String? (e.g., category name for impulseSpender)
```

New enum `ShameMarkType` in Enums.swift with the 4 types above.

### Service: ShameMarkService

Static methods:
- `checkAndApply(profile:dailyLog:context:)` — called after each transaction save, checks conditions and creates active shame marks
- `updateProgress(profile:context:)` — called on dashboard load, checks clearing conditions and updates progress
- `clearMark(_:profile:context:)` — marks as cleared, awards XP, removes from active

### Display in ProfileView

New section between badges and lifetime stats:
- Header: "ACTIVE PENALTIES" (Rival Red label)
- Each active mark shows:
  - Icon + Name in Rival Red
  - Progress bar toward clearing (e.g., "3/5 days under budget")
  - "Earned {date}" subtitle
- When no active marks: section hidden
- When mark is cleared: brief "Mark Cleared!" toast + XP award

---

## Files to Create/Modify

| File | Action | Purpose |
|---|---|---|
| `Models/ShameMark.swift` | Create | New @Model for shame marks |
| `Models/Enums.swift` | Modify | Add ShameMarkType enum |
| `Models/PlayerProfile.swift` | Modify | Add daysOverBudgetCount, worstDailyOverspend |
| `Services/ShameMarkService.swift` | Create | Shame mark check/apply/clear logic |
| `Services/InsightService.swift` | Modify | Add overspend-aware insight messages |
| `Views/Capture/QuickCaptureSheet.swift` | Modify | Add escalating overspend warnings |
| `Views/Components/StreakBreakOverlay.swift` | Create | Streak break visual feedback |
| `Views/Profile/ProfileView.swift` | Modify | Add penalties section + overspend stats |
| `Views/Profile/ShameMarkCard.swift` | Create | Individual shame mark display with progress |
| `ViewModels/QuickCaptureViewModel.swift` | Modify | Budget check before save, streak break detection |
| `ViewModels/DashboardViewModel.swift` | Modify | Update overspend stats on load, check shame marks |
| `docs/WalletWars_PRD_v1.md` | Modify | Add behavioral gamification section |
| `tasks/todo.md` | Modify | Add behavioral gamification sprint items |

---

## Verification

1. **Prevention:** Log transaction that exceeds daily budget → first time: amber banner. Second time: confirmation dialog.
2. **Insight:** When over budget, Strategic Edge shows pointed overspend message (not cheerful).
3. **Streak break:** Log transaction that breaks budget streak → see red "Shield Streak Lost" overlay after success.
4. **Profile stats:** Days Over Budget and Worst Overspend appear in Profile stats.
5. **Shame marks:** Go over budget 3 days in a row → "Shield Shattered" mark appears in Profile. Stay under budget 5 days → mark clears with XP.
6. **Redemption:** Clear a shame mark → see "Mark Cleared!" toast + XP float.
