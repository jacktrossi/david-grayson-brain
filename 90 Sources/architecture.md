# GraysonOS — System Architecture
**Version:** 1.0
**Last Updated:** 2026-05-25

---

## Overview

GraysonOS is a personal AI operating system built for David Grayson — an investment advisor and multi-business operator running across 5 organizations simultaneously. The system acts as a 24/7 autonomous agent that monitors all inboxes, surfaces what matters, drafts communications, manages tasks, and eliminates the daily manual fire-checking that currently consumes David's mornings.

---

## Core Stack

| Layer | Tool | Role |
|---|---|---|
| 🧠 Agent | **Hermes Agent** | Autonomous AI agent — runs 24/7, executes tasks, persistent memory, self-improves |
| 🔌 Integrations | **Nango** | OAuth management — connects all accounts, handles token refresh, unified API |
| ⚡ Intelligence | **Claude API** | LLM backend powering Hermes — reasoning, drafting, triage, classification |
| 🗄️ Database | **Supabase** | PostgreSQL database + encrypted Vault for secrets + pgvector for memory |
| 📓 Knowledge | **Obsidian** | David's second brain — client notes, meeting notes, structured knowledge |
| 🖥️ Hosting | **Railway / Render** | VPS running Hermes 24/7 (~$12-20/mo) |
| 🖱️ Computer Use | **Orgo** *(future)* | Virtual desktop for apps with no API (Toast web, QuickBooks UI, etc.) |

---

## Data Flow

```
┌─────────────────────────────────────────────────────┐
│                  DAVID'S ACCOUNTS                   │
│                                                     │
│  Gmail (Personal)   Office 365 x5   Toast   Bank   │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                     NANGO                           │
│         OAuth layer — all credentials managed       │
│    Microsoft Graph API  ·  Gmail API  ·  Slack API  │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                 HERMES AGENT                        │
│              Running 24/7 on VPS                    │
│                                                     │
│  • Polls all inboxes on schedule                    │
│  • Classifies and triages incoming email            │
│  • Detects VIP senders → immediate alert            │
│  • Drafts replies and communications                │
│  • Monitors Toast + bank for anomalies              │
│  • Syncs tasks to Todoist                           │
│  • Builds morning brief                             │
│  • Schedules Teams meetings                         │
│  • Writes structured notes to Obsidian              │
│                                                     │
│         Powered by Claude API (reasoning)           │
└──────┬───────────────────────────────────┬──────────┘
       │                                   │
       ▼                                   ▼
┌─────────────┐                   ┌─────────────────┐
│  SUPABASE   │                   │     OUTPUTS     │
│             │                   │                 │
│  • DB       │                   │  Slack alerts   │
│  • Vault    │                   │  Todoist tasks  │
│  • Memory   │                   │  Drafted emails │
│  • Logs     │                   │  Obsidian notes │
└─────────────┘                   │  Teams meetings │
                                  └─────────────────┘
```

---

## Email Accounts & Priority

| Account | Platform | Priority | Notes |
|---|---|---|---|
| Personal Gmail | Google | 🔴 HIGH | First inbox David checks every morning |
| Brewster Ambulance | Office 365 | 🔴 HIGH | Primary Boston work account |
| EMS Revenue Solutions | Office 365 | 🟡 MEDIUM | Consulting firm |
| Backwoods Hospitality | Office 365 | 🟡 MEDIUM | Restaurant business |
| Columbia Southern | Office 365 | 🟢 LOWER | Teaching |
| Sacred Heart | Office 365 | 🟢 LOWER | Teaching |

---

## VIP Contacts — Immediate Alert (Any Inbox)

| Name | Action |
|---|---|
| **Mark Brewster** | Surface at top of brief + Slack #urgent |
| **Jason Smith** | Surface at top of brief + Slack #urgent |
| **Courtney Murphy** | Surface at top of brief + Slack #urgent |

> Any email from these 3 contacts bypasses normal triage and fires an immediate alert regardless of time of day.

---

## Integrations Map

| Integration | Connected Via | Purpose |
|---|---|---|
| Personal Gmail | Nango → Gmail API | Email read/send |
| Brewster Ambulance | Nango → Microsoft Graph | Email read/send |
| EMS Revenue Solutions | Nango → Microsoft Graph | Email read/send |
| Backwoods Hospitality | Nango → Microsoft Graph | Email read/send |
| Columbia Southern | Nango → Microsoft Graph | Email read/send |
| Sacred Heart | Nango → Microsoft Graph | Email read/send |
| Google Calendar | Nango → Google Calendar API | Personal calendar |
| Outlook Calendars (x5) | Nango → Microsoft Graph | Work calendars |
| Slack | Nango → Slack API | Alert delivery |
| Todoist | Nango → Todoist API | Unified task inbox |
| Microsoft Teams | Microsoft Graph | Meeting creation |
| Toast POS | Toast API / Orgo fallback | Restaurant daily pulse |
| Bank Accounts | Plaid API | Anomaly monitoring |
| QuickBooks | QBO API / Orgo fallback | Financial monitoring |

---

## Morning Brief (Day-1 Feature)

Delivered every morning before David wakes up. One summary replacing 6 manual app checks.

```
GOOD MORNING, DAVID — [DATE]

TODAY'S SCHEDULE
────────────────
[All meetings across all 6 calendars, time + who]

OVERNIGHT EMAIL SUMMARY
────────────────────────
🔴 HIGH PRIORITY
  · [VIP sender emails first]
  · [Subject lines flagged urgent]

🟡 NEEDS ATTENTION
  · [Action required items]

📋 FYI / SUMMARIZED
  · [Informational emails, grouped by account]

RESTAURANT PULSE (Backwoods)
─────────────────────────────
[Toast summary — normal / flag if anomaly]

BANK
─────
[Status — normal / flag if anything unusual]

OPEN TASKS ROLLING FORWARD
───────────────────────────
[Overdue + due today from Todoist]

TODAY'S FOCUS
──────────────
[One recommended priority for the day]
```

---

## Task Management (Unified Inbox)

David currently runs **3 parallel task systems** — Todoist, Outlook Tasks, and paper. GraysonOS consolidates everything into Todoist as the single source of truth.

| Source | What Happens |
|---|---|
| Email action items | Hermes detects → creates Todoist task automatically |
| Outlook Tasks | Synced to Todoist via Microsoft Graph |
| Meeting commitments | Captured from call notes → Todoist task |
| Paper list | David speaks/types → Hermes creates task |

---

## Automation Library (Skills)

50 pre-built prompt skills across 9 categories:

| Category | Skills |
|---|---|
| Email & Communication | Draft, reply, triage, compliance check, newsletter |
| Client Intelligence | Pre-meeting brief, relationship health, action items |
| Investment & Market | Morning market brief, earnings summary, thesis builder |
| Calendar & Scheduling | Pre-call brief, day planner, weekly overview |
| Legal & Compliance | Document review, regulatory deadlines, RIA checklist |
| Travel | Trip summary, flight brief, itinerary review |
| Domains & Tech | Domain audit, subscription audit |
| Daily Operations | Morning brief, EOD wrap, weekly digest |
| Obsidian & Knowledge | Client notes, meeting notes (WikiLink format) |

---

## Hosting & Infrastructure

| Component | Where It Runs | Cost |
|---|---|---|
| Hermes Agent | Railway or Render VPS | ~$12-20/mo |
| Supabase | Supabase cloud (Pro plan) | ~$25/mo |
| Nango | Nango cloud | Free tier / ~$25/mo |
| Claude API | Anthropic API | Usage-based (~$20-50/mo est.) |
| **Total infra** | | **~$75-120/mo** |

> Covered under David's $550/month retainer. No surprise bills.

---

## Security

- All credentials stored encrypted in **Supabase Vault** — never in plain text or `.env`
- OAuth tokens managed by **Nango** — automatic rotation, no manual key management
- Hermes runs in an isolated VPS environment — David's data never touches shared infrastructure
- No data used for model training — Anthropic API with data privacy enabled
- **Orgo** (when used): sandboxed VM per session, auto-destroyed after task

---

## What's NOT in Scope (By Design)

- GraysonOS does not send emails without David reviewing and approving
- GraysonOS does not make financial transactions
- GraysonOS does not provide investment advice — compliance disclaimer enforced on all client drafts
- Legal emails are flagged but never auto-summarized — always routed to David for review

---

## Build Phases

### Phase 1 — Foundation (Week 1-2)
- [ ] Nango account + all 6 email connections
- [ ] Microsoft Graph OAuth (5 Office 365 accounts)
- [ ] Gmail OAuth (Personal)
- [ ] Hermes deployed on Railway
- [ ] Claude API wired as Hermes LLM backend
- [ ] Supabase schema live
- [ ] Morning brief firing daily

### Phase 2 — Intelligence (Week 3-4)
- [ ] VIP sender detection + Slack alerts
- [ ] Unified Todoist task inbox (auto-creation from emails)
- [ ] Outlook Tasks → Todoist sync
- [ ] Email drafting (general comms templates)
- [ ] Teams meeting scheduler

### Phase 3 — Full OS (Month 2)
- [ ] Toast POS daily pulse
- [ ] Bank anomaly monitoring (Plaid)
- [ ] Obsidian integration (auto-notes from meetings)
- [ ] All 50 skills library active
- [ ] QuickBooks monitoring
- [ ] Orgo setup (if needed for no-API apps)
