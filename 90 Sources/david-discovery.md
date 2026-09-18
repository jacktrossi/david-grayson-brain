# David Grayson — Discovery Interview
**Date:** 2026-05-24
**Interviewed by:** Jack Rossi

---

## Email Accounts

| Account | Platform | Priority | Notes |
|---|---|---|---|
| Personal Gmail | Google | 🔴 HIGH | First thing he checks every morning |
| Brewster Ambulance | Office 365 | 🔴 HIGH | "The Boston one" — most critical work account |
| EMS Revenue Solutions | Office 365 | 🟡 MEDIUM | Consulting firm |
| Backwoods Hospitality | Office 365 | 🟡 MEDIUM | Restaurant business |
| Colombia Southern | Office 365 | 🟢 LOWER | Teaching |
| Sacred Heart | Office 365 | 🟢 LOWER | Teaching |

---

## VIP Contacts (Immediate Alert — Any Email)

- **Mark Brewster**
- **Jason Smith**
- **Courtney Murphy**

> Any email from these 3 → top of morning brief + immediate Slack alert to #urgent

---

## Morning Routine

1. Wakes up → phone + coffee
2. Checks **Toast app** (restaurant daily summary — looking for anything strange)
3. Checks **bank accounts** (anomaly/fire spotting, not transactional)
4. Checks **emails** — Personal Gmail first, then Brewster Ambulance, then the rest
5. No single system pulling it all together — currently manual across multiple apps

**Morning Brief is a Day-1 priority.** Replace the manual app-hopping with one summary.

---

## Morning Brief Should Include

- [ ] Overnight emails across all 6 accounts — summarized and prioritized
- [ ] Today's meetings and commitments (all 5 org calendars)
- [ ] Upcoming deadlines and course lectures
- [ ] Toast restaurant summary (normal / flag if odd)
- [ ] Bank account pulse (normal / flag if anomaly)
- [ ] Open tasks and commitments rolling forward
- [ ] VIP sender alerts (Mark, Jason, Courtney)

---

## Biggest Pain Points

1. **Missing meetings** — scheduled across 5 organizations, no unified view
2. **Missing emails** — especially from VIP senders across multiple inboxes
3. **Course lecture deadlines** — falls through the cracks
4. **Commitments and deadlines** — made across different contexts, not tracked in one place
5. **Task system fragmentation** — running Todoist + Outlook Tasks + paper list simultaneously, nothing syncs

---

## Task Management (Current State — Broken)

| Tool | How He Uses It |
|---|---|
| Todoist | Primary task app |
| Outlook Tasks | Work tasks — not synced to Todoist |
| Paper list | Daily overflow — disappears |

**Goal:** One unified task inbox. Everything lands there automatically. He reviews once, acts.

---

## Repetitive Tasks to Automate

1. **General communications** — drafts based on context, he reviews and sends
2. **Documents** — templated generation
3. **Teams meeting scheduling** — auto-create via Outlook meeting feature, send invite
4. **Morning app-checking** — Toast + bank → replaced by one brief line
5. **Email triage** — summarize and prioritize across all 6 accounts

---

## Businesses / Organizations

| Organization | Role | Email |
|---|---|---|
| Brewster Ambulance | Primary — Boston | Office 365 |
| EMS Revenue Solutions | Consulting firm | Office 365 |
| Backwoods Hospitality | Restaurant owner | Office 365 |
| Colombia Southern | Instructor | Office 365 |
| Sacred Heart | Instructor | Office 365 |

---

## Still To Capture

- [ ] Q12: How does he want to interact with a unified task system? (Phone / Slack / other)
- [ ] Calendar setup — does he have separate calendars per org or everything in one?
- [ ] Slack — does he use it, or is that new for him?
- [ ] Travel frequency and pain points
- [ ] What does perfect look like in 90 days?

---

## Configuration Notes (Build Spec)

```
DAVID'S PRIORITY CONFIG
=======================
Biggest pain point: Scattered across 5 orgs — missing meetings, emails, deadlines
Most repetitive task: Morning app-checking (Toast, bank, 6 inboxes)
Email accounts: 1 Gmail + 4 Office 365 (Microsoft Graph API x4)
VIP senders: Mark Brewster, Jason Smith, Courtney Murphy
Day-1 build: Morning brief (all 6 accounts + Toast + bank + calendar)
Day-2 build: Unified task inbox (Todoist sync + Outlook Tasks sync)
Day-3 build: Email drafting + Teams meeting scheduling
Integrations needed: Gmail, Microsoft Graph (x4), Toast API, Plaid/bank, Todoist, Slack
Task delivery preference: TBD (Q12)
Slack: TBD — confirm if he has/uses it
```
