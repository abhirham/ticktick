# UI Style Guide

Source mockups inspected:

- `UI mockups/Screenshot_20260512_171107_TickTick.jpg`
- `UI mockups/Screenshot_20260512_171112_TickTick.jpg`
- `UI mockups/Screenshot_20260512_171334_TickTick.jpg`
- `UI mockups/Screenshot_20260512_175944_TickTick.jpg`

Live TickTick audit inspected:

- Android phone: Samsung `SM-S938W`.
- App package: `com.ticktick.task`.
- Theme: dark mode.
- Physical capture size: `1440x3120`.
- Android density: `560dpi`, approximately `3.5` physical pixels per `1dp`.
- Logical viewport during audit: approximately `411dp x 891dp`.

The four static mockups are Android mobile screenshots at `1440x2954`. Live audit captures were Android mobile screenshots at `1440x3120`. Values below are implementation-oriented logical pixel estimates, not raw screenshot pixels. For live-audit measurements, physical screenshot pixels were divided by approximately `3.5` to estimate Android `dp`. Where a value is estimated, the guide marks it as approximate.

## 1. Overview

The UI is a dark-mode, mobile-first task management app. It is dense but not cramped: most screens use large touch targets, roomy vertical rhythm, and high-contrast task text on black and charcoal surfaces.

Visible identity:

- App-like Android mobile interface.
- Dark-first visual system with a pure black page background and charcoal cards/sheets.
- Card-based task list on the main screen.
- Drawer navigation for lists/projects.
- Bottom sheets for quick task creation and task detail.
- Minimal elevation. Separation is achieved primarily through surface color, dim overlays, rounded corners, and spacing.
- Strong single accent color: vivid blue for primary actions, active navigation, selected tab icons, focus cursor, and date selection.
- Red is reserved for overdue/due-date warning text.
- Typography is large, bold, and system-like. Labels and titles rely on weight and scale more than decorative treatment.

Not visible:

- Desktop layouts, tablet split panes, light mode, tables, web-style forms, pagination, hover states, loading states, or error messages.
- Toasts were not observed in either the static mockups or the live audit.
- One in-app promotional banner and one anchored tooltip were observed in the live calendar screen. Use the live-audit banner and tooltip rules below for those specific components.

## 2. Design Principles

- Use black as the app canvas and charcoal as the only primary surface. The mockups do not use tinted panels except selected navigation.
- Prefer large rounded containers for grouped content. Task sections, bottom sheets, and selected drawer rows all use generous radii.
- Do not add card shadows by default. Surfaces are separated by contrast and spacing, not raised elevation.
- Keep primary actions blue and sparse. Blue appears on the FAB, active nav item, selected date affordances, cursor, and the `Postpone` action.
- Keep dangerous/time-sensitive information red. Red appears on overdue dates and the overdue date in task detail.
- Use gray for inactive chrome and metadata. Counts, completed tasks, repeat icons, unselected nav icons, and placeholders are muted.
- Avoid visible dividers inside task lists. Rows are separated by vertical spacing and alignment.
- Preserve strong left alignment. Titles, task names, drawer labels, and bottom sheet fields align to a consistent left inset.
- Use icon-only controls for top app actions and bottom navigation. Text labels appear only where the mockups show them.
- Keep touch targets large. Even icon-only controls visually sit inside roughly `44px` to `56px` hit areas.
- Use one primary information column plus a right metadata column for task rows.
- Use dim overlays for modal/sheet states. Background content remains visible but strongly subdued.
- Keep labels in the casing shown in content. System labels use title case or sentence case; user list names may be lowercase.

## 3. Color System

Measured recurring colors from the screenshots:

| Token | Approx Hex | Usage |
|---|---:|---|
| `--color-bg` | `#000000` | Main app canvas, bottom nav background, areas outside cards |
| `--color-bg-near-black` | `#050505` | Dimmed background after overlay, near-black app regions |
| `--color-surface` | `#1c1c1c` | Task cards, drawer background, quick-add sheet, task detail sheet |
| `--color-surface-raised` | `#202020` | Slightly lifted/edge surface impression, FAB shadow edge, subtle sheet variation |
| `--color-surface-popover` | `#222222` | Top-right overflow menus and nested menu surfaces |
| `--color-surface-selected` | `#232d48` | Selected drawer row background |
| `--color-surface-chip-selected` | `#1d2f55` | Selected search chips, kanban pills, and segmented sheet controls |
| `--color-keyboard-bg` | `#1e1f25` | Android keyboard background visible in quick-add mockup. System UI, not app chrome |
| `--color-keyboard-key` | `#35363c` | Android keyboard key fill visible in quick-add mockup. System UI, not app chrome |
| `--color-text` | `#e6e6e6` | Primary titles, active task names, sheet title text |
| `--color-text-strong` | `#f1f1f1` | Highest contrast text and plus icon where nearly white |
| `--color-text-muted` | `#8a8a8a` | Counts, placeholders, secondary labels, unselected metadata |
| `--color-text-subtle` | `#636363` | Completed tasks, disabled/inactive section labels, repeat icons |
| `--color-icon` | `#d9d9d9` | Active top-bar icons, drawer top icons |
| `--color-icon-muted` | `#8d8d8d` | Secondary icons in rows and sheets |
| `--color-border` | `#5e5e5e` | Unchecked checkbox outline |
| `--color-border-muted` | `#3f3f3f` | Completed checkbox fill/border and subtle control edges |
| `--color-divider` | `#343434` | Menu section dividers and bottom-sheet row dividers where visible |
| `--color-primary` | `#4774fa` | Primary blue icons, active nav icon, FAB, selected date icon/text |
| `--color-primary-bright` | `#4b78ff` | FAB and strongest blue accents |
| `--color-primary-soft-bg` | `#232d48` | Dark blue selected navigation background |
| `--color-primary-banner` | `#4f79ff` | Calendar subscription banner fill |
| `--color-primary-sidebar-mark` | `#55a8ff` | Thin blue vertical task markers on card left edge |
| `--color-danger` | `#da3e38` | Due date text in task list |
| `--color-danger-strong` | `#e64a45` | Larger overdue date in detail sheet |
| `--color-critical` | `#ff5b57` | Destructive action icon, observed in task-detail action sheet |
| `--color-success` | `#13c8a0` | Share/action success icon, observed in task-detail action sheet |
| `--color-warning` | `#f7b43b` | Pin/premium accent icon, observed in task-detail/settings surfaces |
| `--color-upgrade` | `#ff8a45` | Premium upgrade outline/text accent |
| `--color-overlay` | `rgba(0, 0, 0, 0.72)` | Modal/bottom-sheet dim overlay |
| `--color-overlay-strong` | `rgba(0, 0, 0, 0.82)` | Heavier dim seen behind quick-add sheet and task-detail sheet |
| `--color-avatar-badge` | `#d9d9d9` | Small crown badge circle on avatar |

Color usage rules:

- Use `--color-bg` for the full mobile viewport.
- Use `--color-surface` for cards, drawers, and bottom sheets. Do not create lighter gray cards unless a mockup shows them.
- Use `--color-primary` only for selected/active affordances and primary creation actions.
- Use `--color-danger` only for overdue or date-warning text. Use `--color-critical` for explicit destructive actions such as the task-detail `Delete` action icon.
- Use `--color-text-muted` for counts and placeholders, and `--color-text-subtle` for completed/disabled content.
- Selected drawer rows use a dark blue fill, not a border or underline.
- Do not introduce gradients into default app chrome. The only default glow-like effect is the soft blue shadow around the FAB.
- Gradients exist only as user-selectable background theme swatches inside the background picker. Do not use those swatches as normal panels, cards, buttons, or page backgrounds.

Uncertain values:

- Approximate value: `#4774fa` for primary blue.
  Confidence: High.
  Reason: Sampled from repeated blue icons and FAB regions.
- Approximate value: `#1c1c1c` for surfaces.
  Confidence: High.
  Reason: Dominant sampled surface color in all four screenshots.
- Approximate value: `rgba(0, 0, 0, 0.72)` for overlay.
  Confidence: Medium.
  Reason: Estimated from the dimmed main screen behind bottom sheets.

## 4. Typography

The font appears to be an Android system sans. Use:

```css
font-family: Roboto, "Google Sans", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
```

Typography scale:

| Style | Size | Weight | Line Height | Letter Spacing | Usage |
|---|---:|---:|---:|---:|---|
| App Page Title | 32px | 700 | 40px | 0 | `Today` title in top app bar |
| Drawer Account Name | 25px | 700 | 32px | 0 | User name in drawer header |
| Bottom Sheet Title Input | 28px | 400 | 36px | 0 | `What would you like to do?` quick-add placeholder |
| Task Detail Title | 34px | 700 | 42px | 0 | `Get insurance fixed` detail title |
| Section Heading | 24px | 700 | 32px | 0 | `Overdue`, `Today`, `Completed` section labels |
| Task Row Text | 25px | 400 | 32px | 0 | Active task names in list rows |
| Task Date Text | 20px | 500 | 28px | 0 | Right-aligned due dates in task list |
| Drawer Nav Text | 23px | 700 | 30px | 0 | `Inbox`, `Skin care`, list names |
| Drawer Count | 22px | 400 | 30px | 0 | Right-side list counts |
| Button/Action Text | 24px | 700 | 32px | 0 | `Postpone`, drawer `Add` |
| Secondary Sheet Text | 22px | 400 | 30px | 0 | `Description` quick-add placeholder |
| Sheet Metadata | 24px | 400 | 32px | 0 | `Last Fri, May 8` in detail sheet |
| Bottom Toolbar Text | 20px | 500 | 28px | 0 | `Today` quick-add toolbar label |
| Completed Row Text | 24px | 400 | 32px | 0 | Completed task names and dates |
| Keyboard Text | 34px | 400 | 42px | 0 | Android keyboard letters. System UI, not app chrome |
| Popover Menu Text | 24px | 400 | 32px | 0 | `View`, `Background`, `Group & Sort`, overflow rows |
| Search Field Text | 24px | 400 | 32px | 0 | Search input placeholder and typed search text |
| Search Chip Text | 18px | 500 | 24px | 0 | `Task`, `Lists`, `Filter` search pills |
| Empty State Text | 21px | 400 | 30px | 0 | Search empty-state instruction text |
| Calendar Date Number | 18px | 500 | 24px | 0 | Day numbers in calendar week strip |
| Calendar Weekday Label | 15px | 500 | 20px | 0 | `Mon`, `Tue`, `Wed` labels |
| Settings Page Title | 32px | 700 | 40px | 0 | `Settings`, `Tab Bar` page titles |
| Settings Row Title | 22px | 400 | 30px | 0 | `Tab Bar`, `Appearance`, settings rows |
| Settings Row Description | 17px | 400 | 24px | 0 | Multi-line settings descriptions |
| Plan Day Hero Title | 44px | 700 | 54px | 0 | `Plan Your Day` onboarding title |
| Plan Day Body | 24px | 400 | 34px | 0 | Plan-your-day explanatory paragraph |

Text casing:

- Page titles and system list names use title case: `Today`, `Inbox`, `Skin care`, `Utilities`, `Bank`.
- The user-created list `today only` stays lowercase.
- Placeholders use sentence case: `What would you like to do?`, `Description`.
- Action labels use title case: `Postpone`, `Add`.
- No all-caps labels are visible.
- No negative letter spacing is visible. Use normal letter spacing.

Weight behavior:

- Strong contrast between headings/nav labels (`700`) and task/body text (`400`).
- Dates use medium weight, enough to read as metadata but less dominant than task titles.
- Completed content uses the same approximate size as active content but much lower contrast.

Line height:

- Compact but readable. Use line heights about `1.2` to `1.35` for large text.
- Long task text truncates with ellipsis on a single line.

## 5. Spacing System

The mockups appear to follow a `4px` base with most layout decisions landing on an `8px` rhythm.

| Token | Value | Usage |
|---|---:|---|
| `--space-1` | `4px` | Tiny icon/text separation, cursor width context, small optical nudges |
| `--space-2` | `8px` | Compact icon gaps, chevron/count gaps |
| `--space-3` | `12px` | Small internal gaps, list marker inset |
| `--space-4` | `16px` | Main horizontal page padding, bottom sheet padding |
| `--space-5` | `20px` | Checkbox-to-text gap, row side breathing room |
| `--space-6` | `24px` | Card padding, major row vertical padding |
| `--space-8` | `32px` | Section gaps, drawer row vertical rhythm |
| `--space-10` | `40px` | Large empty-space rhythm in drawer/header |
| `--space-12` | `48px` | App-bar/icon hit area and large bottom-sheet gaps |
| `--space-16` | `64px` | Large vertical separation between grouped sections |

Observed spacing:

- Page side padding: approximate value `16px`.
  Confidence: Medium.
  Reason: Main cards start about one visual gutter from screen edge.
- Top app bar side padding: approximate value `16px`.
  Confidence: Medium.
  Reason: Hamburger aligns near the same left inset used by cards.
- Top app bar height: approximate value `88px`.
  Confidence: Medium.
  Reason: Includes safe-area/top breathing room and large title alignment.
- Gap below top app bar before first card: approximate value `40px`.
  Confidence: Medium.
  Reason: First card starts well below title row.
- Main card horizontal padding: approximate value `16px` to `18px`.
  Confidence: Medium.
  Reason: Section heading and task rows align to a consistent inner inset.
- Main card vertical padding: approximate value `24px` top and bottom.
  Confidence: Medium.
  Reason: Heading and last row have generous breathing room.
- Task row height: approximate value `64px` to `72px`.
  Confidence: Medium.
  Reason: List rows are large touch targets with no dividers.
- Checkbox-to-text gap: approximate value `18px` to `20px`.
  Confidence: Medium.
  Reason: Text starts clearly after checkbox, not tight.
- Task text-to-date gap: flexible. Task text truncates before date column.
- Gap between cards: approximate value `16px`.
  Confidence: Medium.
  Reason: `Overdue`, `Today`, and `Completed` cards are separated by a black gutter.
- FAB edge inset: approximate value `18px` to `24px` from right and bottom nav area.
  Confidence: Medium.
  Reason: FAB floats above bottom nav and aligns visually near screen edge.
- Drawer horizontal padding: approximate value `24px`.
  Confidence: Medium.
  Reason: Avatar and row icons sit farther from edge than main list checkboxes.
- Drawer row height: approximate value `56px` to `64px`.
  Confidence: Medium.
  Reason: Selected row has a large rounded pill height.
- Bottom sheet padding: approximate value `16px` horizontal, `28px` top.
  Confidence: Medium.
  Reason: Text begins close to sheet edge but still with mobile-safe inset.
- Quick-add toolbar vertical gap from description: approximate value `44px`.
  Confidence: Low.
  Reason: Keyboard covers part of the flow and sheet content may be compressed.

## 6. Layout System

### Mobile App Frame

- Full viewport background uses `--color-bg`.
- Screens are portrait mobile. Use a mobile-first width around `360px` to `430px` logical pixels.
- Content extends nearly full width with `16px` outer gutters.
- Safe area is respected at top and bottom.
- No visible desktop, tablet, or landscape layout.

### Today Task List Layout

- Top app bar spans the viewport.
- Left: hamburger icon.
- Center-left: page title `Today`, aligned after the hamburger, not centered in the screen.
- Right: two icon buttons, lightbulb/sparkle and vertical overflow.
- Main content is a vertical stack of rounded section cards.
- Cards use full available width inside page gutters.
- Each card contains a header row and task rows.
- Header row: section name left, optional blue action (`Postpone`) and count/chevron right.
- Task rows use three columns:
  - Checkbox column, fixed.
  - Task title, flexible and ellipsized.
  - Date/status icon column, right aligned.
- Completed card follows same card structure but uses muted colors.
- Bottom nav is fixed to bottom with three icon slots.
- FAB floats above bottom nav at bottom-right.

### Drawer Layout

- Drawer slides from left and covers about `86%` of the screen width.
- Remaining right strip is a dim overlay.
- Drawer background uses `--color-surface`.
- Header row: avatar left, account name, then three icon buttons aligned to the right.
- Nav list is a vertical stack with large row height and no dividers.
- Selected row is a full-width rounded rectangle with dark blue background.
- Counts are right aligned in a fixed metadata column.
- Bottom action row remains at bottom: `Add` on the left, manage/settings icon on the right.

### Quick-Add Bottom Sheet Layout

- Background app content is dimmed behind the sheet.
- Sheet is anchored to the bottom, above the system keyboard.
- Sheet is full width with rounded top corners only.
- First line is the task title input.
- Second line is description input.
- Bottom toolbar is a horizontal icon/action row:
  - Date action with calendar icon and text.
  - Flag.
  - Tag.
  - Project/list selector.
  - More actions.
  - Microphone aligned to the far right.
- Android keyboard below is system UI and should not be recreated as part of app components.

### Task Detail Bottom Sheet Layout

- Background is dimmed heavily.
- Sheet is full width and begins in the lower half of the screen.
- Rounded top corners only.
- Header row has project/list selector left and flag/overflow controls right.
- Date row has checkbox left and overdue date text right.
- Main title is large and left aligned.
- Bottom action icons are anchored near the lower-left edge with generous spacing.

### Breakpoints

Not clearly visible in the provided mockups.
Recommended default: build for a single mobile breakpoint first. For wider screens, keep the mobile panel width constrained or maintain the same relative gutters rather than expanding rows dramatically.

## 7. Border Radius

| Token | Value | Usage |
|---|---:|---|
| `--radius-xs` | `4px` | Small icon details and thin vertical task markers |
| `--radius-sm` | `6px` | Checkbox corners |
| `--radius-md` | `10px` | Keyboard keys and small controls, where needed |
| `--radius-lg` | `14px` | Selected drawer row, medium rounded controls |
| `--radius-xl` | `20px` | Task section cards |
| `--radius-2xl` | `28px` | Bottom sheet top corners |
| `--radius-full` | `999px` | FAB circle, avatar circle, badge pills/circular badges |

Component radius rules:

- Task cards: use `--radius-xl` on all corners.
- Drawer selected nav item: use `--radius-lg`.
- Bottom sheets: use `--radius-2xl` for top-left and top-right only; bottom corners remain square when sheet reaches viewport bottom.
- Checkboxes: use `--radius-sm`, not circular.
- FAB: use `--radius-full`.
- Avatar: use `--radius-full`.
- Small crown badge: use `--radius-full`.

## 8. Borders and Dividers

Visible border system:

- Borders are subtle and sparse.
- No card border is visible on main task cards, drawer background, or bottom sheets.
- No table/list dividers are visible.
- Checkbox borders are the clearest recurring border.
- Active/selected navigation uses fill color instead of a border.
- Focus cursor uses a blue vertical bar, not an input outline.

| Border Token | Value | Usage |
|---|---:|---|
| `--border-width-hairline` | `1px` | Subtle dividers if absolutely needed, though none are visible |
| `--border-width-control` | `2px` | Checkbox outline and icon strokes |
| `--border-color-control` | `#5e5e5e` | Unchecked checkbox border |
| `--border-color-control-muted` | `#3f3f3f` | Completed checkbox state |
| `--border-color-focus` | `#4774fa` | Text cursor and selected accents |
| `--border-color-danger` | `#da3e38` | Recommended for validation if needed, not visible |

Input focus:

- Text fields in quick-add do not show boxes or underlines.
- Focus is represented by a vertical blue cursor at the start of the title field.

Error/focus borders:

- Not clearly visible in the provided mockups.
Recommended default: if an error state is required, keep the border thin (`2px`) and use `--color-danger`; do not add heavy outlines or alert boxes.

## 9. Shadows and Elevation

The UI is nearly flat.

| Token | Value | Usage |
|---|---:|---|
| `--shadow-none` | `none` | Default for cards, drawer rows, bottom nav, most sheets |
| `--shadow-fab` | `0 8px 28px rgba(71, 116, 250, 0.28)` | Soft blue glow around the primary FAB |
| `--shadow-sheet` | `0 -8px 24px rgba(0, 0, 0, 0.28)` | Optional subtle lift for bottom sheets |
| `--shadow-drawer-edge` | `8px 0 24px rgba(0, 0, 0, 0.25)` | Optional drawer edge over dimmed content |

Rules:

- Do not use heavy card shadows.
- Cards should look inset into the dark canvas through surface contrast only.
- Bottom sheets may use a very subtle top shadow, but the dominant separation is overlay dimming.
- FAB is the only clearly elevated control.

## 10. Icons

Icon style:

- Mostly outlined/stroke icons with rounded line caps.
- Approximate stroke width: `2.25px` to `2.75px`.
- Top app icons are large and light gray/white.
- Active icons are blue.
- Inactive navigation icons are medium gray.
- Icons align vertically centered with adjacent text.
- Icon-only controls should still provide `44px` to `56px` hit targets.

Approximate sizes:

| Icon Context | Size | Color | Notes |
|---|---:|---|---|
| Top app hamburger | `32px` | `--color-icon` | Three horizontal lines |
| Top app action icons | `32px` | `--color-icon` | Lightbulb/sparkle and overflow |
| Drawer header icons | `32px` | `--color-icon` | Search, bell, hex/settings |
| Drawer nav icons | `28px` | Blue or white | Left-aligned in fixed icon column |
| Task row repeat icon | `22px` | `--color-text-subtle` | Right metadata column below/near date |
| Bottom nav icons | `30px` | Blue active or gray inactive | No labels visible |
| Quick-add toolbar icons | `28px` to `32px` | Blue active date, gray others | Stroke icons |
| Task detail bottom icons | `28px` to `32px` | `--color-icon-muted` | Tag, checklist, attachment |
| FAB plus | `34px` | White | Centered in blue circular button |

Preferred library:

- Not clearly visible in the provided mockups.
Recommended default: use a rounded stroke icon set such as Lucide only if the project already uses it, and adjust stroke width/size to match the screenshots.

Do not:

- Mix filled Material-style icons with the outlined icon language except for the selected bottom-nav checkbox tile and avatar badge.
- Put icon buttons in visible rounded-square backgrounds unless shown. Most icon buttons are backgroundless.

## 11. Buttons

### Primary FAB

- Usage: create a new task from the main `Today` screen.
- Shape: circle.
- Size: approximate value `64px`.
  Confidence: Medium.
  Reason: Large floating action button appears about one sixth of mobile width.
- Background: `--color-primary-bright`.
- Text/icon: white plus, `34px`.
- Border: none.
- Radius: `--radius-full`.
- Shadow: `--shadow-fab`.
- Placement: bottom-right above bottom navigation, `18px` to `24px` from right edge.
- Hover state: not visible.
  Recommended default: slightly brighten to `#5b86ff`.
- Active state: not visible.
  Recommended default: darken to `#3f68e6`.
- Disabled/loading state: not visible.
  Recommended default: use muted gray fill and remove glow.

### Text Action Button

Visible example: `Postpone` in the `Overdue` card header.

- Usage: contextual section-level action.
- Background: transparent.
- Text color: `--color-primary`.
- Font: `24px`, `700`.
- Border: none.
- Padding: compact horizontal padding, approximate value `8px`.
- Height: align to section header row, approximate value `40px`.
- Radius: none visible.
- Hover/active: not visible.
  Recommended default: do not add a pill background unless pressed; use lower opacity for press feedback.

### Drawer Add Button

Visible example: bottom-left `Add`.

- Usage: add a list/project from drawer.
- Background: transparent.
- Icon: outlined plus inside rounded square, white.
- Text: `Add`, light gray/white, bold.
- Font: `23px`, `700`.
- Gap: approximate value `18px`.
- Hit height: approximate value `56px`.
- Border: none besides icon strokes.
- Hover/active: not visible.

### Icon Button

- Usage: menu, search, notifications, settings, overflow, flag, tag, attachment, microphone.
- Background: transparent.
- Size: icon `28px` to `34px`, hit target `44px` to `56px`.
- Color: `--color-icon` for primary chrome, `--color-icon-muted` for secondary toolbar actions.
- Border: none.
- Radius: `--radius-full` for hit area if a pressed state is implemented.
- Pressed state: not visible.
  Recommended default: use a subtle `rgba(255,255,255,0.08)` circular background on press only.

### Secondary Button

Visible in the live calendar subscription banner.

- Use compact rounded rectangles.
- Secondary/dismissive action can use a semi-transparent dark/blue fill over a colored banner.
- Text is white or light.
- Do not use browser-default gray buttons.

### Destructive Button

Visible in the live task-detail overflow action sheet as a destructive action icon.

- Use red/critical icon color and compact label.
- Keep the tile background transparent or dark, not filled red.
- Do not use a large filled red button unless a future TickTick screen shows one.
- Red date text remains `--color-danger`; destructive actions use `--color-critical`.

### Loading Button

Not clearly visible in the provided mockups.
Recommended default: keep button dimensions unchanged and replace icon/text with a same-size spinner in muted or white color.

## 12. Inputs and Forms

### Quick-Add Title Input

- Visible in `Screenshot_20260512_171334_TickTick.jpg`.
- Layout: full-width plain text input inside bottom sheet.
- Background: transparent on `--color-surface`.
- Border: none.
- Label: none.
- Placeholder: `What would you like to do?`.
- Placeholder color: `--color-text-muted`.
- Text size: approximate value `28px`.
  Confidence: Medium.
  Reason: Larger than drawer nav text and close to sheet title scale.
- Weight: `400`.
- Line height: `36px`.
- Padding: no boxed input padding beyond sheet inset.
- Focus: blue vertical cursor at the left edge of text.
- Required indicator: not visible.
- Error state: not visible.

### Quick-Add Description Input

- Visible in `Screenshot_20260512_171334_TickTick.jpg`.
- Layout: second text line below title input.
- Background: transparent.
- Border: none.
- Placeholder: `Description`.
- Placeholder color: muted gray, slightly dimmer than title placeholder.
- Text size: approximate value `22px`.
- Gap from title: approximate value `14px` to `18px`.

### Task Detail Text Fields

- Visible in `Screenshot_20260512_175944_TickTick.jpg`.
- The task title appears as large editable text, not inside a bordered field.
- No visible textarea border, underline, or field background.
- Metadata/date row precedes title.

### Checkbox

- Unchecked size: approximate value `24px` square.
  Confidence: Medium.
  Reason: Appears slightly smaller than task text cap height but large enough for touch.
- Border: `2px solid --color-border`.
- Radius: `--radius-sm`.
- Background: transparent on surface.
- Checked/completed state: muted gray filled rounded square with dark check mark.
- Checked state does not use blue in completed list.
- Placement: left column, vertically centered in task row.

### Select/Dropdown

- Visible as chevrons beside section counts and drawer/detail list names.
- No boxed select control is visible.
- Use text plus small chevron icon inline.
- Background: transparent.
- Selected project/list in detail sheet: `Inbox` text with double chevron indicator.

### Search Input

Not clearly visible in the provided mockups. Search appears only as an icon in drawer header.
Recommended default: if implementing search, use a plain or surface-filled field consistent with bottom-sheet inputs, not a browser-default bordered input.

### Textarea

Not clearly visible beyond the plain `Description` line.
Recommended default: transparent textarea inside a sheet with no border, using muted placeholder text.

### Radio, Switch, Date Picker, File Upload

Not clearly visible in the provided mockups.
Recommended default: use the checkbox/select/icon-button patterns above before inventing new boxed controls.

### Form Layout Patterns

- Single-column, plain text fields inside bottom sheets.
- No labels above inputs in visible sheets.
- No two-column forms.
- No modal form footers with save/cancel actions.
- Controls are mostly icon toolbars below text fields.

## 13. Cards and Panels

### Task Section Card

- Background: `--color-surface`.
- Border: none.
- Shadow: none.
- Radius: `--radius-xl`.
- Padding: approximate value `16px` horizontal and `24px` vertical.
- Width: full available width inside page gutters.
- Header: section title left; actions/count/chevron right.
- Body: vertical list of task rows.
- Nested cards: not visible.
- Hoverable cards: not visible.
- Selected cards: not visible.

Task row details:

- No row dividers.
- Single-line task titles.
- Due dates align to the right and use red for overdue.
- Recurring indicator icons appear in muted gray under/near some dates.
- Thin blue markers can appear on the card left edge for grouped items/projects.

### Drawer Panel

- Background: `--color-surface`.
- Covers most of the screen width.
- No card border.
- No visible row dividers.
- Selected row uses `--color-surface-selected`.

### Bottom Sheet Panel

- Background: `--color-surface`.
- Top corners: `--radius-2xl`.
- Full-width.
- Anchored to bottom.
- Uses dim overlay over the rest of the app.
- No visible header divider or footer divider.

When to use cards vs plain sections:

- Use cards for grouped task sections on the main page.
- Use plain drawer rows for navigation lists.
- Use full-width bottom sheets for creation/detail flows.
- Do not place cards inside cards. No nested card pattern is visible.

## 14. Navigation

### Top App Bar

- Layout: horizontal.
- Left icon: hamburger.
- Title: `Today`, large and bold, left aligned after menu icon.
- Right icons: lightbulb/sparkle and vertical overflow.
- Background: `--color-bg`.
- Border: none.
- Shadow: none.
- Height: approximate value `88px`.

### Bottom Navigation

- Visible on main `Today` screen.
- Background: `--color-bg`.
- Three evenly spaced destinations.
- Active item: left destination, blue rounded-square checkbox icon.
- Inactive items: gray calendar and hex/profile icons.
- No visible text labels in the observed main bottom nav; accessibility text may exist in the native hierarchy.
- Icons are centered in their slots.
- Bottom safe area is black.

### Drawer Navigation

- Row structure: icon, label, right-aligned count.
- Active row: dark blue rounded rectangle fill.
- Active icon: blue.
- Active label: light text.
- Inactive text: light gray/white, bold.
- Inactive counts: muted gray.
- Row padding: approximate value `16px` vertical, `20px` horizontal.
- Row radius: `--radius-lg`.
- No dividers between rows.

### Tabs, Breadcrumbs, Stepper, Mobile Nav Menus

- Top-level browser-style tabs are not visible.
- Live TickTick uses compact segmented controls and filter chips in specific contexts: search filters, kanban date groups, background picker, and group/sort sheets.
- Breadcrumbs are not visible.
- Steppers are not visible.
- Drawer acts as the mobile navigation menu.

## 15. Tables, Lists, and Data Display

### Task List

- Row height: approximate value `64px` to `72px`.
- Cell padding: task card padding plus row vertical spacing; no grid/table borders.
- Primary text: large, light, single-line ellipsis.
- Secondary metadata: due date at right, red for overdue and blue for timed task in `Today` card.
- Recurrence icons: right column below/near date on recurring rows.
- Checkbox: left column.
- Completed rows: muted text and checked muted checkbox.
- Empty table/list state: not visible.
- Hover state: not visible.
- Selected row state: not visible in task list.
- Sorting indicators: not visible.
- Pagination: not visible.

### Drawer List

- Similar list row structure but with nav icons and counts.
- Counts align to far right.
- Selected row uses filled background instead of a leading indicator.

### Status Counts

- Counts appear as standalone muted numbers:
  - `8` in `Overdue` card header.
  - `1` in `Today` card header.
  - `2` in `Completed` card header.
  - Drawer counts `9`, `21`, `1`, `3`, `6`, `9`.
- Counts are not badges or pills.

## 16. Badges, Tags, and Status Indicators

### Count Indicator

- Shape: no container.
- Text only.
- Color: `--color-text-muted`.
- Font: `22px` to `24px`, regular.
- Placement: right side of card headers or drawer rows.

### Avatar Crown Badge

- Shape: small circle overlapping avatar top-right.
- Background: light gray.
- Icon: white crown.
- Border: not clearly visible.
- Size: approximate value `22px`.
  Confidence: Low.
  Reason: Badge is small in drawer header and partly image-dependent.

### Due Date Status

- Overdue dates use red text without a pill background.
- Timed task uses blue text (`3:00p.m.`) in the Today card.
- Completed date metadata uses muted gray.

### Project/Group Marker

- Thin vertical blue bars appear on the left edge of the overdue card beside some task groups.
- Width: approximate value `3px` to `4px`.
- Height: approximate value `44px` to `52px`.
- Color: `--color-primary-sidebar-mark`.
- Radius: small, likely `--radius-xs`.

Tags:

- Tag icon is visible in toolbars, but tag chips are not visible.
Recommended default: if tags are needed, use muted text/icon styling until a visible chip pattern exists.

## 17. Alerts, Toasts, and Messages

Not clearly visible in the provided mockups.

Live audit note:

- A calendar subscription banner and a `Tap to go today` coach-mark tooltip were observed on the Calendar screen.
- Use the Calendar rules in section 35 for those components.

Recommended default:

- Use bottom sheets or inline text before adding bright alert banners.
- Keep success/info/warning/error messages on dark surfaces.
- Use icon plus text with no heavy border.
- Error text should use `--color-danger`.
- Info/selected messages should use `--color-primary`.
- Radius should follow `--radius-lg` for compact message surfaces.

Do not add:

- Light-mode toast cards.
- Heavy drop shadows.
- Bright filled warning yellow panels.
- Browser-default validation bubbles.

## 18. Modals, Dialogs, Drawers, and Popovers

### Drawer

- Placement: left.
- Width: approximate value `86vw`.
  Confidence: Medium.
  Reason: Mockup shows drawer ending around the rightmost 14% of the screen.
- Background: `--color-surface`.
- Overlay: right side is darker/dimmed.
- Shadow: optional subtle edge shadow only.
- Corners: square. Drawer itself does not show rounded outside corners.
- Header: avatar, account name, icon actions.
- Footer: `Add` action left and manage/settings icon right.

### Quick-Add Bottom Sheet

- Placement: bottom, above keyboard.
- Width: `100vw`.
- Background: `--color-surface`.
- Radius: `--radius-2xl` on top corners only.
- Overlay: `--color-overlay-strong`.
- Padding: approximate `16px` horizontal, `28px` top.
- Header: no explicit header.
- Footer: icon toolbar inside sheet.
- Close affordance: not visible.

### Task Detail Bottom Sheet

- Placement: bottom.
- Width: `100vw`.
- Height: approximate `42vh`.
  Confidence: Low.
  Reason: Screenshot captures a lower-half sheet; exact expanded/collapsed state is uncertain.
- Background: `--color-surface`.
- Radius: `--radius-2xl` top corners.
- Header: list selector left, flag and overflow right.
- Footer/actions: icon row near lower-left.
- Close affordance: not visible.

### Popovers/Dropdowns

Not clearly visible in the original static mockups, but multiple popovers were observed during the live audit.

Recommended default:

- Use `--color-surface-popover`.
- Use `--radius-xl` to `--radius-2xl`.
- Use row heights around `40dp`.
- Use the detailed popover rules in section 31.

## 19. Images, Avatars, and Media

### Avatar

- Visible in drawer header.
- Shape: circular.
- Size: approximate value `48px`.
  Confidence: Medium.
  Reason: Avatar is visually similar to a large touch/avatar standard beside account name.
- Image fit: cover.
- Badge: small circular crown badge overlaps the avatar top-right.

### Other Images/Media

No thumbnails, image cards, or media previews are visible in the static mockups.

Live audit additions:

- Search empty states use centered, flat, muted gray illustrations with blue accents.
- Plan Your Day onboarding uses a larger centered illustration.
- Calendar banner uses a compact calendar icon illustration.
- Do not substitute generic stock photos for these app illustrations.

Recommended default:

- Use circular avatars for people.
- Use `object-fit: cover`.
- Use no decorative image backgrounds unless future mockups show them.

## 20. Component Inventory

| Component | Seen In Mockup(s) | Description | Key Styling Notes |
|---|---|---|---|
| Mobile App Canvas | All mockups | Full-screen dark app base | Pure black background, no texture |
| Top App Bar | `Screenshot_20260512_171107_TickTick.jpg`, dimmed in sheet mockups | Header with menu, title, utility icons | Black background, large bold title, icon-only controls |
| Hamburger Icon Button | `Screenshot_20260512_171107_TickTick.jpg`, dimmed in sheet mockups | Opens drawer | White/gray three-line stroke icon |
| Utility Icon Button | `Screenshot_20260512_171107_TickTick.jpg` | Lightbulb/sparkle and overflow controls | Large outline icons, transparent background |
| Task Section Card | `Screenshot_20260512_171107_TickTick.jpg` | Rounded task group container | Charcoal surface, large radius, no shadow/border |
| Section Header | `Screenshot_20260512_171107_TickTick.jpg` | Card title plus optional actions/count | Bold text, right-aligned metadata |
| Text Action | `Screenshot_20260512_171107_TickTick.jpg` | `Postpone` action | Blue bold text, transparent background |
| Task Row | `Screenshot_20260512_171107_TickTick.jpg` | Checkbox, task title, due metadata | Large row, no divider, ellipsis text |
| Unchecked Checkbox | `Screenshot_20260512_171107_TickTick.jpg`, `Screenshot_20260512_175944_TickTick.jpg` | Task completion control | Rounded square, gray stroke, transparent fill |
| Checked Checkbox | `Screenshot_20260512_171107_TickTick.jpg` | Completed task state | Muted gray fill with dark check |
| Due Date Text | `Screenshot_20260512_171107_TickTick.jpg`, `Screenshot_20260512_175944_TickTick.jpg` | Overdue metadata | Red text, no badge |
| Time Text | `Screenshot_20260512_171107_TickTick.jpg` | Scheduled time | Blue text at right of Today card |
| Recurrence Icon | `Screenshot_20260512_171107_TickTick.jpg` | Repeating task marker | Muted gray circular arrows |
| Vertical Project Marker | `Screenshot_20260512_171107_TickTick.jpg` | Blue marker on card left edge | Thin vertical blue bar |
| Completed Section | `Screenshot_20260512_171107_TickTick.jpg` | Completed task card | Same card style, muted text |
| Floating Action Button | `Screenshot_20260512_171107_TickTick.jpg` | New task action | Blue circular button, white plus, soft blue glow |
| Bottom Navigation | `Screenshot_20260512_171107_TickTick.jpg` | Three icon-only destinations | Active blue icon tile, inactive gray icons |
| Drawer Panel | `Screenshot_20260512_171112_TickTick.jpg` | Left slide-out navigation | Charcoal full-height panel with right dim overlay |
| Avatar | `Screenshot_20260512_171112_TickTick.jpg` | Account identity image | Circular image, crown badge |
| Drawer Header Actions | `Screenshot_20260512_171112_TickTick.jpg` | Search, bell, settings/profile controls | Large white stroke icons |
| Drawer Nav Item | `Screenshot_20260512_171112_TickTick.jpg` | List/project navigation row | Icon left, bold label, count right |
| Active Drawer Nav Item | `Screenshot_20260512_171112_TickTick.jpg` | Selected `Today` row | Dark blue rounded fill, blue calendar icon |
| Drawer Add Action | `Screenshot_20260512_171112_TickTick.jpg` | Bottom `Add` control | Outlined plus-square icon and bold label |
| Quick-Add Bottom Sheet | `Screenshot_20260512_171334_TickTick.jpg` | Create-task composer | Full-width bottom sheet, rounded top corners |
| Plain Text Input | `Screenshot_20260512_171334_TickTick.jpg` | Task title/description fields | No border, muted placeholder, blue cursor |
| Quick-Add Toolbar | `Screenshot_20260512_171334_TickTick.jpg` | Date, flag, tag, list, more, mic actions | Horizontal icon row, active date blue |
| Date Toolbar Action | `Screenshot_20260512_171334_TickTick.jpg` | Selected date `Today` | Blue calendar icon and blue text |
| System Keyboard | `Screenshot_20260512_171334_TickTick.jpg` | Android keyboard visible below composer | System UI, not app component |
| Task Detail Bottom Sheet | `Screenshot_20260512_175944_TickTick.jpg` | Detail/editor view for one task | Full-width sheet, rounded top corners, sparse controls |
| Detail Header Selector | `Screenshot_20260512_175944_TickTick.jpg` | `Inbox` selector | Bold text with small chevron stack |
| Detail Action Icons | `Screenshot_20260512_175944_TickTick.jpg` | Flag, overflow, tag, checklist, attachment | Gray/white stroke icons, transparent buttons |

## 21. Page-by-Page Notes

### `Screenshot_20260512_171107_TickTick.jpg`

- Overall layout: main `Today` task list in dark mode.
- Background: pure black.
- Top app bar:
  - Hamburger icon on left.
  - Large `Today` title after icon.
  - Lightbulb/sparkle icon and vertical overflow icon on right.
  - No app-bar border or shadow.
- Main content:
  - Vertical stack of rounded cards.
  - First card is `Overdue`, second is `Today`, third is `Completed`.
  - Cards use `#1c1c1c` surface with large rounded corners.
- `Overdue` card:
  - Header has `Overdue` left, `Postpone` blue action near right, count `8`, chevron.
  - Rows show unchecked rounded-square checkboxes.
  - Task titles are large light text and truncate with ellipsis when long.
  - Due dates are red and right aligned: `Nov 18, 2025`, `Dec 10, 2025`, `Dec 20, 2025`, `Apr 24`, `Apr 30`, `May 2`, `May 8`, `May 10`.
  - Some rows include muted repeat icons below/near the date.
  - Thin blue vertical markers appear on the left card edge beside some task groups.
- `Today` card:
  - Header `Today`, count `1`, chevron.
  - One task row: `Get Goodlife Membership`.
  - Time `3:00p.m.` appears in blue at right.
- `Completed` card:
  - Header, count, checkboxes, task names, and dates are all muted.
  - Checked boxes are muted gray fills with dark check marks.
  - Visible completed rows: `Vitamin D`, `Throw egg white .`
- FAB:
  - Large blue circular `+` button floats bottom-right above bottom nav.
  - Soft blue glow visible beneath/right of button.
- Bottom navigation:
  - Three icon-only destinations.
  - Left destination active with blue rounded-square check icon.
  - Center and right icons are gray.

### `Screenshot_20260512_171112_TickTick.jpg`

- Overall layout: left navigation drawer over dark app.
- Drawer:
  - Charcoal `#1c1c1c` panel covers most of the viewport.
  - A narrow dark overlay remains on the right edge.
  - No visible drawer border; possible subtle edge dim.
- Header:
  - Circular avatar at top-left.
  - Small circular crown badge overlaps avatar top-right.
  - Account name `Abhirham Savarap` is large and bold.
  - Search, bell, and hex/settings icons sit on the right.
- Navigation rows:
  - `Today` is selected.
  - Selected row has dark blue rounded rectangle background.
  - Selected calendar icon is blue, label is light, count `9` is muted.
  - Other visible rows: `Inbox` count `21`, `today only` count `1`, `Skin care` count `3`, `Utilities` count `6`, `Bank` count `9`.
  - Blue icons are used for `Inbox` and `today only`; white list-line icons for custom lists.
  - Labels are bold and left aligned; counts are right aligned.
  - No dividers.
- Footer:
  - Bottom-left `Add` action with plus-square icon and bold label.
  - Bottom-right list/settings icon.

### `Screenshot_20260512_171334_TickTick.jpg`

- Overall layout: quick-add composer opened over dimmed `Today` screen.
- Background:
  - Main app content remains visible but heavily dimmed.
  - Top app bar and overdue list are nearly blacked out, indicating modal focus.
- Bottom sheet:
  - Full-width charcoal sheet with rounded top corners.
  - Anchored above Android system keyboard.
  - No drag handle visible.
  - No close button visible.
- Composer fields:
  - First line placeholder: `What would you like to do?`.
  - Blue vertical cursor at far left indicates focused title input.
  - Second line placeholder: `Description`.
  - Inputs are plain text, no borders or boxes.
- Toolbar:
  - Left item has blue calendar icon and blue `Today` text.
  - Next icons are flag, tag, project/list selector, more ellipsis, and microphone.
  - Secondary toolbar icons use muted gray.
  - Microphone is aligned far right.
- System UI:
  - Android keyboard is visible and should be treated as system-provided, not an app component.
  - A small floating rounded square voice/assistant icon appears near the right side over the dimmed content. Treat as system overlay, not app UI.

### `Screenshot_20260512_175944_TickTick.jpg`

- Overall layout: task detail bottom sheet over dimmed `Today` screen.
- Background:
  - Main task list is visible but heavily dimmed.
- Bottom sheet:
  - Full-width charcoal surface.
  - Rounded top corners.
  - Begins in the lower half of the screen.
  - No visible border or divider.
- Header:
  - Left text `Inbox` with small chevron/selector icon.
  - Right side has flag icon and vertical overflow menu.
- Date/status row:
  - Large unchecked checkbox at left.
  - Red overdue date text: `Last Fri, May 8`.
- Main content:
  - Large bold task title: `Get insurance fixed`.
  - Wide empty body area below title.
- Bottom actions:
  - Tag icon, checklist/list icon, and attachment icon align along lower-left.
  - Icons use muted gray strokes.
  - No save button, cancel button, or keyboard visible.

## 22. Implementation Rules for Agents

- Do not invent new colors unless necessary. Use the documented tokens first.
- Use `--color-bg` for the viewport and `--color-surface` for cards, drawers, and sheets.
- Match the spacing scale. Do not compress task rows below large mobile touch targets.
- Use existing component patterns before creating new ones.
- Keep border radius consistent: cards are large-rounded, sheets have rounded top corners, checkboxes are small-rounded squares.
- Use primary blue sparingly. It should mean selected, active, focused, or primary create action.
- Preserve visual hierarchy from the mockups: page title, section headers, task titles, metadata, then muted chrome.
- Match label casing exactly where labels are visible.
- Match icon size and alignment. Icons should feel large, rounded, and stroke-based.
- Do not introduce heavy shadows. The mockups use subtle/no elevation except the FAB glow.
- Do not use generic browser default form styles.
- Do not create components that look like a different design system, especially light cards, bordered web inputs, dense desktop tables, or purple gradients.
- Prefer composition of documented primitives: surface, rounded section, row, checkbox, icon button, metadata text.
- Use no visible row dividers in task lists unless future mockups show them.
- Keep completed content muted rather than struck through unless a future mockup shows strikethrough.
- Treat Android keyboard and floating system overlays as system UI, not app UI to recreate.
- When uncertain, choose the option that visually matches the mockups most closely, not the option that looks generically modern.

## 23. Design Tokens

```css
:root {
  /* Colors */
  --color-bg: #000000;
  --color-bg-near-black: #050505;
  --color-surface: #1c1c1c;
  --color-surface-raised: #202020;
  --color-surface-popover: #222222;
  --color-surface-selected: #232d48;
  --color-surface-chip-selected: #1d2f55;
  --color-primary: #4774fa;
  --color-primary-bright: #4b78ff;
  --color-primary-soft-bg: #232d48;
  --color-primary-banner: #4f79ff;
  --color-primary-sidebar-mark: #55a8ff;
  --color-danger: #da3e38;
  --color-danger-strong: #e64a45;
  --color-critical: #ff5b57;
  --color-success: #13c8a0;
  --color-warning: #f7b43b;
  --color-upgrade: #ff8a45;
  --color-text: #e6e6e6;
  --color-text-strong: #f1f1f1;
  --color-text-muted: #8a8a8a;
  --color-text-subtle: #636363;
  --color-icon: #d9d9d9;
  --color-icon-muted: #8d8d8d;
  --color-border: #5e5e5e;
  --color-border-muted: #3f3f3f;
  --color-divider: #343434;
  --color-avatar-badge: #d9d9d9;
  --color-overlay: rgba(0, 0, 0, 0.72);
  --color-overlay-strong: rgba(0, 0, 0, 0.82);
  --color-keyboard-bg: #1e1f25;
  --color-keyboard-key: #35363c;

  /* Typography */
  --font-sans: Roboto, "Google Sans", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --font-size-xs: 14px;
  --font-size-sm: 16px;
  --font-size-md: 20px;
  --font-size-lg: 22px;
  --font-size-xl: 24px;
  --font-size-2xl: 28px;
  --font-size-3xl: 32px;
  --font-size-4xl: 34px;
  --font-weight-regular: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;
  --line-height-tight: 1.2;
  --line-height-normal: 1.3;
  --letter-spacing-normal: 0;

  /* Spacing */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 24px;
  --space-8: 32px;
  --space-10: 40px;
  --space-12: 48px;
  --space-16: 64px;

  /* Radius */
  --radius-xs: 4px;
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 14px;
  --radius-xl: 20px;
  --radius-2xl: 28px;
  --radius-full: 999px;

  /* Borders */
  --border-width-hairline: 1px;
  --border-width-control: 2px;
  --border-control: var(--border-width-control) solid var(--color-border);

  /* Shadows */
  --shadow-none: none;
  --shadow-fab: 0 8px 28px rgba(71, 116, 250, 0.28);
  --shadow-sheet: 0 -8px 24px rgba(0, 0, 0, 0.28);
  --shadow-drawer-edge: 8px 0 24px rgba(0, 0, 0, 0.25);

  /* Z-index */
  --z-base: 0;
  --z-bottom-nav: 20;
  --z-fab: 30;
  --z-overlay: 40;
  --z-drawer: 50;
  --z-bottom-sheet: 60;
  --z-system-overlay: 70;
}
```

## 24. Do Not Guess Randomly

If a detail is not visible in the mockups, do not present it as confirmed.

Use this format:

```md
Not clearly visible in the provided mockups.
Recommended default: ...
```

For uncertain values, use this format:

```md
Approximate value: 16px
Confidence: Medium
Reason: Estimated from card padding visible in `Screenshot_20260512_171107_TickTick.jpg`.
```

Currently uncertain details:

- Hover states are not visible because the mockups are mobile screenshots.
- Loading states are not visible.
- Error, success, warning, and info alerts are not visible.
- Light mode is not visible.
- Desktop/tablet breakpoints are not visible.
- Exact font family is not confirmed, only visually inferred as Android/system sans.
- Static mockup density is not confirmed. Live audit density is confirmed for the inspected phone as approximately `3.5` physical pixels per `1dp`.

## 25. Accuracy Requirements

- Every visible mockup component should map to a component in this guide.
- Use concrete token values rather than vague descriptions.
- Mark approximate values with confidence and reason when precision is not guaranteed.
- Do not infer unrelated components from common app conventions.
- Do not let system keyboard styling override app component styling.
- Reuse the page-by-page notes when implementing a specific screen.

## 26. Final Quality Check

- Inspected all four files in `UI mockups`.
- Confirmed all visual mockup files present are `.jpg` screenshots.
- Documented recurring colors and provided tokens.
- Documented typography scale and casing patterns.
- Documented spacing, radius, borders, shadows, icons, buttons, inputs, cards, navigation, lists, status indicators, sheets, and avatars.
- Included page-by-page notes for every mockup.
- Marked uncertain/non-visible states instead of fabricating details.
- Added live-audit measurements for TickTick Android screens and components that were not present in the static mockups.

## 27. Live Audit Measurement Baseline

The live audit was performed on the real TickTick Android app in dark mode. Treat these measurements as the best available reference for native Android proportions.

Device and density:

- Physical screenshot: `1440px x 3120px`.
- Logical viewport: approximately `411dp x 891dp`.
- Density conversion: `1dp` is approximately `3.5` physical screenshot pixels.
- Status bar/safe top area: approximately `32dp`.
- Android gesture/navigation area at bottom: approximately `15dp`.
- Main interactive app frame between safe areas: approximately `411dp x 844dp`.

General measured layout:

- Top app bar begins below the status bar and is approximately `56dp` tall.
- Top icon hit targets are approximately `56dp x 56dp`.
- Main horizontal screen gutter is `16dp`.
- Main card/list width on a `411dp` viewport is approximately `379dp`.
- Drawer width is approximately `355dp`, or `86%` of the screen width.
- Bottom navigation height is approximately `58dp`, above the Android gesture area.
- FAB is approximately `56dp x 56dp`, positioned `20dp` from the right edge and `55dp` above the bottom navigation baseline.
- Repeating task, drawer, and menu rows generally land on `40dp` to `48dp` vertical hit areas.

When translating from this guide into Flutter or native Android:

- Use `dp` for layout dimensions.
- Use `sp` or logical font pixels for text sizes.
- Do not use the raw `1440px` screenshot width as the design viewport.
- Use the observed `411dp` viewport as the phone reference width.
- Maintain all `16dp` outer gutters and `56dp` icon hit targets unless the component-specific notes below override them.

State preservation note:

- Live exploration avoided task-affecting actions.
- Menus, sheets, settings pages, and view controls were inspected visually.
- Task completion, delete, postpone, share, subscribe, list toggles, and task creation actions were not activated.
- Temporary display surfaces such as kanban/list view and background tabs must be restored after audit or testing.

## 28. System UI Boundaries

Do not recreate these as app components:

- Android status bar.
- Screen recorder chip or notification overlays.
- Android navigation gesture area.
- Android keyboard.
- Android keyboard toolbar, microphone, and suggestion strip.
- System floating voice/assistant bubble.

Observed system boundaries:

- The status bar can tint black and sit above TickTick content. TickTick does not draw into it with custom decoration in the observed screens.
- The app top bar starts immediately below the status bar.
- Bottom navigation stops above the gesture/navigation area.
- When the keyboard appears, TickTick sheets sit above it and the keyboard is purely system-provided.

Implementation rule:

- Reserve safe-area space but keep app chrome pure black or charcoal.
- Never style a screenshot-only screen recorder chip, keyboard key, or system voice bubble as TickTick UI.

## 29. Today Screen Live Measurements

The Today screen is the primary reference for app density.

Top app bar:

- Height: approximately `56dp` after safe area.
- Left icon: hamburger/menu, `56dp x 56dp` hit target.
- Center title: `Today`, bold, left-aligned after the hamburger area.
- Title baseline sits visually centered in the app bar.
- Right icon cluster: daily reminder/lightbulb and overflow, each `48dp` to `56dp` hit target.
- Icon color: `--color-icon`, no visible button background.
- The top bar surface is `--color-bg`, not a separate card.

Task list card geometry:

- Outer horizontal gutter: `16dp`.
- Section card width: approximately `379dp`.
- Card radius: approximately `20dp` to `24dp`.
- Card fill: `--color-surface`.
- No shadow on default list cards.
- No row separators inside default task section cards.
- Section header row height: approximately `50dp`.
- Task row height: approximately `44dp`.
- Header content uses the same left/right insets as row content.

Section header anatomy:

- Left label: bold section heading.
- Right action or count: blue `Postpone` action for overdue, muted count for ordinary sections.
- Header vertical alignment: centered.
- Header has more top/bottom air than task rows.

Task row anatomy:

- Left checkbox: square with rounded corners, approximately `20dp` to `24dp`.
- Active checkbox outline: muted gray, no fill.
- Completed checkbox: muted filled/outlined gray with check.
- Text column starts approximately `36dp` to `40dp` from card left edge.
- Task title is single-line with ellipsis.
- Right date column is fixed-width and right-aligned.
- Date text uses danger red only for overdue dates.
- Completed task text and dates are muted, not struck through in the observed state.

Blue project markers:

- A thin vertical blue mark can appear near the left edge of a task row.
- Width is approximately `2dp`.
- Height is shorter than the row and vertically centered.
- Use `--color-primary-sidebar-mark`.
- The marker does not shift checkbox or text alignment.

Bottom navigation:

- Height: approximately `58dp`.
- Three observed tabs: tasks/list, calendar, settings.
- Each tab receives one third of the width, approximately `137dp`.
- Active icon uses `--color-primary`.
- Inactive icons use `--color-icon-muted`.
- No visible text labels appear under the main tab icons in the observed Today screen.
- No enclosing card, border, or top divider was prominent in the observed Today screen.

FAB:

- Size: `56dp`.
- Shape: circle.
- Fill: `--color-primary-bright`.
- Icon: white plus, centered.
- Shadow: soft blue glow, subtle black drop shadow.
- Position: fixed above bottom nav, not inside a card.
- It floats above content and should not reserve list layout space.

## 30. Drawer Live Details

Drawer container:

- Width: approximately `355dp`, about `86%` of the viewport.
- Height: full app height including behind top safe area.
- Fill: `--color-surface`.
- Right edge has a dimmed outside overlay, not a bright divider.
- No visible rounded right corners.

Drawer header:

- Header height: approximately `122dp`.
- Avatar size: approximately `40dp`.
- Avatar x inset: approximately `21dp`.
- Account name sits to the right of the avatar and is bold.
- Search, notification, and settings icons sit on the right with `30dp` to `36dp` visual icons inside large hit targets.
- Header controls are horizontally aligned around the avatar/name row.

Drawer navigation rows:

- Row horizontal inset: approximately `12dp`.
- Row height: approximately `44dp`.
- Selected row is a full-width rounded pill inside the drawer, not an underline.
- Selected pill fill: `--color-primary-soft-bg`.
- Selected icon and text: `--color-primary`.
- Unselected rows: transparent.
- Row icon size: approximately `24dp`.
- Row label: bold, approximately `21dp` to `23dp`.
- Count is right-aligned and muted.
- Section/list names preserve user casing.

Drawer footer:

- Footer sits pinned near the bottom above gesture area.
- `Add` action appears left, blue icon plus text.
- Manage/settings action appears right as an icon-only target.
- Footer controls use `44dp` to `48dp` hit areas.

Do not:

- Make the drawer a centered modal.
- Add a white border to the drawer edge.
- Use smaller desktop side-nav row heights.
- Use a permanent desktop sidebar for the phone layout.

## 31. Popovers and Anchored Menus

TickTick popovers are dark, rounded, anchored surfaces. They are visually heavier than default cards but still restrained.

Base popover:

- Fill: `--color-surface-popover`.
- Radius: approximately `20dp` to `24dp`.
- Shadow: soft dark shadow around the edge, stronger than default cards.
- Overlay: the underlying app dims subtly while the popover is open.
- Horizontal padding: approximately `14dp` to `16dp`.
- Row height: approximately `40dp`.
- Icon column: fixed, approximately `40dp`.
- Icon size: approximately `22dp` to `24dp`.
- Text: `Popover Menu Text`.
- Chevron, checkmark, and trailing icons align to the far right.

Daily reminder popover:

- Anchored below the lightbulb/daily reminder top action.
- Width: approximately `187dp`.
- Contains two rows: `Suggested Tasks`, `Plan Your Day`.
- Rows are icon plus label, no dividers.
- Top and bottom padding are approximately `10dp`.

Today overflow menu:

- Anchored below the top-right overflow icon.
- Width: approximately `228dp`.
- Row order observed: `View`, `Background`, `Show Details`, `Hide Completed`, divider, `Group & Sort`, `Select`, `Share`.
- Only `View` has a chevron in the top-level observed menu.
- A divider appears after `Hide Completed`.
- Do not add dividers between every row.
- Do not use a white selected row. Selection uses blue text/check or dark blue fill depending on the submenu.

View submenu:

- Reuses the same popover footprint.
- Header row says `View` with a collapse/down chevron.
- Divider under header.
- Options: `List View`, `Kanban View`.
- Selected option uses a blue checkmark.
- Option text remains white, not blue, in the observed state.

Calendar overflow menu:

- Same surface and row system as Today overflow.
- Row order observed: `Filter View Range`, `View Options`, `Arrange Tasks`, `Calendar Subscription`, `Share`, `Select`.
- Width is approximately the same as the Today overflow menu.

## 32. Search Screen

Search opens as a full-screen page, not a bottom sheet.

Top search row:

- Safe top is preserved.
- Search field x inset after back/search affordance: approximately `62dp`.
- Search field height: approximately `38dp`.
- Search field width on `411dp` viewport: approximately `276dp`.
- Search field fill: `--color-surface`.
- Search field radius: full pill.
- Search icon sits inside the field at the left.
- Placeholder/text uses `Search Field Text`.
- Cursor and active affordances use `--color-primary`.
- `Cancel` sits at the far right, blue, medium/bold.
- Cancel hit target is at least `48dp` wide.

Filter chips:

- Chip row top gap from search row: approximately `15dp`.
- Row x inset: `16dp`.
- Chip height: approximately `28dp` to `32dp`.
- Chip radius: full pill.
- Horizontal gap between chips: approximately `12dp`.
- Chip labels: `Task`, `Lists`, `Filter`.
- Unselected chip fill: `--color-surface`.
- Selected chip fill: `--color-surface-chip-selected`.
- Selected chip text and icon: `--color-primary`.
- Selected chip includes a small trailing close `x`.
- Unselected chip text and icon are light/muted.

Search empty states:

- Illustration is centered vertically below chips.
- Illustration style is simple, flat, muted gray with blue accent.
- Empty instruction text is centered.
- Text examples observed:
  - `Type keywords to search Tasks`
  - `Type keywords to search Lists`
  - `Type keywords to search Filter`
- Instruction text uses `--color-text-muted`.
- The illustration changes per selected chip, but style and scale remain consistent.

Keyboard state:

- The Android keyboard appears when search input is focused.
- Do not recreate keyboard styling in app UI.
- Content above keyboard should avoid being hidden by it.

## 33. Suggested Tasks and Plan Your Day

Suggested Tasks is a full-screen page.

Suggested Tasks top bar:

- Left close/back icon has a `56dp` hit target.
- Title starts after the close target.
- Title text: bold, page-title scale.
- Top bar height follows the standard app bar.
- Surface remains black.

Suggested Tasks card:

- Outer gutter: `16dp`.
- Card fill: `--color-surface`.
- Radius: approximately `20dp` to `24dp`.
- Header block height: approximately `70dp`.
- Header label `Long Unfinished` uses primary blue.
- Header description is muted and can wrap.
- Header has a trailing chevron.
- A single subtle divider separates header from task rows.
- Task rows use the same checkbox/title/date/add-button anatomy as Today rows.
- Right action is a blue plus icon, not a filled button.

Plan Your Day onboarding:

- Full-screen black page.
- Top close/back icon is present.
- Large illustration centered above text.
- Title `Plan Your Day` is primary blue, large, bold.
- Body copy is white/light gray and centered, with roomy line height.
- Primary `Start` button is centered, wide, and filled blue.
- Button width: approximately `288dp`.
- Button height: approximately `40dp`.
- Button radius: full pill or very large radius.
- Secondary `Not Now` is blue text, centered below the button.
- No card surrounds the onboarding content.

Plan Your Day review flow:

- Full-screen black page.
- Top close icon at left.
- Greeting text: large, muted gray/white, with emoji inline.
- Subtitle/motto below greeting is smaller and muted.
- Current task occupies a large vertical center area.
- Bottom action bar contains five evenly spaced actions:
  - `Done`
  - `Today`
  - `Later`
  - `Won't Do`
  - `Delete`
- Each action has a large icon above a compact label.
- Action bar targets are approximately one fifth of screen width and at least `58dp` tall.
- These actions mutate tasks. Do not activate them in audits unless explicitly asked.

## 34. View Modes, Selection, and List Options

Kanban view:

- Top app bar remains identical to Today list view.
- Below the app bar, a horizontal pill row represents date groups.
- Selected pill: dark blue fill, primary blue text.
- Unselected pill: transparent or black background, muted/light text.
- Pill height: approximately `36dp`.
- Task cards become individual rounded cards instead of grouped section cards.
- Individual task card outer gutter: approximately `21dp`.
- Individual card height: approximately `48dp`.
- Individual card radius: approximately `8dp` to `10dp`, smaller than section cards.
- Individual card border: subtle `1dp` muted gray.
- Adjacent kanban column can peek from the right, indicating horizontal scroll.
- FAB and bottom nav remain fixed.

List view:

- Grouped section-card layout is the default reference.
- Restoring from kanban should return to grouped `Overdue`, `Today`, `Completed` cards.

Background picker sheet:

- Bottom sheet anchored to the bottom.
- Sheet fill: `--color-surface` or `--color-surface-raised`.
- Top corners: approximately `24dp` to `28dp`.
- No drag handle observed.
- Segmented control sits near the top of the sheet.
- Segment labels: `None`, `Color`, `Gradient`, `Image`.
- Overall segmented control x inset: approximately `18dp`.
- Segment height: approximately `36dp`.
- Selected segment uses dark inner pill and light/blue text.
- Unselected segment uses transparent or sheet-colored background with muted text.
- Under the segmented control, `Follow app theme` appears centered and muted.
- Color and gradient swatches are large rounded squares in a horizontal row.
- Selected swatch shows a blue circular check badge.
- Default app background remains black when `None` is selected.
- Do not use picker swatches as global app theme unless implementing the actual background setting.

Group & Sort sheet:

- Bottom sheet with dim overlay.
- No large visible title in the observed state.
- Contains section heading `Group by`, then pill-grid options.
- Contains section heading `Sort by`, then pill-grid options.
- Grid is three columns where possible.
- Option height: approximately `40dp`.
- Option radius: full pill.
- Selected option: filled primary blue with white text.
- Unselected option: dark surface fill with light text.
- Observed group options: `List`, `Date`, `Tag`, `Priority`.
- Observed sort options: `Date`, `Title`, `Tag`, `Priority`.
- Keep generous vertical spacing between heading and button rows.

Select mode:

- Entered from overflow `Select`.
- Top bar changes to back/close icon and title `0 Selected`.
- Task completion checkboxes become circular selection rings.
- No task is selected by default.
- Bottom action bar replaces normal bottom navigation.
- Bottom actions observed: date/calendar, column/status, move/list, delete, more.
- Icons are muted/disabled when `0 Selected`.
- Bottom action hit targets remain large, approximately `56dp`.
- Do not show labels in the observed select-mode bottom bar.

## 35. Calendar Screen

Calendar page top bar:

- Page title: month name, e.g. `May`.
- Title uses app page title styling and left alignment.
- Right action cluster contains view/filter icon, calendar icon, and overflow.
- Top icon targets are standard `56dp`.
- Background remains black.

Week strip:

- Sits immediately below the top app bar.
- Horizontal date cells are evenly spaced.
- Weekday label sits above date number.
- Weekday labels use muted text.
- Date numbers are centered.
- Selected/current date states:
  - Filled blue circle with white number for selected date.
  - White/light circle with primary blue number for today or alternate highlighted date.
  - Small blue dots under date numbers indicate scheduled items.
- Circle size: approximately `32dp` to `36dp`.
- The week strip has no card container.

Calendar tooltip:

- Tooltip text observed: `Tap to go today`.
- Dark rounded rectangle with a small pointer/notch.
- Anchored near the date strip/calendar control.
- Text is white/light.
- Radius: approximately `8dp` to `10dp`.
- Treat as transient in-app coach mark, not a permanent banner.

Calendar subscription banner:

- A blue promotional card can appear below the week strip.
- Fill: `--color-primary-banner`.
- Radius: approximately `14dp` to `18dp`.
- Horizontal inset: `16dp`.
- Icon: white calendar symbol inside a light/transparent circle.
- Main copy is white and can wrap over two lines.
- Close `x` icon appears top-right inside the banner.
- Button row sits at the lower-right.
- `Cancel` button is semi-transparent blue/dark overlay with white text.
- `Subscribe` button is white fill with primary blue text.
- Buttons are compact rounded rectangles, not full-width.
- Do not click or auto-dismiss this banner in state-preserving audits.

Calendar task/completed cards:

- Below banner, task sections continue to use TickTick cards.
- Muted completed items appear in dark cards.
- Spacing remains aligned to the `16dp` page gutter.

## 36. Settings Screens

Settings root page:

- Top page title: `Settings`, bold.
- Main content scrolls between top app bar and bottom navigation.
- Page background: black.
- Cards use `--color-surface`.
- Card outer gutter: `16dp`.
- Card radius: approximately `18dp` to `24dp`.

Account header:

- Large avatar at left, approximately `56dp`.
- Crown or premium badge can overlap the avatar.
- Account name is bold and white.
- Secondary level/badge row appears below the name.
- Chevron appears at far right.
- Entire row is a large tappable area.

Premium card:

- Dark card with orange/yellow premium icon.
- Title: `Premium Account`.
- Description text is muted and wraps.
- `Upgrade Now` button is an outlined rounded rectangle.
- Upgrade outline/text color: `--color-upgrade`.
- Button is right-aligned within the card.

Settings list groups:

- Rows are grouped into rounded dark cards.
- Row height is approximately `50dp`.
- Icon column: approximately `44dp` wide.
- Icons are colored, not monochrome, on settings pages.
- Row title uses `Settings Row Title`.
- Row descriptions use `Settings Row Description` when present.
- Chevron or value appears at the far right.
- Dividers are subtle and only between rows inside a group.
- Do not add outer card borders.

Observed root rows:

- `Tab Bar`
- `Appearance`
- `Date & Time`
- `Sounds & Notifications`
- `Widgets`
- `General`
- `Integrations & Import`
- `Recommend to Friends`
- `Help & Feedback`
- `Follow Us`

Tab Bar settings page:

- Top bar has back icon and title `Tab Bar`.
- Row layout is a two-column action plus text structure.
- Left control is an icon/action button or toggle affordance, approximately `32dp`.
- Text block starts after a larger left control column, around `88dp` from screen left.
- Enabled tab rows observed: `Task`, `Calendar`, `Settings`.
- Disabled section label `Disabled` appears muted and small.
- Disabled rows observed: `Eisenhower Matrix`, `Pomodoro`, `Habit Tracker`, `Countdown`, `Search`.
- `Max number of tabs` row has value `5` on the right and description `Over-limited tabs will be shown in More.`
- Avoid changing toggles or tab order when auditing style.

Settings bottom navigation:

- Settings tab active state uses primary blue.
- On subpages such as `Tab Bar`, bottom navigation can appear as icon-only.
- Preserve the same fixed bottom area and safe-area spacing.

## 37. Task Detail Action Sheets

Task detail bottom sheet is documented above; live audit added the nested action surfaces.

Task detail overflow sheet:

- Opens from the task detail overflow menu.
- Presented as a bottom sheet over a dimmed task detail sheet.
- Top row is a four-action grid:
  - `Pin`, yellow/warning icon.
  - `Share`, green/success icon.
  - `Won't Do`, blue icon.
  - `Delete`, red/critical icon.
- Each action target is approximately `56dp` to `64dp` wide with icon above label.
- Labels are compact and muted/light.
- Dangerous action uses red icon but does not fill the whole tile red.

Action menu cards:

- Below the top action grid, rows are grouped in rounded dark cards.
- Card gutter: `16dp`.
- Row height: approximately `48dp`.
- Row text: white/light, regular weight.
- Row icons: right-aligned in the observed sheet.
- Dividers are subtle or absent depending on row group.

Observed rows in the first task-detail overflow sheet:

- `Add Subtask`
- `Convert to Note`
- `Attachment`
- `Tags`
- `Task Activities`
- Separate row/card: `More`

Nested `More` sheet:

- Header row has a back/close icon and title `More`.
- Same bottom-sheet surface and top radius.
- Rows observed:
  - `Comment`
  - `Location`
  - `Copy Link`
  - `Duplicate`
  - `Save & New`
  - `Save as Template`
  - `Edit`
- Rows use the same `48dp` approximate height and dark grouped-card pattern.
- These rows are potential task-affecting actions. Do not activate them during visual audits.

## 38. Live-Audit Implementation Checklist

Before shipping UI intended to match TickTick, compare against this checklist:

- Phone viewport uses approximately `411dp` as the reference width.
- Safe areas are respected: app top bar below status bar, bottom nav above gesture area.
- Main gutters are `16dp`.
- Top icon hit targets are `48dp` to `56dp`.
- Default background is pure black.
- Default cards and sheets use charcoal, not blue-tinted or gray web-card surfaces.
- Section task cards are rounded and divider-free.
- Kanban individual cards use smaller radius and subtle borders.
- FAB is a `56dp` blue circle with a soft glow.
- Active/selected state means primary blue; inactive means muted gray.
- Overdue dates use danger red.
- Explicit destructive icons use critical red.
- Popovers are anchored, rounded, dark, and row-based.
- Bottom sheets use rounded top corners and dimmed background.
- Search is a full-screen page with a pill field, blue cancel action, chips, and centered empty state.
- Calendar uses a week strip with circular date states, not a full web calendar grid by default.
- Settings uses grouped cards with colorful icons and large mobile rows.
- Task detail nested actions use action grids and grouped dark row cards.
- Gradients appear only in the background-picker swatches unless implementing user-selected backgrounds.
- System keyboard, status bar, screen recorder chip, and Android overlays are not recreated as app UI.
- No task-affecting audit/test action should be required to verify the visual system.
