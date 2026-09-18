# GraysonOS — Service Proposal

**Prepared for:** David Grayson, Grayson Financial
**Prepared by:** Jack Rossi
**Date:** May 23, 2026

---

## Overview

GraysonOS is a custom-built personal intelligence operating system designed exclusively for David Grayson. It unifies all 8 email accounts, 8 Google Calendars, client communications, legal correspondence, investment alerts, travel logistics, and domain management into a single automated layer — with a Slack-based command interface as the primary touchpoint.

Rather than a generic AI tool, GraysonOS is purpose-built around the operational reality of Grayson Financial: compliance requirements, known clients, account priority order, communication tone, and recurring obligations are all encoded directly into the system.

---

## What's Included

### Connectivity
- 8 Gmail accounts monitored and triaged in real time
- 8 Google Calendars with intelligent routing (invites go to the matched calendar automatically)
- Zoom post-meeting summaries with action item extraction
- Slack as the command and alert interface (`#daily-brief`, `#urgent`, `#mail-actions`, `#zoom-summaries`, `#domains`, `#travel`, `#finances`, `#calendar`)

### Intelligence Layer
- Priority classification: HIGH / MEDIUM / LOW across all inboxes
- Known client detection (Smith Capital, Harris Group, Mercer Team + full `client_records` table)
- Compliance enforcement: disclaimer auto-appended to all client-facing email drafts
- Legal account flagging: attorney-client privilege notices, no auto-summarization
- Domain expiry monitoring with 30-day alerts
- Tax deadline reminders surfaced 14 days in advance (Q1–Q4 estimated payments + filing)

### Daily Operations
- Morning brief delivered to `#daily-brief` at 7am: meetings, priorities, open action items
- Email drafts posted to `#mail-actions` for one-tap approval before sending
- Quarterly client review prep briefs (January, April, July, October)
- Travel confirmation parsing → Supabase + Travel calendar
- Annual domain audit triggered every January 1

### Infrastructure
- Supabase (PostgreSQL + pgvector) as the system database
- All credentials stored encrypted in Supabase Vault — nothing in code or version control
- Hosted and running 24/7; no action required from David to keep it operational
- Full TypeScript monorepo under version control

---

## Pricing

| | |
|---|---|
| **One-Time Setup Fee** | **$1,700** |
| **Monthly Retainer** | **$550 / month** |

**Setup fee covers:**
Initial build, all connector integrations (Gmail × 8, Google Calendar × 8, Zoom, Slack, Twilio), Supabase schema, Vault configuration, compliance rules, triage logic, and deployment.

**Monthly retainer covers:**
Hosting and infrastructure costs (Supabase, API usage, Anthropic), ongoing maintenance, monitoring, bug fixes, minor configuration changes, and up to 2 hours of enhancements per month.

---

## Optional Add-Ons

| Add-On | Price |
|--------|-------|
| Plaid integration (bank/brokerage balance alerts) | $300 one-time |
| GoDaddy domain management connector | $150 one-time |
| Twilio voice/SMS interface | $200 one-time |
| Custom dashboard (Next.js web UI) | $800–$1,200 one-time |
| Additional connector (per integration) | $150–$400 one-time |

---

## Timeline

| Milestone | Target |
|-----------|--------|
| Vault setup + Gmail OAuth (all 8 accounts) | Week 1 |
| Slack connector + morning brief live | Week 1 |
| Zoom summaries + action item extraction | Week 2 |
| Email drafting + `#mail-actions` approval flow | Week 2 |
| Full QA, compliance verification, go-live | Week 3 |

---

## Terms

- Setup fee is due prior to build commencement
- Monthly retainer billed on the 1st of each month via Stripe
- 30-day written notice required to cancel the retainer
- All code, data, and credentials remain the property of David Grayson / Grayson Financial
- Confidentiality maintained on all email, calendar, and client data processed by the system

---

## Next Steps

1. Review and approve this proposal
2. Setup fee payment via invoice
3. 60-minute onboarding session to complete Gmail OAuth, Vault setup, and Slack workspace connection
4. System goes live within 3 weeks

---

*Questions? Reach out at jack@rossinetwork.com*
