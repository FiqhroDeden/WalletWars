```markdown
# Design System Documentation: Liquid Tactical Finance

## 1. Overview & Creative North Star
**Creative North Star: "The Kinetic Vault"**

This design system rejects the static, spreadsheet-driven nature of traditional finance. Instead, it treats capital as energy and budgeting as a tactical maneuver. We move beyond "Standard UI" by blending the high-end transparency of **iOS 26 Liquid Glass** with the aggressive, high-contrast urgency of a competitive gaming arena.

The interface is not a set of boxes; it is a series of suspended, refractive layers. We break the "template" look through **intentional depth**, where financial data isn't just displayed—it "floats" within a deep-sea tactical environment. Expect expansive whitespace, springy physics-based transitions, and a sophisticated use of light as a functional signifier.

---

## 2. Colors & Surface Philosophy
The palette balances the aggressive "Battle" energy with the "Trust" required for a banking app. We use a high-saturation primary core supported by a sophisticated Material Design-inspired dark-mode architecture.

### Color Tokens
- **Primary (Hero Blue):** `#8AACFF` (Surface) | `#1B6EF2` (Brand Core) - Represents the user’s agency and current standing.
- **Secondary (Rival Red):** `#FF7259` - Used for debt, "past self" performance, and aggressive competition.
- **Tertiary (Victory Green):** `#C2FFD1` - Used for growth, savings wins, and "Healthy" status.
- **Accents (Streak Amber):** `#F5A623` - Reserved exclusively for XP, Gold, and high-velocity streaks.
- **Background (Deep Navy):** `#090E1C` - The "Void" where the tactical battle takes place.

### The "No-Line" Rule
**Explicit Instruction:** Prohibit the use of 1px solid borders for sectioning. 
Structure must be achieved through:
1.  **Background Shifts:** Moving from `surface` to `surface-container-low`.
2.  **Tonal Transitions:** Using subtle gradients to define the start of a new content area.
3.  **Elevation:** Relying on the stacking order of glass layers.

### The Glass & Gradient Rule
To achieve the "Liquid" aesthetic, main CTAs and Hero cards must utilize a **linear gradient** (e.g., `primary` to `primary-container`) at a 135° angle. This provides a "soul" to the UI that flat hex codes lack.

---

## 3. Typography: Energetic Authority
We pair the aggressive, geometric curves of **Plus Jakarta Sans** with the invisible reliability of **SF Pro**.

*   **Display & Headlines:** `Plus Jakarta Sans`. Bold weights only. This is our "Gaming" voice—loud, proud, and motivating. Use `display-lg` (3.5rem) for big win moments.
*   **Body & UI Labels:** `SF Pro` (or `Inter` fallback). This is our "Finance" voice. It ensures legibility for fine-print transactions and legal data.
*   **Currency & Stats:** Always use **Tabular/Monospaced Digits**. This prevents "jumping" layouts during live ticker updates or counting animations.

---

## 4. Elevation & Depth
In this system, depth is a functional tool, not just a decoration.

### The Layering Principle
We stack `surface-container` tiers to create a physical hierarchy:
- **Level 0 (Floor):** `surface` (#090E1C) - The base of the app.
- **Level 1 (Sections):** `surface-container-low` (#0D1323) - Large content groupings.
- **Level 2 (Cards):** `surface-container-highest` (#1E253B) - Interactive glass elements.

### Ambient Shadows & Ghost Borders
- **Shadows:** Use a 24px to 48px blur with only 6% opacity. The shadow color should be tinted with `primary` (Hero Blue) rather than pure black to simulate light refracting through blue glass.
- **Ghost Borders:** If a container needs more definition, use a 1.5pt inner stroke of `outline-variant` at **15% opacity**. This creates a "rim light" effect on the glass edge.

### Glassmorphism
Floating elements (Modals, Navigation Bars) must use:
- **Fill:** `surface-variant` at 60% opacity.
- **Backdrop Blur:** 20px - 32px.
- **Saturate:** 120% (to make the background colors "pop" through the frost).

---

## 5. Components

### Tactical Cards
Cards use a standard `lg` (2rem) corner radius. **Never use dividers.** To separate a card’s header from its body, use a background shift—the header sits on `surface-container-high`, while the body sits on `surface-container`.

### Action Buttons (The "Spring" Variant)
- **Primary:** Gradient fill (`primary` to `primary-dim`). 20pt radius. Use a `1.05x` scale transform on press with a "bouncy" spring curve.
- **Tertiary/Ghost:** No container. Just `SF Pro Bold` text with a filled `SF Symbol`.

### Battle Chips
Small, high-contrast pills used for "Win/Loss" tags.
- **Victory:** `tertiary-container` text on `on-tertiary-fixed` background.
- **Defeat:** `secondary-container` text on `on-secondary-fixed` background.

### Input Fields
Avoid the "boxed" look. Use a `surface-container-lowest` fill with a subtle 10% `outline-variant` ghost border. On focus, the border glows with a `primary` (Hero Blue) 4px outer blur.

### Progress Gauges (The Liquid Bar)
Health and Budget bars should not be flat. Use a "Liquid" fill—a gradient with a slight "shimmer" animation moving across it to indicate that the data is live and "active."

---

## 6. Do’s and Don’ts

### Do:
- **Use "Physical" Spacing:** Use the `20` (5rem) or `24` (6rem) spacing tokens to let hero elements breathe. High-end design is defined by what you leave empty.
- **Embrace Asymmetry:** Place a floating "Streak Amber" badge overlapping the corner of a "Hero Blue" card to break the rigid grid.
- **Animate Tactically:** Use 500ms Spring animations for all entrance transitions. The UI should feel like it's "inflating" into place.

### Don't:
- **No 100% Black:** Even in dark mode, use `surface-container-lowest`. Pure `#000000` kills the glass refraction effect.
- **No Sharp Corners:** Anything smaller than a `sm` (0.5rem) radius feels "corporate" and "stale." Stay in the `md` to `lg` range.
- **No Thin Strokes:** 1px lines feel like wireframes. If you need a line, use a 2pt or 4pt "Grip" or "Indicator" with rounded caps.

---
**Director's Final Note:** 
Remember, this is a "Battle." Every time the user saves money, the UI should feel like a victory. Every time they overspend, the "Rival Red" should feel like a tactical warning. Use light and glass to make the user feel like they are commanding a high-tech financial war-room.```