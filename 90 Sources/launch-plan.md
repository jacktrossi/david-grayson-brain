# GraysonOS — Launch Plan
**Client:** David Grayson | Grayson Financial / Brewster Ambulance / EMS / Backwoods Hospitality
**Built by:** Jack Rossi | jack@rossinetwork.com

---

## Quick Answer: Hostinger VPS, Not VPC

You need a **VPS** (Virtual Private Server), not a **VPC** (Virtual Private Cloud).
A VPC is an enterprise networking concept (AWS/Azure isolation). A VPS is just a server you rent.

**Use Hostinger KVM 1** — $4.99/mo, 1 vCPU, 4GB RAM, 50GB NVMe.
Hostinger has a **one-click Docker setup for Hermes Agent** built in. This is the easiest path.

---

## Full Stack

| Tool | Role | Cost |
|---|---|---|
| **Hermes Agent** | Autonomous AI agent — runs 24/7 | Free (open source) |
| **Hostinger VPS KVM 1** | Server that runs Hermes | ~$5/mo |
| **Composio** | OAuth connections for all accounts | Free tier to start |
| **Claude API** | LLM brain inside Hermes | ~$20-50/mo usage |
| **Supabase** | Database + encrypted secret vault | ~$25/mo Pro |
| **Obsidian** | David's knowledge base (local on his machine) | Free |
| **Total** | | **~$55-80/mo** (inside retainer) |

---

## PHASE 0 — Before the Meeting (Do This Tonight)

- [ ] **Create Composio account** at app.composio.dev — verify it's working again
- [ ] **Create Anthropic API account** at console.anthropic.com — grab API key
- [ ] **Create Supabase project** — run `supabase/migrations/001_initial_schema.sql`
- [ ] **Sign up for Hostinger** — KVM 1 plan ($4.99/mo)
- [ ] **Deploy Hermes on Hostinger** using one-click Docker setup
  - Go to: hostinger.com/vps/docker/hermes-agent
  - Point Claude API key at Hermes during setup
- [ ] **Test Hermes is running** — confirm the agent responds
- [ ] **Print or prep docs for signing:**
  - `docs/nda.md`
  - `docs/services-agreement.md`
  - Fill in: your state, company name, "[X] hours" → "2-3 hours"

---

## PHASE 1 — The Meeting (Tomorrow, ~11am at C&S)

### Step 1 — Close (10 min)
- [ ] Small talk, sit down
- [ ] Pull up payment link — David pays $1,700 setup fee
- [ ] Sign NDA (both parties)
- [ ] Sign Services Agreement (both parties)

### Step 2 — Discovery Interview (30-45 min)
Open `docs/discovery-interview.md` and walk through all 9 sections.
Fill in config notes at the bottom as David talks.

**Key things to confirm during interview:**
- [ ] Exact spelling of all 5 org email addresses
- [ ] Does he have Slack? Or is that new?
- [ ] How does he want tasks delivered — Todoist only, or also Slack?
- [ ] What time does he wake up? (Sets morning brief delivery time)
- [ ] Any other key contacts besides Mark, Jason, Courtney?

### Step 3 — Set Expectations (5 min)
- Tell David Composio just recovered from an incident — you'll have everything connected within 24-48 hours
- He'll receive a Slack message (or text if no Slack) when the system goes live
- First morning brief fires the following morning

---

## PHASE 2 — Same Day After Meeting (Afternoon)

### Step 1 — Composio Connections
Go to app.composio.dev and connect all of David's accounts:

**Gmail**
- [ ] Personal Gmail — David logs in via OAuth → grant read/send

**Office 365 — Microsoft Graph (repeat for each)**
- [ ] Brewster Ambulance
- [ ] EMS Revenue Solutions
- [ ] Backwoods Hospitality
- [ ] Columbia Southern
- [ ] Sacred Heart

**Other integrations**
- [ ] Slack (David's workspace or create new)
- [ ] Todoist (David's account)
- [ ] Microsoft Teams (via Microsoft Graph — already connected above)

> **Note:** David needs to be available by phone/text for 2FA prompts during this step.
> Set up a 30-min Zoom or just text back and forth as you go.

### Step 2 — Configure Hermes
SSH into Hostinger VPS and set environment variables:

```bash
# On Hostinger VPS
ANTHROPIC_API_KEY=your_key
SUPABASE_URL=your_url
SUPABASE_SERVICE_ROLE_KEY=your_key
COMPOSIO_API_KEY=your_key

# Composio connection IDs (paste after connecting each account)
GMAIL_PERSONAL_ID=
BREWSTER_365_ID=
EMS_365_ID=
BACKWOODS_365_ID=
COLUMBIA_365_ID=
SACRED_HEART_365_ID=
SLACK_ID=
TODOIST_ID=
```

### Step 3 — Configure VIP Alerts in Hermes
Add to Hermes config:

```json
{
  "vip_senders": [
    "mark brewster",
    "jason smith",
    "courtney murphy"
  ],
  "vip_action": "slack_urgent_alert",
  "high_priority_accounts": [
    "personal_gmail",
    "brewster_ambulance"
  ]
}
```

### Step 4 — Set Morning Brief Time
- [ ] Ask David what time he wakes up
- [ ] Set Hermes morning brief cron job to fire 30 min before that
- [ ] Configure delivery channel (Slack DM recommended)

```bash
# Example: David wakes at 7am → brief fires at 6:30am
MORNING_BRIEF_CRON="30 6 * * *"
MORNING_BRIEF_CHANNEL="slack_dm_david"
```

### Step 5 — Run Skills Migration in Supabase
- [ ] Open Supabase SQL editor → paste `skills/migration.sql` → run
- [ ] Verify 50 skills loaded: `SELECT count(*) FROM skills;` → should return 50

---

## PHASE 3 — Go-Live Verification (Evening)

- [ ] Hermes is running: `docker ps` on Hostinger — container shows Up
- [ ] Test email read: trigger a manual poll, confirm Hermes reads from all 6 accounts
- [ ] Test VIP alert: send a test email from an address named "Mark Brewster" → confirm Slack fires
- [ ] Test morning brief: trigger manually, review output for accuracy
- [ ] All connections show green in Composio dashboard

**Send David a message when live:**
> "You're live. Your first morning brief fires tomorrow at [TIME]. You'll get it in Slack. Let me know if anything looks off."

---

## PHASE 4 — Week 1-2 After Launch

- [ ] Monitor Hermes logs daily — catch any failed polls or errors
- [ ] Refine morning brief based on David's feedback
- [ ] Set up Todoist auto-task creation from email action items
- [ ] Sync Outlook Tasks → Todoist (Microsoft Graph)
- [ ] Build Teams meeting scheduler
- [ ] Set up Toast POS daily pulse (if API available)

---

## PHASE 5 — Month 2

- [ ] Bank anomaly monitoring (Plaid)
- [ ] QuickBooks monitoring
- [ ] Obsidian integration — auto-notes from meetings
- [ ] All 50 skills active and accessible
- [ ] Orgo setup if needed for apps without APIs

---

## Key Accounts to Create (If Not Already Set Up)

| Account | URL | Why |
|---|---|---|
| Hostinger | hostinger.com | VPS hosting for Hermes |
| Composio | app.composio.dev | OAuth connections |
| Anthropic | console.anthropic.com | Claude API key |
| Supabase | supabase.com | Database |

---

## Costs Summary

| Item | Monthly | Who Pays |
|---|---|---|
| Hostinger KVM 1 VPS | $4.99 | Covered in retainer |
| Supabase Pro | $25 | Covered in retainer |
| Claude API | ~$20-50 | Covered in retainer |
| Composio | $0-25 | Covered in retainer |
| **David's retainer** | **$550** | David pays Jack |
| **Jack's margin** | **~$445-500** | |

---

## Support Sources

- [Hostinger Hermes One-Click](https://www.hostinger.com/vps/docker/hermes-agent)
- [Hermes Agent GitHub](https://github.com/nousresearch/hermes-agent)
- [Composio Dashboard](https://app.composio.dev)
- [Supabase Dashboard](https://supabase.com)
