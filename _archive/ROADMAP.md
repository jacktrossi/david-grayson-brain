# GraysonOS — Build Roadmap

A personal intelligence layer built on Claude Code for David Grayson.
Covers 8 Gmail accounts, 8 Google Calendars, financial professional work,
travel, personal finances, GoDaddy domains, and Zoom meeting intelligence.
Primary interface: dedicated Slack workspace. Secondary: web dashboard.

---

## Phase 1 — Foundation
**Goal:** Lay the data layer, identity kernel, and communication scaffold before any features are built.

### 1.1 Supabase Database Schema
Set up the persistent data store that every module reads from and writes to.

**Tables:**
- `accounts` — David's 8 Gmail accounts with labels, purposes, and priority tiers
- `calendars` — 8 Google Calendars mapped to their accounts and use cases
- `contacts` — Known clients, counterparties, vendors, and personal contacts with relationship notes
- `meetings` — All meetings past and future: source, attendees, calendar, Zoom link, status
- `action_items` — Tasks extracted from emails, meetings, and calls with owner and due date
- `email_threads` — Indexed threads across all 8 accounts for cross-account search
- `domains` — GoDaddy domain inventory with expiry, auto-renew status, DNS, and purpose
- `trips` — Travel itineraries with legs, bookings, expenses, and calendar blocks
- `expenses` — All expenses categorized by type, trip, client, and tax category
- `client_records` — Financial professional CRM: client name, firm, portfolio notes, open items
- `meeting_transcripts` — Zoom transcript storage with vector embeddings for semantic search
- `notifications_log` — History of every Slack alert sent, action taken, and outcome

### 1.2 CLAUDE.md Kernel
The OS identity file. This is what makes Claude understand David's world.

**Contents:**
- Map of all 8 Gmail accounts: address, purpose (personal / client-facing / legal / investments / etc.), priority level, signature style
- Map of all 8 Google Calendars: name, associated account, what goes on it
- Known clients and counterparties with relationship context
- David's communication style and tone preferences per account type
- Financial compliance rules (disclosures to append to client emails, audit trail requirements)
- Travel preferences (airline loyalty programs, seat preferences, hotel chains, dietary)
- GoDaddy domain portfolio with business purpose per domain
- Recurring obligations and deadlines (tax dates, filing deadlines, domain renewals)
- Standing instructions for triage and prioritization

### 1.3 Repository Structure
```
GraysonCompanyOS/
├── CLAUDE.md                  ← OS identity kernel
├── ROADMAP.md                 ← This file
├── packages/
│   ├── mail/                  ← GraysonMail module
│   ├── calendar/              ← GraysonCalendar module
│   ├── zoom/                  ← GraysonZoom module
│   ├── domains/               ← GraysonDomains module
│   ├── travel/                ← GraysonTravel module
│   ├── finance-pro/           ← GraysonFinance Pro module
│   ├── wallet/                ← GraysonWallet module
│   └── command/               ← GraysonCommand hub + Slack bot
├── dashboard/                 ← Next.js web dashboard
├── supabase/
│   └── migrations/            ← Database schema migrations
└── .claude/
    └── settings.json          ← Claude Code hooks and permissions
```

### 1.4 Slack Workspace Setup
- Create dedicated GraysonOS Slack workspace
- Create channels: `#daily-brief`, `#urgent`, `#mail-actions`, `#calendar`, `#finances`, `#travel`, `#domains`, `#zoom-summaries`
- Configure GraysonOS bot with posting permissions
- Set up webhook endpoints for incoming actions (button clicks → trigger Claude workflows)

**Deliverables:** Supabase project live, schema migrated, CLAUDE.md drafted, repo structured, Slack workspace ready with bot posting to all channels.

---

## Phase 2 — GraysonMail + GraysonCalendar
**Goal:** Solve the missed-meeting problem. Proactively monitor all 8 inboxes and guarantee every time-sensitive email lands on the right calendar with a Slack alert.

### 2.1 Gmail MCP Configuration (8 Accounts)
- OAuth setup for all 8 Gmail accounts
- Each account tagged with its purpose and priority tier from CLAUDE.md
- Unified inbox polling (every 5 minutes or via push notifications)
- Cross-account search: query against all 8 accounts simultaneously

### 2.2 Google Calendar MCP Configuration (8 Calendars)
- OAuth setup for all 8 Google Calendars
- Conflict detection across all calendars before any event is created
- Write-back capability: create, update, and delete events from Claude

### 2.3 Email → Calendar Detection Engine
The most critical feature. Scans every incoming email for time-sensitive content.

**Detects:**
- Calendar invites (.ics attachments, "Meet on Thursday at 2pm", "Please join us for...")
- Deadline mentions ("due by Friday", "respond by EOD", "filing due March 15")
- Flight/hotel confirmations → auto-block travel time on calendar
- GoDaddy renewal notices → push to domain expiry calendar
- Financial deadlines (payment due, filing dates)

**Flow:**
1. Email arrives in any of the 8 accounts
2. Claude classifies: is this time-sensitive?
3. If yes → check all 8 calendars for conflicts
4. Post to `#urgent` in Slack with context and action buttons
5. David taps [Add to Calendar], [Add + Prep Brief], or [Skip]
6. Action executes, confirmation posted back to Slack

### 2.4 Meeting Prep Brief Generator
Triggered when David adds a meeting or requests a prep brief.

**Brief includes:**
- All prior emails from attendees across all 8 accounts
- Previous meeting summaries (from Zoom transcripts)
- Open action items from the client record
- Any relevant financial data or portfolio notes
- Suggested talking points based on recent correspondence

### 2.5 Morning Calendar Digest
Posted to `#daily-brief` every morning at a configurable time.

```
Good morning, David. Here's your day — Friday, May 23

TODAY
• 9:00am  Call with Harris Group (Zoom) — prep brief ready
• 2:00pm  Smith Capital Q2 Review — 3 open items from last meeting
• 4:30pm  Flight to Chicago O'Hare (AA 1847) — check-in opens now

INBOX SUMMARY
• 8 new emails flagged as priority across your accounts
• 2 meeting invites detected — not yet on calendar ⚠️
• 1 email from sarah@smithcapital.com needs a reply

THIS WEEK
• Domain graysonventures.com expires in 8 days ⚠️
• Tax filing deadline: June 15 (23 days)
```

### 2.6 Smart Email Routing Rules
Claude learns which types of emails belong to which accounts and flags when something arrives in the wrong inbox. Surfaces cross-account threads (same counterparty emailing two different accounts).

**Deliverables:** All 8 Gmail + Calendar accounts connected, email → calendar bridge live, Slack alerts flowing, morning briefings running, prep briefs on demand.

---

## Phase 3 — GraysonZoom
**Goal:** Turn every Zoom meeting into structured intelligence. No more lost decisions, forgotten action items, or uncaptured follow-ups.

### 3.1 Zoom Webhook Integration
- Connect Zoom account via Zoom API
- Webhook triggers on meeting end
- Auto-download recording and transcript from Zoom cloud
- Fallback: Whisper transcription if Zoom transcript unavailable

### 3.2 Transcript Processing Pipeline
After every meeting ends:
1. Transcript received
2. Claude processes → generates structured summary
3. Summary posted to `#zoom-summaries` in Slack
4. Action items extracted and added to `action_items` table
5. Follow-up email draft queued in `#mail-actions`
6. Summary attached to the calendar event
7. If meeting matches a known client → summary logged in their client record

**Summary format:**
```
MEETING: Smith Capital Q2 Review
Date: May 23, 2026 | Duration: 47 min | Attendees: David, Sarah Chen, Mike Ross

KEY DECISIONS
• Agreed to increase equity allocation by 5%
• Q3 review scheduled for August 14

OPEN QUESTIONS
• Sarah to confirm whether the offshore structure applies

ACTION ITEMS
• David: Send updated allocation model by May 30
• Sarah: Confirm offshore structure question by June 5

FOLLOW-UP EMAIL
[Draft ready in #mail-actions]
```

### 3.3 Semantic Search Across All Transcripts
Ask Claude natural language questions across all past meetings:
- "What did we agree on with Smith Capital in March?"
- "Has anyone mentioned the Chen family trust in the last 6 months?"
- "What action items from Q1 are still open?"

Powered by vector embeddings stored in Supabase (pgvector).

### 3.4 Pre-Meeting Alert
30 minutes before any Zoom meeting, post to `#urgent`:
- Who's on the call
- Last meeting summary
- Open action items from prior calls
- Any relevant recent emails

**Deliverables:** Zoom auto-recording, structured summaries in Slack, action items tracked, semantic search live, pre-meeting alerts running.

---

## Phase 4 — GraysonDomains + GraysonTravel
**Goal:** Eliminate renewal anxiety and make travel frictionless.

### 4.1 GraysonDomains — GoDaddy API Integration

**Domain Inventory:**
- Pull full domain list from GoDaddy API
- Store in Supabase: domain name, expiry date, auto-renew status, registrar lock, DNS config, business purpose
- Web dashboard widget showing full portfolio at a glance

**Renewal Alert System:**
- 90 days out: informational notice to `#domains`
- 30 days out: action required notice with [Renew Now] button
- 7 days out: urgent alert to `#urgent` with direct GoDaddy renewal link
- Renewal calendar events auto-added to GraysonCalendar

**DNS Management:**
- View all DNS records per domain
- Natural language changes: "Point blog.graysonventures.com to this IP"
- Claude validates the change before executing, posts confirmation

**Domain Portfolio View:**
- Estimated values (GoDaddy appraisal API)
- Hosting relationship map (which domain → which host/email provider)
- Domains with no activity in 2+ years flagged for review

### 4.2 GraysonTravel — Intelligent Travel Operations

**Itinerary Parser:**
- Forward any travel confirmation email to GraysonOS
- Claude extracts: flight numbers, departure/arrival times, hotel check-in/out, car rental
- All legs auto-blocked on GraysonCalendar with travel buffer time
- Itinerary stored in `trips` table

**Travel Preferences (from CLAUDE.md):**
- Preferred airlines and loyalty program numbers
- Seat preferences (aisle/window, row)
- Hotel chains and loyalty numbers
- Dietary restrictions

**Expense Tracking:**
- Snap a receipt → Claude categorizes it to the active trip
- Per-trip expense ledger in real time
- Expense report generated on return home

**Pre-Trip Brief:**
Posted 24 hours before departure to `#travel`:
- Full itinerary summary
- Weather at destination
- Ground transportation options
- Open action items to clear before leaving
- Reminders (passport, documents, loyalty numbers)

**Deliverables:** Full domain inventory live, renewal alerts flowing to Slack, travel parser running, expense tracking active, pre-trip briefs automated.

---

## Phase 5 — GraysonFinance Pro + GraysonWallet
**Goal:** Bring the same rigor David applies to clients to his own financial professional practice and personal finances.

### 5.1 GraysonFinance Pro — Professional Workbench

**Client CRM (built in Supabase):**
- Client roster: name, firm, contact details, relationship notes
- Per-client timeline: all emails, meetings, calls, documents
- Portfolio notes: allocation model, mandates, risk profile
- Open items tracker: what's pending per client
- Communication log: every outbound email and meeting auto-logged

**Engagement Tracker:**
- Active engagements with stage, documents required, open questions
- Deadline calendar for each engagement (filing dates, review dates, reporting deadlines)
- Status overview across all clients

**Report Generation:**
- Templates for common reports (performance summaries, allocation reviews, quarterly updates)
- Claude populates templates from client record data
- Draft posted to `#mail-actions` for review before sending

**Compliance Layer:**
- Auto-append required disclosures to client emails (rules defined in CLAUDE.md)
- Audit trail: every client communication timestamped and stored
- Regulatory deadline calendar (FINRA, SEC, tax dates)
- Document retention rules enforced

**Document Vault:**
- Upload contracts, statements, filings, agreements
- OCR + indexing for full-text search
- Linked to client records

### 5.2 GraysonWallet — Personal Finance Dashboard

**Account Aggregation (Plaid):**
- Bank accounts, credit cards, brokerage accounts connected
- Daily balance and transaction sync to Supabase

**Expense Intelligence:**
- Automatic categorization of all transactions
- Monthly P&L summary posted to `#finances`
- Budget tracking with variance alerts
- Subscription audit: identify overlapping or unused recurring charges

**Tax Preparation:**
- Year-to-date categorized expense summary
- Exportable report for accountant
- Estimated quarterly tax payments tracked

**Investment Tracking:**
- Personal portfolio performance vs. benchmarks
- Domain portfolio tracked as an asset class (linked to GraysonDomains)
- Net worth tracker with monthly snapshots

**Deliverables:** Client CRM live, compliance layer active, personal finance dashboard running, Plaid connected, monthly P&L automated.

---

## Phase 6 — GraysonCommand Dashboard
**Goal:** A single visual cockpit David opens in the morning that shows everything at once.

### 6.1 Web Dashboard (Next.js + Vercel)
Designed for a non-technical user: large text, clear visual hierarchy, no configuration required. Read-only by default — actions happen in Slack, the dashboard is for situational awareness.

**Dashboard Widgets:**
- **Today's Calendar** — unified view of all 8 calendars, color-coded by calendar
- **Inbox Summary** — unread count per account, priority emails flagged
- **Active Alerts** — anything in `#urgent` not yet actioned
- **Domain Watch** — domains expiring within 90 days
- **Finance Snapshot** — portfolio performance, pending client items, personal P&L
- **Active Trip** — current or next trip itinerary
- **Action Items** — open items across all modules

**Tech Stack:**
- Next.js frontend deployed to Vercel
- Supabase as the data source (real-time subscriptions)
- Tailwind CSS — clean, professional, high-contrast design
- Mobile responsive for phone/tablet use

### 6.2 GraysonCommand Natural Language Interface
Embedded chat window on the dashboard — same as talking to Claude but with full GraysonOS context loaded.

**Example commands:**
- "Prep me for my 2pm call"
- "What meetings do I have next week that aren't confirmed?"
- "Draft a follow-up to yesterday's Zoom with the Mercer team"
- "Which domains haven't had any activity in 2 years?"
- "Show me all emails from @smithcapital.com across all accounts this month"
- "Build me an expense report for the Chicago trip"
- "Renew graysonventures.com"

### 6.3 Claude Code Hooks (Automation Layer)
Configured in `.claude/settings.json`:

- **Daily brief hook** — triggers every morning at 7am, generates and posts to `#daily-brief`
- **Pre-meeting hook** — triggers 30 min before any calendar event with a Zoom link
- **Post-meeting hook** — triggers on Zoom webhook, starts transcript pipeline
- **Email scan hook** — polls all 8 inboxes every 5 minutes for time-sensitive content
- **Domain scan hook** — runs nightly, checks for upcoming expirations
- **Finance sync hook** — runs nightly, syncs Plaid transactions, posts any alerts

**Deliverables:** Dashboard live on Vercel, chat interface working, all automation hooks configured and running, full GraysonOS operational.

---

## Summary Timeline

| Phase | Name | Duration | Key Deliverable |
|---|---|---|---|
| 1 | Foundation | Week 1 | Supabase live, CLAUDE.md drafted, Slack workspace ready |
| 2 | Mail + Calendar | Weeks 2–3 | Missed-meeting problem solved, morning briefs running |
| 3 | Zoom Intelligence | Week 4 | Every meeting summarized, action items tracked |
| 4 | Domains + Travel | Weeks 5–6 | Renewal alerts live, travel itineraries automated |
| 5 | Finance Pro + Wallet | Weeks 7–8 | Client CRM live, personal finances tracked |
| 6 | Dashboard | Week 9 | Visual cockpit on Vercel, full system operational |

---

## Information Needed from David

To begin Phase 1, the following inputs are required:

### Gmail Accounts
For each of the 8 Gmail accounts:
- Email address
- Primary purpose (personal, client-facing, legal, investments, etc.)
- Priority level (high / medium / low)
- Signature and tone style

### Google Calendars
For each of the 8 Google Calendars:
- Calendar name
- Which Gmail account it's associated with
- What types of events belong on it

### Key Contacts
- Names and firms of primary clients
- Known counterparties, legal counsel, accountants, advisors
- Any contacts that should always be treated as high priority

### GoDaddy
- GoDaddy account credentials or API key
- Approximate number of domains in portfolio
- Any domains with upcoming renewals in the next 90 days

### Zoom
- Zoom account email
- Whether cloud recording is currently enabled
- Preferred language for transcripts (English assumed)

### Financial
- Names of financial institutions to connect via Plaid
- Brokerage accounts to track
- Preferred expense categories for client work

### Slack
- Whether David has an existing Slack workspace to use, or needs a new one created

---

*Last updated: May 2026*
