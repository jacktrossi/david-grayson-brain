import Anthropic from '@anthropic-ai/sdk'
import type { MeetingSummary, FollowUpDraft, ActionItem } from './types.js'

const MODEL = 'claude-sonnet-4-6'

// ---------------------------------------------------------------------------
// Known client domains (from CLAUDE.md + schema)
// Used to detect client attendees and append compliance disclosure.
// ---------------------------------------------------------------------------
const CLIENT_DOMAINS: Record<string, string> = {
  'smithcapital.com': 'Smith Capital Management',
  'smithcapitalmanagement.com': 'Smith Capital Management',
  'harrisgroup.com': 'Harris Group Partners',
  'harrisgrouppartners.com': 'Harris Group Partners',
  'merceradvisors.com': 'Mercer Advisors',
}

const COMPLIANCE_DISCLOSURE = `\n\n---\nInvestment advisory services provided by Grayson Financial. Past performance is not indicative of future results.`

// ---------------------------------------------------------------------------
// Account routing
// ---------------------------------------------------------------------------

/**
 * Determines which Gmail account to send the follow-up from.
 *
 * Logic (matches CLAUDE.md account priority):
 *   - Any attendee from a known client domain → account2 (client-facing)
 *   - Any attendee with .gov or legal-sounding domain → account3 (legal)
 *   - Default for investment/business meetings → account2 (client-facing)
 *   - Internal/personal → account1 (personal)
 */
function determineAccountToSendFrom(attendeeEmails: string[]): string {
  if (attendeeEmails.length === 0) {
    return 'account2@gmail.com' // default to client-facing
  }

  for (const email of attendeeEmails) {
    const domain = email.split('@')[1]?.toLowerCase() ?? ''

    // Known client domains → client-facing account
    if (domain in CLIENT_DOMAINS) return 'account2@gmail.com'

    // Legal / regulatory
    if (domain.endsWith('.gov') || domain.includes('legal') || domain.includes('law')) {
      return 'account3@gmail.com'
    }
  }

  // Default: client-facing for business meetings
  return 'account2@gmail.com'
}

/**
 * Returns true if any attendee email is from a known client firm.
 */
function hasKnownClientAttendee(attendeeEmails: string[]): boolean {
  return attendeeEmails.some((email) => {
    const domain = email.split('@')[1]?.toLowerCase() ?? ''
    return domain in CLIENT_DOMAINS
  })
}

// ---------------------------------------------------------------------------
// Prompt helpers
// ---------------------------------------------------------------------------

function formatActionItemsForPrompt(items: ActionItem[]): string {
  if (items.length === 0) return 'None identified.'
  return items
    .map((item, i) => {
      const due = item.dueDate ? ` (due ${item.dueDate})` : ''
      return `${i + 1}. ${item.description} — Owner: ${item.owner}${due}`
    })
    .join('\n')
}

// ---------------------------------------------------------------------------
// Main export
// ---------------------------------------------------------------------------

/**
 * Uses Claude to generate a professional follow-up email based on the meeting
 * summary. Automatically:
 *   - Routes to the correct Gmail account based on attendee domains
 *   - Appends compliance disclosure for client-facing emails
 *   - Uses David's authoritative but approachable voice (per CLAUDE.md)
 */
export async function generateFollowUpEmail(
  summary: MeetingSummary,
  attendeeEmails: string[] = [],
): Promise<FollowUpDraft> {
  const client = new Anthropic()

  const accountToSendFrom = determineAccountToSendFrom(attendeeEmails)
  const isClientFacing =
    accountToSendFrom === 'account2@gmail.com' || hasKnownClientAttendee(attendeeEmails)

  const dateStr = summary.date.toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })

  const systemPrompt = `You are drafting a follow-up email on behalf of David Grayson, Principal at Grayson Financial.

David's communication style (from his personal OS guidelines):
- Professional, concise, financial-industry appropriate
- Authoritative but approachable; no slang or casual language
- Get to the point in the first two sentences
- Use bullet points for lists
- Address clients by last name with "Mr./Ms." unless a first-name relationship is known
- Sign off: "Best regards, David Grayson | Grayson Financial"

Return ONLY valid JSON with this exact structure — no prose, no markdown:
{
  "to": ["email1@example.com"],
  "subject": "Follow-Up: [Meeting Title] — [Date]",
  "body": "Full email body text, using \\n for line breaks"
}`

  const userMessage = `Draft a follow-up email for this meeting:

Meeting: ${summary.title}
Date: ${dateStr}
Duration: ${summary.durationMinutes} minutes
Attendees: ${summary.attendees.join(', ')}
Attendee emails: ${attendeeEmails.length > 0 ? attendeeEmails.join(', ') : '(not available)'}

Key Decisions Made:
${summary.keyDecisions.length > 0 ? summary.keyDecisions.map((d, i) => `${i + 1}. ${d}`).join('\n') : 'None.'}

Action Items:
${formatActionItemsForPrompt(summary.actionItems)}

Open Questions (unresolved):
${summary.openQuestions.length > 0 ? summary.openQuestions.map((q, i) => `${i + 1}. ${q}`).join('\n') : 'None.'}

${summary.nextMeetingProposed ? `Next Meeting Proposed: ${summary.nextMeetingProposed}` : ''}

Meeting Summary:
${summary.fullSummaryText}

The email should:
1. Open with a brief thank-you for the meeting
2. Recap the key decisions concisely
3. List action items with owners and due dates
4. Note any open questions that need resolution
5. Mention next steps / proposed follow-up meeting if applicable
6. Close professionally

${isClientFacing ? 'This is a client-facing email — maintain formal tone and address by last name.' : ''}

For the "to" field, use the attendee emails provided, or leave as [""] if none are available.`

  console.log(
    `[zoom/follow-up] Generating follow-up email for "${summary.title}" via ${accountToSendFrom}`,
  )

  const message = await client.messages.create({
    model: MODEL,
    max_tokens: 2048,
    system: systemPrompt,
    messages: [{ role: 'user', content: userMessage }],
  })

  const rawContent = message.content[0]
  if (!rawContent || rawContent.type !== 'text') {
    throw new Error(`Unexpected Claude response type: ${rawContent?.type ?? 'undefined'}`)
  }

  let parsed: { to: string[]; subject: string; body: string }
  try {
    const jsonText = rawContent.text
      .replace(/^```(?:json)?\s*/m, '')
      .replace(/\s*```\s*$/m, '')
      .trim()
    parsed = JSON.parse(jsonText) as typeof parsed
  } catch (err) {
    console.error('[zoom/follow-up] Failed to parse Claude JSON:', rawContent.text)
    throw new Error(`Claude returned invalid JSON: ${(err as Error).message}`)
  }

  // Append mandatory compliance disclaimer for client-facing emails
  let body = parsed.body
  if (isClientFacing && !body.includes('Past performance is not indicative')) {
    body += COMPLIANCE_DISCLOSURE
  }

  return {
    to: parsed.to ?? [],
    subject: parsed.subject ?? `Follow-Up: ${summary.title} — ${dateStr}`,
    body,
    accountToSendFrom,
  }
}
