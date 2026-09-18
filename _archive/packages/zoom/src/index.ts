// Public API for @graysonos/zoom

// Types
export type {
  ZoomWebhookEvent,
  ZoomRecordingFile,
  TranscriptSegment,
  MeetingSummary,
  ActionItem,
  FollowUpDraft,
} from './types.js'

// Webhook handler
export { createWebhookRouter, validateZoomSignature } from './webhook-handler.js'

// Transcript fetching
export { fetchTranscript, getZoomAccessToken } from './transcript-fetcher.js'

// Meeting summarization
export { summarizeMeeting } from './summarizer.js'

// Follow-up email generation
export { generateFollowUpEmail } from './follow-up-generator.js'

// Slack posting
export {
  postMeetingSummary,
  postFollowUpQueued,
  postPreMeetingAlert,
} from './slack-poster.js'

// Full pipeline orchestrator
export { processMeetingRecording } from './pipeline.js'

// Semantic search
export { searchTranscripts } from './search.js'
export type { TranscriptSearchResult } from './search.js'
