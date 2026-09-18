/**
 * @graysonos/shared
 * Central export for all GraysonOS shared TypeScript types.
 */

export type {
  // Enums / Union types
  Priority,
  MeetingStatus,
  ActionItemStatus,
  ActionItemSourceType,
  TripStatus,
  RiskProfile,

  // accounts
  Account,
  AccountInsert,

  // calendars
  Calendar,
  CalendarInsert,

  // contacts
  Contact,
  ContactInsert,

  // meetings
  Meeting,
  MeetingAttendee,
  MeetingInsert,

  // action_items
  ActionItem,
  ActionItemInsert,

  // email_threads
  EmailThread,
  EmailParticipant,
  EmailThreadInsert,

  // domains
  Domain,
  DnsRecord,
  DomainInsert,

  // trips
  Trip,
  TripLeg,
  TripHotel,
  TripInsert,

  // expenses
  Expense,
  ExpenseInsert,

  // client_records
  ClientRecord,
  ClientContactInfo,
  AllocationModel,
  OpenItem,
  ClientRecordInsert,

  // meeting_transcripts
  MeetingTranscript,
  KeyDecision,
  TranscriptActionItem,
  MeetingTranscriptInsert,

  // notifications_log
  NotificationLog,
  NotificationLogInsert,
} from './types';
