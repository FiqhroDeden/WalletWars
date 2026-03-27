# WalletWars — Product Requirements Document v1

> **"Your wallet. Your rules. Your rival."**

## 1. Vision & Mission

### Vision
To become the first financial tracker that makes people *addicted* to improving their financial habits through competition against themselves.

### Mission
Transform financial tracking from a boring obligation into a weekly battle that makes you wonder: "Can I win this week?"

### Tagline Options
- "Your wallet. Your rules. Your rival."
- "Beat yesterday's budget."
- "Outspend your past self — by spending less."

---

## 2. Problem Statement

### Core Problems
1. **Finance trackers are boring** — Users download, use for 2 weeks, then abandon. Average retention of finance apps is < 30% after 30 days.
2. **Guilt-driven, not game-driven** — Finance apps judge spending instead of motivating improvement.
3. **Information overload** — Too many charts, categories, and features that overwhelm young professionals who are just starting out.
4. **Privacy concerns** — Post-Mint shutdown, users are increasingly wary of apps that require bank sync and accounts.

### Why Now?
- Mint shutdown (2024) left millions of users without a free finance tracker
- A generation raised on gamification (Duolingo, fitness apps) is ready for gamified finance
- Privacy-first movement is growing stronger
- No competitor in the "high gamification + high insight" quadrant

---

## 3. Target User

### Primary: Young Professional (22-30 years old)
- Has been earning their own income for 1-5 years
- Familiar with gamification (grew up with games, Duolingo, fitness apps)
- Has disposable income but often engages in impulsive spending
- Wants to improve but doesn't know where to start
- Doesn't need complex investment/tax features
- Values privacy, reluctant to create accounts

### User Persona: "Rina"
- 26 years old, UI designer, salary $3,000/month
- Always runs out of money before the 25th of the month
- Used Money Manager before but stopped because it was boring
- Competitive nature — plays mobile games daily
- Wants to save for a trip to Japan but always fails
- "I know I overspend, but nothing makes me excited about saving"

---

## 4. Core Principles

1. **5-Second Entry** — Log a transaction in 5 seconds. Any longer and users won't stay consistent.
2. **Beat Yourself, Not Others** — All benchmarks come from your own data. No social comparison that breeds insecurity.
3. **Celebrate Progress, Not Perfection** — Overspending isn't failure, it's a "lost round." You can still win the duel.
4. **Simplicity Over Completeness** — Better to have 5 features used every day than 50 features that get ignored.
5. **Offline-First, Privacy-First** — Zero signup, zero bank sync, zero data collection. Data stays on device only.
6. **Momentum > Snapshots** — A 3-week trend is more meaningful than today's number.

---

## 5. Core Loop

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   CAPTURE ──► CATEGORIZE ──► TRACK ──► DUEL         │
│      │                                    │         │
│      │         ┌──────────────┐           │         │
│      └─────────│  SAVE QUEST  │◄──────────┘         │
│                └──────────────┘                      │
│                                                     │
│   Daily: Log expenses, stay under budget             │
│   Weekly: Duel against last week (4 rounds)          │
│   Monthly: Review momentum, level up                 │
│   Goal: Complete saving quests                       │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Daily Actions
- Log expenses (5 seconds per entry)
- Check remaining daily budget ("War Chest")
- See if you're on track vs yesterday

### Weekly Rhythm
- Monday: Last week's duel results appear
- Throughout the week: Battle to win 3+ of 4 rounds
- Sunday night: Snapshot saved, new cycle begins

### Monthly Arc
- Review momentum (how many duels won)
- Level progression
- Saving quest milestones

---

## 6. Feature Specification

### 6.1 Quick Capture (Transaction Entry)

**Goal:** Log a transaction in 5 seconds or less.

**Flow:**
1. Open app → "+" button always visible
2. Type amount → pick category (icon grid) → done
3. Optional: add a short note

**Default Categories (8 categories, icon-based):**
| Category | Icon (SF Symbol) | Color |
|----------|-----------------|-------|
| Food & Drink | `fork.knife` | Orange |
| Transport | `car.fill` | Blue |
| Shopping | `bag.fill` | Pink |
| Entertainment | `gamecontroller.fill` | Purple |
| Bills & Utilities | `bolt.fill` | Yellow |
| Health | `heart.fill` | Red |
| Education | `book.fill` | Green |
| Other | `ellipsis.circle.fill` | Gray |

**Rules:**
- Custom categories can be added (max 12 total)
- Default currency: IDR (configurable)
- Numeric keyboard appears immediately (no extra tap)
- Swipe left on a transaction to delete, swipe right to edit

---

### 6.2 War Chest (Daily Budget Tracker)

**Goal:** One number that answers "How much can I still spend today?"

**Formula:**
```
War Chest = (Monthly Budget - Total Spent This Month) / Remaining Days in Month
```

**Visual:**
- Large number in the center of the screen
- Color changes:
  - Green (Victory): > 80% of daily budget remaining
  - Yellow (Streak Amber): 40-80% remaining
  - Red (Rival Red): < 40% remaining or over budget
- "Shield" animation that shrinks with spending

**Rules:**
- User sets monthly budget during first-time setup
- Budget can be adjusted at any time
- If War Chest goes negative: "Shield Broken!" — not punitive, just a visual cue

---

### 6.3 Budget Categories

**Goal:** Per-category budgets (optional but recommended).

**Flow:**
- User sets total monthly budget
- Optional: breakdown per category
- If not broken down, everything goes into a shared pool
- Progress bar per category shows % used

**Smart Suggestions (after 2 weeks of data):**
- "You average 1.5M/month on Food. Want to set a budget of 1.3M?"
- Suggestions based on 80% of average spending (achievable but stretching)

---

### 6.4 Weekly Duel (Core Differentiator)

**Goal:** Every Monday, compare this week's performance vs last week. 4 rounds, win 3+ = win the duel.

**4 Rounds:**

| Round | Metric | How to Win |
|-------|--------|-------------|
| 1. War Chest Discipline | How many days daily budget wasn't exceeded | More days under budget |
| 2. Saving Power | Total money "saved" (budget - actual spend) | More money remaining |
| 3. Logging Consistency | How many days at least 1 transaction was logged | More consistent logging |
| 4. Category Control | Whether your worst category (highest % over budget) improved | Worst category improves |

**Duel States:**
- **Win (3-4 rounds):** +200 XP, victory animation, "Winning Streak" counter++
- **Draw (2-2):** +50 XP, "Stalemate" animation
- **Loss (0-1 rounds):** +10 XP (participation), "Comeback Next Week" message

**Momentum Score:**
```
Momentum = ((thisWeekSaved - lastWeekSaved) / lastWeekSaved) × 100
```
- Clamped to -99%...999%
- Named states (inspired by Garmin):
  - **Surging** (> +30%): "You're on fire!"
  - **Climbing** (+10% to +30%): "Steady improvement"
  - **Holding** (-10% to +10%): "Maintaining discipline"
  - **Slipping** (-30% to -10%): "Watch out!"
  - **Freefalling** (< -30%): "Time to fight back"

**First Week:**
- No duel — "This week sets your baseline. Fight starts Monday!"
- Snapshot saved as benchmark

**Visualization:**
- VS screen: "THIS WEEK" (Hero Blue, left) vs "LAST WEEK" (Rival Red, right)
- Each round: side-by-side bar chart with animated reveal
- Confetti on duel win
- Streak counter: "3-Week Win Streak!"

---

### 6.5 Saving Quests

**Goal:** Saving goals gamified as quests (similar to IdeaTamer's active quest).

**Rules:**
- Max 1 active quest at a time (focus!)
- Quest = saving goal with target amount and optional deadline
- Milestone system: break down target into smaller chunks

**Example Quest:**
```
Quest: "Japan Trip Fund"
Target: $5,000
Deadline: December 2026
Milestones:
  ☑ $500 — "First Blood"
  ☑ $1,500 — "Getting Serious"
  ☐ $2,500 — "Halfway Hero"
  ☐ $4,000 — "Almost There"
  ☐ $5,000 — "Quest Complete!"
```

**Quest Actions:**
- "Add to Quest" — after logging an expense, remaining budget can be allocated to the quest
- Manual deposit to quest
- Progress ring visualization (similar to IdeaTamer Focus view)

**Quest Completion:**
- +500 XP
- Special badge unlock
- Confetti celebration
- Quest moves to "Hall of Fame"

---

### 6.6 Gamification System

#### 6.6.1 XP & Levels

| Action | XP | Constant |
|--------|----|----------|
| Log a transaction | +5 | `XP.logTransaction` |
| Full day under budget | +25 | `XP.underBudget` |
| Complete a quest milestone | +75 | `XP.questMilestone` |
| Complete a saving quest | +500 | `XP.questComplete` |
| Win weekly duel (3+ rounds) | +200 | `XP.duelWin` |
| Draw weekly duel (2-2) | +50 | `XP.duelDraw` |
| Logging streak/day | +10 | `XP.loggingStreak` |
| Budget streak/day | +30 | `XP.budgetStreak` |

**Level Formula:**
```swift
/// XP required for a specific level: 100 x level
/// Cumulative XP for level N = sum(100 x i for i in 1...N)
static func levelFor(xp: Int) -> Int {
    var level = 0
    var remaining = xp
    while remaining >= (level + 1) * 100 {
        level += 1
        remaining -= level * 100
    }
    return max(1, level)
}
```

**Level Titles:**
| Level | Title |
|-------|-------|
| 1 | Rookie Saver |
| 5 | Budget Warrior |
| 10 | Money Master |
| 15 | Financial Knight |
| 20 | Wealth Guardian |
| 25 | Legend |

#### 6.6.2 Dual Streak System

**Logging Streak:** How many consecutive days at least 1 transaction was logged.
- Streak freeze: 1 per week (allows skipping a day off without breaking the streak)
- Visual: small flame with counter

**Budget Streak:** How many consecutive days spending stayed under daily budget.
- No streak freeze (this is the challenge)
- Visual: shield with counter

**Streak XP:**
- Budget streak gives 3x XP compared to logging streak (30 vs 10)
- Philosophy: discipline > awareness

#### 6.6.3 Badges

| Badge ID | Name | Condition | Color |
|----------|------|---------|-------|
| `firstSave` | First Blood | First deposit to a saving quest | Victory Green |
| `logger7` | Week Warrior | 7-day logging streak | Amber |
| `logger30` | Log Legend | 30-day logging streak | Amber |
| `budget7` | Shield Bearer | 7-day budget streak | Blue |
| `budget30` | Iron Wall | 30-day budget streak | Blue |
| `duelWin` | Self Surpassed | First weekly duel win | Red |
| `duelStreak3` | Unstoppable | 3 consecutive weeks winning duels | Red |
| `questDone` | Quest Conqueror | Complete first saving quest | Victory Green |
| `quest5` | Five Star General | Complete 5 saving quests | Gold |
| `underSpend50` | Half Spender | Spend < 50% of budget in a month | Victory Green |
| `noImpulse` | Zen Master | 7 days without a transaction in worst category | Purple |
| `momentum3` | Rising Star | Momentum at "Climbing" or "Surging" for 3 consecutive weeks | Blue |

---

### 6.6.4 Behavioral Penalties (Shame Marks)

**Goal:** Temporary penalty marks earned through bad financial behavior that can be redeemed through good behavior. Creates a recovery quest loop — bad behavior isn't just punished, it creates a mission to recover.

**Shame Mark Definitions:**

| Mark ID | Name | Earned When | Cleared By | Clear XP |
|---------|------|-------------|------------|----------|
| `shieldShattered` | Shield Shattered | Over budget 3 consecutive days | 5 consecutive days under budget | +50 |
| `budgetBreaker` | Budget Breaker | Monthly spend > 100% of budget | 7 consecutive days under budget | +75 |
| `impulseSpender` | Impulse Spender | 3+ transactions in worst category in one day | 3 days with 0 transactions in that category | +50 |
| `streakDestroyer` | Streak Destroyer | Break a budget streak of 7+ days | Rebuild a 7-day budget streak | +50 |

**Rules:**
- Displayed in Profile under "Active Penalties" section (Rival Red theme)
- Each shows progress bar toward clearing (e.g., "3/5 days under budget")
- When cleared: victory animation + "Mark Cleared!" + bonus XP
- Multiple marks can stack
- Philosophy: bad behavior creates a quest to recover, not a reason to quit

### 6.6.5 Overspend Prevention (Escalating Warnings)

**Goal:** Add friction before overspending to help users exercise self-control.

**In QuickCapture, when transaction would exceed daily budget:**
- **First overspend of the day:** Amber warning banner: "This will break your shield for today." User can still save immediately.
- **Second+ overspend of the day:** Confirmation dialog: "You're already $X over budget today. Spend anyway?" Forces deliberate choice.

**Budget Streak Break Visibility:**
- When a transaction breaks the budget streak, show a red "Shield Streak Lost" overlay after save success, displaying the streak count that was just broken.

---

### 6.7 Insights (Passive Intelligence)

**Goal:** Brief insights that appear naturally, not an overwhelming analytics dashboard.

**Insight Types:**
1. **Weekly Summary** — "This week you spent 15% less on Food. Past you is shaking."
2. **Category Alert** — "Entertainment is at 90% of budget. 3 days until month end."
3. **Trend Observation** — "Transport spending has dropped 3 weeks in a row. Nice trend!"
4. **Smart Suggestion** — "You tend to go over budget on Shopping. Try reducing by 100k next week?"

**Overspend-Aware Insights (Priority):**
5. **Daily Overspend** — "You spent $X more than your daily shield allows. That's tomorrow's budget eaten today."
6. **Monthly Warning** — "You've burned through 80% of your monthly budget with X days left. The walls are closing in."
7. **Streak Break** — "Your 5-day budget streak just shattered. Building it back starts tomorrow."
8. **Penalty Reminder** — "You have 2 active penalty marks. Good behavior clears them."

**Rules:**
- Max 2 insights per day (not spammy)
- Overspend/warning insights take priority over positive insights
- Tone: concerned commander, not judgmental parent. Military theme. Factual but emotionally weighted.
- When over budget, user should NOT see cheerful messages

---

### 6.8 Tabs & Navigation

| Tab | Name | SF Symbol | Function |
|-----|------|-----------|--------|
| 1 | Dashboard | `chart.bar.fill` | War Chest + today's overview + quick stats |
| 2 | Log | `list.bullet.rectangle.fill` | Transaction history + filters |
| 3 | Duel | `figure.fencing` | Weekly duel + duel history |
| 4 | Quest | `flag.fill` | Active saving quest + milestones |
| 5 | Profile | `trophy.fill` | Level, badges, streaks, stats |

---

## 7. User Flows

### 7.1 First Time User (Onboarding)

```
Page 1: "Your wallet has a rival — last week's you."
  → Visual: VS screen Hero vs Rival

Page 2: "Track spending. Stay under budget. Win the week."
  → Visual: 4-round duel preview

Page 3: "Set your monthly budget to start."
  → Input: Monthly budget amount
  → Optional: Breakdown per category
  → CTA: "Start Fighting"
```

### 7.2 Daily Flow

```
Open App
  → See War Chest (remaining daily budget)
  → Tap "+" to log expense
  → Enter amount → Pick category → Done (+5 XP)
  → War Chest updates
  → If streak maintained → streak badge animates
  → If insight available → card appears below War Chest
```

### 7.3 Weekly Duel Flow

```
Monday Morning:
  → App shows "DUEL RESULTS" modal
  → Round 1 reveal (animation) → Win/Lose
  → Round 2 reveal → Win/Lose
  → Round 3 reveal → Win/Lose
  → Round 4 reveal → Win/Lose
  → Final: "YOU WIN 3-1!" + XP award + confetti
  → Momentum update: "Climbing ↑"
  → "New week starts now. Defend your title!"
```

### 7.4 Saving Quest Flow

```
Profile → "Start a Quest"
  → Enter quest name ("Japan Trip")
  → Set target amount ($5,000)
  → Optional: set deadline
  → Auto-generate milestones (20%, 50%, 80%, 100%)
  → Or: manual milestones
  → "Quest Activated!"

During Quest:
  → Dashboard shows quest progress ring
  → "Add to Quest" button after logging a cheap day
  → Manual deposit button on Quest tab
  → Milestone completion → +75 XP + celebration

Quest Complete:
  → +500 XP + badge + confetti
  → Quest moves to Hall of Fame
  → "Start new quest?"
```

---

## 8. Monetization Strategy

### Model: Freemium (Free Forever Core)

### Phase 1: V1 Launch — Fully Free

All features are completely free at launch. No paywalls, no premium tier, no restrictions.

**Why:**
- Maximize downloads and retention with zero friction
- Build trust and a loyal user base before asking for money
- Collect organic App Store reviews and ratings
- Gather real usage data to understand which features users value most
- Get user feedback to shape what premium features should be

**V1 Free includes everything:**
- Unlimited transaction logging
- War Chest daily budget
- Weekly duel (full 4 rounds)
- 1 active saving quest
- Full gamification: XP, levels, badges, dual streaks
- Insights
- All 8 default categories + up to 4 custom

> **Important:** Everything available in v1 stays free forever. Premium never takes away what users already had.

---

### Phase 2: V2+ Major Update — Introduce WalletWars Plus

Premium is introduced as **new features on top** of the free experience. Nothing gets locked behind a paywall retroactively.

**Free (unchanged from v1 — free forever):**
- Everything from v1 remains fully unlocked
- All core features continue to work without limits

**WalletWars Plus (new features, added in v2+):**
| Feature | Details |
|---------|---------|
| Multiple active quests | Up to 3 simultaneous (free stays at 1) |
| Advanced insights | Monthly report, category deep dive, spending trends |
| Duel history & analytics | Full history + trend graphs + win rate over time |
| Streak freeze inventory | Earn/buy extra streak freezes (free gets 1/week) |
| Themes & customization | Dark mode variations, color themes, custom icons |
| Export data | CSV export for spreadsheet lovers |
| iCloud sync | Sync data across devices |

**Pricing:**
| Plan | Price | Notes |
|------|-------|-------|
| Monthly | $1.99/month | Low commitment entry point |
| Yearly | $14.99/year | ~37% discount, encourages commitment |
| Lifetime | $29.99 | One-time purchase, best fit for budget-conscious users |

> **Note:** Lifetime option is key for our target audience — they're budget-conscious users who dislike recurring costs. It also generates upfront revenue.

---

## 9. Technical Architecture

### Stack
- Swift 6.2, SwiftUI, iOS 26+ minimum
- SwiftData for local persistence
- UserNotifications for reminders
- BGTaskScheduler for weekly snapshot
- MVVM with @Observable ViewModels
- Zero third-party dependencies
- Offline-first, no server, no account

### Architecture Rules
- Same as IdeaTamer (see Data Model doc)
- Privacy: zero analytics, zero tracking, zero network calls
- Data stays on device only, iCloud sync via SwiftData CloudKit (optional future)

---

## 10. Design Language

### Name: "Battle Finance"
A combination of military/battle metaphor with clean modern finance UI.

### Color Palette

```
Hero Blue (You Now):     #1B6EF2 — primary actions, this week
Rival Red (Past You):    #E5432A — last week, opponent
Victory Green:           #12B76A — under budget, quest progress, wins
Streak Amber:            #F5A623 — streaks, warnings, urgency
Shield Silver:           #8A8B8A — war chest, neutral

Surface & Text: same as IdeaTamer (neutral, never pure black)
```

### Typography
Plus Jakarta Sans (same as IdeaTamer) — bold, modern, slightly playful.

### iOS 26 Liquid Glass
- Glass cards for transaction items, duel rounds, quest cards
- Tab bar with automatic glass
- War Chest as prominent glass surface

### Animations
- All spring-based (never linear)
- Duel round reveals: dramatic pause + slide in
- XP float animation on earn
- Confetti on duel win + quest complete
- War Chest shield shrink animation on spending
- Streak fire animation on streak days

---

## 11. Success Metrics

| Metric | Target | Timeframe |
|--------|--------|-----------|
| D7 Retention | > 50% | 3 months post-launch |
| D30 Retention | > 30% | 3 months post-launch |
| Daily active logging | > 70% of active users | Ongoing |
| Weekly duel engagement | > 80% of active users check results | Ongoing |
| Saving quest activation | > 40% of users start a quest in first month | Ongoing |
| App Store rating | > 4.5 stars | 6 months post-launch |
| Plus conversion | > 5% of free users | 6 months post-launch |

---

## 12. Development Roadmap

| Sprint | Focus | Est. Days |
|--------|-------|-----------|
| 0 | Foundation: project setup, models, tokens, fonts, TabView | 1 |
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
| 12 | Monetization: Plus features, paywall, restore purchases | 1-2 |

**Total: 22-28 days**

---

## 13. Competitive Positioning

```
              HIGH GAMIFICATION
                   │
      Fortune City │  ★ WALLETWARS ★
      (fun but     │  (fun AND useful)
       shallow)    │
                   │
LOW INSIGHT ───────┼─────── HIGH INSIGHT
                   │
      Money Manager│  YNAB / Monarch
      (boring,     │  (powerful but
       basic)      │   boring)
                   │
              LOW GAMIFICATION
```

### Key Differentiators
1. **Weekly Duel** — doesn't exist in any other finance app
2. **Saving Quests** — gamified saving goals with milestones
3. **Momentum System** — named states (Surging/Slipping), not raw numbers
4. **Dual Streaks** — separate logging + budget streaks
5. **Offline-first, no-account** — privacy as a feature
6. **5-second entry** — fastest in its category

---

## 14. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Gamification overpowers financial insight | Users play the game but don't improve | Balance XP: budget discipline (30 XP) >> logging (5 XP) |
| Duel loss demotivates | Users abandon after losing | "Comeback" narrative, always give participation XP, no punishment |
| Manual entry fatigue | Users stop logging | 5-sec entry, streak reward, smart suggestions reduce entries needed |
| Feature creep | App becomes complicated | Strict: no investment, no debt tracking, no bank sync v1 |
| Competition from major apps | YNAB/Monarch add gamification | First-mover advantage, community, brand identity |

---

## 15. V2 Flagship: War Base & Battle Companion

> **Design philosophy:** Every visual reward must be earned through financial discipline, never just activity. This is what separates WalletWars from Fortune City — the game reinforces the right behavior, not any behavior.

### 15.1 War Base (Visual Fortress World)

**Concept:** A living, evolving fortress that reflects your actual financial health. Unlike Fortune City where any expense builds your city (rewarding spending), the War Base grows stronger only when you demonstrate discipline.

**How It Works:**
- Your base starts as a small outpost on a floating island
- Financial discipline upgrades and strengthens it over time
- Poor habits cause visible wear — cracks, dimmed lights, weakened walls
- The base is the first thing you see on the Dashboard, replacing the static War Chest card with a living visual

**Base Evolution Tiers:**

| Tier | Name | Unlock Condition | Visual |
|------|------|-----------------|--------|
| 1 | Outpost | Complete onboarding | Small tent, wooden fence, single flag |
| 2 | Camp | First duel win | Stone walls, watchtower, campfire |
| 3 | Stronghold | Level 5 + 3 duel wins | Iron walls, two towers, armory building |
| 4 | Fortress | Level 10 + first quest complete | Full stone fortress, moat, banners |
| 5 | Citadel | Level 15 + 5 quests + 10 duel wins | Grand citadel, multiple towers, glowing shields |
| 6 | War Palace | Level 20+ (Legend) | Epic palace with animated elements, particle effects |

**Dynamic State Indicators:**
- **War Chest healthy (>80%):** Base is bright, shields glow green, troops patrol
- **War Chest cautious (40-80%):** Amber warning fires lit on towers
- **War Chest critical (<40%):** Red alert, walls show cracks, smoke effects
- **War Chest broken (over budget):** Shields down, damage visible, "under siege" atmosphere
- **Duel win streak active:** Victory banners fly, golden glow on fortress
- **Budget streak active:** Shield barrier animation around the base

**Base Buildings (Unlocked Through Achievements):**

| Building | Unlock | Purpose |
|----------|--------|---------|
| Barracks | 7-day logging streak | Houses troops, shows streak count |
| Treasury | First quest deposit | Shows quest savings progress |
| Arena | First duel played | Displays duel record |
| Forge | 7-day budget streak | "Forges" your financial discipline |
| Academy | Complete 3 quests | Shows lifetime stats |
| Hall of Heroes | Earn 6+ badges | Displays badge collection |
| Watchtower | Unlock advanced insights | Shows trend alerts |

**Why This Works (vs Fortune City):**
- Fortune City: spend money → get building. More spending = bigger city. **Bad incentive.**
- WalletWars: stay under budget → stronger fortress. Overspend → fortress weakens. **Good incentive.**
- The visual state is a real-time reflection of financial health, not just activity logging.

---

### 15.2 Battle Companion (Mascot)

**Concept:** A small armored companion character that lives in your War Base, reacts to your financial behavior, and delivers insights conversationally. Think Duolingo's owl meets a tactical advisor.

**Character Design:**
- **Species:** Armored fox or wolf cub (fits battle/tactical theme, universally appealing)
- **Name:** User can name them, default suggestion: "Scout"
- **Visual style:** Stylized, expressive, 2.5D illustration style (not pixel art, not hyper-realistic)
- **Wears armor that upgrades** as user levels up (leather → chain → plate → golden)

**Companion Behaviors:**

| Trigger | Reaction | Example |
|---------|----------|---------|
| Open app (healthy budget) | Happy idle animation, salute | Stands at attention, tail wagging |
| Open app (critical budget) | Worried expression, holds shield up | "Commander, shields are low!" |
| Log a transaction | Quick thumbs-up or nod | Brief positive animation |
| Stay under budget all day | Victory dance | Jumps with sparkle effects |
| Over budget | Concerned, braces for impact | Ducks behind shield |
| Win a duel | Celebration with confetti | Waves flag, fireworks |
| Lose a duel | Encouraging pose | "We'll get them next week, Commander!" |
| Quest milestone | Salute + item reveal | Presents the milestone achievement |
| Streak about to break | Urgent alert pose | "Your streak is at risk!" |
| Open app after long absence | Lonely/waiting animation | "Welcome back, Commander! I held the fort." |

**Insight Delivery:**
Instead of static insight cards, the companion delivers them as speech bubbles:
- "Commander, food spending dropped 15% this week. The troops are well-fed and frugal!"
- "Alert: Entertainment is at 90% of budget with 3 days remaining."
- "Intelligence report: You've been under budget for 3 weeks straight. Promoting you to next rank!"

**Companion Customization (Plus Feature):**
- Outfit variations (seasonal armor, themed costumes)
- Color variations
- Companion species alternatives (wolf, fox, owl, dragon)

---

### 15.3 Collectible Troops & Decorations

**Concept:** Earn collectible units that populate your War Base. Each is tied to a specific financial achievement — not random rewards.

**Troop Types:**

| Troop | Earned By | Visual Role |
|-------|----------|-------------|
| Scouts | Logging streak milestones (7, 14, 30 days) | Patrol the base perimeter |
| Guards | Budget streak milestones (7, 14, 30 days) | Stand at gates and walls |
| Knights | Duel wins (every 3rd win) | Train in the arena |
| Merchants | Quest deposits | Work in the treasury |
| Engineers | Category control improvements | Repair and upgrade buildings |
| Champions | Legendary achievements (30-day streaks, 5 quests) | Golden armored elite units |

**Decorations:**
- **Duel banners:** Each duel win adds a banner to the fortress walls
- **Quest trophies:** Completed quests become trophy displays in Hall of Heroes
- **Seasonal items:** Limited-time decorations during events (holiday lights, festival flags)
- **Milestone markers:** Stone monuments for major achievements (100 transactions, 1 year tracking)

**Collection Book:**
A dedicated view where users can see all possible troops, decorations, and items — earned ones in full color, unearned as silhouettes with unlock conditions. Drives the completionist motivation.

---

### 15.4 Seasonal Events & Challenges

**Concept:** Time-limited events that create urgency and freshness, preventing the app from feeling stale after months of use.

**Event Types:**

| Event | Timing | Mechanic |
|-------|--------|----------|
| New Year's Resolution Rally | January | Special 4-week quest with bonus XP multiplier |
| Summer Savings Sprint | June-July | Daily challenges with exclusive summer decorations |
| Harvest Festival | October | "Harvest" your savings — bonus rewards for quest deposits |
| Year-End Review | December | Annual stats recap + exclusive badge for full-year users |
| Monthly Siege | First week of each month | Community-style challenge: collective budget goal |

**Event Rewards:**
- Limited-edition badges (dated, never available again)
- Exclusive base decorations
- Companion outfits
- Bonus XP multipliers during event

---

### 15.5 The Balance Rule

> **Core principle: Gamification serves financial insight, never the other way around.**

To prevent the Fortune City trap where the game overshadows finance:

1. **Reward discipline, not activity** — Logging gets +5 XP. Staying under budget gets +25 XP. The game always pushes toward the financially healthy action.
2. **Visual consequences for overspending** — The base weakens when you overspend. Fortune City's city never degrades. Ours does. This creates a feedback loop where the game *motivates* saving.
3. **Companion delivers real insights** — The mascot isn't just cute — it's your financial advisor in character. Every speech bubble contains actionable information.
4. **No pay-to-win** — You cannot buy troops, buildings, or skip financial milestones. Everything is earned through real behavior.
5. **Financial data always accessible** — The War Base is an overlay on top of real data, never replacing it. One tap reveals the actual numbers behind the visuals.

---

### 15.6 Implementation Roadmap (Post-V1)

| Update | Focus | Features |
|--------|-------|----------|
| V1.5 | Companion Lite | Battle companion with basic reactions + speech bubble insights (replaces static insight cards) |
| V2.0 | War Base | Full visual fortress, 6 tiers, dynamic state, base buildings |
| V2.5 | Troops & Collection | Collectible troops, decoration system, collection book |
| V3.0 | Seasons & Events | Seasonal events, limited-edition rewards, monthly challenges |

---

## 16. Other Future Considerations

- iCloud sync across devices
- Apple Watch complication (War Chest glance)
- Widgets (War Chest + streak on home screen)
- Recurring transaction auto-detection
- Receipt photo attachment
- Social sharing (duel results card, base screenshot)
- Family/couple mode (duel each other — opt-in)
- Siri shortcuts ("Hey Siri, log 50 food")
