/**
 * GraysonOS Shared Types
 * TypeScript types mirroring all Supabase database tables.
 * Keep in sync with supabase/migrations/001_initial_schema.sql
 */

// ============================================================
// Enums / Union types
// ============================================================

export type Priority = 'HIGH' | 'MEDIUM' | 'LOW';

export type MeetingStatus = 'scheduled' | 'completed' | 'cancelled' | 'rescheduled';

export type ActionItemStatus = 'open' | 'in_progress' | 'completed' | 'dismissed';

export type ActionItemSourceType = 'email' | 'meeting' | 'manual' | 'zoom' | 'calendar';

export type TripStatus = 'planned' | 'booked' | 'in_progress' | 'completed' | 'cancelled';

export type RiskProfile = 'conservative' | 'moderate' | 'aggressive' | 'ultra-aggressive';

// ============================================================
// accounts
// ============================================================

export interface Account {
  id: string;
  email: string;
  label: string;
  purpose: string;
  priority: number;
  signature_text: string | null;
  created_at: string;
}

export interface AccountInsert extends Omit<Account, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// calendars
// ============================================================

export interface Calendar {
  id: string;
  name: string;
  google_calendar_id: string;
  account_id: string;
  purpose: string;
  color: string | null;
  created_at: string;
}

export interface CalendarInsert extends Omit<Calendar, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// contacts
// ============================================================

export interface Contact {
  id: string;
  name: string;
  firm: string | null;
  email: string | null;
  phone: string | null;
  relationship_notes: string | null;
  priority: Priority;
  created_at: string;
  updated_at: string;
}

export interface ContactInsert extends Omit<Contact, 'id' | 'created_at' | 'updated_at'> {
  id?: string;
  created_at?: string;
  updated_at?: string;
}

// ============================================================
// meetings
// ============================================================

export interface Meeting {
  id: string;
  title: string;
  start_time: string;
  end_time: string;
  calendar_id: string | null;
  zoom_link: string | null;
  attendees: MeetingAttendee[];
  status: MeetingStatus;
  source_email_id: string | null;
  prep_brief: string | null;
  created_at: string;
}

export interface MeetingAttendee {
  name: string;
  email: string;
  role?: string;
}

export interface MeetingInsert extends Omit<Meeting, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// action_items
// ============================================================

export interface ActionItem {
  id: string;
  description: string;
  due_date: string | null;
  owner: string;
  source_type: ActionItemSourceType | null;
  source_id: string | null;
  status: ActionItemStatus;
  client_id: string | null;
  created_at: string;
  completed_at: string | null;
}

export interface ActionItemInsert extends Omit<ActionItem, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// email_threads
// ============================================================

export interface EmailThread {
  id: string;
  account_id: string;
  gmail_thread_id: string;
  subject: string;
  participants: EmailParticipant[];
  last_message_at: string;
  priority: Priority;
  labels: string[];
  summary: string | null;
  created_at: string;
}

export interface EmailParticipant {
  name: string | null;
  email: string;
}

export interface EmailThreadInsert extends Omit<EmailThread, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// domains
// ============================================================

export interface Domain {
  id: string;
  domain_name: string;
  registrar: string;
  expiry_date: string;
  auto_renew: boolean;
  dns_records: DnsRecord[];
  purpose: string | null;
  estimated_value: number | null;
  created_at: string;
  updated_at: string;
}

export interface DnsRecord {
  type: string;
  name: string;
  value: string;
  ttl?: number;
}

export interface DomainInsert extends Omit<Domain, 'id' | 'created_at' | 'updated_at'> {
  id?: string;
  created_at?: string;
  updated_at?: string;
}

// ============================================================
// trips
// ============================================================

export interface Trip {
  id: string;
  destination: string;
  departure_date: string;
  return_date: string;
  status: TripStatus;
  legs: TripLeg[];
  hotels: TripHotel[];
  total_expenses: number;
  calendar_event_id: string | null;
  created_at: string;
}

export interface TripLeg {
  flight_number: string;
  airline: string;
  departure_airport: string;
  arrival_airport: string;
  departure_time: string;
  arrival_time: string;
  confirmation_code: string | null;
  seat: string | null;
}

export interface TripHotel {
  name: string;
  check_in: string;
  check_out: string;
  confirmation_code: string | null;
  address: string | null;
  loyalty_number: string | null;
}

export interface TripInsert extends Omit<Trip, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// expenses
// ============================================================

export interface Expense {
  id: string;
  amount: number;
  currency: string;
  category: string;
  description: string | null;
  trip_id: string | null;
  client_id: string | null;
  receipt_url: string | null;
  tax_deductible: boolean;
  date: string;
  created_at: string;
}

export interface ExpenseInsert extends Omit<Expense, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// client_records
// ============================================================

export interface ClientRecord {
  id: string;
  name: string;
  firm: string | null;
  contact_info: ClientContactInfo;
  portfolio_notes: string | null;
  risk_profile: RiskProfile | null;
  allocation_model: AllocationModel;
  open_items: OpenItem[];
  created_at: string;
  updated_at: string;
}

export interface ClientContactInfo {
  email?: string;
  phone?: string;
  address?: string;
  preferred_contact?: 'email' | 'phone' | 'in-person';
}

export interface AllocationModel {
  equities?: number;
  fixed_income?: number;
  alternatives?: number;
  cash?: number;
  [key: string]: number | undefined;
}

export interface OpenItem {
  description: string;
  due_date: string | null;
  status: ActionItemStatus;
}

export interface ClientRecordInsert extends Omit<ClientRecord, 'id' | 'created_at' | 'updated_at'> {
  id?: string;
  created_at?: string;
  updated_at?: string;
}

// ============================================================
// meeting_transcripts
// ============================================================

export interface MeetingTranscript {
  id: string;
  meeting_id: string;
  zoom_recording_id: string | null;
  raw_transcript: string | null;
  summary: string | null;
  key_decisions: KeyDecision[];
  action_items: TranscriptActionItem[];
  follow_up_drafted: boolean;
  embedding: number[] | null;
  created_at: string;
}

export interface KeyDecision {
  decision: string;
  made_by: string | null;
  timestamp: string | null;
}

export interface TranscriptActionItem {
  description: string;
  owner: string | null;
  due_date: string | null;
}

export interface MeetingTranscriptInsert extends Omit<MeetingTranscript, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}

// ============================================================
// notifications_log
// ============================================================

export interface NotificationLog {
  id: string;
  channel: string;
  message: string;
  slack_message_ts: string | null;
  action_taken: string | null;
  created_at: string;
}

export interface NotificationLogInsert extends Omit<NotificationLog, 'id' | 'created_at'> {
  id?: string;
  created_at?: string;
}
