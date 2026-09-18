# GraysonOS Skills — Master Index

50 structured prompt templates for David Grayson, Principal at Grayson Financial.

Each skill is stored in the Supabase `skills` table (see `migration.sql`) and has a corresponding markdown reference file in `/skills/md/`.

---

## Email & Communication

| Slug | Title | Description |
|------|-------|-------------|
| `draft-client-email` | Draft Client Email | Draft a professional, compliant email to a client from scratch. |
| `reply-to-client-inquiry` | Reply to Client Inquiry | Draft a reply to an incoming client email with compliance checks. |
| `email-triage-summary` | Email Triage Summary | Classify a batch of emails as HIGH/MEDIUM/LOW using David's triage rules. |
| `cold-thread-followup` | Cold Thread Follow-Up | Draft a polite follow-up for an email thread that has gone unanswered. |
| `meeting-request-draft` | Meeting Request Draft | Draft a meeting request email to a client or contact. |
| `quarterly-update-email` | Quarterly Update Email | Draft a quarterly portfolio/relationship update email to a client. |
| `new-client-welcome` | New Client Welcome Email | Draft a welcome email for a newly onboarded advisory client. |
| `referral-thankyou` | Referral Thank You | Draft a thank-you note for a referral from Mercer Advisors or another partner. |
| `compliance-email-check` | Compliance Email Check | Pre-send review of a draft email for disclaimer, securities, and legal red flags. |
| `newsletter-draft` | Client Newsletter Draft | Draft a monthly or quarterly client newsletter for Grayson Financial. |

---

## Client Intelligence

| Slug | Title | Description |
|------|-------|-------------|
| `pre-meeting-client-brief` | Pre-Meeting Client Brief | Generate a scannable briefing document for an upcoming client meeting. |
| `relationship-health-check` | Relationship Health Check | Score a client relationship across recency, open items, engagement, and satisfaction. |
| `quarterly-review-prep` | Quarterly Review Prep | Full preparation brief for a 45-60 minute quarterly client review. |
| `client-action-items` | Client Action Items | Pull and organize all open action items for a specific client. |
| `meeting-debrief-capture` | Meeting Debrief Capture | Convert a post-meeting brain dump into structured notes and Supabase-ready action items. |
| `new-client-intake` | New Client Intake Checklist | Generate a complete onboarding checklist for a new advisory client. |
| `client-anniversary-note` | Client Anniversary Note | Draft a brief annual relationship anniversary touchpoint message. |
| `prospect-first-email` | Prospect First Email | Draft the first outreach email to a prospective advisory client. |

---

## Investment & Market

| Slug | Title | Description |
|------|-------|-------------|
| `morning-market-brief` | Morning Market Brief | Structure a morning market briefing from overnight and pre-market data. |
| `earnings-summary` | Earnings Summary | Extract a 5-bullet decision-ready summary from an earnings release. |
| `research-report-digest` | Research Report Digest | Condense a long research report into a 1-page decision-ready digest. |
| `investment-thesis-builder` | Investment Thesis Builder | Build a formal investment thesis with bull case, bear case, risks, and catalysts. |
| `security-mention-flag` | Security Mention Flag | Scan text for specific securities and classify them by compliance risk. |
| `macro-weekly-brief` | Macro Weekly Brief | Generate a structured weekly macro briefing across rates, equities, and geopolitics. |
| `portfolio-risk-check` | Portfolio Risk Check | Analyze a portfolio for concentration, correlation, and downside risk flags. |

---

## Calendar & Scheduling

| Slug | Title | Description |
|------|-------|-------------|
| `pre-call-brief` | Pre-Call Brief | 5-minute rapid brief generated 30 minutes before a scheduled call. |
| `day-planner` | Day Planner | Build a structured, prioritized day plan from meetings and task list. |
| `weekly-overview` | Weekly Overview | Monday morning week-at-a-glance briefing with focus recommendation. |
| `reschedule-draft` | Reschedule Draft | Draft a polite, professional meeting reschedule request. |
| `calendar-audit` | Calendar Audit | Review the next 30 days of calendar for gaps, over-commitment, and missing prep. |

---

## Legal & Compliance

| Slug | Title | Description |
|------|-------|-------------|
| `compliance-document-review` | Compliance Document Review | Review any document for RIA compliance red flags before use. |
| `legal-email-flag` | Legal Email Flag | Determine if an email is attorney-client privileged and how to handle it. |
| `regulatory-deadline-tracker` | Regulatory Deadline Tracker | List all upcoming tax, SEC, and RIA compliance deadlines. |
| `contract-key-points` | Contract Key Points | Extract parties, obligations, payment terms, and red flags from a contract. |
| `ria-compliance-checklist` | RIA Compliance Checklist | Generate a comprehensive quarterly/annual RIA compliance checklist. |

---

## Travel

| Slug | Title | Description |
|------|-------|-------------|
| `trip-summary` | Trip Summary | Compile all trip details into one briefing using David's travel preferences. |
| `travel-expense-report` | Travel Expense Report | Compile and categorize travel expenses from a completed trip. |
| `flight-options-brief` | Flight Options Brief | Generate a flight search brief with Delta/SkyMiles preferences applied. |
| `hotel-booking-brief` | Hotel Booking Brief | Generate a hotel booking brief with Marriott Bonvoy preferences applied. |
| `itinerary-review` | Itinerary Review | Review a travel itinerary and flag tight connections, gaps, and missing confirmations. |

---

## Domains & Tech

| Slug | Title | Description |
|------|-------|-------------|
| `domain-audit` | Domain Audit | Full annual audit of the domain portfolio with recommendations per domain. |
| `domain-expiry-check` | Domain Expiry Check | Flag domains expiring within 30/60 days in RED/YELLOW/GREEN bands. |
| `subscription-audit` | Subscription Audit | Review all active software subscriptions for redundancy, waste, and GraysonOS overlap. |
| `tech-stack-brief` | Tech Stack Brief | Document the current GraysonOS technology stack for reference or developer onboarding. |

---

## Daily Operations

| Slug | Title | Description |
|------|-------|-------------|
| `morning-brief` | Morning Brief | Daily morning priority brief — meetings, HIGH items, deadlines, and focus recommendation. |
| `eod-wrap` | End of Day Wrap | End-of-day summary converting a brain dump into completed/carry-forward/tomorrow items. |
| `weekly-digest` | Weekly Digest | Friday end-of-week summary and next-week preview with client activity table. |
| `open-action-items` | Open Action Items | Organize all open action items across all sources into a prioritized master list. |

---

## Obsidian & Knowledge

| Slug | Title | Description |
|------|-------|-------------|
| `obsidian-client-note` | Obsidian Client Note | Format a client update as a structured Obsidian markdown note with YAML frontmatter. |
| `obsidian-meeting-note` | Obsidian Meeting Note | Format a meeting as a structured Obsidian markdown note with action items and WikiLinks. |

---

## Files

| File | Purpose |
|------|---------|
| `migration.sql` | Creates the `skills` table and inserts all 50 skill records |
| `md/{slug}.md` | Individual reference file for each skill |
| `README.md` | This file — master index of all skills |

---

## Usage

Invoke a skill by its slug. The `prompt_template` field contains the complete prompt to execute. Skills can be triggered programmatically from the GraysonOS command package or invoked directly in a conversation by referencing the slug.

Compliance note: All skills involving client-facing emails automatically include or prompt for the mandatory disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
