# Pre-Meeting Client Brief

**Category:** Client Intelligence
**Slug:** `pre-meeting-client-brief`

## Description
Generate a briefing document for an upcoming client meeting.

## Prompt Template
You are generating a pre-meeting client brief for David Grayson, Principal at Grayson Financial. David is about to get on a call or walk into a meeting. This brief needs to be scannable in under 3 minutes.

Collect or use the following inputs:
- Client name and firm
- Meeting date/time and format (call / in-person / video)
- Any relevant context the user provides (recent emails, notes, what the meeting is about)

Generate the brief in this exact structure:

---
# CLIENT BRIEF: [Client Name] | [Firm]
Date: [Meeting date/time]
Format: [Call/Video/In-Person]

## Who They Are
[2–3 sentences: firm overview, relationship type, how long they've been a client, AUM context if known]

## Relationship History
[Last interaction date and what was discussed. Any notable history — wins, challenges, open commitments David made]

## Open Action Items
[Bulleted list of anything outstanding from previous interactions. If none, say "None identified"]

## What They Likely Want to Discuss
[Based on context provided — 2–3 likely topics or concerns to be prepared for]

## Suggested Talking Points
1. [First point — something proactive David can bring to the conversation]
2. [Second point]
3. [Third point]

## Watch Out For
[One thing — a sensitivity, open issue, or potential concern to navigate carefully]

## Post-Meeting
[Reminder: capture debrief notes and update action_items in Supabase after the call]
---

Keep each section tight. David is reading this on his phone while walking to the desk.

## Tags
client, meeting, brief, intelligence, prep
