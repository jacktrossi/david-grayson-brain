# AGENTS.md — How to Use This Vault

You are operating inside **David Grayson’s second brain**. Treat every file as durable memory. Prefer reading and updating vault notes over inventing facts.

## Read order (every session)

1. `CLAUDE.md` — identity kernel
2. `10 Identity/IDENTITY.md` — expanded identity
3. `00 Home/Dashboard.md` — map of the vault
4. Then only the folders relevant to the task (`40 Brands/`, `60 Skills/`, etc.)

## Hard rules

1. **Venue order is sacred.** Always: Whiskey Ranch → Estelle’s Diner → 1929. Oxford, MS is the city, not a venue.
2. **No Grayson Financial.** That firm does not exist. No RIA / investment-advisor persona.
3. **Never invent.** Brands, hex codes, Toast numbers, preferences, VIP details — if missing, mark `needs-david` or run an interview skill.
4. **Venue brand isolation.** Never apply Whiskey Ranch voice/visuals to Estelle’s or 1929 (and vice versa). Load `40 Brands/[Venue]/` first.
5. **Toast is read-first.** No menu edits, payouts, clock changes, or destructive Toast actions unless David explicitly confirms.
6. **Passwords never in vault.** Pause on login walls; David authenticates.
7. **Write durable notes.** Interview answers and Toast pulls belong in files, not only chat.

## Write rules

- Use templates in `70 Templates/` when available
- Frontmatter: include `status`, `updated`, and relevant tags
- After interviews: list exact paths created/updated
- Put unfiled captures in `Inbox/`

## Skill triggers

| David says… | Run |
|-------------|-----|
| “run onboarding interview” | `60 Skills/interview-onboarding.md` |
| “interview [venue] brand” | `60 Skills/interview-brand-venue.md` |
| “get Toast data” / “pull Toast” | `60 Skills/get-toast-data.md` |
| “morning brief” | `50 Playbooks/Morning-Brief.md` |
| “fill vault gaps” | `60 Skills/interview-gap-fill.md` |

## Quality bar (design & brand)

Outputs for BHG brands must feel **Fable-5 intentional**: sparse, premium, coherent. Ban generic restaurant AI slop (fake script fonts as the whole identity, purple gradients, stock “cheers” as the brand).

## Platforms

See `00 Home/How to plug this into ChatGPT Claude Cursor.md`. Toast browser automation requires Cursor (or similar) browser tools; elsewhere follow the manual checklist inside `get-toast-data`.
