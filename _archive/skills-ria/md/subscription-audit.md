# Subscription Audit

**Category:** Domains & Tech
**Slug:** `subscription-audit`

## Description
Review all active software subscriptions and identify redundancy or waste.

## Prompt Template
You are performing a software subscription audit for David Grayson. The goal is to identify redundancy, unused tools, and savings opportunities.

The user will provide a list of active subscriptions with costs. Analyze and output:

---
# SUBSCRIPTION AUDIT
Audit Date: [Today's date]

## Subscription Inventory

| Tool/Service | Category | Monthly Cost | Annual Cost | Usage Level | GraysonOS Overlap | Recommendation |
|---|---|---|---|---|---|---|
[One row per subscription]

Categories: Productivity / Communication / Finance / Security / Development / Marketing / Travel / Storage / Other

Usage Levels: Active (daily/weekly) / Occasional (monthly) / Unknown / Unused

GraysonOS Overlap: Flag if GraysonOS (Claude + Supabase + custom packages) now provides equivalent functionality

Recommendations: KEEP / CANCEL / NEGOTIATE / CONSOLIDATE / EVALUATE

## Redundancy Flags
[Any subscriptions where two or more tools serve the same function — recommend keeping the better one and cancelling the other]

## Unused / Unknown Usage
[Any subscriptions where usage is unknown or appears unused — flag for David to verify before next billing cycle]

## GraysonOS Replacement Opportunities
[Any subscriptions that the GraysonOS platform may now make redundant — be specific about which GraysonOS capability replaces them]

## Upcoming Renewals
[Any annual subscriptions renewing in the next 60 days — flag for decision before auto-renewal]

## Financial Summary
| | Monthly | Annual |
|---|---|---|
| Current total spend | $X | $X |
| Recommended cuts | -$X | -$X |
| Projected spend after optimization | $X | $X |
| Estimated annual savings | | $X |

## Priority Actions (This Week)
[Top 3–5 specific actions to take: subscriptions to cancel, subscriptions to negotiate, subscriptions to evaluate]
---

Paste subscription list below (format: Tool name | Monthly or Annual cost | Notes):
[PASTE SUBSCRIPTION LIST HERE]

## Tags
subscriptions, tech, audit, cost, operations
