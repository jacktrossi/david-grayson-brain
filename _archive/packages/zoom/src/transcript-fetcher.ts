import fetch from 'node-fetch'
import type { ZoomRecordingFile, TranscriptSegment } from './types.js'

// ---------------------------------------------------------------------------
// OAuth token
// ---------------------------------------------------------------------------

/**
 * Fetches a Zoom Server-to-Server OAuth access token using client credentials.
 * Requires: ZOOM_CLIENT_ID, ZOOM_CLIENT_SECRET, ZOOM_ACCOUNT_ID
 */
export async function getZoomAccessToken(): Promise<string> {
  const clientId = process.env.ZOOM_CLIENT_ID
  const clientSecret = process.env.ZOOM_CLIENT_SECRET
  const accountId = process.env.ZOOM_ACCOUNT_ID

  if (!clientId || !clientSecret || !accountId) {
    throw new Error(
      'Missing required env vars: ZOOM_CLIENT_ID, ZOOM_CLIENT_SECRET, ZOOM_ACCOUNT_ID',
    )
  }

  const credentials = Buffer.from(`${clientId}:${clientSecret}`).toString('base64')

  const response = await fetch(
    `https://zoom.us/oauth/token?grant_type=account_credentials&account_id=${accountId}`,
    {
      method: 'POST',
      headers: {
        Authorization: `Basic ${credentials}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    },
  )

  if (!response.ok) {
    const body = await response.text()
    throw new Error(`Zoom OAuth token request failed (${response.status}): ${body}`)
  }

  const data = (await response.json()) as { access_token: string }
  return data.access_token
}

// ---------------------------------------------------------------------------
// VTT parser
// ---------------------------------------------------------------------------

/**
 * Parses a WebVTT transcript file into structured TranscriptSegment objects.
 *
 * VTT cue format:
 *   00:00:01.000 --> 00:00:05.000
 *   Speaker Name: dialogue text here
 */
function parseVttTranscript(vttContent: string): TranscriptSegment[] {
  const segments: TranscriptSegment[] = []
  const lines = vttContent.split('\n')

  let i = 0
  // Skip WEBVTT header
  while (i < lines.length) {
    const l = lines[i]
    if (l !== undefined && l.startsWith('WEBVTT')) break
    i++
  }
  i++ // skip the WEBVTT line itself

  while (i < lines.length) {
    const line = (lines[i] ?? '').trim()

    // Skip blank lines and cue identifiers (pure numbers or strings without -->)
    if (!line || /^\d+$/.test(line)) {
      i++
      continue
    }

    // Timestamp line: "00:00:01.000 --> 00:00:05.000"
    const timestampMatch = line.match(
      /^(\d{2}:\d{2}:\d{2}[.,]\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2}[.,]\d{3})/,
    )

    if (timestampMatch) {
      const ts1 = timestampMatch[1] ?? ''
      const ts2 = timestampMatch[2] ?? ''
      const startTime = parseVttTimestamp(ts1)
      const endTime = parseVttTimestamp(ts2)

      // Collect cue text (may span multiple lines)
      const textLines: string[] = []
      i++
      while (i < lines.length && (lines[i] ?? '').trim() !== '') {
        textLines.push((lines[i] ?? '').trim())
        i++
      }

      const fullText = textLines.join(' ')
      if (!fullText) continue

      // Extract speaker: "Speaker Name: dialogue"
      const speakerMatch = fullText.match(/^([^:]+):\s*(.+)$/)
      const speaker = speakerMatch ? (speakerMatch[1] ?? 'Unknown').trim() : 'Unknown'
      const text = speakerMatch ? (speakerMatch[2] ?? fullText).trim() : fullText

      if (text) {
        segments.push({ speaker, text, start_time: startTime, end_time: endTime })
      }
    } else {
      i++
    }
  }

  return segments
}

/** Converts VTT timestamp "HH:MM:SS.mmm" to seconds */
function parseVttTimestamp(ts: string): number {
  const normalised = ts.replace(',', '.')
  const parts = normalised.split(':')
  if (parts.length === 3) {
    return (
      parseInt(parts[0] ?? '0', 10) * 3600 +
      parseInt(parts[1] ?? '0', 10) * 60 +
      parseFloat(parts[2] ?? '0')
    )
  }
  if (parts.length === 2) {
    return parseInt(parts[0] ?? '0', 10) * 60 + parseFloat(parts[1] ?? '0')
  }
  return parseFloat(normalised)
}

// ---------------------------------------------------------------------------
// Whisper fallback
// ---------------------------------------------------------------------------

/**
 * Downloads an M4A audio file and transcribes it using OpenAI Whisper.
 * Used when Zoom has not generated a VTT transcript file.
 */
async function transcribeWithWhisper(
  m4aFile: ZoomRecordingFile,
  accessToken: string,
): Promise<TranscriptSegment[]> {
  console.log('[zoom/transcript] Falling back to Whisper transcription for M4A')

  const openaiApiKey = process.env.OPENAI_API_KEY
  if (!openaiApiKey) {
    throw new Error(
      'No VTT transcript available and OPENAI_API_KEY is not set — cannot transcribe audio',
    )
  }

  // Download the M4A file
  const audioResponse = await fetch(`${m4aFile.download_url}?access_token=${accessToken}`)
  if (!audioResponse.ok) {
    throw new Error(
      `Failed to download M4A file (${audioResponse.status}): ${await audioResponse.text()}`,
    )
  }
  const audioBuffer = await audioResponse.buffer()

  // Call OpenAI Whisper using node-fetch FormData
  const nodeFetchModule = await import('node-fetch')
  const FormDataNode = (await import('formdata-node')).FormData
  const { Blob } = await import('buffer')

  const formData = new FormDataNode()
  formData.set('file', new Blob([audioBuffer], { type: 'audio/m4a' }), 'audio.m4a')
  formData.set('model', 'whisper-1')
  formData.set('response_format', 'verbose_json')
  formData.set('timestamp_granularities[]', 'segment')

  const whisperFetch = nodeFetchModule.default
  const whisperResponse = await whisperFetch('https://api.openai.com/v1/audio/transcriptions', {
    method: 'POST',
    headers: { Authorization: `Bearer ${openaiApiKey}` },
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    body: formData as any,
  })

  if (!whisperResponse.ok) {
    throw new Error(
      `Whisper API error (${whisperResponse.status}): ${await whisperResponse.text()}`,
    )
  }

  const result = (await whisperResponse.json()) as {
    segments?: Array<{
      text: string
      start: number
      end: number
    }>
    text?: string
  }

  if (result.segments && result.segments.length > 0) {
    return result.segments.map((seg) => ({
      speaker: 'Unknown', // Whisper doesn't do diarization natively
      text: seg.text.trim(),
      start_time: seg.start,
      end_time: seg.end,
    }))
  }

  // Fallback: return as single segment if no granular segments
  return [
    {
      speaker: 'Unknown',
      text: result.text ?? '',
      start_time: 0,
      end_time: 0,
    },
  ]
}

// ---------------------------------------------------------------------------
// Main export
// ---------------------------------------------------------------------------

/**
 * Downloads and parses the transcript for a completed Zoom recording.
 *
 * Strategy:
 *   1. Look for a TRANSCRIPT (VTT) file in recording_files
 *   2. Download and parse VTT → TranscriptSegment[]
 *   3. If no VTT file, fall back to M4A + Whisper API
 */
export async function fetchTranscript(
  recordingFiles: ZoomRecordingFile[],
  accessToken: string,
): Promise<TranscriptSegment[]> {
  // Prefer the native VTT transcript
  const vttFile = recordingFiles.find((f) => f.recording_type === 'TRANSCRIPT')

  if (vttFile) {
    console.log(`[zoom/transcript] Found VTT transcript file (id=${vttFile.id}, size=${vttFile.file_size} bytes)`)

    const downloadUrl = `${vttFile.download_url}?access_token=${accessToken}`
    const response = await fetch(downloadUrl)

    if (!response.ok) {
      throw new Error(
        `Failed to download VTT transcript (${response.status}): ${await response.text()}`,
      )
    }

    const vttContent = await response.text()
    const segments = parseVttTranscript(vttContent)

    console.log(`[zoom/transcript] Parsed ${segments.length} segments from VTT`)
    return segments
  }

  // Fall back to M4A + Whisper
  const m4aFile = recordingFiles.find((f) => f.recording_type === 'M4A')
  if (!m4aFile) {
    throw new Error(
      'No TRANSCRIPT (VTT) or M4A recording file found — cannot produce transcript',
    )
  }

  return transcribeWithWhisper(m4aFile, accessToken)
}
