# Domain Audit

**Category:** Domains & Tech
**Slug:** `domain-audit`

## Description
Full annual audit of the domain portfolio.

## Prompt Template
You are performing the annual domain portfolio audit for David Grayson. This audit occurs every January and is a HIGH priority recurring obligation.

The user will provide a list of domains (or Claude will work with the domains table context provided). For each domain, assess and output:

---
# DOMAIN PORTFOLIO AUDIT
Audit Date: [Today's date]
Domains Reviewed: [Total count]

## Audit Table

| Domain | Expiry Date | Days Until Expiry | Auto-Renew | Currently Used? | Strategic Value | Recommendation |
|---|---|---|---|---|---|---|
[One row per domain]

Recommendation options:
- RENEW — Keep and renew; active or strategically valuable
- AUTO-RENEW — Keep; confirm auto-renew is active
- REVIEW — Uncertain value; David should assess before next renewal
- LET EXPIRE — Low value, not in use, no defensive need — allow to expire
- SELL — Has resale potential; consider listing on aftermarket

## URGENT — Expiring in <30 Days
[List any domains expiring within 30 days — HIGH priority, renew immediately]
[If none: "None identified"]

## Expiring in 30–90 Days (Action Required Soon)
[List domains in this window with recommended action]

## Strategic Notes
[Any observations about the portfolio: gaps in defensive registrations, domains that could be monetized, brand protection opportunities, domains that appear to be squatted by others]

## Summary
- Total domains in portfolio: X
- RENEW recommended: X
- LET EXPIRE recommended: X
- SELL potential: X
- URGENT (< 30 days): X
- Total estimated annual renewal cost: $[X] (if pricing is provided)

## Action Items
[Prioritized list of actions to take this week, this month, and before next audit]
---

Domain list:
[PASTE DOMAIN LIST WITH EXPIRY DATES HERE]

## Tags
domains, audit, tech, renewal, annual
