-- GraysonOS Skills Table Migration
-- Creates the skills table and inserts all 50 defined skills

create table if not exists public.skills (
  id uuid default gen_random_uuid() primary key,
  slug text unique not null,
  title text not null,
  description text not null,
  category text not null,
  prompt_template text not null,
  tags text[] default '{}',
  is_active boolean default true,
  created_at timestamptz default now()
);

insert into public.skills (slug, title, description, category, prompt_template, tags) values

-- ============================================================
-- CATEGORY: Email & Communication
-- ============================================================

(
  'draft-client-email',
  'Draft Client Email',
  'Draft a professional, compliant email to a client from scratch.',
  'Email & Communication',
  $$You are drafting a professional, compliant client email on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Recipient name and firm (e.g., "John Smith, Smith Capital Management")
- Subject / purpose of the email (e.g., "Q2 portfolio review follow-up")
- Key points to convey (bullet list of 2–5 ideas or facts to communicate)
- Tone modifier if any (e.g., "more formal", "warm but brief")

Instructions:
1. Address the recipient as "Mr." or "Ms." followed by their last name unless a first-name basis has been explicitly established.
2. Open with a clear, direct first sentence that states the purpose of the email.
3. Keep the body concise — get to the point within the first two sentences.
4. Use bullet points if conveying more than two distinct items.
5. Close with "Best regards, David Grayson | Grayson Financial".
6. Append the mandatory compliance disclaimer on a new line after the sign-off:
   "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
7. If any specific securities, tickers, or investment performance figures are mentioned in the key points, insert a flag: ⚠️ FLAG FOR MANUAL REVIEW — specific securities/performance figures mentioned. Do not send without David's review.

Output the complete, ready-to-send email. Do not add commentary above or below the email itself.$$,
  ARRAY['email', 'client', 'compliance', 'draft']
),

(
  'reply-to-client-inquiry',
  'Reply to Client Inquiry',
  'Draft a reply to an incoming client email.',
  'Email & Communication',
  $$You are drafting a professional reply to an incoming client email on behalf of David Grayson, Principal at Grayson Financial.

The user will paste the full text of the incoming email below. Read it carefully before drafting the reply.

Instructions:
1. Identify the sender's name and firm from the email. Address them as "Mr." or "Ms." + last name.
2. Identify the core question, request, or concern being raised. Address it directly in the first 1–2 sentences of your reply.
3. Keep the reply concise and financial-industry appropriate. No slang. No filler language.
4. If the email contains a question that requires research or action before answering, note that clearly: "I am looking into this and will follow up by [reasonable timeframe]."
5. If the email references any specific securities (by name, ticker, or CUSIP), flag them: ⚠️ SECURITIES MENTIONED — flag for manual review before sending. List each security identified.
6. If the email references specific performance figures David has shared, flag: ⚠️ PERFORMANCE FIGURES REFERENCED — ensure accuracy before sending.
7. Close with "Best regards, David Grayson | Grayson Financial".
8. Append the mandatory compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."

Output the complete reply email, followed by a brief section labeled "FLAGS" if any issues were detected (securities, performance claims, etc.).

Incoming email:
[PASTE EMAIL HERE]$$,
  ARRAY['email', 'client', 'reply', 'compliance', 'triage']
),

(
  'email-triage-summary',
  'Email Triage Summary',
  'Summarize a batch of emails by priority.',
  'Email & Communication',
  $$You are triaging a batch of emails for David Grayson, Principal at Grayson Financial. Classify each email as HIGH, MEDIUM, or LOW priority using the rules below, then output a prioritized action list.

Priority Rules:
HIGH (act or alert immediately):
- Any email from or about: Smith Capital, Harris Group, Mercer Team, or any name matching known clients
- Subject contains any of: "urgent", "deadline", "time-sensitive", "action required", "ASAP" (case-insensitive)
- Legal notices, subpoenas, regulatory correspondence, attorney emails
- Domain expiration notices where expiry is within 30 days
- IRS or tax authority correspondence
- Any email from account3 (legal account)

MEDIUM (surface in daily brief):
- Investment research alerts, brokerage notifications, market summaries
- Admin and vendor matters
- Travel confirmations, itinerary updates
- Routine client newsletters or non-urgent check-ins
- Domain renewal notices with 31–60 days remaining

LOW (batch weekly):
- Personal emails (account1)
- Marketing, promotional, newsletters
- Domain renewal notices with more than 60 days remaining
- General informational emails requiring no action

For each email, output:
- Priority: HIGH / MEDIUM / LOW
- Sender and subject
- One-line summary of what it is
- Recommended action (e.g., "Reply today", "Review and file", "No action needed", "Flag for legal review")

Sort output: all HIGH items first, then MEDIUM, then LOW.

At the end, output a count: X HIGH | X MEDIUM | X LOW

Paste the email list below (format: Sender | Subject | Account | Date):
[PASTE EMAIL LIST HERE]$$,
  ARRAY['email', 'triage', 'priority', 'operations']
),

(
  'cold-thread-followup',
  'Cold Thread Follow-Up',
  'Draft a follow-up for an email thread that has gone unanswered.',
  'Email & Communication',
  $$You are drafting a follow-up email for David Grayson, Principal at Grayson Financial, for an email thread that has received no response.

Collect or use the following inputs:
- Who the original email was sent to (name, firm, relationship to David)
- Original email subject and brief context of what was asked or discussed
- How long ago the original email was sent (e.g., "8 days ago", "3 weeks ago")
- Is this a client, prospect, or general contact?

Instructions:
1. Do not be pushy or passive-aggressive. The tone should be polite, professional, and assume the best — the recipient has simply been busy.
2. Keep it short — 3–5 sentences maximum. The recipient has already seen the original email.
3. Reference the original email briefly (subject or topic) without restating all the details.
4. End with a clear but low-pressure call to action (e.g., "When you have a moment, I'd appreciate your thoughts" or "Let me know if this week works for a quick call").
5. If the recipient is a client, append the compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
6. Close with "Best regards, David Grayson | Grayson Financial".

Timing guidance:
- Under 1 week old: Too soon — suggest waiting before following up unless HIGH priority.
- 1–2 weeks: Appropriate follow-up window.
- 2–4 weeks: Acknowledge the delay has been longer, slightly warmer tone.
- 4+ weeks: This thread may be cold — note that and ask if the topic is still relevant.

Output the complete follow-up email. If the thread is too new to follow up, explain why and suggest when to follow up instead.$$,
  ARRAY['email', 'follow-up', 'client', 'outreach']
),

(
  'meeting-request-draft',
  'Meeting Request Draft',
  'Draft a meeting request email to a client or contact.',
  'Email & Communication',
  $$You are drafting a meeting request email on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Recipient name, firm, and relationship (client / prospect / partner / vendor)
- Purpose of the meeting (e.g., "Q3 portfolio review", "introductory call", "discuss estate planning options")
- Preferred format (video call / phone / in-person)
- Rough timeframe (e.g., "sometime next week", "before end of month")
- Duration (default: 30 minutes unless otherwise specified)
- Any specific agenda items to surface in the request

Instructions:
1. Open by clearly stating why you are requesting the meeting in the first sentence.
2. Briefly outline what will be covered (2–3 agenda points maximum — don't over-commit to detail).
3. Propose a format and rough availability, but make it easy for the recipient to suggest an alternative.
4. Keep the email to 5 sentences or fewer in the body.
5. If the recipient is a client, append the compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
6. Close with "Best regards, David Grayson | Grayson Financial".

Output the complete meeting request email, ready to send.$$,
  ARRAY['email', 'meeting', 'scheduling', 'client']
),

(
  'quarterly-update-email',
  'Quarterly Update Email',
  'Draft a quarterly portfolio/relationship update email to a client.',
  'Email & Communication',
  $$You are drafting a quarterly update email on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Client name and firm
- Quarter and year (e.g., "Q2 2026")
- 2–3 key talking points provided by David (portfolio observations, market commentary, action items, or relationship notes)
- Any open items or decisions the client needs to be aware of

Instructions:
1. Address the client as "Mr." or "Ms." + last name.
2. Open by framing the quarter — brief, confident, professional. One sentence is enough.
3. Communicate each talking point in a clear, plain-English paragraph or short bullet list. Do not pad with unnecessary language.
4. If any specific securities, return percentages, or forward-looking projections are included in the talking points: ⚠️ FLAG — specific securities/performance figures mentioned. Do not send without David's manual review and approval.
5. Close with a forward-looking sentence about the next quarter or next touchpoint.
6. Use the sign-off: "Best regards, David Grayson | Grayson Financial".
7. Append the mandatory compliance disclaimer on a new line: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."

Output the complete quarterly update email, followed by any FLAGS if securities or performance figures were detected.$$,
  ARRAY['email', 'quarterly', 'client', 'update', 'compliance']
),

(
  'new-client-welcome',
  'New Client Welcome Email',
  'Draft a welcome email for a newly onboarded advisory client.',
  'Email & Communication',
  $$You are drafting a new client welcome email on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- New client name and firm
- What was agreed upon during onboarding (e.g., service tier, initial focus areas, investment mandate)
- Any immediate next steps already discussed

Instructions:
1. Warm but professional tone — this is a relationship-building email, not a transactional one.
2. Address the client as "Mr." or "Ms." + last name.
3. Open by expressing genuine welcome and noting that you are glad to be working together.
4. Outline 3–5 concrete next steps so the client knows exactly what to expect in the coming days/weeks:
   - What David will do (e.g., schedule intake call, review documents)
   - What the client needs to do (e.g., complete onboarding forms, provide statements)
   - When the first meeting or review will occur
5. Provide direct contact info or confirm the best way to reach David with questions.
6. Keep the body to under 200 words.
7. Close with "Best regards, David Grayson | Grayson Financial".
8. Append the compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."

Output the complete welcome email, ready to send.$$,
  ARRAY['email', 'onboarding', 'client', 'welcome']
),

(
  'referral-thankyou',
  'Referral Thank You',
  'Draft a thank-you note for a referral, typically to Mercer Advisors or another strategic partner.',
  'Email & Communication',
  $$You are drafting a referral thank-you email on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Who sent the referral (name, firm — often Mercer Advisors or another strategic partner)
- Name of the referred prospect (if known and appropriate to mention)
- Any context about the nature of the referral or why it was particularly valued
- The relationship dynamic (longstanding partner vs. newer connection)

Instructions:
1. Genuine and warm — not effusive or sycophantic. One sincere thank-you is worth more than three enthusiastic ones.
2. Open by thanking them directly and specifically (not "I wanted to reach out to thank you").
3. Acknowledge why the referral matters — either the quality of the connection or the trust it represents.
4. If appropriate, note that you will take good care of the referred contact.
5. Close by reinforcing the mutual value of the partnership and leaving the door open for reciprocal referrals or future collaboration.
6. Keep to under 150 words.
7. Close with "Best regards, David Grayson | Grayson Financial".
8. No compliance disclaimer needed — this is not investment advice communication.

Output the complete thank-you email, ready to send.$$,
  ARRAY['email', 'referral', 'relationship', 'partners']
),

(
  'compliance-email-check',
  'Compliance Email Check',
  'Review a draft email for compliance issues before sending.',
  'Email & Communication',
  $$You are performing a pre-send compliance review of a draft email on behalf of David Grayson, a registered investment advisor at Grayson Financial.

The user will paste a draft email. Review it against the following compliance checklist:

CHECK 1 — DISCLAIMER PRESENT (if client-facing):
Is the mandatory disclaimer present? Required text: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
→ If the email is going to a client and this disclaimer is missing: FAIL

CHECK 2 — SPECIFIC SECURITIES MENTIONED:
Does the email mention any specific securities by name, ticker symbol, or CUSIP?
→ If yes: FLAG each one and note the context (recommendation? performance discussion? general reference?)
→ Any securities mentioned in a recommendation or performance context: FAIL — requires David's manual review

CHECK 3 — FORWARD-LOOKING PERFORMANCE STATEMENTS:
Does the email contain any projected returns, forecasted performance, or guarantees?
→ If yes: FAIL — forward-looking statements require legal review and proper caveats

CHECK 4 — SUITABILITY LANGUAGE:
Does the email make any blanket investment recommendations without suitability context?
→ If yes: FLAG for review

CHECK 5 — SIGN-OFF:
Is the sign-off "Best regards, David Grayson | Grayson Financial" or equivalent professional close?
→ If missing: NOTE

CHECK 6 — GENERAL RED FLAGS:
Any other language that could create legal exposure for a registered investment advisor? (guarantees, unlicensed services implied, confidentiality breaches, etc.)

Output format:
OVERALL: PASS / PASS WITH FLAGS / FAIL
Then list each check result with a brief explanation.
If FAIL or FLAGS, provide specific corrective language.

Draft email to review:
[PASTE DRAFT EMAIL HERE]$$,
  ARRAY['compliance', 'email', 'review', 'legal', 'audit']
),

(
  'newsletter-draft',
  'Client Newsletter Draft',
  'Draft a monthly or quarterly client newsletter for Grayson Financial.',
  'Email & Communication',
  $$You are drafting a client newsletter on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Period covered (e.g., "May 2026" or "Q2 2026")
- 2–3 market themes or macro observations for the period
- Any firm updates or announcements (optional)
- Tone: professional and informative, suitable for a broad advisory client audience

Instructions:
1. Open with a brief personal note from David — one short paragraph, warm but professional.
2. Market Observations section: Cover the 2–3 themes provided. Plain English — no jargon. Each theme gets 2–4 sentences.
3. What It Means For Your Portfolio section: General observations on how these themes affect typical advisory portfolios. Do NOT reference specific client portfolios or individual positions.
4. Outlook section: 2–4 sentences on what David is watching in the period ahead.
5. Firm Updates section (only if updates were provided): Brief, factual.
6. Close with a brief invitation to reach out with questions.
7. Sign-off: "Best regards, David Grayson | Grayson Financial"
8. Append the mandatory compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."

⚠️ If any specific securities, return figures, or individual client data are included in the input, FLAG them and do not include in the newsletter without David's review.

Aim for 400–600 words total. Professional, readable, and useful.$$,
  ARRAY['newsletter', 'email', 'client', 'compliance', 'marketing']
),

-- ============================================================
-- CATEGORY: Client Intelligence
-- ============================================================

(
  'pre-meeting-client-brief',
  'Pre-Meeting Client Brief',
  'Generate a briefing document for an upcoming client meeting.',
  'Client Intelligence',
  $$You are generating a pre-meeting client brief for David Grayson, Principal at Grayson Financial. David is about to get on a call or walk into a meeting. This brief needs to be scannable in under 3 minutes.

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

Keep each section tight. David is reading this on his phone while walking to the desk.$$,
  ARRAY['client', 'meeting', 'brief', 'intelligence', 'prep']
),

(
  'relationship-health-check',
  'Relationship Health Check',
  'Assess the health of a client relationship based on recent activity.',
  'Client Intelligence',
  $$You are assessing the health of a client relationship for David Grayson, Principal at Grayson Financial.

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

SUGGESTED NEXT TOUCHPOINT: [Specific recommendation — what, when, how]$$,
  ARRAY['client', 'relationship', 'health', 'intelligence', 'retention']
),

(
  'quarterly-review-prep',
  'Quarterly Review Prep',
  'Full preparation brief for a quarterly client review meeting.',
  'Client Intelligence',
  $$You are generating a complete quarterly review preparation brief for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Client name and firm
- Quarter and year being reviewed (e.g., "Q2 2026")
- Any portfolio notes, performance highlights, or changes since last review
- Any open items, concerns, or relationship context
- Meeting duration (default: 45–60 minutes)

Generate the prep brief in this structure:

---
# QUARTERLY REVIEW PREP: [Client Name] | [Quarter Year]

## Client Snapshot
[2–3 sentences on who this client is, relationship duration, and current service context]

## Quarter in Review
[Key portfolio or relationship activities from the quarter — what happened, what changed, what was delivered]

## Suggested Agenda (45 min)
- 0:00–0:05 — Welcome and check-in
- 0:05–0:15 — [Specific topic 1 based on context]
- 0:15–0:30 — [Specific topic 2]
- 0:30–0:40 — [Specific topic 3 or open items]
- 0:40–0:50 — Questions and next steps
- 0:50–0:55 — Confirm next review date

## Key Points to Cover
[Bulleted list of 4–6 specific points to address — mix of portfolio, relationship, and proactive items]

## Questions to Ask the Client
[3–5 open-ended questions to draw out concerns, goals, or feedback]

## Compliance Reminders
- Confirm all recommendations are suitable for client profile
- Do not share specific return figures without the disclaimer
- Log meeting in Supabase after completion

## Open Items from Last Review
[List anything outstanding — who is accountable and current status]

## Follow-Up Actions to Prepare Before the Meeting
[What does David need to pull together, research, or confirm before getting on the call?]
---$$,
  ARRAY['client', 'quarterly', 'review', 'prep', 'meeting']
),

(
  'client-action-items',
  'Client Action Items',
  'Pull and organize all open action items for a specific client.',
  'Client Intelligence',
  $$You are organizing all open action items for a specific client for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Client name and firm
- Source material: paste any meeting notes, email threads, flagged items, or previous action item lists the user provides

Organize all identified action items into these buckets:

---
# ACTION ITEMS: [Client Name] | [Firm]
Generated: [Today's date]

## DUE SOON (within 7 days)
[List items with: description | owner (David / Client / Third Party) | due date | status]

## IN PROGRESS
[Items actively being worked]

## WAITING ON CLIENT
[Items where David has done his part and is awaiting client response or input]

## WAITING ON DAVID
[Items where David owes a deliverable, response, or decision]

## UPCOMING / SCHEDULED
[Items with a future date that are not yet active]

## NO DUE DATE (unscheduled)
[Items that exist but have no timeline assigned — flag these for David's attention]
---

For each item, format as:
- [ ] [Action description] | Owner: [David/Client/Other] | Due: [date or "TBD"] | Notes: [brief context if needed]

At the end, summarize: Total open items: X | David owns: X | Client owns: X | Overdue: X$$,
  ARRAY['client', 'action-items', 'tasks', 'follow-up']
),

(
  'meeting-debrief-capture',
  'Meeting Debrief Capture',
  'Capture structured notes and action items immediately after a client meeting.',
  'Client Intelligence',
  $$You are capturing a structured meeting debrief for David Grayson, Principal at Grayson Financial. The user will provide a brain dump of what happened. Convert it into clean, structured notes ready to save.

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
[PASTE BRAIN DUMP HERE]$$,
  ARRAY['meeting', 'debrief', 'notes', 'client', 'capture']
),

(
  'new-client-intake',
  'New Client Intake Checklist',
  'Generate a complete intake checklist for onboarding a new advisory client.',
  'Client Intelligence',
  $$You are generating a complete new client intake and onboarding checklist for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- New client name and firm
- Type of client (individual, family office, institutional, small business)
- Service scope agreed upon (e.g., investment management, financial planning, estate coordination)
- Any specifics about the client situation already known

Generate the full onboarding checklist:

---
# NEW CLIENT INTAKE CHECKLIST: [Client Name] | [Firm]
Onboarding Date: [Today's date]

## Phase 1: Documents to Collect (Week 1)
- [ ] Signed advisory agreement / engagement letter
- [ ] Form ADV acknowledgment (Part 2)
- [ ] Client information / KYC form (full contact details, DOB, SSN if individual)
- [ ] Investment Policy Statement (IPS) — draft and have signed
- [ ] Current account statements (brokerage, retirement, other)
- [ ] Recent tax returns (prior 2 years) — if financial planning in scope
- [ ] Estate documents summary (if estate planning in scope)
- [ ] Beneficiary designations on file
- [ ] [Add any client-specific items based on inputs]

## Phase 2: Accounts & Systems Setup (Week 1–2)
- [ ] Create client record in Supabase client_records table
- [ ] Create initial action_items entries in Supabase
- [ ] Add client to email tracking (email_threads)
- [ ] Schedule welcome call / kickoff meeting
- [ ] Add client meeting cadence to Client Meetings calendar (account2)
- [ ] Create client folder in Obsidian (/Clients/[ClientName].md)

## Phase 3: Compliance (Week 1–2)
- [ ] Confirm suitability profile documented
- [ ] Risk tolerance assessment completed
- [ ] Confirm client is in CRM / compliance system
- [ ] Disclosure documents delivered and acknowledged

## Phase 4: First 30 Days
- [ ] Kickoff / welcome meeting completed
- [ ] Investment Policy Statement finalized
- [ ] Initial portfolio review or plan delivered
- [ ] First quarterly review date scheduled

## Phase 5: First 60–90 Days
- [ ] 60-day check-in call
- [ ] Any outstanding documents collected
- [ ] Initial recommendations implemented
- [ ] Client confirmed with communication preferences

## Supabase Updates Required
- [ ] client_records: Insert new record with all profile fields
- [ ] action_items: Create intake action items
- [ ] email_threads: Tag all incoming emails with client ID
---$$,
  ARRAY['client', 'onboarding', 'intake', 'checklist', 'compliance']
),

(
  'client-anniversary-note',
  'Client Anniversary Note',
  'Draft an annual relationship anniversary touchpoint message.',
  'Client Intelligence',
  $$You are drafting a client relationship anniversary note on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Client name and firm
- How long the relationship has been active (e.g., "3 years", "5 years")
- Any specific milestones, achievements, or memorable moments from the relationship (optional)
- Tone preference: choose one — Warm Professional / Formal Appreciation / Brief and Personal

Instructions:
1. Keep it brief — 4–6 sentences maximum. This is a touchpoint, not an update.
2. Do NOT mention specific portfolio performance, returns, or investment outcomes.
3. Open by acknowledging the anniversary directly — do not bury it.
4. Reference something genuine about the relationship — the trust, the work done together, the partnership — without being vague.
5. Express a forward-looking sentiment — looking forward to the year ahead together.
6. This is relationship-building, not advisory communication. Do NOT append the compliance disclaimer.
7. Close with "Best regards, David Grayson | Grayson Financial".

Output the complete note, ready to send as a brief email or handwritten card text.$$,
  ARRAY['client', 'relationship', 'anniversary', 'retention']
),

(
  'prospect-first-email',
  'Prospect First Email',
  'Draft the first outreach email to a prospective advisory client.',
  'Client Intelligence',
  $$You are drafting a first outreach email to a prospective advisory client on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Prospect name and firm
- How they heard about Grayson Financial (referral source, event, prior relationship, etc.)
- What the potential fit is (why is David reaching out to this specific prospect?)
- Any intelligence about their current situation, goals, or pain points (optional)

Instructions:
1. Warmer than a client email but still professional. This is a first impression.
2. Lead with relevance — why is David reaching out to them specifically? Generic outreach is immediately apparent and counterproductive.
3. Briefly position David's expertise and what Grayson Financial does — 1–2 sentences. Specificity beats comprehensiveness.
4. Reference the connection or context (referral, shared event, industry) naturally — not as an obligation.
5. End with a single, low-friction call to action: a 20-minute introductory call or coffee meeting.
6. Do NOT use high-pressure language. Do NOT over-promise. Do NOT list all services.
7. Keep the body to 4–6 sentences.
8. Close with "Best regards, David Grayson | Grayson Financial".
9. No compliance disclaimer needed for initial prospect outreach (not yet advisory relationship).

Output the complete first outreach email, ready to send.$$,
  ARRAY['prospect', 'outreach', 'email', 'business-development']
),

-- ============================================================
-- CATEGORY: Investment & Market
-- ============================================================

(
  'morning-market-brief',
  'Morning Market Brief',
  'Structure a morning market briefing based on overnight and pre-market data.',
  'Investment & Market',
  $$You are generating a morning market brief for David Grayson, Principal at Grayson Financial. This brief is read over coffee — it must be concise, scannable, and actionable. Target reading time: 3 minutes.

The user will paste pre-market headlines, data points, or overnight news. Organize them into this structure:

---
# MORNING MARKET BRIEF
Date: [Today's date]
Generated: [Time]

## Overnight Summary
[2–3 sentences on what happened in Asian and European markets overnight. Key moves only.]

## Pre-Market Snapshot
- S&P 500 Futures: [level / change]
- 10-Year Treasury: [yield / change]
- US Dollar Index: [level / change]
- Gold / Oil: [levels if mentioned]
- VIX: [level if mentioned]
[Extract from provided data — note "N/A" if not provided]

## Key Events Today
[Bulleted list of scheduled events: earnings reports, Fed speakers, economic data releases, geopolitical developments]

## What's Moving Pre-Market
[2–4 specific movers or themes — what's up, what's down, and the brief reason why]

## Macro Theme of the Day
[One paragraph — the dominant narrative driving markets today and what it means for the next 24–48 hours]

## Relevance for Client Portfolios
[1–3 bullets on how today's environment may affect typical advisory client positioning — interest rate sensitivity, equity exposure, defensive positioning, etc. General observations only — no specific client data]

## Watch Today
[2–3 specific things to monitor as the day develops]
---

If input data is sparse, note what's missing and generate the brief with available information.$$,
  ARRAY['market', 'morning-brief', 'macro', 'investment']
),

(
  'earnings-summary',
  'Earnings Summary',
  'Summarize an earnings release for a holding relevant to David''s clients.',
  'Investment & Market',
  $$You are summarizing an earnings release for David Grayson, Principal at Grayson Financial. This summary may be shared with relevant clients — keep it professional and compliant.

The user will paste an earnings release, news article, or key figures. Extract and organize the following:

---
# EARNINGS SUMMARY: [Company Name] ([Ticker])
Report Date: [Date of release]
Quarter: [e.g., Q1 FY2026]

## Headline Results
- EPS (Reported): [actual] vs. Consensus: [expected] → [Beat / Miss / In-Line] by [amount / %]
- Revenue (Reported): [actual] vs. Consensus: [expected] → [Beat / Miss / In-Line]
- Net Income: [if mentioned]
- Operating Margin: [if mentioned]

## Guidance
[What did management guide for next quarter or full year? Did they raise, lower, or maintain guidance? If no guidance provided, note that.]

## Key Management Commentary
[2–4 bullet points on the most important things management said — strategic priorities, macro observations, notable risks acknowledged]

## Key Metrics (Segment or Business-Specific)
[Any KPIs specific to this business — subscriber growth, same-store sales, loan volume, AUM, etc.]

## Market Reaction
[Stock price move post-earnings if mentioned in source material]

## Relevance Assessment
[2–3 sentences: What does this mean for a client holding this position? Is the story intact, improving, or deteriorating? General observation only.]

---
⚠️ COMPLIANCE NOTE: If sharing with clients, append: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."

Raw earnings material:
[PASTE EARNINGS RELEASE OR FIGURES HERE]$$,
  ARRAY['earnings', 'investment', 'research', 'market', 'compliance']
),

(
  'research-report-digest',
  'Research Report Digest',
  'Condense a long research report into a decision-ready summary.',
  'Investment & Market',
  $$You are condensing a research report into a decision-ready summary for David Grayson, Principal at Grayson Financial.

The user will paste the full research report or a detailed summary. Extract the following:

---
# RESEARCH DIGEST: [Subject / Security / Topic]
Source: [Analyst firm / author if mentioned]
Date: [Publication date]

## Core Thesis
[1–2 sentences: What is the main argument this report is making? What is the analyst predicting or recommending?]

## Supporting Evidence
[3–5 bullet points: The strongest data points, trends, or arguments supporting the thesis]

## Risks to Thesis
[2–4 bullet points: What would have to be wrong for this thesis to fail? What risks does the analyst acknowledge?]

## Recommendation
- Rating: [Buy / Hold / Sell / Overweight / Underweight / Neutral — as stated in report]
- Price Target: [If applicable]
- Time Horizon: [If stated]
- Conviction Level: [High / Medium / Low — based on language used in report]

## Key Data Points
[Any specific figures, multiples, or metrics that are central to the argument — formatted for quick reference]

## What This Means for David
[2–3 sentences: Is this actionable? Does it change a thesis on a current or prospective holding? Should it inform a client conversation?]

---
⚠️ DISTRIBUTION FLAG: If this report contains specific return projections, price targets, or performance forecasts and is intended for client distribution, include the compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."

Paste research report below:
[PASTE REPORT HERE]$$,
  ARRAY['research', 'investment', 'digest', 'analysis']
),

(
  'investment-thesis-builder',
  'Investment Thesis Builder',
  'Structure a clear investment thesis for a position or potential investment.',
  'Investment & Market',
  $$You are helping David Grayson, Principal at Grayson Financial, structure a rigorous investment thesis before committing capital or presenting to a client.

Collect or use the following inputs:
- Security, asset, or opportunity name (company, ETF, sector, asset class)
- David's initial thinking or conviction (even rough notes are fine — Claude will structure them)
- Any data, context, or research already gathered
- Investment horizon and approximate risk tolerance of the intended portfolio

Build a formal investment thesis using this structure:

---
# INVESTMENT THESIS: [Security / Opportunity Name]
Date: [Today's date]
Prepared by: David Grayson | Grayson Financial

## Overview
[2–3 sentences: What is this? What does it do / represent? Why is it being considered?]

## Bull Case
[3–5 specific reasons this investment could outperform. Each reason should be distinct, evidence-based where possible, and not just generic positives.]

## Bear Case
[3–5 specific risks, headwinds, or scenarios where this thesis fails. Be honest and rigorous — a weak bear case means weak risk management.]

## Key Risks
[Categorized: Market risk / Company-specific risk / Macro risk / Liquidity risk / Regulatory risk — identify which apply and why]

## Catalysts
[What specific events, data releases, or developments would accelerate the bull case? What would accelerate the bear case?]

## Valuation Context
[Current valuation vs. historical range and/or peers — even directionally. Is it cheap, fair, or expensive relative to the thesis?]

## Suggested Position Sizing Rationale
[Given the conviction level and risk factors, what is a reasonable position size — core (5–10%), satellite (2–5%), speculative (<2%), or avoid? Explain the reasoning.]

## Monitoring Criteria
[What metrics, events, or signals would cause you to revisit this thesis? What would make you add? What would make you exit?]

## Decision
[ ] Proceed — initiate or add position
[ ] Watch — monitor for entry point
[ ] Pass — thesis not compelling enough at current risk/reward
---$$,
  ARRAY['investment', 'thesis', 'analysis', 'research', 'portfolio']
),

(
  'security-mention-flag',
  'Security Mention Flag',
  'Identify and flag any specific securities mentioned in an email or document.',
  'Investment & Market',
  $$You are performing a securities mention scan for David Grayson, Principal at Grayson Financial. This scan is used before distributing any document or email to clients to ensure compliance.

The user will paste the text to be scanned. Identify every specific security mentioned and assess each one.

Scan for:
- Company names used as investment references (e.g., "Apple", "JPMorgan")
- Ticker symbols (e.g., AAPL, JPM, BRK.B)
- CUSIP numbers
- Fund names (e.g., "Vanguard S&P 500 ETF", "PIMCO Total Return")
- Specific bonds, treasuries, or fixed income instruments
- Crypto assets (e.g., Bitcoin, Ethereum)

For each security identified, output:
| Security | Ticker/ID | Context | Usage Type | Action Required |

Usage Types:
- RECOMMENDATION — this text is recommending the security
- PERFORMANCE CLAIM — this text cites past returns of this security
- GENERAL REFERENCE — mentioned but not as a recommendation or performance claim
- MARKET COMMENTARY — mentioned as part of broader market context

Action Required:
- BLOCK — Do not send to clients without legal/compliance review (RECOMMENDATION + PERFORMANCE CLAIM)
- FLAG — David should manually review before sending
- OK — General reference or market commentary, low risk

Summary output:
TOTAL SECURITIES IDENTIFIED: X
BLOCKED: X (do not send without review)
FLAGGED: X (David's review recommended)
CLEAR: X (no action required)

OVERALL ASSESSMENT: [CLEAR TO SEND / FLAGGED — REVIEW BEFORE SENDING / BLOCKED — DO NOT SEND]

Text to scan:
[PASTE TEXT HERE]$$,
  ARRAY['compliance', 'securities', 'email', 'legal', 'scan']
),

(
  'macro-weekly-brief',
  'Macro Weekly Brief',
  'Generate a structured weekly macro economic briefing.',
  'Investment & Market',
  $$You are generating a structured weekly macro briefing for David Grayson, Principal at Grayson Financial. This brief informs client conversations and portfolio positioning for the week ahead.

The user will provide key events, data releases, and headlines from the week. Organize them into this structure:

---
# MACRO WEEKLY BRIEF
Week of: [Date range]

## The Big Picture
[2–3 sentences: What was the dominant narrative this week? What are markets focused on?]

## Fed & Rates
[Key Fed commentary, rate decisions, or expectations changes this week. Where does the market see rates going?]

## Equity Markets
[Weekly performance of major indices. Any notable sector rotation or themes?]

## Fixed Income
[Treasury yield moves, credit spreads, any notable fixed income developments]

## Currency & Commodities
[Dollar, oil, gold — key moves and what they signal]

## Geopolitical
[Any geopolitical developments relevant to markets — note if impact is direct or indirect]

## Key Data This Week
[Summary of the most important economic data released — CPI, jobs, PMI, retail sales, etc. — and whether it came in above, below, or in line with expectations]

## Outlook for Next Week
[Key scheduled events: Fed speakers, earnings, economic data, geopolitical events. What is the market watching most closely?]

## Positioning Implications
[2–4 bullets: What does this macro environment mean for typical advisory client portfolios? Interest rate duration, equity exposure, defensive vs. cyclical tilt, cash levels, etc. General — not specific client data.]
---

Paste the week's events and headlines below:
[PASTE WEEKLY DATA/HEADLINES HERE]$$,
  ARRAY['macro', 'weekly', 'brief', 'market', 'investment']
),

(
  'portfolio-risk-check',
  'Portfolio Risk Check',
  'Review a portfolio for concentration, correlation, or risk red flags.',
  'Investment & Market',
  $$You are performing a portfolio risk review for David Grayson, Principal at Grayson Financial.

The user will describe or paste a portfolio (positions, weights, asset classes, sectors). Analyze it for risk flags.

---
# PORTFOLIO RISK REVIEW
Date: [Today's date]
Portfolio: [Name or identifier if provided]

## Portfolio Summary
[Brief summary of what was provided — asset classes, number of positions, approximate composition]

## Risk Flag Analysis

### 1. Concentration Risk
[Is any single position or sector overweight? Flag anything >10% in a single name or >30% in a single sector]

### 2. Correlation Risk
[Are multiple holdings highly correlated? E.g., multiple tech names, multiple rate-sensitive assets, multiple commodity plays]

### 3. Interest Rate Sensitivity
[How would this portfolio be affected by a 100bps rate rise or fall? Flag high-duration bonds or rate-sensitive equities]

### 4. Liquidity Risk
[Are there any illiquid positions (private equity, small-cap, illiquid alternatives)? What % of the portfolio is liquid within 5 business days?]

### 5. Geographic / Currency Risk
[Significant non-US exposure? Currency mismatch risk?]

### 6. Downside Scenario
[In a market correction of -20%, what happens to this portfolio? Any positions that could experience amplified losses?]

## Risk Flags Summary
[Bulleted list of specific flags identified — ordered by severity]

## Suggested Adjustments
[2–4 specific adjustments that would reduce identified risks without dramatically altering the investment profile]

## Overall Risk Profile Assessment
[One-paragraph summary: Is this portfolio appropriate for a typical advisory client? What risk profile does it best suit?]
---

Paste or describe the portfolio below:
[PASTE PORTFOLIO HERE]$$,
  ARRAY['portfolio', 'risk', 'investment', 'analysis', 'compliance']
),

-- ============================================================
-- CATEGORY: Calendar & Scheduling
-- ============================================================

(
  'pre-call-brief',
  'Pre-Call Brief',
  '5-minute brief generated 30 minutes before a scheduled call.',
  'Calendar & Scheduling',
  $$You are generating a rapid pre-call brief for David Grayson, Principal at Grayson Financial. He has approximately 5 minutes to read this before the call starts.

Collect or use the following inputs:
- Who the call is with (name, firm, role)
- Purpose of the call or meeting
- Any recent context (last email, last meeting, open items)
- Format: internal / client / prospect / partner / vendor / other

Generate the brief in this tight format:

---
# PRE-CALL BRIEF: [Name] | [Firm]
Call in: ~30 minutes
Duration: [If known]

## Who They Are
[One sentence. Who is this person and why does it matter?]

## Last Interaction
[When was the last touchpoint and what was discussed? If unknown, say so.]

## What They Likely Want
[1–2 sentences: Based on context, what is this call probably about? What are they expecting?]

## What David Should Cover
1. [First point]
2. [Second point]
3. [Third point — keep it to 3 max]

## Watch Out For
[One thing — a sensitivity, open commitment, potential ask, or landmine to navigate]

## What to Have Ready
[Any documents, numbers, or facts David should pull up before the call starts]
---

Keep each item to one sentence or bullet. This is a quick-scan brief, not a research report.

Call details:
[PROVIDE WHO / WHAT / CONTEXT HERE]$$,
  ARRAY['calendar', 'meeting', 'brief', 'prep', 'scheduling']
),

(
  'day-planner',
  'Day Planner',
  'Structure and prioritize today''s agenda.',
  'Calendar & Scheduling',
  $$You are building a structured daily plan for David Grayson, Principal at Grayson Financial. The goal is a realistic, prioritized day that protects focus time and ensures HIGH priority items get done.

The user will provide today's meetings and rough task list. Generate the day plan:

---
# DAY PLAN: [Today's date]

## Hard Commitments (fixed time blocks)
[List all meetings and calls with time slots — pull from input]

## Focus Blocks (suggested)
[Suggest 1–2 blocks of 60–90 minutes for deep work — place in morning or after first meeting block when David is freshest]

## HIGH Priority Tasks (do today)
[From the task list, identify anything HIGH priority that must get done today — flag if not enough time to complete them all]

## MEDIUM Priority (do if time permits)
[Tasks that are important but can slip to tomorrow without consequence]

## Admin Batch (batch at low-energy time)
[Email triage, routine responses, filing — suggest placing in early afternoon or end of day]

## Flags
[Anything that looks overloaded, under-prepared, or conflicting — e.g., "You have 4 calls back-to-back with no break", "Quarterly report due but no time blocked for it"]

## Today's One Priority
[If David can only accomplish ONE meaningful thing today, what should it be? Be decisive.]
---

Provide today's meetings and task list below:
[PASTE CALENDAR + TASK LIST HERE]$$,
  ARRAY['calendar', 'planning', 'daily', 'productivity', 'operations']
),

(
  'weekly-overview',
  'Weekly Overview',
  'Monday morning week-at-a-glance briefing.',
  'Calendar & Scheduling',
  $$You are generating a Monday morning weekly overview for David Grayson, Principal at Grayson Financial. This is the first thing he reads on Monday morning to orient the week.

The user will provide the week's calendar events and any known priorities or carryovers from last week. Generate the overview:

---
# WEEKLY OVERVIEW: Week of [Date Range]

## This Week at a Glance
[2–3 sentences: What kind of week is this? Heavy client meeting week? Execution week? Travel week? What's the dominant theme?]

## Key Meetings This Week
| Day | Time | Who | Purpose | Prep Required? |
[Table of all meetings — flag any that need prep briefs with "YES — prep needed"]

## Deadlines This Week
[Any hard deadlines — deliverables, filings, renewals, tax payments, client commitments — with exact dates]

## Client Touchpoints Needed
[Any clients due for a check-in who don't have a meeting scheduled this week? Flag and suggest outreach.]

## Carryover from Last Week
[Open items that rolled over — what must be addressed this week vs. what can wait?]

## Focus Recommendation
[One clear recommendation: What is the most important area of focus this week, given the meetings, deadlines, and priorities?]

## Risk of the Week
[One flag: Is there anything on this week's schedule that looks risky — tight prep time, back-to-back demanding calls, a deadline without time blocked, a relationship that needs attention?]
---

Paste this week's calendar and priorities below:
[PASTE WEEKLY CALENDAR AND NOTES HERE]$$,
  ARRAY['calendar', 'weekly', 'planning', 'overview', 'monday']
),

(
  'reschedule-draft',
  'Reschedule Draft',
  'Draft a polite, professional reschedule request.',
  'Calendar & Scheduling',
  $$You are drafting a meeting reschedule email on behalf of David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Who the meeting is with (name, firm, relationship)
- Original meeting date and time
- Reason for rescheduling (optional — David may not want to share the specific reason)
- 2–3 alternative times to propose
- Is this a client, prospect, partner, or other?

Instructions:
1. Open directly: acknowledge you need to reschedule without over-explaining or over-apologizing.
2. One brief apology is appropriate. Do not dwell on it.
3. Propose 2–3 specific alternative times (user should provide these; if not provided, note "[INSERT ALTERNATIVE TIMES]").
4. Make it easy to respond: end with a clear ask for the recipient to confirm one of the alternatives or suggest their own.
5. Keep to 3–5 sentences total.
6. If rescheduling a client meeting where advisory matters will be discussed, append the compliance disclaimer: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
7. Close with "Best regards, David Grayson | Grayson Financial".

Output the complete reschedule email, ready to send.$$,
  ARRAY['calendar', 'reschedule', 'email', 'scheduling', 'meeting']
),

(
  'calendar-audit',
  'Calendar Audit',
  'Review the next 30 days of calendar and flag gaps, over-commitment, or missing prep.',
  'Calendar & Scheduling',
  $$You are performing a 30-day calendar audit for David Grayson, Principal at Grayson Financial. The goal is to surface problems before they become problems.

The user will paste or describe the next 30 days of calendar events. Review for the following:

---
# CALENDAR AUDIT: Next 30 Days
Audit Date: [Today's date]
Period Reviewed: [Date range]

## Over-Commitment Flags
[Any week with more than 4 client-facing meetings? Back-to-back blocks with no buffer? Identify and flag with specific dates]

## Missing Prep Briefs
[Identify any client meetings, quarterly reviews, or prospect calls that do not have a pre-meeting prep brief scheduled in the calendar. List each one with the meeting date and suggest when the prep should be scheduled.]

## Missing Client Reviews
[Cross-reference: Are all active clients getting their quarterly reviews this quarter? Flag any clients who should have a review scheduled but don't.]

## Tax Deadlines Without Calendar Blocks
Tax deadlines to check:
- January 15: Q4 prior-year estimated tax
- April 15: Q1 estimated tax + prior-year filing
- June 15: Q2 estimated tax
- September 15: Q3 estimated tax
[Flag any of the above that fall within the audit period and are not on the calendar]

## Travel Conflicts
[Any travel days (flights, hotel check-ins) that conflict with meetings? Any travel without proper logistics confirmed?]

## Domain / Tech Reminders
[Flag any domain renewals due in the next 30 days that should be on the calendar]

## Gaps / Under-Committed Periods
[Any week with unusually light scheduling where David could proactively reach out to clients or tackle deferred projects?]

## Recommended Actions
[Bulleted list of the top 5–7 specific calendar changes, additions, or prep tasks to address this week]
---

Paste the next 30 days of calendar events below:
[PASTE CALENDAR EVENTS HERE]$$,
  ARRAY['calendar', 'audit', 'planning', 'scheduling', 'review']
),

-- ============================================================
-- CATEGORY: Legal & Compliance
-- ============================================================

(
  'compliance-document-review',
  'Compliance Document Review',
  'Review any document for compliance red flags relevant to a registered investment advisor.',
  'Legal & Compliance',
  $$You are performing a compliance document review for David Grayson, a registered investment advisor (RIA) at Grayson Financial.

The user will paste a document or describe its contents. Review it against the following compliance framework:

---
# COMPLIANCE DOCUMENT REVIEW
Document: [Name/type of document]
Review Date: [Today's date]

## Review Checklist

### 1. Regulatory Language
[Does the document use language consistent with RIA obligations? Any language that implies guarantees, promises of returns, or unlicensed services?]
→ Status: PASS / FLAG / FAIL

### 2. Required Disclosures
[Are all required disclosures present? For client-facing documents: Is the firm properly identified? Is advisory services language accurate? Is there a reference to Form ADV availability?]
→ Status: PASS / FLAG / FAIL

### 3. Forward-Looking Statements
[Does the document make any forward-looking statements about performance, returns, or market outcomes without appropriate caveats? Flag exact language.]
→ Status: PASS / FLAG / FAIL

### 4. Suitability
[Does the document make broad investment recommendations without suitability context? Does it imply one-size-fits-all advice?]
→ Status: PASS / FLAG / FAIL

### 5. Performance Claims
[Any historical performance claims? Are they presented fairly with appropriate time periods and risk disclosures?]
→ Status: PASS / FLAG / FAIL

### 6. Confidentiality / Privacy
[Any PII, client account data, or confidential information present that should not be in this document?]
→ Status: PASS / FLAG / FAIL

### 7. Legal Counsel Recommendation
[Should this document be reviewed by a securities attorney or compliance consultant before use?]
→ YES / NO / RECOMMENDED (not required but prudent)

## Flagged Language
[Quote specific passages that triggered flags, with explanation of the concern]

## Overall Assessment
[PASS / PASS WITH FLAGS / FAIL — REQUIRES REVISION]

## Recommended Edits
[Specific suggested edits for each flagged item, if applicable]
---

DISCLAIMER: This review is an initial compliance check to assist David Grayson in identifying potential issues. It is not a legal opinion. All documents with material compliance implications should be reviewed by qualified legal counsel.

Paste document below:
[PASTE DOCUMENT HERE]$$,
  ARRAY['compliance', 'legal', 'document', 'review', 'ria']
),

(
  'legal-email-flag',
  'Legal Email Flag',
  'Identify whether an email contains attorney-client privileged content and how to handle it.',
  'Legal & Compliance',
  $$You are performing a legal sensitivity review on an incoming email for David Grayson, Principal at Grayson Financial.

The user will paste an email. Assess it on the following dimensions:

---
# LEGAL EMAIL FLAG REVIEW
Review Date: [Today's date]

## Privilege Assessment
Question: Is this email likely attorney-client privileged?

Indicators of privilege:
- Sent by or to a licensed attorney (look for law firm domain, "Esq.", "Attorney at Law")
- Subject matter is legal advice, legal strategy, or legal opinion
- The communication is seeking or providing legal counsel — not just legal information
- The email or a prior in-thread message contains language like "attorney-client privileged" or "work product"

Assessment: [LIKELY PRIVILEGED / LIKELY NOT PRIVILEGED / UNCERTAIN]
Reasoning: [1–2 sentences]

If LIKELY PRIVILEGED:
⚠️ ATTORNEY-CLIENT PRIVILEGED — DO NOT SUMMARIZE, FORWARD, OR DISTRIBUTE without David's explicit review and authorization. File only in the legal account (account3). Do not log to Supabase without David's instruction.

## Content Summary (if NOT privileged)
[If not privileged: 2–4 sentence summary of what this email is about]

## Immediate Action Required
[ ] Yes — describe what action is needed and urgency
[ ] No — file and monitor

## Recommended Handling
[How should this email be handled? Options: File in legal account / Reply / Forward to attorney / Log to Supabase / No action needed]

## Calendar Flag
[Should anything in this email trigger a calendar entry? E.g., a deadline, a court date, a compliance filing date]

## Priority Classification
[HIGH / MEDIUM / LOW — using David's standard triage rules]
---

Paste email below:
[PASTE EMAIL HERE]$$,
  ARRAY['legal', 'email', 'privilege', 'compliance', 'triage']
),

(
  'regulatory-deadline-tracker',
  'Regulatory Deadline Tracker',
  'List all upcoming regulatory and compliance deadlines.',
  'Legal & Compliance',
  $$You are generating a regulatory and compliance deadline tracker for David Grayson, a registered investment advisor (RIA) at Grayson Financial.

Today's date is provided in context. Generate a comprehensive forward-looking deadline list.

---
# REGULATORY DEADLINE TRACKER
Generated: [Today's date]
Next 90 Days: [Date range]

## Estimated Tax Payment Deadlines
These are recurring annual deadlines — flag any that fall in the next 90 days:
- January 15 — Q4 Prior Year Estimated Tax Payment
- April 15 — Q1 Estimated Tax + Prior Year Filing Deadline
- June 15 — Q2 Estimated Tax Payment
- September 15 — Q3 Estimated Tax Payment

Status for each: [UPCOMING — X days / DUE THIS WEEK / PAST]
Priority: HIGH if within 14 days

## SEC / RIA Compliance Deadlines
Key recurring obligations for a registered investment advisor:
- Form ADV Annual Amendment: Within 90 days of fiscal year end (if Dec 31 year-end: due March 31)
- Form ADV Part 2 Delivery: Annual delivery to all clients within 120 days of fiscal year end
- Annual Code of Ethics Review: Note date last reviewed
- Annual Compliance Program Review: Document annual review completion
- Form 13F filing (if applicable): 45 days after quarter-end for managers with >$100M AUM
- Form PF (if applicable): Quarterly or annual depending on fund size

[Flag which apply based on context, mark others as N/A if not applicable]

## State-Specific Obligations
[Note: Specific state requirements depend on registration status — flag that David should confirm state-level obligations with his compliance counsel or state securities administrator]

## Custom Deadlines (from David's notes)
[If any custom deadlines are provided in context, include them here]

## Overdue Items
[Any deadlines that appear to be past due based on today's date — flag RED]

## Action Items
[Prioritized list of upcoming compliance actions, sorted by date, with HIGH flag for anything within 14 days]
---$$,
  ARRAY['regulatory', 'compliance', 'deadlines', 'tax', 'ria']
),

(
  'contract-key-points',
  'Contract Key Points',
  'Extract and summarize key points from a contract or agreement.',
  'Legal & Compliance',
  $$You are extracting key points from a contract or agreement for David Grayson, Principal at Grayson Financial.

The user will paste the contract text. Extract and organize the following:

---
# CONTRACT KEY POINTS SUMMARY
Document Type: [Identify: advisory agreement, vendor contract, NDA, lease, service agreement, etc.]
Review Date: [Today's date]

⚠️ THIS IS NOT LEGAL ADVICE. This summary is for David's initial review only. Have qualified legal counsel review this contract before signing.

## Parties
- Party 1: [Name, entity type, role in agreement]
- Party 2: [Name, entity type, role in agreement]
- Additional parties: [If any]

## Effective Date & Term
- Effective Date: [When it begins]
- Term / Duration: [How long it lasts]
- Renewal: [Auto-renew? How to cancel? Notice period required?]
- Termination provisions: [Under what conditions can either party terminate?]

## Key Obligations

### David / Grayson Financial is obligated to:
[Bulleted list of specific obligations, deliverables, restrictions]

### The other party is obligated to:
[Bulleted list of their specific obligations, deliverables, restrictions]

## Payment Terms
- Amount: [Fee, rate, or pricing]
- Payment schedule: [When and how]
- Late payment: [Penalties if mentioned]
- Refunds: [Policy if mentioned]

## Liability & Indemnification
[Key liability caps, indemnification obligations, who bears what risk]

## Confidentiality & IP
[Any NDA provisions, data handling, intellectual property ownership, non-compete]

## Governing Law
[Which state's law governs? Where is dispute resolution?]

## Red Flags
[Anything that looks unusual, one-sided, or concerning from David's perspective — specific clause references where possible]

## Questions for Legal Counsel
[Specific questions David should ask an attorney before signing]
---$$,
  ARRAY['legal', 'contract', 'review', 'compliance']
),

(
  'ria-compliance-checklist',
  'RIA Compliance Checklist',
  'Generate a compliance checklist for a registered investment advisor.',
  'Legal & Compliance',
  $$You are generating a quarterly/annual RIA compliance checklist for David Grayson, a registered investment advisor at Grayson Financial.

Today's date is provided in context. Generate the checklist for the current period.

---
# RIA COMPLIANCE CHECKLIST
Period: [Current Quarter and Year]
Generated: [Today's date]

## Form ADV Obligations
- [ ] Form ADV Part 1 — Annual amendment filed within 90 days of fiscal year-end (March 31 if Dec 31 year-end)
- [ ] Form ADV Part 2A (Brochure) — Updated to reflect any material changes
- [ ] Form ADV Part 2B (Brochure Supplement) — Updated for any supervised persons changes
- [ ] Form ADV Part 2 — Delivered to all existing clients within 120 days of fiscal year-end
- [ ] Summary of material changes included with Part 2A delivery

## Code of Ethics
- [ ] Annual code of ethics review completed and documented
- [ ] All access persons have acknowledged the code of ethics in writing
- [ ] Personal trading logs reviewed for the quarter
- [ ] Pre-clearance procedures followed for restricted securities

## Compliance Program Review
- [ ] Annual written compliance program review completed
- [ ] Any deficiencies identified and remediation plan documented
- [ ] Compliance calendar updated for next 12 months

## Client Disclosures
- [ ] All new clients received Form ADV Part 2 at or before signing
- [ ] Material changes communicated to existing clients promptly
- [ ] All advisory agreements reviewed for accuracy and completeness
- [ ] Privacy policy (Reg SP) distributed to all clients annually

## Trading & Portfolio Management
- [ ] Best execution review documented for the quarter
- [ ] Soft dollar arrangements (if any) documented and disclosed
- [ ] Trade allocation procedures followed and documented
- [ ] Any aggregated trades allocated fairly across clients

## Cybersecurity & Data
- [ ] Client data access controls reviewed
- [ ] Passwords and authentication reviewed
- [ ] Incident response plan current
- [ ] Third-party vendor data security confirmed

## Books & Records
- [ ] All required records maintained per SEC Rule 204-2
- [ ] Email archiving current and complete
- [ ] Client files organized and complete
- [ ] Financial records current

## State-Specific Requirements
- [ ] State registration current (if state-registered)
- [ ] State-specific filings completed
- [ ] Confirm no new state registration triggers based on client locations

## Notes / Open Items
[Space for David to note any in-progress items or exceptions]
---

DISCLAIMER: This checklist is a general guide for RIA compliance obligations. Specific requirements vary by registration status, AUM, and state. Consult your compliance counsel or CCO for requirements specific to Grayson Financial.$$,
  ARRAY['compliance', 'ria', 'checklist', 'regulatory', 'legal']
),

-- ============================================================
-- CATEGORY: Travel
-- ============================================================

(
  'trip-summary',
  'Trip Summary',
  'Compile all details for an upcoming trip into one clean briefing.',
  'Travel',
  $$You are generating a complete trip briefing for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Destination (city, country if international)
- Travel dates (departure and return)
- Purpose of the trip (client meetings, conference, personal, etc.)
- Any specific meetings or events scheduled during the trip (optional)

Generate the trip brief using David's known travel preferences:
- Preferred airline: Delta (SkyMiles loyalty — # in Vault)
- Seat preference: Aisle seat always
- Cabin: Business class for flights >3 hours; Economy for short-haul
- TSA PreCheck: Always select — enrolled
- Preferred hotel: Marriott (Bonvoy loyalty — # in Vault)
- Car rental: National Car Rental (Emerald Club)
- Meal preference: No dietary restrictions

---
# TRIP BRIEF: [Destination]
Dates: [Departure] → [Return]
Purpose: [Business / Personal / Mixed]

## Flight Summary
- Preferred carrier: Delta Air Lines (SkyMiles)
- Cabin: [Business if >3hrs / Economy if short-haul — based on destination]
- Seat: Aisle seat
- TSA PreCheck: Yes — select PreCheck lane
- Loyalty: Apply SkyMiles number (stored in Vault)
- Departure window preference: [Note if provided, otherwise "flexible"]

## Hotel
- Preferred chain: Marriott (Bonvoy loyalty — apply number from Vault)
- Check-in: [Departure date]
- Check-out: [Return date]
- Room type: Standard King (unless meeting venue requires proximity)
- [Note any proximity requirements if meetings are known]

## Ground Transportation
- Car rental: National Car Rental — Emerald Club preferred
- [Or note if airport transfer / rideshare is more appropriate for the destination]

## Trip Details
- Local time zone: [Destination timezone vs. David's home timezone]
- Weather: [General seasonal expectation — note to check forecast closer to travel]

## Meeting / Event Schedule
[If meetings are provided — list with date, time, location, and who they're with]

## Pre-Travel Checklist
- [ ] Flights confirmed — seat selected (aisle), loyalty number applied
- [ ] Hotel confirmed — Bonvoy number applied
- [ ] Car rental confirmed — Emerald Club applied
- [ ] Travel confirmed on Travel calendar (account6)
- [ ] Any client meetings added to Client Meetings calendar (account2)
- [ ] Passport current (if international)
- [ ] Global Entry / TSA PreCheck — confirm enrollment active
- [ ] Out-of-office set if needed

## Packing Reminders
[Business trip: Business attire for client days + casual for travel days / Conference: Bring business cards / International: Adapter, currency]
---$$,
  ARRAY['travel', 'trip', 'brief', 'planning', 'logistics']
),

(
  'travel-expense-report',
  'Travel Expense Report',
  'Compile and categorize travel expenses from a completed trip.',
  'Travel',
  $$You are compiling a travel expense report for David Grayson, Principal at Grayson Financial.

The user will provide a list of expenses, receipts, or raw notes from a completed trip. Organize them into a structured expense report.

---
# TRAVEL EXPENSE REPORT
Trip: [Destination]
Travel Dates: [From] → [To]
Purpose: [Business / Personal / Mixed]
Report Date: [Today's date]

## Expense Detail

### Transportation
| Date | Description | Vendor | Amount | Business? | Notes |
[List all: flights, taxis, rideshares, car rentals, parking, tolls, trains]
Subtotal: $[X]

### Lodging
| Date | Description | Vendor | Amount | Business? | Notes |
[List all hotel nights, Airbnb, etc.]
Subtotal: $[X]

### Meals & Entertainment
| Date | Description | Vendor | Amount | Business? | Attendees | Notes |
[List all meals — note if client entertainment (who attended?)]
Subtotal: $[X]

### Business Incidentals
| Date | Description | Vendor | Amount | Business? | Notes |
[Conference fees, printing, office supplies, business gifts, etc.]
Subtotal: $[X]

### Personal Expenses (Non-Reimbursable)
| Date | Description | Amount |
[Any clearly personal items — for transparency in reporting]
Subtotal: $[X]

## Summary
| Category | Amount |
|---|---|
| Transportation | $[X] |
| Lodging | $[X] |
| Meals & Entertainment | $[X] |
| Business Incidentals | $[X] |
| **Total Business Expenses** | **$[X]** |
| Personal (non-reimbursable) | $[X] |

## Potential Tax Deductions
[Note any expenses that are likely 100% business deductible: flights, hotel, client meals (50% meals rule applies), conference fees]

## Missing Receipts
[Flag any expense items where no receipt was provided — these will need documentation for tax purposes]

## Notes for Accounting
[Any special categorization notes, split business/personal items, or items requiring clarification]
---

Paste expense list or receipts below:
[PASTE EXPENSES HERE]$$,
  ARRAY['travel', 'expenses', 'accounting', 'finance', 'reporting']
),

(
  'flight-options-brief',
  'Flight Options Brief',
  'Structure a flight search brief based on David''s travel preferences.',
  'Travel',
  $$You are generating a flight search brief for David Grayson, Principal at Grayson Financial to hand to a travel agent or use directly in a booking tool.

Collect or use the following inputs:
- Origin city/airport
- Destination city/airport
- Travel date (outbound)
- Return date (if round trip)
- Any meeting times or schedule constraints at destination

Generate the brief using David's confirmed travel preferences:

---
# FLIGHT SEARCH BRIEF
Route: [Origin] → [Destination]
Travel Date: [Outbound date]
Return Date: [Return date or "One-way"]

## Search Parameters

### Preferred Airline
- First choice: Delta Air Lines
- Loyalty: SkyMiles — apply number when booking (stored in Vault)
- If Delta not available or significantly worse option: [Note alternative]

### Cabin Class
- [Determine based on flight duration:]
  - Flights under 3 hours: Economy (or Comfort+)
  - Flights 3 hours or longer: Business class
- [Estimated flight time: X hours based on route — confirm at booking]

### Seat Preference
- Aisle seat — mandatory preference
- Preferred: Aisle in first few rows of cabin

### TSA PreCheck
- David is enrolled — always select TSA PreCheck lane
- Ensure Known Traveler Number (KTN) is applied to reservation (stored in Vault)

### Departure Window
- Preferred: [If schedule constraints provided — e.g., "must arrive by 2pm for 3pm meeting" → suggest latest viable departure]
- Avoid red-eye if possible unless necessary for schedule

### Connection Preference
- Direct flight preferred
- Minimum connection time if connecting: 60 minutes domestic, 90 minutes international
- Avoid connections through high-delay hubs if direct is available

### Return Window
- [Based on any provided schedule constraints or default: afternoon departure on return date]

## Schedule Notes
[If meeting times were provided — note what arrival time is needed and what departure times are viable]

## Booking Instructions
- Apply SkyMiles number to reservation
- Apply KTN (TSA PreCheck) to reservation
- Select aisle seat at booking
- Add trip to Travel calendar (account6) after booking
---$$,
  ARRAY['travel', 'flights', 'booking', 'delta', 'logistics']
),

(
  'hotel-booking-brief',
  'Hotel Booking Brief',
  'Structure a hotel booking brief for an upcoming trip.',
  'Travel',
  $$You are generating a hotel booking brief for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Destination city
- Check-in date
- Check-out date
- Purpose of trip (to help identify proximity requirements)
- Any specific meeting venue or conference location (for proximity planning)

Generate the brief using David's confirmed travel preferences:

---
# HOTEL BOOKING BRIEF
Destination: [City]
Check-In: [Date]
Check-Out: [Date]
Nights: [Number]
Purpose: [Business / Conference / Personal]

## Preferred Hotel Chain
- First choice: Marriott (Bonvoy loyalty program)
  - Loyalty number: Stored in Vault — apply at booking
  - Preferred tier properties: Marriott, Sheraton, Westin, W Hotels, Renaissance, or JW Marriott
- If Marriott not available or practical: Hilton Honors, Hyatt, or independent luxury hotel

## Room Preferences
- Room type: King room (standard or deluxe)
- Floor: Higher floor preferred if available
- Away from: elevators, ice machines, street noise if possible
- Early check-in: Request if arriving before 3pm
- Late check-out: Request if departing after noon

## Location Requirements
[Based on purpose provided:]
- Business / client meetings: [As close as practical to meeting venue or [City] CBD]
- Conference: [On-site at conference hotel if available; walking distance as fallback]
- Personal: [Based on preferences or itinerary details]

## Business Amenities Required
- [ ] Reliable high-speed WiFi (confirm business-grade, not fee-based)
- [ ] Business center or workspace in room
- [ ] 24-hour fitness center preferred
- [ ] Restaurant on-site or nearby

## Booking Instructions
- Apply Bonvoy loyalty number at booking (stored in Vault)
- Request Bonvoy member rate or Best Available Rate — compare against booking portal
- Request elite benefits if status applies (late check-out, room upgrade, welcome amenity)
- Confirm cancellation policy — flexible cancellation preferred
- Add hotel confirmation to Travel calendar (account6) after booking
- Update trips table in Supabase with confirmation number and details
---$$,
  ARRAY['travel', 'hotel', 'booking', 'marriott', 'logistics']
),

(
  'itinerary-review',
  'Itinerary Review',
  'Review a travel itinerary and flag any issues or gaps.',
  'Travel',
  $$You are reviewing a travel itinerary for David Grayson, Principal at Grayson Financial. Flag any issues, gaps, or risks before travel.

The user will paste a travel itinerary. Review it against the following checklist:

---
# ITINERARY REVIEW
Review Date: [Today's date]
Trip: [Destination — extract from itinerary]
Travel Dates: [Extract from itinerary]

## Connection Time Check
[Review all flights with connections]
- Flag: Any domestic connection under 60 minutes → ⚠️ TIGHT CONNECTION
- Flag: Any international connection under 90 minutes → ⚠️ TIGHT CONNECTION
- Flag: Any connection through known high-delay airports (JFK, ORD, LAX, EWR in bad weather) → NOTE

## Hotel Confirmation Check
- [ ] Hotel confirmed for each night of travel? Flag any nights without accommodation.
- [ ] Bonvoy loyalty number applied?
- [ ] Check-in time vs. arrival time — will David arrive before or after standard check-in?

## Meeting vs. Travel Time Conflicts
[If meetings are listed in the itinerary:]
- Flag: Any meeting scheduled on the same day as arrival without adequate buffer
- Flag: Any departure on the same day as a meeting that could be cut short
- Flag: Any overseas time zone adjustments that haven't been accounted for in meeting times

## Car Rental Check
- [ ] Car rental confirmed if needed for destination?
- [ ] National Emerald Club applied?
- [ ] Pick-up and drop-off times aligned with flights?

## Loyalty Numbers Applied
- [ ] SkyMiles number on all Delta flights?
- [ ] KTN (TSA PreCheck) on all flights?
- [ ] Bonvoy number on hotel?
- [ ] Emerald Club on car rental?

## Calendar Check
- [ ] All flights on Travel calendar (account6)?
- [ ] All client meetings on Client Meetings calendar (account2)?
- [ ] Hotel check-in/check-out on Travel calendar?

## Gaps Identified
[Any dates or nights where David appears to have no accommodation, no transport, or an unaccounted-for block of time]

## Overall Assessment
[CLEAR — no issues / FLAGS — see items above / ISSUES — specific problems to fix]

## Priority Actions
[Bulleted list of what needs to be fixed or confirmed before travel]
---

Paste itinerary below:
[PASTE ITINERARY HERE]$$,
  ARRAY['travel', 'itinerary', 'review', 'logistics', 'audit']
),

-- ============================================================
-- CATEGORY: Domains & Tech
-- ============================================================

(
  'domain-audit',
  'Domain Audit',
  'Full annual audit of the domain portfolio.',
  'Domains & Tech',
  $$You are performing the annual domain portfolio audit for David Grayson. This audit occurs every January and is a HIGH priority recurring obligation.

The user will provide a list of domains (or Claude will work with the domains table context provided). For each domain, assess and output:

---
# DOMAIN PORTFOLIO AUDIT
Audit Date: [Today's date]
Domains Reviewed: [Total count]

## Audit Table

| Domain | Expiry Date | Days Until Expiry | Auto-Renew | Currently Used? | Strategic Value | Recommendation |
|---|---|---|---|---|---|---|
[One row per domain]

Recommendation options:
- RENEW — Keep and renew; active or strategically valuable
- AUTO-RENEW — Keep; confirm auto-renew is active
- REVIEW — Uncertain value; David should assess before next renewal
- LET EXPIRE — Low value, not in use, no defensive need — allow to expire
- SELL — Has resale potential; consider listing on aftermarket

## URGENT — Expiring in <30 Days
[List any domains expiring within 30 days — HIGH priority, renew immediately]
[If none: "None identified"]

## Expiring in 30–90 Days (Action Required Soon)
[List domains in this window with recommended action]

## Strategic Notes
[Any observations about the portfolio: gaps in defensive registrations, domains that could be monetized, brand protection opportunities, domains that appear to be squatted by others]

## Summary
- Total domains in portfolio: X
- RENEW recommended: X
- LET EXPIRE recommended: X
- SELL potential: X
- URGENT (< 30 days): X
- Total estimated annual renewal cost: $[X] (if pricing is provided)

## Action Items
[Prioritized list of actions to take this week, this month, and before next audit]
---

Domain list:
[PASTE DOMAIN LIST WITH EXPIRY DATES HERE]$$,
  ARRAY['domains', 'audit', 'tech', 'renewal', 'annual']
),

(
  'domain-expiry-check',
  'Domain Expiry Check',
  'Check which domains are expiring within the next 30-60 days.',
  'Domains & Tech',
  $$You are performing a domain expiry check for David Grayson. Flag domains by urgency level.

The user will provide a list of domains with expiry dates. Classify and output:

---
# DOMAIN EXPIRY CHECK
Check Date: [Today's date]

## 🔴 RED — EXPIRING IN < 30 DAYS (HIGH PRIORITY — RENEW IMMEDIATELY)
| Domain | Expiry Date | Days Remaining | Auto-Renew Status | Action |
[List all domains expiring within 30 days]
[If none: "None — no immediate action required"]

Recommended action: Log to #domains Slack channel, update domains table in Supabase, renew immediately if auto-renew is not confirmed active.

## 🟡 YELLOW — EXPIRING IN 30–60 DAYS (RENEW SOON)
| Domain | Expiry Date | Days Remaining | Auto-Renew Status | Action |
[List all domains expiring in 30–60 days]
[If none: "None in this window"]

Recommended action: Confirm auto-renew is active. If not, schedule renewal within the next 2 weeks.

## 🟢 GREEN — EXPIRING IN > 60 DAYS (MONITOR)
| Domain | Expiry Date | Days Remaining |
[List remaining domains]
[Summary count if list is long: "X domains with >60 days remaining — no action required"]

## Summary
- RED (< 30 days): X domains
- YELLOW (30–60 days): X domains
- GREEN (> 60 days): X domains
- Total checked: X domains

## Supabase Update Required
[If any domains are RED or YELLOW: Note to update the domains table in Supabase with current expiry and alert status]
---

Domain list with expiry dates:
[PASTE DOMAIN LIST HERE — format: domain.com | YYYY-MM-DD | auto-renew: yes/no]$$,
  ARRAY['domains', 'expiry', 'tech', 'renewal', 'alert']
),

(
  'subscription-audit',
  'Subscription Audit',
  'Review all active software subscriptions and identify redundancy or waste.',
  'Domains & Tech',
  $$You are performing a software subscription audit for David Grayson. The goal is to identify redundancy, unused tools, and savings opportunities.

The user will provide a list of active subscriptions with costs. Analyze and output:

---
# SUBSCRIPTION AUDIT
Audit Date: [Today's date]

## Subscription Inventory

| Tool/Service | Category | Monthly Cost | Annual Cost | Usage Level | GraysonOS Overlap | Recommendation |
|---|---|---|---|---|---|---|
[One row per subscription]

Categories: Productivity / Communication / Finance / Security / Development / Marketing / Travel / Storage / Other

Usage Levels: Active (daily/weekly) / Occasional (monthly) / Unknown / Unused

GraysonOS Overlap: Flag if GraysonOS (Claude + Supabase + custom packages) now provides equivalent functionality

Recommendations: KEEP / CANCEL / NEGOTIATE / CONSOLIDATE / EVALUATE

## Redundancy Flags
[Any subscriptions where two or more tools serve the same function — recommend keeping the better one and cancelling the other]

## Unused / Unknown Usage
[Any subscriptions where usage is unknown or appears unused — flag for David to verify before next billing cycle]

## GraysonOS Replacement Opportunities
[Any subscriptions that the GraysonOS platform may now make redundant — be specific about which GraysonOS capability replaces them]

## Upcoming Renewals
[Any annual subscriptions renewing in the next 60 days — flag for decision before auto-renewal]

## Financial Summary
| | Monthly | Annual |
|---|---|---|
| Current total spend | $X | $X |
| Recommended cuts | -$X | -$X |
| Projected spend after optimization | $X | $X |
| Estimated annual savings | | $X |

## Priority Actions (This Week)
[Top 3–5 specific actions to take: subscriptions to cancel, subscriptions to negotiate, subscriptions to evaluate]
---

Paste subscription list below (format: Tool name | Monthly or Annual cost | Notes):
[PASTE SUBSCRIPTION LIST HERE]$$,
  ARRAY['subscriptions', 'tech', 'audit', 'cost', 'operations']
),

(
  'tech-stack-brief',
  'Tech Stack Brief',
  'Document the current GraysonOS technology stack for reference or onboarding.',
  'Domains & Tech',
  $$You are generating the current GraysonOS technology stack brief for David Grayson. This document is used for developer onboarding, system reference, and architecture planning.

---
# GRAYSONOS TECHNOLOGY STACK BRIEF
Generated: [Today's date]
Owner: David Grayson | Grayson Financial

## Overview
GraysonOS is a personal intelligence operating system built for David Grayson, an investment advisor and principal at Grayson Financial. It integrates communication, client management, investment research, calendar, travel, domains, and compliance workflows into a unified, AI-augmented platform.

## Core Infrastructure

### Database & Backend
- **Platform:** Supabase (PostgreSQL + pgvector)
- **Purpose:** Persistent storage for all GraysonOS data — client records, action items, email threads, trips, domains, skills, and more
- **Key tables:** client_records, action_items, email_threads, trips, domains, skills
- **Vault:** Sensitive data (loyalty numbers, credentials) stored in Supabase Vault (encrypted)
- **Shared types:** @graysonos/shared — TypeScript types mirroring all Supabase tables

### Email Integration
- **Gmail accounts (4):** Integrated via Gmail API
  - account1: personal | account2: client-facing | account3: legal | account4: investments
  - account5: admin | account6: travel | account7: domains | account8: finance-pro
- **Office 365 (3):** Integrated via Microsoft Graph API (where applicable)

### Calendar
- **Google Calendar:** 8 purpose-specific calendars, one per Gmail account
- **Routing rule:** Events route to the calendar matching the email account purpose

### Communication & Alerts
- **Slack:** Real-time alerts and notifications
  - Key channels: #daily-brief, #urgent, #mail-actions, #calendar, #finances, #travel, #domains, #zoom-summaries

### AI & Automation
- **Anthropic Claude:** Core intelligence layer for drafting, analysis, triage, and summarization
- **Skills system:** 50+ structured prompt templates stored in Supabase skills table, triggered by slug

### Meetings
- **Zoom:** Meeting recordings and summaries
- **Post-meeting:** Action items and summaries posted to #zoom-summaries Slack channel

### Knowledge Management
- **Obsidian:** Personal knowledge base and note-taking
  - Key paths: /Clients/{ClientName}.md, /Meetings/YYYY-MM-DD {Title}.md

## Monorepo Structure
- **Root:** /home/user/GraysonCompanyOS
- **Package manager:** pnpm (workspaces)
- **Packages:** /packages/ — mail, calendar, zoom, domains, travel, finance-pro, wallet, command
- **Dashboard:** /dashboard/ — Next.js web application
- **Skills:** /skills/ — SQL migrations, markdown docs, README

## Data Flow (Simplified)
1. Emails arrive → parsed by mail package → classified by triage rules → logged to email_threads
2. HIGH priority items → Slack #urgent alert
3. Client emails → action_items created in Supabase
4. Meetings → Zoom recording → summary posted to Slack → debrief captured to Obsidian + Supabase
5. Calendar events → routed to appropriate Google Calendar → prep briefs generated pre-meeting

## Developer Notes
- All packages use TypeScript
- Supabase client initialized with service role key for server-side operations
- Shared types package (@graysonos/shared) must be kept in sync with Supabase schema
- pnpm workspaces — run commands from root with pnpm -F {package-name} {command}
---$$,
  ARRAY['tech', 'stack', 'architecture', 'documentation', 'onboarding']
),

-- ============================================================
-- CATEGORY: Daily Operations
-- ============================================================

(
  'morning-brief',
  'Morning Brief',
  'Daily morning priority brief — the first thing David reads each day.',
  'Daily Operations',
  $$You are generating the daily morning brief for David Grayson, Principal at Grayson Financial. This is the first thing David reads each morning. It must be complete, prioritized, and readable in under 5 minutes.

Today's date is provided in context. Generate the brief using any available context about today's schedule, open items, and pending priorities.

---
# MORNING BRIEF
[Day of week], [Full date]
Good morning, David.

## Today's Meetings
[List each meeting with: time | who | purpose — one line each]
[If calendar data is not provided: "No meeting data available — paste today's calendar to populate"]

## HIGH Priority Items (Act Today)
[List all HIGH priority items requiring action today:
- Emails flagged HIGH from triage
- Overdue action items
- Client items requiring response
- Deadlines today or tomorrow
- Legal or regulatory items
- Domain expiry alerts]
[If none: "No HIGH priority items identified"]

## Deadlines in the Next 7 Days
[Bulleted list of upcoming deadlines with exact dates:
- Tax payment deadlines
- Client deliverables
- Domain renewals
- Compliance filings
- Any other time-sensitive commitments]

## Open Items from Yesterday
[Any action items that were due yesterday and have not been completed — flag as overdue]
[If not available: "Paste yesterday's EOD wrap or action items list to populate this section"]

## Quick Wins Available Today
[2–3 items that could be completed in under 15 minutes each — small tasks that are worth clearing]

## Today's Focus Recommendation
[One decisive recommendation: Given today's meetings, deadlines, and priorities — what is the single most important thing David should accomplish today?]

---
Briefing generated for: [Today's date]
Next brief: Tomorrow morning$$,
  ARRAY['daily', 'morning', 'brief', 'operations', 'priority']
),

(
  'eod-wrap',
  'End of Day Wrap',
  'End-of-day summary of what was completed and what carries forward.',
  'Daily Operations',
  $$You are generating the end-of-day wrap for David Grayson, Principal at Grayson Financial. This should take under 2 minutes to complete and keeps the system current.

The user will provide a quick brain dump of what they did today. Process it into a clean EOD summary.

---
# END OF DAY WRAP
Date: [Today's date]

## Completed Today ✓
[List all tasks, meetings, and actions that were completed — check these off in Supabase action_items]
- [Item 1]
- [Item 2]
...

## Carrying Forward →
[Items that were started or planned today but not completed — update their due dates in Supabase action_items]
- [Item]: [New due date or "tomorrow"]
...

## New Items Surfaced Today
[Any new action items, follow-ups, or commitments that emerged today and need to be logged to Supabase]
- [New item] | Owner: [David/Client/Other] | Due: [Date] | Priority: HIGH/MEDIUM/LOW
...

## Tomorrow's Top 3
[Based on what carried forward and any known priorities — what are the 3 most important things to do tomorrow?]
1. [Most important]
2. [Second priority]
3. [Third priority]

## Supabase Update Summary
Items to log/update:
- action_items: [List of updates]
- email_threads: [Any threads to log or close]
- client_records: [Any client profile updates]

---
Raw brain dump from David:
[PASTE BRAIN DUMP HERE]$$,
  ARRAY['daily', 'eod', 'operations', 'wrap', 'planning']
),

(
  'weekly-digest',
  'Weekly Digest',
  'Friday end-of-week summary and next-week preview.',
  'Daily Operations',
  $$You are generating the Friday weekly digest for David Grayson, Principal at Grayson Financial. This captures the week in review and previews the week ahead.

The user will provide context about the week's activity. Generate the digest:

---
# WEEKLY DIGEST
Week of: [Date range — Monday to Friday]
Generated: [Today's date — Friday]

## This Week's Accomplishments
[What got done this week? Bulleted list of meaningful completions — client meetings held, deliverables completed, action items resolved, relationships advanced]

## Client Activity This Week
| Client | Interaction | Status | Next Step |
[Table of client touchpoints this week — any meetings, emails, follow-ups completed]
[Flag any HIGH priority clients with no interaction this week]

## Open Items Rolling Into Next Week
[Items that were not completed this week — sorted by priority]
- OVERDUE: [Any items past their due date — flag RED]
- HIGH priority carryovers:
- MEDIUM priority carryovers:

## Next Week Preview
[Key meetings and commitments already on the calendar for next week — with prep requirements]
| Day | Event | Prep Needed? |

## One Metric This Week
[One observation about the week: Was it a high-output week? Client-heavy? Reactive (firefighting) or proactive (building)? What does it suggest about next week's focus?]

## Focus Recommendation for Next Week
[One clear recommendation: Based on this week's activity and what's coming next week, what should David prioritize?]

## Supabase Update Required
[Any data to update before end of week: closed action items, client record updates, completed email threads]
---

Provide this week's activity below:
[PASTE WEEK'S ACTIVITY, MEETINGS, COMPLETED ITEMS HERE]$$,
  ARRAY['weekly', 'digest', 'operations', 'review', 'planning']
),

(
  'open-action-items',
  'Open Action Items',
  'Pull and organize all open action items across all sources.',
  'Daily Operations',
  $$You are organizing all open action items across all sources for David Grayson, Principal at Grayson Financial.

The user will provide the current action items list (from Supabase or pasted notes). Organize them into a master prioritized view.

---
# OPEN ACTION ITEMS — MASTER LIST
Generated: [Today's date]

## 🔴 OVERDUE (Past Due Date)
[Items where due date has already passed]
- [ ] [Action] | Owner: [David/Client/Other] | Was Due: [Date] | Client/Context: [Name] | Notes: [Brief context]
[Flag: These need immediate attention or explicit decision to reschedule]

## THIS WEEK (Due in next 7 days)
[Items due this week]
- [ ] [Action] | Owner: [Owner] | Due: [Date] | Client/Context: [Name] | Priority: HIGH/MEDIUM

## THIS MONTH (Due in next 30 days, not this week)
[Items due within the month but not urgent this week]
- [ ] [Action] | Owner: [Owner] | Due: [Date] | Client/Context: [Name]

## WAITING ON OTHERS
[Items where David has done his part and is waiting for a response, input, or action from a client, counterparty, or vendor]
- [ ] [Action] | Waiting on: [Name] | Since: [Date] | Next step if no response by: [Date]

## SOMEDAY / NO DATE
[Items that exist but have no due date — need David's attention to assign or close]
- [ ] [Action] | Owner: [Owner] | Context: [Brief note]

---
## Summary
| Bucket | Count |
|---|---|
| Overdue | X |
| Due this week | X |
| Due this month | X |
| Waiting on others | X |
| No date | X |
| **Total open** | **X** |

## David's Ownership Summary
Items where David is the owner: X
Items overdue that David owns: X

## Recommended Next Actions
[Top 5 specific actions to take today/tomorrow to move the most critical items forward]
---

Paste all open action items below:
[PASTE ACTION ITEMS LIST HERE]$$,
  ARRAY['action-items', 'operations', 'tasks', 'productivity', 'daily']
),

-- ============================================================
-- CATEGORY: Obsidian & Knowledge
-- ============================================================

(
  'obsidian-client-note',
  'Obsidian Client Note',
  'Format a client update as a structured Obsidian markdown note.',
  'Obsidian & Knowledge',
  $$You are formatting a client update as a structured Obsidian markdown note for David Grayson, Principal at Grayson Financial.

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
[PASTE CLIENT UPDATE CONTENT HERE]$$,
  ARRAY['obsidian', 'notes', 'client', 'knowledge', 'markdown']
),

(
  'obsidian-meeting-note',
  'Obsidian Meeting Note',
  'Format a meeting as a structured Obsidian markdown note.',
  'Obsidian & Knowledge',
  $$You are formatting a meeting as a structured Obsidian markdown note for David Grayson, Principal at Grayson Financial.

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
[PASTE MEETING DETAILS / BRAIN DUMP HERE]$$,
  ARRAY['obsidian', 'notes', 'meeting', 'knowledge', 'markdown']
);
