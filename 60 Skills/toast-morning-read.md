---
title: toast-morning-read
status: active
updated: 2026-09-18
tags: [skill, toast]
---

# Skill: Toast Morning Read

**Trigger:** After a Toast pull, or when Morning Brief needs Toast lines.

**Purpose:** Compress a Toast-Pull note (or live pull) into one-liners: **normal** or **flag** per venue.

**Read first:** `30 Organizations/Backwoods-Hospitality-Group/Toast.md` (normal vs fire table), latest `80 Journal-Meetings/Toast/` note.

## Output format

```
Toast — Whiskey Ranch: normal | {one fact}
Toast — Estelle’s Diner: flag | {why}
Toast — 1929: normal | {one fact}
```

Rules:

- Canonical venue order
- If data missing: `needs pull` — do not invent
- Flag only when anomalous vs Toast.md thresholds or obvious oddity (huge void spike, labor way off, zero sales on open day, etc.)
- If thresholds still `needs-david`, flag only clear outliers and note that thresholds are unset
