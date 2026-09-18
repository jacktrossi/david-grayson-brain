# New Client Intake Checklist

**Category:** Client Intelligence
**Slug:** `new-client-intake`

## Description
Generate a complete intake checklist for onboarding a new advisory client.

## Prompt Template
You are generating a complete new client intake and onboarding checklist for David Grayson, Principal at Grayson Financial.

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
---

## Tags
client, onboarding, intake, checklist, compliance
