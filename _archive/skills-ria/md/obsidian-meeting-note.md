# Obsidian Meeting Note

**Category:** Obsidian & Knowledge
**Slug:** `obsidian-meeting-note`

## Description
Format a meeting as a structured Obsidian markdown note.

## Prompt Template
You are formatting a meeting as a structured Obsidian markdown note for David Grayson, Principal at Grayson Financial.

The user will provide meeting details (who was there, when, what was discussed, decisions made, action items). Format as a complete Obsidian meeting note ready to save.

File name suggestion: /Meetings/[YYYY-MM-DD] [Meeting Title].md

Output the note in this exact format:

---
```
---
date: [YYYY-MM-DD]
title: "[Meeting Title]"
attendees: ["[Name 1]", "[Name 2]"]
meeting-type: [client-call / internal / prospect / partner / vendor / other]
duration: "[X minutes]"
tags: [meetings, graysonfinancial, and relevant topic tags]
related: []
---

# [Meeting Title]
**Date:** [Full date]
**Time:** [Time and timezone]
**Format:** [Zoom / Phone / In-Person]
**Attendees:** [Name, Firm] | [Name, Firm]

## Agenda Recap
[What was this meeting supposed to cover? Brief agenda or stated purpose]

## Key Discussion Points
- [Point 1 — specific, not vague]
- [Point 2]
- [Point 3]
[Continue as needed]

## Decisions Made
- [Decision 1 — who decided what]
- [Decision 2]
[If no decisions: "No formal decisions made — see action items"]

## Action Items
- [ ] [Action] — Owner: [[David Grayson]] | Due: [YYYY-MM-DD] | Priority: HIGH/MEDIUM/LOW
- [ ] [Action] — Owner: [[Client Name]] | Due: [YYYY-MM-DD] | Priority: HIGH/MEDIUM/LOW
[Use Obsidian task syntax and WikiLinks for owners]

## Open Questions
[Anything unresolved that needs follow-up or a decision]

## Next Meeting
**Proposed:** [Date or "TBD"]
**Purpose:** [What the next meeting should accomplish]

## Notes
[Additional context, observations, or anything that doesn't fit above]

## Related Notes
- [[Clients/[ClientName]]] — if client meeting
- [[Meetings/[previous related meeting]]] — if applicable
- [Other relevant WikiLinks]
```
---

After the note, output a separate section:

**SUPABASE ACTION ITEMS (ready to paste)**
| Action | Owner | Due Date | Priority | Client/Context |
[Table format of all action items extracted — ready to insert into action_items table]

Raw meeting details to format:
[PASTE MEETING DETAILS / BRAIN DUMP HERE]

## Tags
obsidian, notes, meeting, knowledge, markdown
