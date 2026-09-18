import { google } from 'googleapis'
import type { Calendar, ClassifiedEmail } from './types.js'

function getOAuthClient() {
  const auth = new google.auth.OAuth2(
    process.env.GCAL_CLIENT_ID!,
    process.env.GCAL_CLIENT_SECRET!,
  )
  auth.setCredentials({ refresh_token: process.env.GCAL_REFRESH_TOKEN! })
  return auth
}

export async function addMeetingToCalendar(
  calendar: Calendar,
  email: ClassifiedEmail,
): Promise<string | null> {
  if (!email.extractedDateTime) return null

  const auth = getOAuthClient()
  const cal = google.calendar({ version: 'v3', auth })

  const startTime = email.extractedDateTime
  const endTime = new Date(startTime.getTime() + 60 * 60 * 1000) // default 1hr

  // Extract Zoom link from body
  const zoomMatch = email.body.match(/https:\/\/[a-z0-9.]*zoom\.us\/j\/[\d?=&]+/i)
  const zoomLink = zoomMatch?.[0] ?? null

  const description = [
    `Detected from: ${email.fromAddress}`,
    `Subject: ${email.subject}`,
    zoomLink ? `Zoom: ${zoomLink}` : null,
    `\nAdded automatically by GraysonOS`,
  ].filter(Boolean).join('\n')

  try {
    const event = await cal.events.insert({
      calendarId: calendar.google_calendar_id,
      requestBody: {
        summary: email.extractedTitle ?? email.subject,
        description,
        start: { dateTime: startTime.toISOString() },
        end: { dateTime: endTime.toISOString() },
        conferenceData: zoomLink ? {
          entryPoints: [{ entryPointType: 'video', uri: zoomLink }],
        } : undefined,
      },
    })
    return event.data.id ?? null
  } catch (err) {
    console.error(`Calendar insert failed for ${calendar.name}:`, err)
    return null
  }
}

export function pickCalendar(
  calendars: Calendar[],
  accountId: string,
): Calendar | undefined {
  // Prefer the calendar that belongs to the same account the email arrived on
  return calendars.find(c => c.account_id === accountId) ?? calendars[0]
}
