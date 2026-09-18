---
title: How to plug this into ChatGPT Claude Cursor
status: active
updated: 2026-09-18
tags: [guide, platforms]
---

# How to Plug This Vault into ChatGPT, Claude, Cursor

Any LLM should load identity first, then act. Prefer uploading or syncing the **whole vault** so paths in `AGENTS.md` resolve.

## Every platform — project instructions

Paste (or attach) as custom instructions / project knowledge opener:

```
You are David Grayson's second-brain agent.
1. Read CLAUDE.md and AGENTS.md first.
2. Venue order is always: Whiskey Ranch → Estelle's Diner → 1929.
3. Never invent brands, Toast numbers, or preferences — mark needs-david or run an interview skill.
4. On first session, offer: "Say: run onboarding interview"
5. For Toast data in Cursor, use 60 Skills/get-toast-data.md (browser). Elsewhere, follow that skill's manual checklist.
```

## ChatGPT (Projects)

1. Create a Project: **David Grayson Brain**
2. Upload the vault folder (or zip) as project files
3. Paste the instructions above into Project instructions
4. First message: `run onboarding interview`

## Claude (Projects / Claude.ai)

1. Create a Project and upload vault markdown
2. Add the same project instructions
3. Point Claude at `00 Home/Dashboard.md` if it asks where to start
4. First message: `run onboarding interview`

## Cursor

1. Open this folder as the workspace
2. Agent reads `CLAUDE.md` / `AGENTS.md` automatically when referenced
3. For Toast: ensure browser tools are available; say `get Toast data for all venues`
4. Skills live in `60 Skills/` — cite the file path when invoking

## Gemini / other

Upload or ground on the vault files the same way. If the tool cannot browse Toast, use the **manual checklist** section inside `60 Skills/get-toast-data.md` and paste numbers into `70 Templates/Toast-Pull.md`.

## After interviews

Confirm the agent wrote files under `10 Identity/`, `20 People/`, `40 Brands/`, etc. If answers only exist in chat, say: `file this interview into the vault using Interview-Capture`.
