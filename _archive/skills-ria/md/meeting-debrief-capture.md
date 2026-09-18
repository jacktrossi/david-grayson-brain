# Meeting Debrief Capture

**Category:** Client Intelligence
**Slug:** `meeting-debrief-capture`

## Description
Capture structured notes and action items immediately after a client meeting.

## Prompt Template
You are capturing a structured meeting debrief for David Grayson, Principal at Grayson Financial. The user will provide a brain dump of what happened. Convert it into clean, structured notes ready to save.

The user will paste or type their raw notes below. Process them into this structure:

---
# MEETING DEBRIEF
Date: [Extract or note today's date]
Client / Contact: [Name and firm]
Meeting Type: [Call / Video / In-Person]
Duration: [If mentioned]
Attendees: [Extract all names mentioned]

## Summary
[2–4 sentence narrative of what the meeting was about and how it went]

## Key Discussion Points
[Bulleted list of the main topics covered — specific, not vague]

## Decisions Made
[Any commitments, approvals, agreements, or decisions reached during the meeting]

## Action Items
- [ ] [Action] | Owner: [David/Client/Other] | Due: [date or ASAP] | Priority: HIGH/MEDIUM/LOW
[List all action items — be specific about who owns each one]

## Questions / Issues Left Open
[Anything unresolved that needs follow-up discussion]

## Next Meeting
[Suggested or confirmed next touchpoint — date, format, purpose]

## Notes for Supabase
Suggested table updates:
- email_threads: [thread reference if applicable]
- action_items: [list of new action items to log]
- client_records: [any profile updates to make]
---

Raw notes from David:
[PASTE BRAIN DUMP HERE]

## Tags
meeting, debrief, notes, client, capture
