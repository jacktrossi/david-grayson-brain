/**
 * GraysonOS Nervous System
 *
 * Run on a cron every 5 minutes:
 *   node dist/index.js
 *
 * Or run the morning digest at 7am:
 *   node dist/index.js --digest
 */

import { loadSecrets } from './secrets.js'
import { fetchNewEmails, markProcessed } from './gmail.js'
import { classifyBatch } from './classifier.js'
import { addMeetingToCalendar, pickCalendar } from './calendar.js'
import { alertMeetingAdded, alertUrgent, sendMorningDigest } from './alerter.js'
import {
  getAccounts, getCalendars, isAlreadyProcessed,
  saveThread, getTodayMeetings, getOpenActionItems,
} from './db.js'

const IS_DIGEST = process.argv.includes('--digest')

async function run() {
  await loadSecrets()
  const accounts = await getAccounts()
  const calendars = await getCalendars()

  if (IS_DIGEST) {
    await runMorningDigest(accounts)
    return
  }

  // Scan all 8 inboxes in parallel
  const results = await Promise.allSettled(
    accounts.map(account => scanAccount(account, accounts, calendars))
  )

  results.forEach((r, i) => {
    if (r.status === 'rejected') {
      console.error(`Account ${accounts[i].label} failed:`, r.reason)
    }
  })
}

async function scanAccount(
  account: ReturnType<typeof getAccounts> extends Promise<infer T> ? T[number] : never,
  allAccounts: Awaited<ReturnType<typeof getAccounts>>,
  calendars: Awaited<ReturnType<typeof getCalendars>>,
) {
  const refreshToken = process.env[`GMAIL_ACCOUNT_${account.priority}_REFRESH_TOKEN`]
  if (!refreshToken) return // account not configured yet — skip silently

  const rawEmails = await fetchNewEmails(account, 10)
  if (rawEmails.length === 0) return

  // Filter out already-processed threads
  const newEmails = (
    await Promise.all(
      rawEmails.map(async e => ({
        email: e,
        seen: await isAlreadyProcessed(account.id, e.threadId),
      }))
    )
  ).filter(x => !x.seen).map(x => x.email)

  if (newEmails.length === 0) return

  // Classify all new emails in one pass
  const classified = await classifyBatch(newEmails)

  const calendar = pickCalendar(calendars, account.id)

  for (const email of classified) {
    // Save to DB regardless of classification
    await saveThread(account.id, email)
    await markProcessed(account, email.threadId)

    if (email.classification === 'meeting' && email.extractedDateTime && calendar) {
      const eventId = await addMeetingToCalendar(calendar, email)
      await alertMeetingAdded(allAccounts, email, calendar.name)
      console.log(`[${account.label}] Meeting added: ${email.extractedTitle} → ${calendar.name}`)
    }

    if (email.classification === 'urgent' || email.isHighPriority) {
      await alertUrgent(allAccounts, email, account.label)
      console.log(`[${account.label}] Urgent flagged: ${email.subject}`)
    }
  }
}

async function runMorningDigest(accounts: Awaited<ReturnType<typeof getAccounts>>) {
  const [meetings, items] = await Promise.all([
    getTodayMeetings(),
    getOpenActionItems(),
  ])

  // Count urgent unread across accounts (simplified — uses DB classification)
  const { supabase } = await import('./db.js')
  const yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1)
  const { count: urgentCount } = await supabase
    .from('email_threads')
    .select('*', { count: 'exact', head: true })
    .eq('classification', 'urgent')
    .gte('received_at', yesterday.toISOString())

  await sendMorningDigest(accounts, meetings, items, urgentCount ?? 0)
  console.log('Morning digest sent.')
}

run().catch(err => {
  console.error('Nervous system error:', err)
  process.exit(1)
})
