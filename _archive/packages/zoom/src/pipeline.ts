import { createClient } from '@supabase/supabase-js'
import type { ZoomWebhookEvent, MeetingSummary, ActionItem, TranscriptSegment } from './types.js'
import { getZoomAccessToken, fetchTranscript } from './transcript-fetcher.js'
import { summarizeMeeting } from './summarizer.js'
import { generateFollowUpEmail } from './follow-up-generator.js'
import { postMeetingSummary, postFollowUpQueued } from './slack-poster.js'

// ---------------------------------------------------------------------------
// Supabase client (lazy-init)
// ---------------------------------------------------------------------------

function getSupabase() {
  const url = process.env.SUPABASE_URL
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_ANON_KEY
  if (!url || !key) {
    throw new Error('Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars')
  }
  return createClient(url, key)
}

// ---------------------------------------------------------------------------
// Supabase persistence
// ---------------------------------------------------------------------------

/**
 * Upserts a meeting record and stores the transcript summary.
 * Returns the internal Supabase meetings.id for cross-table linking.
 */
async function saveMeetingToSupabase(
  event: ZoomWebhookEvent,
  summary: MeetingSummary,
  rawTranscript: string,
): Promise<string | null> {
  try {
    const supabase = getSupabase()
    const obj = event.payload.object

    // Upsert into meetings table
    const { data: meetingData, error: meetingError } = await supabase
      .from('meetings')
      .upsert(
        {
          title: obj.topic,
          start_time: obj.start_time,
          end_time: new Date(
            new Date(obj.start_time).getTime() + obj.duration * 60 * 1000,
          ).toISOString(),
          zoom_link: `https://zoom.us/rec/${obj.uuid}`,
          attendees: summary.attendees,
          status: 'completed',
        },
        { onConflict: 'zoom_link' },
      )
      .select('id')
      .single()

    if (meetingError) {
      console.error('[zoom/pipeline] Failed to upsert meeting:', meetingError)
      return null
    }

    const meetingDbId: string = meetingData.id

    // Insert into meeting_transcripts
    const { error: transcriptError } = await supabase.from('meeting_transcripts').insert({
      meeting_id: meetingDbId,
      zoom_recording_id: obj.id,
      raw_transcript: rawTranscript,
      summary: summary.fullSummaryText,
      key_decisions: summary.keyDecisions,
      action_items: summary.actionItems,
      follow_up_drafted: true,
    })

    if (transcriptError) {
      console.error('[zoom/pipeline] Failed to insert meeting_transcript:', transcriptError)
    }

    // Persist action items into the action_items table
    if (summary.actionItems.length > 0) {
      const actionItemRows = summary.actionItems.map((item: ActionItem) => ({
        description: item.description,
        due_date: item.dueDate ?? null,
        owner: item.owner,
        source_type: 'zoom',
        source_id: obj.id,
        status: 'open',
      }))

      const { error: aiError } = await supabase.from('action_items').insert(actionItemRows)
      if (aiError) {
        console.error('[zoom/pipeline] Failed to insert action_items:', aiError)
      } else {
        console.log(`[zoom/pipeline] Saved ${actionItemRows.length} action items to Supabase`)
      }
    }

    return meetingDbId
  } catch (err) {
    console.error('[zoom/pipeline] Supabase save failed:', err)
    return null
  }
}

/**
 * Looks up a client record by attendee email domain.
 * Returns the client record id and name if found.
 */
async function findClientByAttendeeDomains(
  attendees: string[],
): Promise<{ id: string; name: string } | null> {
  try {
    const supabase = getSupabase()

    const { data, error } = await supabase
      .from('client_records')
      .select('id, name, contact_info')

    if (error || !data) return null

    for (const record of data) {
      const contactInfo = record.contact_info as Record<string, unknown>
      const clientEmails = (contactInfo.emails ?? []) as string[]
      const clientDomains: string[] = clientEmails
        .map((e: string) => e.split('@')[1]?.toLowerCase())
        .filter((d): d is string => d !== undefined && d.length > 0)

      const attendeeDomainsSet = new Set<string>(
        attendees
          .map((a) => a.split('@')[1]?.toLowerCase())
          .filter((d): d is string => d !== undefined && d.length > 0),
      )

      const hasMatch = clientDomains.some((d) => attendeeDomainsSet.has(d))
      if (hasMatch) {
        return { id: record.id as string, name: record.name as string }
      }
    }

    return null
  } catch (err) {
    console.error('[zoom/pipeline] Client lookup failed:', err)
    return null
  }
}

/**
 * Appends a meeting reference to a client_record's open_items.
 */
async function logMeetingToClientRecord(
  clientId: string,
  summary: MeetingSummary,
): Promise<void> {
  try {
    const supabase = getSupabase()

    const { data, error } = await supabase
      .from('client_records')
      .select('open_items')
      .eq('id', clientId)
      .single()

    if (error || !data) return

    const existingItems = (data.open_items ?? []) as unknown[]
    const newItem = {
      type: 'zoom_meeting',
      meetingId: summary.meetingId,
      title: summary.title,
      date: summary.date.toISOString(),
      actionItems: summary.actionItems.map((a: ActionItem) => ({
        description: a.description,
        owner: a.owner,
        dueDate: a.dueDate,
      })),
    }

    await supabase
      .from('client_records')
      .update({
        open_items: [...existingItems, newItem],
        updated_at: new Date().toISOString(),
      })
      .eq('id', clientId)

    console.log(`[zoom/pipeline] Logged meeting to client record: ${clientId}`)
  } catch (err) {
    console.error('[zoom/pipeline] Failed to log meeting to client record:', err)
  }
}

// ---------------------------------------------------------------------------
// Main pipeline
// ---------------------------------------------------------------------------

/**
 * Full meeting intelligence pipeline — triggered by a Zoom recording.completed event.
 *
 * Steps:
 *   1. Fetch Zoom OAuth access token
 *   2. Download and parse the meeting transcript (VTT or Whisper fallback)
 *   3. Summarize with Claude → MeetingSummary
 *   4. Generate follow-up email draft with Claude
 *   5. Save transcript + summary + action items to Supabase
 *   6. Post structured summary to Slack #zoom-summaries
 *   7. Post follow-up draft to Slack #mail-actions
 *   8. If meeting matches a known client, log to their client_record
 *
 * Errors in individual steps are logged but do not crash the pipeline —
 * later steps still run even if an earlier optional step fails.
 */
export async function processMeetingRecording(event: ZoomWebhookEvent): Promise<void> {
  const obj = event.payload.object
  console.log(
    `[zoom/pipeline] Starting pipeline for meeting: "${obj.topic}" (id=${obj.id}, uuid=${obj.uuid})`,
  )

  // --- Step 1: Fetch access token ---
  let accessToken: string
  try {
    accessToken = await getZoomAccessToken()
    console.log('[zoom/pipeline] Step 1/8: Access token acquired')
  } catch (err) {
    console.error('[zoom/pipeline] FATAL: Cannot get Zoom access token:', err)
    return // Cannot proceed without a token
  }

  // --- Step 2: Fetch and parse transcript ---
  let rawTranscript = ''
  let segments: TranscriptSegment[] = []

  try {
    if (!obj.recording_files || obj.recording_files.length === 0) {
      console.warn('[zoom/pipeline] No recording files in event payload — skipping pipeline')
      return
    }

    segments = await fetchTranscript(obj.recording_files, accessToken)

    if (segments.length === 0) {
      console.warn('[zoom/pipeline] Transcript is empty — skipping summarization')
      return
    }

    rawTranscript = segments.map((s) => `${s.speaker}: ${s.text}`).join('\n')
    console.log(`[zoom/pipeline] Step 2/8: Fetched ${segments.length} transcript segments`)
  } catch (err) {
    console.error('[zoom/pipeline] Step 2 failed (transcript fetch):', err)
    return // Cannot proceed without a transcript
  }

  // --- Step 3: Summarize with Claude ---
  let summary: MeetingSummary
  try {
    const meetingDate = new Date(obj.start_time)
    summary = await summarizeMeeting(
      segments,
      obj.topic,
      obj.duration,
      obj.id,
      obj.uuid,
      meetingDate,
    )
    console.log('[zoom/pipeline] Step 3/8: Meeting summarized by Claude')
  } catch (err) {
    console.error('[zoom/pipeline] Step 3 failed (summarization):', err)
    return // Summary is required for all downstream steps
  }

  // --- Step 4: Generate follow-up email draft ---
  // Extract attendee emails from summary attendees if they look like email addresses
  const attendeeEmails = summary.attendees.filter((a) => a.includes('@'))

  let followUpDraft
  try {
    followUpDraft = await generateFollowUpEmail(summary, attendeeEmails)
    console.log(`[zoom/pipeline] Step 4/8: Follow-up email drafted (from: ${followUpDraft.accountToSendFrom})`)
  } catch (err) {
    console.error('[zoom/pipeline] Step 4 failed (follow-up generation):', err)
    // Non-fatal: continue without follow-up
    followUpDraft = null
  }

  // --- Step 5: Save to Supabase ---
  let meetingDbId: string | null = null
  try {
    meetingDbId = await saveMeetingToSupabase(event, summary, rawTranscript)
    console.log(`[zoom/pipeline] Step 5/8: Saved to Supabase (meeting db id: ${meetingDbId})`)
  } catch (err) {
    console.error('[zoom/pipeline] Step 5 failed (Supabase save):', err)
    // Non-fatal: continue with Slack posting
  }

  // --- Step 6: Post summary to Slack #zoom-summaries ---
  try {
    await postMeetingSummary(summary)
    console.log('[zoom/pipeline] Step 6/8: Posted summary to Slack #zoom-summaries')
  } catch (err) {
    console.error('[zoom/pipeline] Step 6 failed (Slack summary post):', err)
  }

  // --- Step 7: Post follow-up draft to Slack #mail-actions ---
  if (followUpDraft) {
    try {
      await postFollowUpQueued(followUpDraft, summary.title)
      console.log('[zoom/pipeline] Step 7/8: Posted follow-up draft to Slack #mail-actions')
    } catch (err) {
      console.error('[zoom/pipeline] Step 7 failed (Slack follow-up post):', err)
    }
  } else {
    console.log('[zoom/pipeline] Step 7/8: Skipped (no follow-up draft)')
  }

  // --- Step 8: Log to client record if known client attended ---
  try {
    const client = await findClientByAttendeeDomains(attendeeEmails)
    if (client) {
      console.log(`[zoom/pipeline] Step 8/8: Matched client "${client.name}" — logging meeting`)
      await logMeetingToClientRecord(client.id, summary)
    } else {
      console.log('[zoom/pipeline] Step 8/8: No known client attendees — skipping client log')
    }
  } catch (err) {
    console.error('[zoom/pipeline] Step 8 failed (client record log):', err)
  }

  console.log(`[zoom/pipeline] Pipeline complete for "${obj.topic}"`)
}
