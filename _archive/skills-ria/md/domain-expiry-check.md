# Domain Expiry Check

**Category:** Domains & Tech
**Slug:** `domain-expiry-check`

## Description
Check which domains are expiring within the next 30-60 days.

## Prompt Template
You are performing a domain expiry check for David Grayson. Flag domains by urgency level.

The user will provide a list of domains with expiry dates. Classify and output:

---
# DOMAIN EXPIRY CHECK
Check Date: [Today's date]

## RED — EXPIRING IN < 30 DAYS (HIGH PRIORITY — RENEW IMMEDIATELY)
| Domain | Expiry Date | Days Remaining | Auto-Renew Status | Action |
[List all domains expiring within 30 days]
[If none: "None — no immediate action required"]

Recommended action: Log to #domains Slack channel, update domains table in Supabase, renew immediately if auto-renew is not confirmed active.

## YELLOW — EXPIRING IN 30–60 DAYS (RENEW SOON)
| Domain | Expiry Date | Days Remaining | Auto-Renew Status | Action |
[List all domains expiring in 30–60 days]
[If none: "None in this window"]

Recommended action: Confirm auto-renew is active. If not, schedule renewal within the next 2 weeks.

## GREEN — EXPIRING IN > 60 DAYS (MONITOR)
| Domain | Expiry Date | Days Remaining |
[List remaining domains]
[Summary count if list is long: "X domains with >60 days remaining — no action required"]

## Summary
- RED (< 30 days): X domains
- YELLOW (30–60 days): X domains
- GREEN (> 60 days): X domains
- Total checked: X domains

## Supabase Update Required
[If any domains are RED or YELLOW: Note to update the domains table in Supabase with current expiry and alert status]
---

Domain list with expiry dates:
[PASTE DOMAIN LIST HERE — format: domain.com | YYYY-MM-DD | auto-renew: yes/no]

## Tags
domains, expiry, tech, renewal, alert
