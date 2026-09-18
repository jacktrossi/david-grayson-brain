# David Grayson — Identity Kernel

This file is the authoritative identity contract for David Grayson’s second brain vault. Any LLM (ChatGPT, Claude, Cursor, Gemini, etc.) must read this and `AGENTS.md` before acting.

---

## Who

- **Name:** David Grayson
- **Role:** Multi-organization operator
- **Hospitality parent:** Backwoods Hospitality Group (BHG)
- **Home base for restaurants:** The Square, Oxford, Mississippi

**Not true:** David is not a principal at “Grayson Financial.” That entity does not exist. Never use RIA, investment-advisory, or Grayson Financial framing.

---

## Backwoods Hospitality Group — Venues

Three restaurants on the Oxford, MS Square. **Always list and process in this order:**

1. **Whiskey Ranch**
2. **Estelle’s Diner**
3. **1929**

Oxford is the **city / Square location**, not a venue name. Do not invent a fourth venue called “Oxford.”

All three venues run on **Toast POS**. Use skill `60 Skills/get-toast-data.md` for restaurant data pulls.

---

## Other Organizations

| Organization | Role | Priority |
|--------------|------|----------|
| Brewster Ambulance | Primary Boston work | HIGH |
| EMS Revenue Solutions | Consulting | MEDIUM |
| Colombia Southern | Instructor | LOWER |
| Sacred Heart | Instructor | LOWER |
| Personal | Life, family, personal Gmail | Context-dependent |

---

## Email Priority (check order)

1. Personal Gmail (HIGH — first thing each morning)
2. Brewster Ambulance — Office 365 (HIGH — “the Boston one”)
3. EMS Revenue Solutions — Office 365
4. Backwoods Hospitality — Office 365
5. Colombia Southern — Office 365
6. Sacred Heart — Office 365

---

## VIP Contacts (immediate attention)

- Mark Brewster
- Jason Smith
- Courtney Murphy

Any email from these three → top of morning brief; treat as urgent.

---

## Morning Reality

1. Wake → phone + coffee
2. Toast (restaurant daily summary — looking for anything strange)
3. Bank accounts (anomaly / fire spotting, not full bookkeeping)
4. Emails — Personal Gmail first, then Brewster, then the rest

Pain: no single system; manual hopping across apps. This vault + Morning Brief playbook replace that.

---

## Communication

- Professional, concise, clear
- Match audience: VIP / staff / guests / vendors / students
- For venue guest-facing copy, load the correct brand kit under `40 Brands/` — never mix Whiskey Ranch voice onto Estelle’s or 1929
- Sign as David Grayson (context-appropriate; no fake firm disclaimer)

---

## How AI Should Behave

- Prefer brevity; lead with the answer
- Never invent brand colors, logos, sales numbers, or preferences — mark `status: needs-david` or run an interview skill
- Cite vault paths when updating knowledge
- On first spin-up, offer: **“Say: run onboarding interview”**
- For Toast: use `get-toast-data`; read-only unless David explicitly confirms writes

---

## Canonical Paths

| Need | Path |
|------|------|
| Agent rules | `AGENTS.md` |
| Identity detail | `10 Identity/` |
| People / VIPs | `20 People/` |
| Orgs & venues | `30 Organizations/` |
| Brand kits | `40 Brands/` |
| Playbooks | `50 Playbooks/` |
| Skills | `60 Skills/` |
| Templates | `70 Templates/` |
| Toast pulls / meetings | `80 Journal-Meetings/` |
| Source interviews | `90 Sources/` |
| Capture inbox | `Inbox/` |
