# Design System Specification: The Organic Editorial

## 1. Overview & Creative North Star
### Creative North Star: "The Digital Agronomist"
This design system moves beyond the utility of a standard management tool into the realm of high-end editorial clarity. We treat agricultural data not as a spreadsheet, but as a living narrative. By blending the structured reliability of **Material Design 3** with a sophisticated, organic aesthetic, we create an experience that feels as grounded as the soil and as modern as precision farming.

The system breaks the "template" look through **intentional white space, tonal layering, and sophisticated typography scales.** We reject the "boxy" nature of traditional apps in favor of fluid, nested surfaces that mimic the natural overlapping of the environment.

---

## 2. Color Tokens & Surface Logic
The palette is rooted in a "New Earth" aesthetic—using desaturated greens and warm, clay-like neutrals to ensure a premium, calming user experience.

### Primary & Brand Colors
* **Primary (#286B33):** The authoritative deep forest green. Used for key actions.
* **Primary Container (#81C784):** A soft, pastel spring green for high-visibility backgrounds.
* **Secondary (#6F5A52):** A refined earth tone for auxiliary elements.
* **Tertiary (#5B6300):** An olive accent for specialized status indicators.

### The "No-Line" Rule
**Crucial Instruction:** Prohibit the use of 1px solid borders for sectioning or containment. Boundaries must be defined solely through background color shifts or subtle tonal transitions. For example, a `surface-container-low` card sitting on a `surface` background creates a clean, sophisticated edge without the visual noise of a stroke.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following hierarchy to define depth:
* **Surface (#F9F9F7):** The base canvas.
* **Surface Container Low (#F4F4F2):** Secondary groupings.
* **Surface Container (#EEEEEC):** Standard card backgrounds.
* **Surface Container High (#E8E8E6):** Active states or elevated cards.

### Signature Textures
* **Glassmorphism:** For floating elements like Bottom Sheets or Navigation Bars, use semi-transparent surface colors with a `20px` backdrop blur to allow crop data and imagery to bleed through softly.
* **Tonal Gradients:** Use a subtle linear gradient (from `primary` to `primary_container`) on primary CTAs to provide a sense of "life" and dimension.

---

## 3. Typography
We utilize a pairing of **Manrope** (for editorial flair) and **Inter** (for high-density data legibility).

| Token | Font Family | Size | Case/Weight | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Display LG** | Manrope | 3.5rem | Bold | Hero dashboard metrics |
| **Headline MD** | Manrope | 1.75rem | Semi-Bold | Section headers |
| **Title LG** | Inter | 1.375rem | Medium | Card titles (e.g., "Visita de cliente") |
| **Body MD** | Inter | 0.875rem | Regular | Descriptions and farm details |
| **Label MD** | Inter | 0.75rem | Semi-Bold | Metadata (e.g., "Status", "12:00 AM") |

The contrast between the rounded, modern geometry of Manrope and the neutral clarity of Inter creates a signature "Editorial Management" feel.

---

## 4. Elevation & Depth
In this system, depth is a function of light and tone, not shadows.

* **The Layering Principle:** Depth is achieved by "stacking" surface tiers. Place a `surface_container_lowest` card on a `surface_container_low` background. The slight shift in hex value creates a soft, natural lift.
* **Ambient Shadows:** If a floating element (like a FAB) requires a shadow, it must be an "Ambient Shadow": `0px 8px 24px rgba(26, 28, 27, 0.06)`. The shadow color is a tinted version of `on-surface`, never pure black.
* **The "Ghost Border" Fallback:** If accessibility requires a border, use `outline_variant` at **15% opacity**. 100% opaque high-contrast borders are forbidden.

---

## 5. Components

### Cards & Lists
* **Style:** No dividers. Use `Spacing 6 (1.5rem)` to separate list items.
* **Interaction:** Cards should use `Roundedness XL (1.5rem)` to feel approachable.
* **Refinement:** Metadata should be placed in `label-md` using `on_surface_variant` to create a clear hierarchy against the primary title.

### Buttons & FABs
* **Primary Button:** Solid `primary` fill with `on_primary` text. `Roundedness Full`.
* **Secondary Button (The "Ver" Button):** As seen in reference imagery, use a "Ghost Border" approach or a simple `secondary_container` fill.
* **Floating Action Button (FAB):** Utilize a large container with `Roundedness XL`. Use the `tertiary_container` color to ensure the button pops against green-heavy agricultural data.

### Input Fields (Material 3)
* **Text Inputs:** Filled style using `surface_container`. No bottom line. Use a `2px` focus indicator in `primary` on the left edge only, rather than a full outline, to maintain the "No-Line" philosophy.

---

## 6. Spacing Scale (8pt System)
Precise spacing is the difference between "cluttered" and "curated."

* **2 (0.5rem):** Tight grouping (Label to Value).
* **4 (1rem):** Standard internal component padding.
* **6 (1.5rem):** External padding between cards.
* **10 (2.5rem):** Major section breaks.

---

## 7. Do's and Don'ts

### Do:
* **Do** use asymmetrical layouts on the dashboard to highlight the most important "Active Task."
* **Do** use `backdrop-blur` on navigation elements to create a sense of depth and continuity.
* **Do** rely on font weight and color (using the `on_surface_variant` token) rather than lines to separate information.

### Don't:
* **Don't** use 1px solid dividers (ever). Use whitespace or background shifts.
* **Don't** use standard Material "Level 1" shadows. They are too heavy for this organic aesthetic. Use Tonal Layering.
* **Don't** use pure black (#000000) for text. Always use `on_surface` (#1A1C1B) to maintain a soft, premium feel.