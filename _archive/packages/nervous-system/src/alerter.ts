import { sendEmail } from './gmail.js'
import type { Account, ClassifiedEmail } from './types.js'

// The account GraysonOS sends alert emails FROM (highest-priority account)
function getPrimaryAccount(accounts: Account[]): Account {
  return accounts.sort((a, b) => a.priority - b.priority)[0]
}

const ALERT_TO = process.env.ALERT_TO_EMAIL! // David's main inbox for alerts

export async function alertMeetingAdded(
  accounts: Account[],
  email: ClassifiedEmail,
  calendarName: string,
) {
  const from = getPrimaryAccount(accounts)
  const time = email.extractedDateTime
    ? email.extractedDateTime.toLocaleString('en-US', {
        weekday: 'long', month: 'short', day: 'numeric',
        hour: 'numeric', minute: '2-digit', timeZoneName: 'short',
      })
    : 'time TBD'

  const subject = `📅 Added to calendar: ${email.extractedTitle ?? email.subject}`
  const body = [
    `GraysonOS detected a meeting in your ${from.label} inbox and added it to your calendar.`,
    ``,
    `Meeting: ${email.extractedTitle ?? email.subject}`,
    `When:    ${time}`,
    `Calendar: ${calendarName}`,
    `From:    ${email.fromAddress}`,
    ``,
    `Original subject: ${email.subject}`,
  ].join('\n')

  await sendEmail(from, ALERT_TO, subject, body)
}

export async function alertUrgent(
  accounts: Account[],
  email: ClassifiedEmail,
  accountLabel: string,
) {
  const from = getPrimaryAccount(accounts)
  const subject = `🔴 Urgent: ${email.subject}`
  const body = [
    `GraysonOS flagged a high-priority email in your ${accountLabel} inbox.`,
    ``,
    `From:    ${email.fromAddress}`,
    `Subject: ${email.subject}`,
    ``,
    `Open this account to reply: ${accountLabel}`,
  ].join('\n')

  await sendEmail(from, ALERT_TO, subject, body)
}

export async function sendMorningDigest(
  accounts: Account[],
  todayMeetings: Array<{ title: string; time: string; calendar: string }>,
  openItems: Array<{ description: string; dueDate: string | null }>,
  urgentEmails: number,
) {
  const from = getPrimaryAccount(accounts)
  const today = new Date().toLocaleDateString('en-US', {
    weekday: 'long', month: 'long', day: 'numeric',
  })

  const meetingLines = todayMeetings.length > 0
    ? todayMeetings.map(m => `  • ${m.time} — ${m.title} (${m.calendar})`).join('\n')
    : '  No meetings today.'

  const itemLines = openItems.length > 0
    ? openItems.slice(0, 5).map(i =>
        `  • ${i.description}${i.dueDate ? ` (due ${i.dueDate})` : ''}`
      ).join('\n')
    : '  No open items.'

  const body = [
    `Good morning. Here's your day — ${today}`,
    ``,
    `TODAY'S MEETINGS`,
    meetingLines,
    ``,
    `OPEN ITEMS`,
    itemLines,
    ``,
    urgentEmails > 0
      ? `ATTENTION: ${urgentEmails} urgent email${urgentEmails > 1 ? 's' : ''} need your reply.`
      : `Inbox clear of urgent items.`,
    ``,
    `— GraysonOS`,
  ].join('\n')

  await sendEmail(from, ALERT_TO, `GraysonOS — ${today}`, body)
}
