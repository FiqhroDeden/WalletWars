# V1.0 UX Polish — Design Spec

> 5 targeted improvements to close UX gaps before release.

---

## 1. War Chest "Daily Funds" Clarity

**Problem:** Users see "Daily Funds: $101.17" but don't know where to set it. It's calculated from monthly budget, not directly configurable.

**Solution:** Add an explainer subtitle showing the source.

**Changes to `WarChestCard.swift`:**
- Below "Daily Funds" label, add: `"from $5,000/mo budget"` (dynamically using actual budget)
- Pass `monthlyBudget` as a new parameter to the card

**No new files.** Just a subtitle addition.

---

## 2. Settings — Monthly Budget Save Flow

**Problem:** Budget updates on every keystroke with zero feedback. Users don't know if their change was saved.

**Solution:** Explicit save with feedback.

**Changes to `SettingsView.swift`:**
- Track `editingBudget: String` as local state (not bound to ViewModel on each keystroke)
- Show a **"Save" button** when `editingBudget` differs from saved value
- On save: call `viewModel.updateBudget()`, dismiss keyboard, show success toast
- Success toast: checkmark icon + "Budget updated" — auto-dismiss after 1.5s, overlaid at bottom of screen

**Changes to `SettingsViewModel.swift`:**
- No logic changes needed — `updateBudget()` already works correctly

---

## 3. Settings — Replace Build Info with Review Prompt

**Problem:** About section shows "Build: Sprint 11" and "Made with SwiftUI" — irrelevant to users.

**Solution:** Clean About section + App Store review prompt.

**Changes to `SettingsView.swift`:**
- Remove "Build" and "Made with" rows from About section
- Keep "Version 1.0.0" row
- Add "Rate WalletWars" row with `star.fill` icon that calls `requestReview()`

**New: Auto-prompt logic:**
- Use `@AppStorage("hasRequestedReview")` flag
- In `ProfileViewModel` or wherever level-up is detected: when user reaches Level 3+ and `hasRequestedReview == false`, call `requestReview()` and set flag to true
- This is a one-time prompt tied to a moment of accomplishment

**Import:** `import StoreKit` in the files that call `requestReview()`

---

## 4. Log — Edit Transaction Row Animation

**Problem:** After editing a transaction, the list updates silently. User has no visual confirmation.

**Solution:** Highlight the edited row briefly.

**Changes to `TransactionLogView.swift`:**
- Add `@State private var highlightedTransactionID: UUID?`
- After edit save completes, set `highlightedTransactionID = tx.id`
- On `LogTransactionRow`: apply a Victory Green background overlay (opacity 0.2) that fades to 0 over 0.6s when the row's transaction ID matches `highlightedTransactionID`
- Clear `highlightedTransactionID` after animation completes (via `DispatchQueue.main.asyncAfter` or `.onAppear` with delay)

---

## 5. Log — Delete Transaction Confirmation + Feedback

**Problem:** Delete happens immediately from context menu with no confirmation or success feedback.

**Solution:** Two-step: confirm, then acknowledge.

**Changes to `TransactionLogView.swift`:**
- Add `@State private var transactionToDelete: Transaction?`
- Context menu delete button sets `transactionToDelete` instead of deleting directly
- `.alert("Delete Transaction?")` bound to `transactionToDelete != nil`
  - Message: "This will permanently remove this expense."
  - Actions: "Cancel" (dismiss) + "Delete" (destructive, performs delete)
- After successful delete: show toast "Transaction deleted" (same toast component as budget save)
- EditTransactionSheet's `onDelete` also goes through this same confirmation flow

**Shared toast component:** Extract a reusable `ToastView` used by both Settings (budget saved) and Log (transaction deleted). Simple overlay with icon + text + auto-dismiss.

---

## Shared Component: ToastView

A lightweight reusable toast overlay used across the app.

```
ToastView(icon: String, message: String, isShowing: Binding<Bool>)
```

- Appears at bottom of screen with spring animation
- Auto-dismisses after 1.5 seconds
- Uses `.ultraThinMaterial` background with rounded corners
- Icon + message in HStack
- Victory Green checkmark for success states

**File:** `WalletWars/Views/Components/ToastView.swift`

---

## Files Modified

| File | Changes |
|------|---------|
| `Views/Dashboard/WarChestCard.swift` | Add budget subtitle |
| `Views/Settings/SettingsView.swift` | Budget save flow, clean About, add review row |
| `Views/Log/TransactionLogView.swift` | Edit highlight animation, delete confirmation + toast |
| `Views/Components/ToastView.swift` | **New** — reusable toast component |
| `ViewModels/DashboardViewModel.swift` | Pass monthlyBudget to WarChestCard (if not already) |

## Verification

1. Dashboard: War Chest shows "from $X/mo budget" subtitle
2. Settings: Change budget amount, see Save button appear, tap Save, see toast
3. Settings: About section shows Version + Rate row only. Tap Rate triggers StoreKit prompt.
4. Log: Edit a transaction, see green highlight flash on the row
5. Log: Delete via context menu, see confirmation alert, confirm, see "deleted" toast
6. Log: Delete via EditTransactionSheet, same confirmation + toast flow
