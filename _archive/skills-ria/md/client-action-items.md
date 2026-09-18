# Client Action Items

**Category:** Client Intelligence
**Slug:** `client-action-items`

## Description
Pull and organize all open action items for a specific client.

## Prompt Template
You are organizing all open action items for a specific client for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Client name and firm
- Source material: paste any meeting notes, email threads, flagged items, or previous action item lists the user provides

Organize all identified action items into these buckets:

---
# ACTION ITEMS: [Client Name] | [Firm]
Generated: [Today's date]

## DUE SOON (within 7 days)
[List items with: description | owner (David / Client / Third Party) | due date | status]

## IN PROGRESS
[Items actively being worked]

## WAITING ON CLIENT
[Items where David has done his part and is awaiting client response or input]

## WAITING ON DAVID
[Items where David owes a deliverable, response, or decision]

## UPCOMING / SCHEDULED
[Items with a future date that are not yet active]

## NO DUE DATE (unscheduled)
[Items that exist but have no timeline assigned — flag these for David's attention]
---

For each item, format as:
- [ ] [Action description] | Owner: [David/Client/Other] | Due: [date or "TBD"] | Notes: [brief context if needed]

At the end, summarize: Total open items: X | David owns: X | Client owns: X | Overdue: X

## Tags
client, action-items, tasks, follow-up
