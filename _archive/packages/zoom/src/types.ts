export type ZoomWebhookEvent = {
  event: string
  payload: {
    object: {
      id: string
      uuid: string
      host_id: string
      topic: string
      start_time: string
      duration: number
      recording_files: ZoomRecordingFile[]
    }
  }
}

export type ZoomRecordingFile = {
  id: string
  meeting_id: string
  recording_type: 'MP4' | 'M4A' | 'TIMELINE' | 'TRANSCRIPT' | 'CHAT' | 'CC' | 'CSV'
  download_url: string
  file_size: number
  status: string
}

export type TranscriptSegment = {
  speaker: string
  text: string
  start_time: number
  end_time: number
}

export type MeetingSummary = {
  meetingId: string
  zoomUuid: string
  title: string
  date: Date
  durationMinutes: number
  attendees: string[]
  keyDecisions: string[]
  openQuestions: string[]
  actionItems: ActionItem[]
  nextMeetingProposed?: string
  fullSummaryText: string
}

export type ActionItem = {
  description: string
  owner: string
  dueDate?: string
  sourceQuote: string
}

export type FollowUpDraft = {
  to: string[]
  subject: string
  body: string
  accountToSendFrom: string
}
