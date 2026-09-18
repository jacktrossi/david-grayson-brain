import Anthropic from '@anthropic-ai/sdk'
import type { TranscriptSegment, MeetingSummary, ActionItem } from './types.js'

const MODEL = 'claude-sonnet-4-6'

// ---------------------------------------------------------------------------
// System prompt
// ---------------------------------------------------------------------------

const SUMMARIZER_SYSTEM_PROMPT = `You are an expert meeting analyst for David Grayson, a 58-year-old investment advisor and principal at Grayson Financial. Your job is to extract structured, actionable intelligence from meeting transcripts.

## Your Output Format
You MUST respond with valid JSON and nothing else. No prose before or after. Use this exact structure:

{
  "attendees": ["Name 1", "Name 2"],
  "keyDecisions": [
    "Concrete decision made in the meeting — must be a firm agreement, not a discussion point"
  ],
  "openQuestions": [
    "Something raised but not resolved — a question left hanging, a topic deferred, a disagreement unresolved"
  ],
  "actionItems": [
    {
      "description": "Specific task to be completed",
      "owner": "Full name of the person responsible (must be a named individual, not 'the team')",
      "dueDate": "YYYY-MM-DD or null if not specified",
      "sourceQuote": "Exact verbatim quote from the transcript that spawned this action item"
    }
  ],
  "nextMeetingProposed": "Date/time string if a follow-up meeting was proposed, or null",
  "fullSummaryText": "3-5 sentence narrative summary of what was discussed and decided. Write in past tense. Mention participants by name."
}

## Extraction Rules — Read These Carefully

### Key Decisions
- A key decision is a CONCRETE AGREEMENT made by the participants. Examples: "We agreed to move the portfolio to 60/40 allocation", "We decided to send the contract to legal by Friday".
- DO NOT include items that were merely discussed, considered, or mentioned as possibilities.
- DO NOT include things someone said they would "think about" or "look into" — those become open questions or action items.
- If no concrete decisions were made, return an empty array [].

### Action Items
- An action item MUST have a named owner — a specific person. If someone says "we should do X" with no clear assignee, flag it as an open question instead.
- The sourceQuote must be the exact text from the transcript — copy it verbatim, do not paraphrase.
- Include a dueDate only if a specific date or timeframe was mentioned (e.g. "by Friday", "end of month", "next Tuesday"). Convert relative dates to absolute if the meeting date is known.
- If the transcript mentions someone will "follow up" or "get back to you", that is an action item for that person.

### Open Questions
- These are things left unresolved: unanswered questions, topics deferred to a later meeting, disagreements without resolution, requests for more information.
- Separate clearly from decisions — if it is not resolved, it is an open question.

### Attendees
- Extract all unique speaker names from the transcript. Use the names as they appear. If only one participant is identified, list only that person.

### Next Meeting
- Only populate nextMeetingProposed if a specific date, time, or timeframe for a follow-up meeting was explicitly mentioned.

### Full Summary
- 3-5 sentences. Past tense. Name the key participants. Describe what was discussed (high level), what was decided, and what needs follow-up.
- Write for a senior financial professional who needs a quick briefing before his next call.

## Tone & Quality
- Be conservative: prefer "no decision found" over a speculative extraction.
- Be precise: vague action items like "look into it" are not useful — if the task cannot be described specifically, mark it as an open question.
- Always attribute — never list an action item without an owner.`

// ---------------------------------------------------------------------------
// Claude response type (internal)
// ---------------------------------------------------------------------------

interface ClaudeStructuredResponse {
  attendees: string[]
  keyDecisions: string[]
  openQuestions: string[]
  actionItems: Array<{
    description: string
    owner: string
    dueDate: string | null
    sourceQuote: string
  }>
  nextMeetingProposed: string | null
  fullSummaryText: string
}

// ---------------------------------------------------------------------------
// Transcript formatting
// ---------------------------------------------------------------------------

function formatTranscriptForPrompt(segments: TranscriptSegment[]): string {
  return segments
    .map((seg) => {
      const ts = formatTimestamp(seg.start_time)
      return `[${ts}] ${seg.speaker}: ${seg.text}`
    })
    .join('\n')
}

function formatTimestamp(seconds: number): string {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = Math.floor(seconds % 60)
  if (h > 0) return `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}

// ---------------------------------------------------------------------------
// Main export
// ---------------------------------------------------------------------------

/**
 * Uses Claude (claude-sonnet-4-6) to extract structured intelligence from a
 * meeting transcript.
 *
 * Returns a fully populated MeetingSummary including key decisions, action items
 * with named owners and source quotes, open questions, and a narrative summary.
 */
export async function summarizeMeeting(
  segments: TranscriptSegment[],
  meetingTitle: string,
  durationMinutes: number,
  meetingId: string = '',
  zoomUuid: string = '',
  meetingDate: Date = new Date(),
): Promise<MeetingSummary> {
  if (segments.length === 0) {
    throw new Error('Cannot summarize an empty transcript')
  }

  const client = new Anthropic()
  const transcriptText = formatTranscriptForPrompt(segments)
  const dateStr = meetingDate.toISOString().split('T')[0]

  const userMessage = `Please analyze this meeting transcript and extract structured intelligence.

Meeting Title: ${meetingTitle}
Meeting Date: ${dateStr}
Duration: ${durationMinutes} minutes

--- TRANSCRIPT START ---
${transcriptText}
--- TRANSCRIPT END ---

Return ONLY valid JSON following the exact schema in your instructions.`

  console.log(
    `[zoom/summarizer] Sending ${segments.length} segments (${transcriptText.length} chars) to Claude for "${meetingTitle}"`,
  )

  const message = await client.messages.create({
    model: MODEL,
    max_tokens: 4096,
    system: SUMMARIZER_SYSTEM_PROMPT,
    messages: [{ role: 'user', content: userMessage }],
  })

  const rawContent = message.content[0]
  if (!rawContent || rawContent.type !== 'text') {
    throw new Error(`Unexpected Claude response type: ${rawContent?.type ?? 'undefined'}`)
  }

  let parsed: ClaudeStructuredResponse
  try {
    // Strip any accidental markdown code fences
    const jsonText = rawContent.text
      .replace(/^```(?:json)?\s*/m, '')
      .replace(/\s*```\s*$/m, '')
      .trim()
    parsed = JSON.parse(jsonText) as ClaudeStructuredResponse
  } catch (err) {
    console.error('[zoom/summarizer] Failed to parse Claude JSON response:', rawContent.text)
    throw new Error(`Claude returned invalid JSON: ${(err as Error).message}`)
  }

  // Map ClaudeStructuredResponse → MeetingSummary
  const actionItems: ActionItem[] = (parsed.actionItems ?? []).map((item) => ({
    description: item.description,
    owner: item.owner,
    dueDate: item.dueDate ?? undefined,
    sourceQuote: item.sourceQuote,
  }))

  const summary: MeetingSummary = {
    meetingId,
    zoomUuid,
    title: meetingTitle,
    date: meetingDate,
    durationMinutes,
    attendees: parsed.attendees ?? [],
    keyDecisions: parsed.keyDecisions ?? [],
    openQuestions: parsed.openQuestions ?? [],
    actionItems,
    nextMeetingProposed: parsed.nextMeetingProposed ?? undefined,
    fullSummaryText: parsed.fullSummaryText ?? '',
  }

  console.log(
    `[zoom/summarizer] Extracted: ${summary.keyDecisions.length} decisions, ` +
      `${summary.actionItems.length} action items, ${summary.openQuestions.length} open questions`,
  )

  return summary
}
