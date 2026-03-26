# WalletWars — User Flows & Wireframes

## Tab Structure

```
┌─────────────────────────────────────────────────┐
│                                                 │
│              [Active Screen Area]               │
│                                                 │
├────────┬────────┬────────┬────────┬────────────┤
│  📊    │  📝    │  ⚔️    │  🏴    │  🏆       │
│ Dash   │  Log   │  Duel  │ Quest  │ Profile    │
└────────┴────────┴────────┴────────┴────────────┘

Tab 1: Dashboard  → chart.bar.fill      → Hero Blue
Tab 2: Log        → list.bullet.rectangle.fill → Hero Blue
Tab 3: Duel       → figure.fencing      → Rival Red
Tab 4: Quest      → flag.fill           → Hero Blue
Tab 5: Profile    → trophy.fill         → Hero Blue
```

---

## Screen 1: Dashboard

### Layout

```
┌─────────────────────────────────────────┐
│ WalletWars                    [⚙️]     │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │         WAR CHEST                   │ │
│ │                                     │ │
│ │        $125.00                      │ │
│ │    ═══════════════════              │ │
│ │    Remaining budget today           │ │
│ │                                     │ │
│ │  🟢 Healthy                         │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─── Today ───────────────────────────┐ │
│ │ 🍔 Lunch        $12.00    10:30     │ │
│ │ 🚗 Ride         $8.00     08:15     │ │
│ │                                     │ │
│ │ Total: $20.00                       │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─── Streaks ─────────────────────────┐ │
│ │ 🔥 Log: 12 days    🛡️ Budget: 5    │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─── Insight ─────────────────────────┐ │
│ │ 💡 "Transport spending dropped 20%  │ │
│ │     from last week. Nice!"          │ │
│ └─────────────────────────────────────┘ │
│                                         │
│              [ + ]                      │
│         (FAB: Add Transaction)          │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

### War Chest Card States

```
HEALTHY (> 80% remaining)
┌─────────────────────────┐
│     $125.00              │  ← Victory Green, large font
│  ━━━━━━━━━━━━━━━━━━━    │  ← Full green bar
│  Remaining budget today  │
│  🟢 Healthy             │
└─────────────────────────┘

CAUTIOUS (40-80% remaining)
┌─────────────────────────┐
│     $65.00               │  ← Streak Amber
│  ━━━━━━━━━━━━           │  ← Partial amber bar
│  Remaining budget today  │
│  🟡 Watch it            │
└─────────────────────────┘

CRITICAL (< 40% remaining)
┌─────────────────────────┐
│     $18.00               │  ← Rival Red, pulsing
│  ━━━━                   │  ← Short red bar
│  Remaining budget today  │
│  🔴 Almost gone         │
└─────────────────────────┘

BROKEN (over budget)
┌─────────────────────────┐
│     -$12.00              │  ← Deep Red
│  ━━━━━━━━ OVER ━━━━━━   │  ← Cracked bar animation
│  Shield Broken!         │
│  🛡️💥 Over budget       │
└─────────────────────────┘
```

---

## Screen 2: Quick Capture (Modal Sheet)

### Flow: Tap FAB "+"

```
Step 1: Amount Entry
┌─────────────────────────────────────────┐
│                              [ Cancel ] │
│                                         │
│           $35.00                        │
│           ___________                   │
│                                         │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ 🍔  │ │ 🚗  │ │ 🛍️  │ │ 🎮  │      │
│  │Food │ │Trans│ │Shop │ │Fun  │      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ ⚡  │ │ ❤️  │ │ 📚  │ │ ••• │      │
│  │Bills│ │Hlth │ │ Edu │ │Other│      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│                                         │
│  Note (optional): ________________      │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │          💾 Save (+5 XP)        │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌───┬───┬───┐                          │
│  │ 1 │ 2 │ 3 │                          │
│  ├───┼───┼───┤   ← Numeric keypad      │
│  │ 4 │ 5 │ 6 │     (auto-focused)      │
│  ├───┼───┼───┤                          │
│  │ 7 │ 8 │ 9 │                          │
│  ├───┼───┼───┤                          │
│  │ . │ 0 │ ⌫ │                          │
│  └───┴───┴───┘                          │
└─────────────────────────────────────────┘

Step 2: After Save
┌─────────────────────────────────────────┐
│                                         │
│           ✅ Saved!                     │
│          +5 XP ↑                        │
│   (XP float animation rises up)        │
│                                         │
│   War Chest: $125.00 → $90.00          │
│                                         │
│   (Auto-dismiss after 1 second)         │
└─────────────────────────────────────────┘
```

### Interaction Details
- Keyboard appears automatically (amount first)
- Category: tap icon → selected state (checkmark overlay)
- Default category: "Other" if none selected
- Note field: optional, single line
- Save button shows +5 XP as motivation
- After save: XP float animation + sheet dismiss

---

## Screen 3: Transaction Log

### Layout

```
┌─────────────────────────────────────────┐
│ Transactions              [Filter 🔽]  │
│                                         │
│ ┌─── This Month ──────────────────────┐ │
│ │ Spent: $2,450 / $5,000             │ │
│ │ ━━━━━━━━━━━━━━━━━━                 │ │
│ │ 49% of budget                       │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ── Today, 26 Mar ──────────────────     │
│ ┌─────────────────────────────────────┐ │
│ │ 🍔 Lunch               -$12.00     │ │
│ │    Fried rice at office   10:30     │ │
│ ├─────────────────────────────────────┤ │
│ │ 🚗 Ride to Office      -$8.00      │ │
│ │                          08:15      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ── Yesterday, 25 Mar ──────────────     │
│ ┌─────────────────────────────────────┐ │
│ │ 🛍️ Online Shopping     -$50.00     │ │
│ │    Phone case             21:00     │ │
│ ├─────────────────────────────────────┤ │
│ │ 🍔 Dinner              -$28.00     │ │
│ │    Sushi restaurant       19:30     │ │
│ ├─────────────────────────────────────┤ │
│ │ 🍔 Lunch               -$10.00     │ │
│ │                          12:00      │ │
│ ├─────────────────────────────────────┤ │
│ │ 🚗 Ride                -$7.00      │ │
│ │                          08:00      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│              [ + ]                      │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

### Filter Options (Sheet)

```
┌─────────────────────────────────────────┐
│ Filter Transactions                     │
│                                         │
│ Period:                                 │
│ [Today] [This Week] [This Month] [All] │
│                                         │
│ Category:                               │
│ [All] [🍔] [🚗] [🛍️] [🎮] [⚡] [❤️] [📚]│
│                                         │
│ Sort:                                   │
│ [Newest First] [Oldest First]           │
│ [Highest Amount] [Lowest Amount]        │
│                                         │
│ [Apply Filter]                          │
└─────────────────────────────────────────┘
```

### Swipe Actions

```
← Swipe Left:  [🗑️ Delete]  (Red background)
→ Swipe Right: [✏️ Edit]    (Blue background)
```

---

## Screen 4: Category Budget View

### Accessed from: Dashboard → tap month progress bar

```
┌─────────────────────────────────────────┐
│ ← Budget Breakdown         March 2026  │
│                                         │
│ Total: $2,450 / $5,000 (49%)           │
│ ━━━━━━━━━━━━━━━━━━━━━━                 │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🍔 Food & Drink                    │ │
│ │ $850 / $1,500                      │ │
│ │ ━━━━━━━━━━━━━━ 57%         🟡      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🚗 Transport                        │ │
│ │ $400 / $800                        │ │
│ │ ━━━━━━━━━━ 50%             🟡      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🛍️ Shopping                        │ │
│ │ $650 / $500                        │ │
│ │ ━━━━━━━━━━━━━━━━━━━ 130%   🔴      │ │
│ │ ⚠️ Over budget by $150            │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🎮 Entertainment                    │ │
│ │ $200 / $400                        │ │
│ │ ━━━━━━━━━━ 50%             🟡      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ ⚡ Bills                            │ │
│ │ $350 / $800                        │ │
│ │ ━━━━━━━━ 44%               🟢      │ │
│ └─────────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

---

## Screen 5: Weekly Duel

### State: Duel Results (Monday Morning)

```
┌─────────────────────────────────────────┐
│              WEEKLY DUEL                │
│         Week of Mar 19-25              │
│                                         │
│    THIS WEEK        LAST WEEK           │
│   ┌────────┐       ┌────────┐           │
│   │  YOU   │  VS   │  PAST  │           │
│   │  NOW   │       │  YOU   │           │
│   │ 💙     │       │     ❤️ │           │
│   └────────┘       └────────┘           │
│                                         │
│ ─── ROUND 1: War Chest Discipline ───  │
│ ┌─────────────────────────────────────┐ │
│ │    5 days          3 days           │ │
│ │    ━━━━━━━━        ━━━━━            │ │
│ │         ✅ YOU WIN                   │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ─── ROUND 2: Saving Power ────────     │
│ ┌─────────────────────────────────────┐ │
│ │  $320              $280             │ │
│ │  ━━━━━━━━━━━    ━━━━━━━━━          │ │
│ │         ✅ YOU WIN                   │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ─── ROUND 3: Logging Consistency ──    │
│ ┌─────────────────────────────────────┐ │
│ │    6 days          7 days           │ │
│ │    ━━━━━━━━━       ━━━━━━━━━━       │ │
│ │                   ❌ PAST WINS      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ─── ROUND 4: Category Control ─────   │
│ ┌─────────────────────────────────────┐ │
│ │  Shopping: 85%   Shopping: 130%     │ │
│ │  ━━━━━━━━━       ━━━━━━━━━━━━━━     │ │
│ │         ✅ YOU WIN                   │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │  🏆 YOU WIN 3-1!                    │ │
│ │  +200 XP                            │ │
│ │                                     │ │
│ │  Momentum: Climbing ↗️ +18%         │ │
│ │  Duel Win Streak: 3 🔥              │ │
│ └─────────────────────────────────────┘ │
│                                         │
│         [🔗 Share Result]              │
│                                         │
│ ─── Duel History ──────────────────    │
│ │ W12: Win 3-1  │ W11: Draw 2-2 │    │
│ │ W10: Win 4-0  │ W9: Loss 1-3  │    │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

### State: Mid-Week (Battle In Progress)

```
┌─────────────────────────────────────────┐
│              WEEKLY DUEL                │
│         Week of Mar 26 - Apr 1         │
│         Day 4 of 7                      │
│                                         │
│    THIS WEEK        LAST WEEK           │
│   ┌────────┐       ┌────────┐           │
│   │  YOU   │  VS   │  PAST  │           │
│   │  NOW   │       │  YOU   │           │
│   └────────┘       └────────┘           │
│                                         │
│ ─── LIVE STANDINGS ────────────────    │
│                                         │
│ 🛡️ War Chest:     4/4 vs 3/7          │
│   ━━━━━━━━━━ YOU'RE AHEAD              │
│                                         │
│ 💰 Saving Power:  $180 vs $280         │
│   ━━━━━━━━━━ BEHIND (but 3 days left)  │
│                                         │
│ 📝 Logging:       4/4 vs 6/7           │
│   ━━━━━━━━━━ ON TRACK                  │
│                                         │
│ 📊 Category:      Shopping 45% vs 130% │
│   ━━━━━━━━━━ WAY AHEAD                 │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Projection: WIN 3-1                 │ │
│ │ "Keep going, warrior!"             │ │
│ └─────────────────────────────────────┘ │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

### State: First Week (No Opponent Yet)

```
┌─────────────────────────────────────────┐
│              WEEKLY DUEL                │
│                                         │
│   ┌────────┐       ┌────────┐           │
│   │  YOU   │  VS   │  ???   │           │
│   │  NOW   │       │       │           │
│   └────────┘       └────────┘           │
│                                         │
│   "This week sets your baseline.        │
│    Your rival appears next Monday."     │
│                                         │
│   ┌─────────────────────────────────┐   │
│   │ 📊 Building your first record: │   │
│   │                                 │   │
│   │ Days logged: 3 / 7              │   │
│   │ Days under budget: 2 / 3        │   │
│   │ Total saved: $85.00             │   │
│   │                                 │   │
│   │ "Make this week count —         │   │
│   │  future you has to beat it!"    │   │
│   └─────────────────────────────────┘   │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

---

## Screen 6: Saving Quest

### State: Active Quest

```
┌─────────────────────────────────────────┐
│ Saving Quest                            │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │                                     │ │
│ │        🏴 Japan Trip                │ │
│ │                                     │ │
│ │         ┌──────────┐                │ │
│ │         │          │                │ │
│ │         │  42%     │  ← Progress    │ │
│ │         │    🔵    │    Ring        │ │
│ │         │          │                │ │
│ │         └──────────┘                │ │
│ │                                     │ │
│ │   $2,100 / $5,000                   │ │
│ │                                     │ │
│ │   Deadline: Dec 2026               │ │
│ │   Day 45 of 270 remaining          │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │   💰 Deposit to Quest           │    │
│  └─────────────────────────────────┘    │
│                                         │
│ ─── Milestones ────────────────────     │
│                                         │
│ ✅ First Steps            $1,000        │
│    Completed Mar 10                     │
│                                         │
│ 🔲 Halfway There         $2,500        │
│    $400 to go                           │
│    ━━━━━━━━━━━━━━━━━━                  │
│                                         │
│ 🔲 Almost There          $4,000        │
│    Locked                               │
│                                         │
│ 🔲 Quest Complete!       $5,000        │
│    Locked                               │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

### State: No Active Quest

```
┌─────────────────────────────────────────┐
│ Saving Quest                            │
│                                         │
│                                         │
│          🏴                             │
│                                         │
│    "No active quest."                   │
│    "What are you saving for?"           │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │   🏴 Start a Quest              │    │
│  └─────────────────────────────────┘    │
│                                         │
│                                         │
│ ─── Completed Quests ──────────────     │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🏆 New Laptop Fund                  │ │
│ │ $2,500 • Completed in 62 days      │ │
│ │ Feb 2026                            │ │
│ └─────────────────────────────────────┘ │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

### Quest Deposit Sheet

```
┌─────────────────────────────────────────┐
│ Deposit to "Japan Trip"        [Cancel] │
│                                         │
│           $500.00                       │
│           ___________                   │
│                                         │
│  Quick amounts:                         │
│  [$10] [$25] [$50] [$100]              │
│                                         │
│  Today's War Chest remaining: $90.00    │
│  💡 "Saving this puts you $590         │
│      closer to Halfway There!"         │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │       💰 Deposit (+75 XP?)      │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌───┬───┬───┐                          │
│  │ 1 │ 2 │ 3 │                          │
│  ├───┼───┼───┤                          │
│  │ 4 │ 5 │ 6 │                          │
│  ├───┼───┼───┤                          │
│  │ 7 │ 8 │ 9 │                          │
│  ├───┼───┼───┤                          │
│  │ . │ 0 │ ⌫ │                          │
│  └───┴───┴───┘                          │
└─────────────────────────────────────────┘
```

---

## Screen 7: Profile

### Layout

```
┌─────────────────────────────────────────┐
│ Profile                                 │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │                                     │ │
│ │     Level 8 — Budget Warrior        │ │
│ │     ━━━━━━━━━━━━━━━━ 72%           │ │
│ │     1,840 / 2,500 XP to Level 9    │ │
│ │     Total: 8,640 XP                │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ─── Streaks ───────────────────────     │
│ ┌────────────────┐ ┌────────────────┐   │
│ │ 🔥 Logging     │ │ 🛡️ Budget      │   │
│ │   12 days      │ │   5 days       │   │
│ │   Best: 23     │ │   Best: 14     │   │
│ │                │ │                │   │
│ │ ❄️ Freeze: 1   │ │                │   │
│ └────────────────┘ └────────────────┘   │
│                                         │
│ ─── Duel Record ───────────────────     │
│ ┌─────────────────────────────────────┐ │
│ │ W: 8  D: 3  L: 2                   │ │
│ │ Win Rate: 62%                       │ │
│ │ Current Streak: 3 wins 🔥           │ │
│ │ Best Streak: 4 wins                 │ │
│ │                                     │ │
│ │ Momentum: Climbing ↗️              │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ─── Badges ────────────────────────     │
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│ │ 🩸  │ │ 🔥  │ │ 🛡️  │ │ ⚔️  │       │
│ │First│ │Week │ │Shild│ │Self │       │
│ │Blood│ │Warr.│ │Bear.│ │Surp.│       │
│ └─────┘ └─────┘ └─────┘ └─────┘       │
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│ │ 🏴  │ │ 🔒  │ │ 🔒  │ │ 🔒  │       │
│ │Quest│ │Iron │ │Log  │ │5Star│       │
│ │Conq.│ │Wall │ │Lgnd │ │Gen. │       │
│ └─────┘ └─────┘ └─────┘ └─────┘       │
│                                         │
│ ─── Lifetime Stats ───────────────     │
│ ┌─────────────────────────────────────┐ │
│ │ Transactions logged:      1,247     │ │
│ │ Quests completed:             3     │ │
│ │ Total saved (quests):      $9.5K    │ │
│ │ Days tracked:               156     │ │
│ │ Best month saving rate:      38%    │ │
│ └─────────────────────────────────────┘ │
│                                         │
│        [⚙️ Settings]                    │
│                                         │
├────────┬────────┬────────┬────────┬─────┤
│  Dash  │  Log   │  Duel  │ Quest  │ Me  │
└────────┴────────┴────────┴────────┴─────┘
```

---

## Screen 8: Onboarding

### Page 1: Hook

```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│          ⚔️                             │
│                                         │
│    "Your wallet has a rival"            │
│                                         │
│    ┌────────┐       ┌────────┐          │
│    │  YOU   │  VS   │  PAST  │          │
│    │  NOW   │       │  YOU   │          │
│    │  💙   │       │   ❤️  │          │
│    └────────┘       └────────┘          │
│                                         │
│    Track spending. Beat last week.      │
│    Level up your finances.              │
│                                         │
│                                         │
│              ● ○ ○                      │
│                                         │
│         [Next →]                        │
└─────────────────────────────────────────┘
```

### Page 2: How It Works

```
┌─────────────────────────────────────────┐
│                                         │
│    How WalletWars Works                 │
│                                         │
│    📝 LOG                               │
│    Record expenses in 5 seconds         │
│                                         │
│    🛡️ DEFEND                            │
│    Guard your War Chest — your daily    │
│    remaining budget                     │
│                                         │
│    ⚔️ DUEL                              │
│    Every Monday, battle last week's     │
│    you in 4 rounds                      │
│                                         │
│    🏆 LEVEL UP                          │
│    Earn XP, unlock badges, level up     │
│                                         │
│              ○ ● ○                      │
│                                         │
│         [Next →]                        │
└─────────────────────────────────────────┘
```

### Page 3: Setup

```
┌─────────────────────────────────────────┐
│                                         │
│    Set Your Monthly Budget              │
│                                         │
│    "What's your monthly budget?"        │
│                                         │
│         $5,000                          │
│         _______________                 │
│                                         │
│    💡 You can change this at any time.  │
│       Start with something realistic.   │
│                                         │
│    Currency: [USD 🇺🇸 ▾]               │
│                                         │
│                                         │
│              ○ ○ ●                      │
│                                         │
│    ┌─────────────────────────────────┐  │
│    │      ⚔️ Start Fighting          │  │
│    └─────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

---

## Screen 9: Settings

```
┌─────────────────────────────────────────┐
│ ← Settings                              │
│                                         │
│ ─── Budget ────────────────────────     │
│ Monthly Budget               $5,000  >  │
│ Category Budgets                     >  │
│                                         │
│ ─── Currency ──────────────────────     │
│ Currency                    USD 🇺🇸  >  │
│                                         │
│ ─── Notifications ─────────────────     │
│ Daily Reminder              🔵 ON       │
│ Reminder Time               20:00    >  │
│ Duel Results (Monday)       🔵 ON       │
│ Streak Warning              🔵 ON       │
│                                         │
│ ─── Categories ────────────────────     │
│ Manage Categories                    >  │
│                                         │
│ ─── Data ──────────────────────────     │
│ Export Transactions (CSV)            >  │
│ Reset All Data              ⚠️       >  │
│                                         │
│ ─── About ─────────────────────────     │
│ Version                        1.0.0    │
│ Rate WalletWars                      >  │
│ Privacy Policy                       >  │
│                                         │
└─────────────────────────────────────────┘
```

---

## Notification Flows

### Daily Reminder (Configurable, default 8 PM)

```
┌─────────────────────────────────────────┐
│ WalletWars                              │
│ 🛡️ You haven't logged today!            │
│ War Chest: $90.00 remaining.            │
│ Don't break your 12-day streak!         │
└─────────────────────────────────────────┘
```

### Monday Morning (Duel Results)

```
┌─────────────────────────────────────────┐
│ WalletWars                              │
│ ⚔️ Duel Results are in!                 │
│ You vs Last Week — tap to see who won.  │
└─────────────────────────────────────────┘
```

### Streak Warning (Evening before break)

```
┌─────────────────────────────────────────┐
│ WalletWars                              │
│ 🔥 Your 12-day logging streak is at     │
│ risk! Log one transaction to save it.   │
│ (1 streak freeze available)             │
└─────────────────────────────────────────┘
```

### Badge Unlock

```
┌─────────────────────────────────────────┐
│ WalletWars                              │
│ 🏆 Badge Unlocked: Shield Bearer!       │
│ 7 days under budget. You're a warrior.  │
└─────────────────────────────────────────┘
```

---

## Animation Specifications

### XP Float
- +5 XP text rises from action point
- Duration: 1.2s
- Spring: response 0.3, damping 0.7
- Fade out at top

### Confetti
- Triggers on: Duel Win, Quest Complete, Badge Unlock
- Duration: 2.0s
- Colors: Hero Blue, Victory Green, Streak Amber
- Particle count: ~50

### War Chest Shield
- Shrinks with spending (1.0 → 0.0 scale)
- Color transitions: Green → Amber → Red
- "Crack" animation at 0% (broken state)
- Spring: response 0.4, damping 0.8

### Duel Round Reveal
- Each round slides in from right
- Pause 0.5s between rounds (dramatic tension)
- Winner side glows (blue or red)
- Final result: scale bounce + confetti (if win)
- Spring: response 0.3, damping 0.7

### Streak Fire
- Flame icon pulses gently when active
- Grows slightly larger with longer streaks
- "Freeze" animation: ice crystal overlay when freeze is used

### Level Up
- Full-screen overlay
- New level number scales up with spring
- Title text fades in below
- Gold particle burst
- Duration: 2.5s
- Auto-dismiss

---

## Project Structure

```
WalletWars/
├── App/
│   ├── WalletWarsApp.swift
│   └── ContentView.swift              (TabView)
├── Models/
│   ├── Transaction.swift
│   ├── Category.swift
│   ├── SavingQuest.swift
│   ├── QuestMilestone.swift
│   ├── PlayerProfile.swift
│   ├── WeeklySnapshot.swift
│   ├── CurrentWeekTracker.swift
│   ├── DailyLog.swift
│   └── Enums.swift                    (QuestStatus, DuelResult, DuelRound, etc.)
├── ViewModels/
│   ├── DashboardViewModel.swift
│   ├── TransactionLogViewModel.swift
│   ├── DuelViewModel.swift
│   ├── QuestViewModel.swift
│   ├── ProfileViewModel.swift
│   ├── QuickCaptureViewModel.swift
│   ├── OnboardingViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   ├── WarChestCard.swift
│   │   ├── TodayTransactionsList.swift
│   │   ├── StreakBanner.swift
│   │   └── InsightCard.swift
│   ├── Capture/
│   │   ├── QuickCaptureSheet.swift
│   │   ├── AmountInput.swift
│   │   └── CategoryGrid.swift
│   ├── Log/
│   │   ├── TransactionLogView.swift
│   │   ├── TransactionRow.swift
│   │   ├── FilterSheet.swift
│   │   └── CategoryBudgetView.swift
│   ├── Duel/
│   │   ├── DuelView.swift
│   │   ├── VSCard.swift
│   │   ├── RoundCard.swift
│   │   ├── DuelResultOverlay.swift
│   │   ├── MomentumBadge.swift
│   │   ├── LiveStandingsView.swift
│   │   └── DuelHistoryList.swift
│   ├── Quest/
│   │   ├── QuestView.swift
│   │   ├── QuestProgressRing.swift
│   │   ├── MilestoneList.swift
│   │   ├── QuestDepositSheet.swift
│   │   ├── NewQuestSheet.swift
│   │   └── CompletedQuestCard.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── LevelCard.swift
│   │   ├── StreakCards.swift
│   │   ├── DuelRecordCard.swift
│   │   ├── BadgeGrid.swift
│   │   └── LifetimeStatsCard.swift
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   ├── OnboardingPage1.swift
│   │   ├── OnboardingPage2.swift
│   │   └── OnboardingPage3.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Components/
│       ├── GlassCard.swift
│       ├── XPFloatView.swift
│       ├── ConfettiView.swift
│       ├── ProgressBar.swift
│       └── ShieldView.swift
├── Services/
│   ├── XPService.swift
│   ├── StreakService.swift
│   ├── DuelService.swift
│   ├── BadgeService.swift
│   ├── WarChestService.swift
│   ├── InsightService.swift
│   ├── NotificationService.swift
│   └── CategorySeedService.swift
├── Extensions/
│   ├── Color+Brand.swift
│   ├── Date+Week.swift
│   ├── View+Glass.swift
│   ├── Double+Currency.swift
│   └── Animation+Spring.swift
├── Resources/
│   ├── Assets.xcassets
│   ├── Fonts/
│   └── Preview Content/
├── docs/
│   ├── WalletWars_PRD_v1.md
│   ├── WalletWars_DataModel.md
│   └── WalletWars_UserFlows.md
└── tasks/
    ├── todo.md
    └── lessons.md
```
