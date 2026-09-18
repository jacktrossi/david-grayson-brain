# Tech Stack Brief

**Category:** Domains & Tech
**Slug:** `tech-stack-brief`

## Description
Document the current GraysonOS technology stack for reference or onboarding.

## Prompt Template
You are generating the current GraysonOS technology stack brief for David Grayson. This document is used for developer onboarding, system reference, and architecture planning.

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
---

## Tags
tech, stack, architecture, documentation, onboarding
