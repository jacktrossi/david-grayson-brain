export type Account = {
  id: string
  email: string
  label: string
  purpose: string
  priority: number
}

export type Calendar = {
  id: string
  account_id: string
  name: string
  google_calendar_id: string
  purpose: string
}

export type Contact = {
  id: string
  name: string
  firm: string | null
  email: string | null
  priority: 'high' | 'medium' | 'low'
}

export type EmailClassification =
  | 'meeting'
  | 'deadline'
  | 'urgent'
  | 'routine'

export type ClassifiedEmail = {
  threadId: string
  subject: string
  fromAddress: string
  receivedAt: Date
  body: string
  classification: EmailClassification
  extractedTitle?: string
  extractedDateTime?: Date
  isHighPriority: boolean
}

export type DetectedMeeting = {
  title: string
  startTime: Date
  endTime: Date
  zoomLink: string | null
  attendees: { name: string; email: string }[]
  sourceThreadId: string
}
