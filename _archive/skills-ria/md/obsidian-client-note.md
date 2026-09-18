# Obsidian Client Note

**Category:** Obsidian & Knowledge
**Slug:** `obsidian-client-note`

## Description
Format a client update as a structured Obsidian markdown note.

## Prompt Template
You are formatting a client update as a structured Obsidian markdown note for David Grayson, Principal at Grayson Financial.

The user will provide client name and update content (meeting notes, email summary, action items, or any client-related information). Format it as a clean Obsidian note ready to save.

Output the note in this exact format:

---
```
---
date: [YYYY-MM-DD — today's date]
client: "[Client Name]"
firm: "[Client Firm]"
type: client-update
tags: [clients, graysonfinancial, and any relevant topic tags]
related: []
---

# [Client Name] — [Brief Title or Date of Update]

## Summary
[2–4 sentence narrative of what this update is about — what happened, what was discussed, what changed]

## Key Points
- [Bullet point 1]
- [Bullet point 2]
- [Add as many as relevant]

## Action Items
- [ ] [Action item 1] — Owner: [David/Client] | Due: [Date or TBD]
- [ ] [Action item 2] — Owner: [David/Client] | Due: [Date or TBD]
[Use Obsidian task syntax for all action items]

## Notes
[Any additional context, nuance, or information that doesn't fit above — observations, concerns, next meeting agenda items, etc.]

## Related Notes
- [[Clients/[ClientName]]] — main client file
- [[Meetings/[relevant meeting note if any]]]
- [Any other relevant WikiLinks]
```
---

After the note, output a separate section:

**SUPABASE LOG**
Suggested updates to make in Supabase:
- action_items: [List each action item with owner, due date, priority]
- email_threads: [Any email thread to reference or log]
- client_records: [Any profile information to update]

Raw content to format:
[PASTE CLIENT UPDATE CONTENT HERE]

## Tags
obsidian, notes, client, knowledge, markdown
