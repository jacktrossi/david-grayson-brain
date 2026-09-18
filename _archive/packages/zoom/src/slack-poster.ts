import { WebClient } from '@slack/web-api'
import type { MeetingSummary, FollowUpDraft, ActionItem } from './types.js'

// ---------------------------------------------------------------------------
// Slack channel constants (from CLAUDE.md channel map)
// ---------------------------------------------------------------------------
const CHANNEL_ZOOM_SUMMARIES = '#zoom-summaries'
const CHANNEL_MAIL_ACTIONS = '#mail-actions'
const CHANNEL_URGENT = '#urgent'

// ---------------------------------------------------------------------------
// Slack client (lazy-init)
// ---------------------------------------------------------------------------

let _slack: WebClient | null = null

function getSlack(): WebClient {
  if (!_slack) {
    const token = process.env.SLACK_BOT_TOKEN
    if (!token) {
      throw new Error('SLACK_BOT_TOKEN environment variable is not set')
    }
    _slack = new WebClient(token)
  }
  return _slack
}

// ---------------------------------------------------------------------------
// Block Kit helpers
// ---------------------------------------------------------------------------

function headerBlock(text: string) {
  return {
    type: 'header',
    text: { type: 'plain_text', text, emoji: true },
  }
}

function sectionBlock(text: string) {
  return {
    type: 'section',
    text: { type: 'mrkdwn', text },
  }
}

function dividerBlock() {
  return { type: 'divider' }
}

function contextBlock(text: string) {
  return {
    type: 'context',
    elements: [{ type: 'mrkdwn', text }],
  }
}

function actionsBlock(buttons: Array<{ text: string; value: string; style?: string }>) {
  return {
    type: 'actions',
    elements: buttons.map((btn) => ({
      type: 'button',
      text: { type: 'plain_text', text: btn.text, emoji: true },
      value: btn.value,
      ...(btn.style ? { style: btn.style } : {}),
    })),
  }
}

// ---------------------------------------------------------------------------
// Formatters
// ---------------------------------------------------------------------------

function formatActionItemsList(items: ActionItem[]): string {
  if (items.length === 0) return '_None identified_'
  return items
    .map((item) => {
      const due = item.dueDate ? ` *(due ${item.dueDate})*` : ''
      return `• [ ] ${item.description} — *${item.owner}*${due}`
    })
    .join('\n')
}

function formatDecisionsList(decisions: string[]): string {
  if (decisions.length === 0) return '_No concrete decisions recorded_'
  return decisions.map((d) => `• ${d}`).join('\n')
}

function formatQuestionsList(questions: string[]): string {
  if (questions.length === 0) return '_No open questions_'
  return questions.map((q) => `• ${q}`).join('\n')
}

function formatDate(date: Date): string {
  return date.toLocaleDateString('en-US', {
    weekday: 'short',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * Posts a structured meeting summary to #zoom-summaries using Slack Block Kit.
 * Sections: narrative summary, key decisions, action items, open questions.
 */
export async function postMeetingSummary(summary: MeetingSummary): Promise<void> {
  const slack = getSlack()
  const dateStr = formatDate(summary.date)
  const attendeesStr =
    summary.attendees.length > 0 ? summary.attendees.join(', ') : 'Unknown attendees'

  const blocks = [
    headerBlock(`Meeting Summary: ${summary.title}`),
    contextBlock(
      `${dateStr}  •  ${summary.durationMinutes} min  •  ${attendeesStr}`,
    ),
    dividerBlock(),

    // Narrative summary
    sectionBlock(`*Overview*\n${summary.fullSummaryText}`),
    dividerBlock(),

    // Key Decisions
    sectionBlock(`*Key Decisions*\n${formatDecisionsList(summary.keyDecisions)}`),
    dividerBlock(),

    // Action Items
    sectionBlock(`*Action Items*\n${formatActionItemsList(summary.actionItems)}`),
    dividerBlock(),

    // Open Questions
    sectionBlock(`*Open Questions*\n${formatQuestionsList(summary.openQuestions)}`),
  ]

  // Optional: next meeting
  if (summary.nextMeetingProposed) {
    blocks.push(dividerBlock())
    blocks.push(sectionBlock(`*Next Meeting Proposed*\n${summary.nextMeetingProposed}`))
  }

  blocks.push(
    contextBlock(
      `Meeting ID: ${summary.meetingId}  •  Zoom UUID: ${summary.zoomUuid}  •  Posted by GraysonOS`,
    ),
  )

  await slack.chat.postMessage({
    channel: CHANNEL_ZOOM_SUMMARIES,
    text: `Meeting Summary: ${summary.title} (${dateStr})`,
    blocks,
  })

  console.log(`[zoom/slack] Posted meeting summary for "${summary.title}" to ${CHANNEL_ZOOM_SUMMARIES}`)
}

/**
 * Posts a follow-up email draft to #mail-actions with [Send] and [Edit] buttons.
 */
export async function postFollowUpQueued(
  draft: FollowUpDraft,
  meetingTitle: string,
): Promise<void> {
  const slack = getSlack()

  // Build a preview: first 400 chars of body
  const preview =
    draft.body.length > 400 ? draft.body.substring(0, 400) + '…' : draft.body

  const recipientsStr = draft.to.filter(Boolean).join(', ') || 'TBD'

  const blocks = [
    headerBlock(`Follow-Up Email Ready: ${meetingTitle}`),
    contextBlock(
      `To: ${recipientsStr}  •  From: ${draft.accountToSendFrom}`,
    ),
    sectionBlock(`*Subject:* ${draft.subject}`),
    dividerBlock(),
    sectionBlock(`*Preview:*\n\`\`\`\n${preview}\n\`\`\``),
    dividerBlock(),
    actionsBlock([
      { text: 'Send', value: `send:${meetingTitle}`, style: 'primary' },
      { text: 'Edit', value: `edit:${meetingTitle}` },
      { text: 'Discard', value: `discard:${meetingTitle}`, style: 'danger' },
    ]),
    contextBlock('Review before sending. GraysonOS will not send without your approval.'),
  ]

  await slack.chat.postMessage({
    channel: CHANNEL_MAIL_ACTIONS,
    text: `Follow-up email draft ready for: ${meetingTitle}`,
    blocks,
  })

  console.log(`[zoom/slack] Posted follow-up draft for "${meetingTitle}" to ${CHANNEL_MAIL_ACTIONS}`)
}

/**
 * Posts a pre-meeting alert to #urgent 30 minutes before a Zoom meeting.
 * Includes: meeting context, attendees, last meeting snippet, open action item count.
 */
export async function postPreMeetingAlert(
  meetingTitle: string,
  startTime: Date,
  attendees: string[],
  brief: string,
  openActionItemCount: number = 0,
): Promise<void> {
  const slack = getSlack()

  const startStr = startTime.toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    timeZoneName: 'short',
  })
  const attendeesStr = attendees.length > 0 ? attendees.join(', ') : 'No attendees listed'

  // Truncate brief to avoid overly long messages
  const briefPreview = brief.length > 300 ? brief.substring(0, 300) + '…' : brief

  const blocks = [
    headerBlock(`Upcoming Meeting in 30 min: ${meetingTitle}`),
    contextBlock(`Starts at ${startStr}`),
    dividerBlock(),
    sectionBlock(`*Attendees*\n${attendeesStr}`),
    dividerBlock(),
    sectionBlock(`*Context Brief*\n${briefPreview || '_No prior meeting data available_'}`),
  ]

  if (openActionItemCount > 0) {
    blocks.push(dividerBlock())
    blocks.push(
      sectionBlock(
        `*Open Action Items from Prior Meetings*\n${openActionItemCount} outstanding item${openActionItemCount !== 1 ? 's' : ''} — review before joining`,
      ),
    )
  }

  blocks.push(contextBlock('GraysonOS pre-meeting alert'))

  await slack.chat.postMessage({
    channel: CHANNEL_URGENT,
    text: `Upcoming meeting in 30 min: ${meetingTitle} at ${startStr}`,
    blocks,
  })

  console.log(`[zoom/slack] Posted pre-meeting alert for "${meetingTitle}" to ${CHANNEL_URGENT}`)
}
