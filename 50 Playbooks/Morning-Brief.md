---
title: Morning Brief
status: active
updated: 2026-09-18
tags: [playbook]
---

# Playbook: Morning Brief

**Trigger:** “morning brief”, start of day.

Replace manual hopping: Toast → bank → six inboxes → calendars.

## Steps

1. **VIP scan** — Any mail from Mark Brewster, Jason Smith, Courtney Murphy? List first.
2. **Toast** — Run `60 Skills/get-toast-data.md` for all three venues (Whiskey Ranch → Estelle’s Diner → 1929), morning pulse. Compress with `toast-morning-read`.
3. **Bank pulse** — If David provides numbers or access: normal / flag only (anomaly spotting). Else: `needs input`.
4. **Email triage** — `multi-inbox-triage` across accounts in priority order.
5. **Calendar** — Today’s meetings across orgs; flag conflicts.
6. **Teaching** — Upcoming lecture deadlines from `30 Organizations/Teaching/`.
7. **Open tasks** — Rolling commitments if provided / from vault Inbox.

## Output shape

```
# Morning Brief — {date}

## Urgent / VIP
-

## Toast
- Whiskey Ranch: …
- Estelle’s Diner: …
- 1929: …

## Bank
-

## Email (HIGH)
-

## Today
-

## Deadlines (teaching / other)
-

## Open loops
-
```

## Writes

Optional: save copy to `80 Journal-Meetings/YYYY-MM-DD-Morning-Brief.md`
