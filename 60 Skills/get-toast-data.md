---
title: get-toast-data
status: active
updated: 2026-09-18
tags: [skill, toast, browser]
---

# Skill: Get Toast Data

**Trigger:** “get Toast data”, “pull Toast”, “Toast for all venues”, “labor at 1929”, morning pulse Toast, etc.

**Purpose:** Open Toast in the browser, navigate restaurant management UI, and pull what David needs into a reviewable vault note. All three BHG venues run on Toast POS.

**Read first:**

1. `30 Organizations/Backwoods-Hospitality-Group/Toast.md`
2. Venue overviews if scoped to one venue
3. `70 Templates/Toast-Pull.md`

**Venue order (always):** Whiskey Ranch → Estelle’s Diner → 1929

---

## Runtime

### A) Cursor (or any agent with browser tools) — preferred

Use browser navigate / snapshot / click tools.

### B) ChatGPT / Claude without browser — manual checklist

Guide David through the same steps; he pastes numbers; you write the Toast-Pull note.

---

## Procedure

### 1. Confirm scope

Ask only if ambiguous:

- One venue, all three (canonical order), or custom metric/date?
- Default morning pulse if he says “Toast check” / morning brief: yesterday + today sales, labor signal, anomalies — **all three venues in order**.

### 2. Open Toast

1. Navigate to login URL from `Toast.md` (default starting point: `https://www.toasttab.com/login` or Toast Web URL David confirmed).
2. If login / 2FA wall: **stop**. Ask David to authenticate. Do not store or request passwords into the vault.
3. When authenticated, snapshot to confirm restaurant admin / Toast Web home.

### 3. For each target venue (canonical order)

1. Open restaurant / location switcher.
2. Select the exact UI label from `Toast.md` for that venue. If label is `needs-david`, ask David once and write it back to `Toast.md`.
3. Confirm header / context shows the correct venue name before extracting any number.
4. Navigate to the surface for the ask:

| Ask | Navigate toward |
|-----|-----------------|
| Morning pulse | Sales summary (yesterday/today); labor overview; glance voids/open tickets if visible |
| Sales deep dive | Reports / sales for date range; daypart/server/category if available |
| Labor / OT | Labor report; hours vs sales |
| Voids / comps / discounts | Exception / void / comp reports |
| Menu / item performance | Menu or product mix reports |
| Staff / scheduling | Employees / shifts — **read-only** unless he confirms changes |
| Open loops | Open tickets, unpaid, stuck orders |
| Compare venues | Same metric, repeat per venue, single multi-venue note |

5. Extract metrics via snapshot / readable UI text. **Never invent numbers.** If unreadable, say so and ask David to confirm.
6. Note Toast navigation path used (for updating Report map in `Toast.md`).

### 4. Write vault note

Create `80 Journal-Meetings/Toast/YYYY-MM-DD-{{slug}}.md` using `70 Templates/Toast-Pull.md`.

Must include:

- Venue label(s) in canonical order
- Date range
- Metrics table
- Flags / anomalies
- Source screens / paths
- Next action for David
- Morning Brief one-liner (normal / flag) per venue if multi

### 5. Optional Morning Brief feed

If this pull is for morning brief, also apply `60 Skills/toast-morning-read.md` to compress into brief lines.

---

## Safety

- **Read-first.** No menu price edits, clock-outs, payouts, or config changes unless David explicitly confirms in this session.
- Always label which venue each metric belongs to.
- If UI changed: re-orient with snapshots — do not guess.
- Stop after ~4 failed navigation attempts; report what you saw and ask David.

## Quality failures

- Mixing venues without labels
- Invented sales/labor figures
- Writing passwords into vault
- Silent write actions in Toast
- Skipping a venue when he asked for “all”

## Manual checklist (no browser)

1. Open Toast Web and log in.
2. Switch to Whiskey Ranch → copy sales/labor (or requested metrics) → paste in chat.
3. Switch to Estelle’s Diner → paste.
4. Switch to 1929 → paste.
5. Agent files `80 Journal-Meetings/Toast/...` from the paste.
