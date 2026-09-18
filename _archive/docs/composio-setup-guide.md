# Composio Setup Guide — GraysonOS Go-Live

**Audience:** Jack (running the meeting)
**When:** Live, during the client meeting with David Grayson, immediately after payment.
**Goal:** Connect every one of David's accounts to GraysonOS via Composio OAuth in one sitting, so the system goes live the same day.

> Work through this top to bottom with David sitting across the table. Don't skip the "verify" step on any connection — a green check now saves a support call later.

---

## What Composio Is

Composio is the integration layer for GraysonOS. Instead of building OAuth flows from scratch for Gmail, Google Calendar, Slack, Zoom, and the rest, Composio handles authentication and exposes a unified API. Every connection David makes through Composio grants GraysonOS permission to read and write on his behalf (send mail, post to Slack, read his calendar, etc.). Each connection takes about 2-3 minutes.

---

## Pre-Meeting Checklist
*(Jack does this BEFORE David arrives — do not start the meeting until all five are checked.)*

- [ ] Composio account created at **app.composio.dev**
- [ ] **GraysonOS** project created inside Composio
- [ ] Composio **API key** generated and ready (you'll store it in Supabase Vault, not in `.env`)
- [ ] Laptop open, Composio dashboard loaded and logged in
- [ ] David's **`.env.example`** open for reference (note: only `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` live in `.env` — everything else, including Composio keys and connection IDs, is stored encrypted in **Supabase Vault** and loaded at startup)

> **Where secrets go:** `.env` stays tiny. The Composio API key and every connection ID below get written to **Supabase Vault**, not to `.env`. Keep a scratch doc or the Vault tab open to paste connection IDs as you go.

---

## Connection Order (at a glance)

| # | Integration | Count | Est. time |
|---|-------------|-------|-----------|
| 1 | Gmail | 8 accounts | ~20 min |
| 2 | Google Calendar | 8 calendars | ~15 min |
| 3 | Slack | 1 workspace | ~5 min |
| 4 | Zoom | 1 account | ~5 min |
| 5 | Microsoft 365 *(optional)* | if applicable | ~5 min |

---

## 1. Gmail — 8 Accounts

**Composio integration name:** `GMAIL`

David has 8 Gmail accounts; **each one needs its own Composio connection.** Repeat the steps below 8 times.

**Steps (per account):**
1. In Composio dashboard → **Apps** → search **Gmail** → **Connect / Add Account**.
2. Composio launches the Google OAuth flow in the browser.
3. **Hand David the keyboard.** He logs in with the *specific* account for this row.
4. Grant the requested scopes — **read and send mail**.
5. Composio returns to the dashboard. **Verify the connection shows green / Active.**
6. **Copy the connection ID** and paste it into your scratch doc against the matching account.

> **Critical:** Before David clicks "Authorize," confirm the browser is logged into the *right* Google account. The fastest way to avoid mistakes is to do these one at a time and sign out / use a fresh account picker between each.

**Track each connection:**

| Account | Label | Connected (green) | Connection ID |
|---------|-------|:-----------------:|---------------|
| account1@gmail.com | personal | [ ] | |
| account2@gmail.com | client-facing | [ ] | |
| account3@gmail.com | legal | [ ] | |
| account4@gmail.com | investments | [ ] | |
| account5@gmail.com | admin | [ ] | |
| account6@gmail.com | travel | [ ] | |
| account7@gmail.com | domains | [ ] | |
| account8@gmail.com | finance-pro | [ ] | |

**Config keys (store in Supabase Vault):** one Gmail connection ID per account, e.g.
`COMPOSIO_GMAIL_ACCOUNT1` … `COMPOSIO_GMAIL_ACCOUNT8`

---

## 2. Google Calendar — 8 Calendars

**Composio integration name:** `GOOGLECALENDAR`

Each Gmail account has a matching Google Calendar. These use the **same Google login** as the Gmail step but are a **separate Composio integration** — you connect them individually.

**Steps (per calendar):**
1. Composio dashboard → **Apps** → search **Google Calendar** → **Connect / Add Account**.
2. Google OAuth flow launches.
3. David logs in with the matching account (same account as the Gmail row).
4. Grant **calendar read/write** permissions.
5. **Verify green / Active.**
6. Copy the connection ID into your scratch doc.

> **Tip:** If David is still signed into the right Google account from the Gmail step, the calendar OAuth often goes through in one or two clicks. Still confirm the account before authorizing.

**Track each connection:**

| Calendar | Linked Account | Connected (green) | Connection ID |
|----------|----------------|:-----------------:|---------------|
| Personal | account1 | [ ] | |
| Client Meetings | account2 | [ ] | |
| Legal & Compliance | account3 | [ ] | |
| Investment Activity | account4 | [ ] | |
| Admin & Operations | account5 | [ ] | |
| Travel | account6 | [ ] | |
| Domains & Tech | account7 | [ ] | |
| Finance & Tax | account8 | [ ] | |

**Config keys (store in Supabase Vault):**
`COMPOSIO_GCAL_ACCOUNT1` … `COMPOSIO_GCAL_ACCOUNT8`

---

## 3. Slack

**Composio integration name:** `SLACK`

GraysonOS posts to these channels: `#daily-brief`, `#urgent`, `#mail-actions`, `#calendar`, `#finances`, `#travel`, `#domains`, `#zoom-summaries`.

**Steps:**
1. Composio dashboard → **Apps** → search **Slack** → **Connect**.
2. David authorizes the GraysonOS app on **his Slack workspace**.
3. Grant chat/post scopes.
4. **Verify green / Active.**
5. Confirm the bot can post — see test in the final section. If the channels are private, make sure the bot is invited to each one (`/invite @GraysonOS` in each channel).
6. Note the **bot token / connection ID**.

- [ ] Slack connected (green)
- [ ] Bot present in all 8 channels
- [ ] Connection ID / bot token saved to Vault

**Config key:** `COMPOSIO_SLACK` (connection ID); bot token in Vault.

---

## 4. Zoom

**Composio integration name:** `ZOOM`

Used for post-meeting transcription and summaries posted to `#zoom-summaries`.

**Steps:**
1. Composio dashboard → **Apps** → search **Zoom** → **Connect**.
2. David logs in with his Zoom account.
3. Grant **recording / transcript access**.
4. **Verify green / Active.**
5. Save the connection ID.

- [ ] Zoom connected (green)
- [ ] Recording/transcript scope granted
- [ ] Connection ID saved to Vault

**Config key:** `COMPOSIO_ZOOM`

---

## 5. Microsoft 365 *(Optional — only if David has a 365 account)*

**Composio integration name:** `MICROSOFT365` / `OUTLOOK`

Only do this if David uses a Microsoft 365 account for any email.

**Steps:**
1. Composio dashboard → **Apps** → search **Microsoft 365 / Outlook** → **Connect**.
2. David runs the Microsoft OAuth flow.
3. Grant mail read/send scopes.
4. **Verify green / Active.**
5. Save the connection ID.

- [ ] N/A — David has no 365 account
- [ ] Microsoft 365 connected (green) + Connection ID saved

**Config key:** `COMPOSIO_MS365`

---

## After All Connections Are Made

1. [ ] **Save all connection IDs and the Composio API key to Supabase Vault** (not `.env` — `.env` only holds the two Supabase keys).
2. [ ] **Run the nervous system test:** `pnpm run test:connections` — should show **green for each account** (18+ connections: 8 Gmail, 8 Calendar, Slack, Zoom, + 365 if added).
3. [ ] **Fire a live Slack test:** show David a test message landing in **`#daily-brief`**.
4. [ ] **Done — GraysonOS is live.** Confirm the win with David out loud.

---

## Troubleshooting (keep this handy mid-meeting)

- **Gmail OAuth fails or grabs the wrong account:** Make sure David is logged into the *correct* Google account in the browser *before* clicking Authorize. Use the account picker, or sign out between connections. Do them one at a time.
- **Connection shows "expired":** **Re-authorize — do not delete.** Deleting loses the connection ID and any downstream config.
- **Connection limits / free tier:** Composio's free tier may cap connected accounts. 8+ Gmail accounts likely needs a **paid plan** — confirm this is sorted *before* the meeting so you don't stall halfway.
- **2FA prompt mid-flow:** Have **David's phone nearby**. Google, Slack, and Zoom may all trigger a code or push approval.
- **Slack bot can't post:** The bot needs to be a member of each channel. Run `/invite @GraysonOS` in any channel it can't reach (especially private ones).
- **Calendar didn't connect but Gmail did:** Remember they're separate Composio integrations. Connecting Gmail does **not** auto-connect Calendar — run the Calendar step explicitly.

---

## Time Estimate

| Task | Time |
|------|------|
| 8 Gmail connections | ~20 min |
| 8 Calendar connections | ~15 min |
| Slack | ~5 min |
| Zoom | ~5 min |
| Buffer / troubleshooting | ~15 min |
| **Total** | **~60 min** |
