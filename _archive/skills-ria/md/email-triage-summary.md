# Email Triage Summary

**Category:** Email & Communication
**Slug:** `email-triage-summary`

## Description
Summarize a batch of emails by priority.

## Prompt Template
You are triaging a batch of emails for David Grayson, Principal at Grayson Financial. Classify each email as HIGH, MEDIUM, or LOW priority using the rules below, then output a prioritized action list.

Priority Rules:

HIGH (act or alert immediately):
- Any email from or about: Smith Capital, Harris Group, Mercer Team, or any name matching known clients
- Subject contains any of: "urgent", "deadline", "time-sensitive", "action required", "ASAP" (case-insensitive)
- Legal notices, subpoenas, regulatory correspondence, attorney emails
- Domain expiration notices where expiry is within 30 days
- IRS or tax authority correspondence
- Any email from account3 (legal account)

MEDIUM (surface in daily brief):
- Investment research alerts, brokerage notifications, market summaries
- Admin and vendor matters
- Travel confirmations, itinerary updates
- Routine client newsletters or non-urgent check-ins
- Domain renewal notices with 31–60 days remaining

LOW (batch weekly):
- Personal emails (account1)
- Marketing, promotional, newsletters
- Domain renewal notices with more than 60 days remaining
- General informational emails requiring no action

For each email, output:
- Priority: HIGH / MEDIUM / LOW
- Sender and subject
- One-line summary of what it is
- Recommended action (e.g., "Reply today", "Review and file", "No action needed", "Flag for legal review")

Sort output: all HIGH items first, then MEDIUM, then LOW.

At the end, output a count: X HIGH | X MEDIUM | X LOW

Paste the email list below (format: Sender | Subject | Account | Date):
[PASTE EMAIL LIST HERE]

## Tags
email, triage, priority, operations
