import { createClient } from '@supabase/supabase-js'
import type { Account, Calendar, Contact, ClassifiedEmail } from './types.js'

export const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
)

export async function getAccounts(): Promise<Account[]> {
  const { data, error } = await supabase
    .from('accounts')
    .select('*')
    .order('priority')
  if (error) throw error
  return data
}

export async function getCalendars(): Promise<Calendar[]> {
  const { data, error } = await supabase.from('calendars').select('*')
  if (error) throw error
  return data
}

export async function getContacts(): Promise<Contact[]> {
  const { data, error } = await supabase
    .from('contacts')
    .select('*')
    .eq('priority', 'high')
  if (error) throw error
  return data
}

export async function isAlreadyProcessed(
  accountId: string,
  threadId: string,
): Promise<boolean> {
  const { count } = await supabase
    .from('email_threads')
    .select('*', { count: 'exact', head: true })
    .eq('account_id', accountId)
    .eq('gmail_thread_id', threadId)
  return (count ?? 0) > 0
}

export async function saveThread(
  accountId: string,
  email: ClassifiedEmail,
) {
  await supabase.from('email_threads').upsert({
    account_id: accountId,
    gmail_thread_id: email.threadId,
    subject: email.subject,
    from_address: email.fromAddress,
    received_at: email.receivedAt.toISOString(),
    classification: email.classification,
  }, { onConflict: 'account_id,gmail_thread_id' })
}

export async function saveMeeting(
  accountId: string,
  calendarId: string,
  email: ClassifiedEmail,
  googleEventId: string | null,
  threadDbId: string,
) {
  await supabase.from('meetings').insert({
    title: email.extractedTitle ?? email.subject,
    start_time: email.extractedDateTime!.toISOString(),
    end_time: new Date(email.extractedDateTime!.getTime() + 3600000).toISOString(),
    account_id: accountId,
    calendar_id: calendarId,
    google_event_id: googleEventId,
    source_thread_id: threadDbId,
  })
}

export async function getTodayMeetings() {
  const start = new Date()
  start.setHours(0, 0, 0, 0)
  const end = new Date()
  end.setHours(23, 59, 59, 999)

  const { data } = await supabase
    .from('meetings')
    .select('title, start_time, calendars(name)')
    .gte('start_time', start.toISOString())
    .lte('start_time', end.toISOString())
    .order('start_time')

  return (data ?? []).map(m => ({
    title: m.title,
    time: new Date(m.start_time).toLocaleTimeString('en-US', {
      hour: 'numeric', minute: '2-digit',
    }),
    calendar: (m.calendars as { name: string } | null)?.name ?? 'Calendar',
  }))
}

export async function getOpenActionItems() {
  const { data } = await supabase
    .from('action_items')
    .select('description, due_date')
    .eq('status', 'open')
    .order('due_date', { ascending: true, nullsFirst: false })
    .limit(10)

  return (data ?? []).map(i => ({
    description: i.description,
    dueDate: i.due_date,
  }))
}
