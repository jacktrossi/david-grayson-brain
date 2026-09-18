import { google } from 'googleapis'
import type { Account, ClassifiedEmail } from './types.js'

function getOAuthClient(account: Account) {
  const idx = account.priority // 1-8, matches env var numbering
  const clientId = process.env[`GMAIL_ACCOUNT_${idx}_CLIENT_ID`]
    ?? process.env.GMAIL_CLIENT_ID!
  const clientSecret = process.env[`GMAIL_ACCOUNT_${idx}_CLIENT_SECRET`]
    ?? process.env.GMAIL_CLIENT_SECRET!
  const refreshToken = process.env[`GMAIL_ACCOUNT_${idx}_REFRESH_TOKEN`]!

  const auth = new google.auth.OAuth2(clientId, clientSecret)
  auth.setCredentials({ refresh_token: refreshToken })
  return auth
}

export async function fetchNewEmails(account: Account, sinceMinutes = 10): Promise<ClassifiedEmail[]> {
  const auth = getOAuthClient(account)
  const gmail = google.gmail({ version: 'v1', auth })

  const after = Math.floor((Date.now() - sinceMinutes * 60 * 1000) / 1000)
  const query = `is:unread -label:graysonos/processed after:${after}`

  const listRes = await gmail.users.messages.list({
    userId: 'me',
    q: query,
    maxResults: 20,
  })

  const messages = listRes.data.messages ?? []
  const emails: ClassifiedEmail[] = []

  for (const msg of messages) {
    if (!msg.id) continue
    const res = await gmail.users.messages.get({
      userId: 'me',
      id: msg.id,
      format: 'full',
    })

    const headers = res.data.payload?.headers ?? []
    const subject = headers.find(h => h.name?.toLowerCase() === 'subject')?.value ?? '(no subject)'
    const from = headers.find(h => h.name?.toLowerCase() === 'from')?.value ?? ''
    const date = headers.find(h => h.name?.toLowerCase() === 'date')?.value ?? ''

    const body = extractBody(res.data.payload)

    emails.push({
      threadId: res.data.threadId ?? msg.id,
      subject,
      fromAddress: from,
      receivedAt: date ? new Date(date) : new Date(),
      body: body.slice(0, 4000), // keep tokens reasonable
      classification: 'routine', // filled by classifier
      isHighPriority: false,
    })
  }

  return emails
}

export async function markProcessed(account: Account, threadId: string) {
  const auth = getOAuthClient(account)
  const gmail = google.gmail({ version: 'v1', auth })

  // Create label if needed, then apply it
  try {
    await gmail.users.threads.modify({
      userId: 'me',
      id: threadId,
      requestBody: { addLabelIds: [], removeLabelIds: ['UNREAD'] },
    })
  } catch {
    // Non-fatal — thread already read or label doesn't exist yet
  }
}

export async function sendEmail(
  account: Account,
  to: string,
  subject: string,
  body: string,
) {
  const auth = getOAuthClient(account)
  const gmail = google.gmail({ version: 'v1', auth })

  const raw = btoa(
    `From: ${account.email}\r\nTo: ${to}\r\nSubject: ${subject}\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n${body}`
  ).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')

  await gmail.users.messages.send({
    userId: 'me',
    requestBody: { raw },
  })
}

function extractBody(payload: Parameters<typeof extractBody>[0]): string {
  if (!payload) return ''

  if (payload.body?.data) {
    return Buffer.from(payload.body.data, 'base64').toString('utf-8')
  }

  for (const part of payload.parts ?? []) {
    const text = extractBody(part)
    if (text) return text
  }

  return ''
}
