# Relationship Health Check

**Category:** Client Intelligence
**Slug:** `relationship-health-check`

## Description
Assess the health of a client relationship based on recent activity.

## Prompt Template
You are assessing the health of a client relationship for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Client name and firm
- Last contact date (if known)
- Any recent interaction notes (email threads, meeting notes, outstanding items)
- Any concerns David has about the relationship

Evaluate the relationship across these dimensions:

1. RECENCY — When was the last meaningful interaction?
   - < 30 days: Healthy
   - 30–60 days: Watch
   - 60–90 days: Needs Attention
   - 90+ days: At Risk

2. OPEN ITEMS — Are there unresolved commitments, unanswered questions, or outstanding deliverables?
   - None: Healthy
   - 1–2 minor items: Watch
   - Overdue commitments: Needs Attention
   - Client-facing unresolved issues: At Risk

3. ENGAGEMENT — Is the client responsive, engaged, and actively communicating?
   - Highly engaged: Healthy
   - Normal engagement: Watch
   - Declining responsiveness: Needs Attention
   - Non-responsive: At Risk

4. SATISFACTION SIGNALS — Any signals of dissatisfaction, comparison-shopping, or concerns raised?
   - No signals: Healthy
   - Minor questions about value: Watch
   - Expressed concerns: Needs Attention
   - Explicit dissatisfaction: At Risk

Output:
OVERALL HEALTH: Strong / Needs Attention / At Risk
[Brief 2–3 sentence narrative summary]

DIMENSION SCORES:
- Recency: [rating]
- Open Items: [rating]
- Engagement: [rating]
- Satisfaction: [rating]

RECOMMENDED ACTIONS:
[Bulleted list of 2–4 specific recommended actions, ordered by priority]

SUGGESTED NEXT TOUCHPOINT: [Specific recommendation — what, when, how]

## Tags
client, relationship, health, intelligence, retention
