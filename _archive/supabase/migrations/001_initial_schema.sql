-- GraysonOS nervous system schema
-- Only what's needed: accounts, calendars, contacts, emails, meetings, action items

create extension if not exists "pgcrypto";

-- The 8 Gmail accounts
create table accounts (
  id       uuid primary key default gen_random_uuid(),
  email    text not null unique,
  label    text not null,
  purpose  text not null,
  priority integer not null default 5
);

-- The 8 Google Calendars (one per account)
create table calendars (
  id                 uuid primary key default gen_random_uuid(),
  account_id         uuid references accounts(id),
  name               text not null,
  google_calendar_id text not null unique,
  purpose            text not null
);

-- Known contacts: clients, legal, vendors
create table contacts (
  id       uuid primary key default gen_random_uuid(),
  name     text not null,
  firm     text,
  email    text unique,
  priority text not null default 'medium' check (priority in ('high', 'medium', 'low'))
);

-- Every email processed by the nervous system
create table email_threads (
  id              uuid primary key default gen_random_uuid(),
  account_id      uuid references accounts(id),
  gmail_thread_id text not null,
  subject         text not null,
  from_address    text not null,
  received_at     timestamptz not null,
  classification  text not null default 'routine'
                  check (classification in ('meeting', 'deadline', 'urgent', 'routine')),
  processed_at    timestamptz default now(),
  unique(account_id, gmail_thread_id)
);

-- Meetings detected from email and added to Google Calendar
create table meetings (
  id               uuid primary key default gen_random_uuid(),
  title            text not null,
  start_time       timestamptz not null,
  end_time         timestamptz,
  account_id       uuid references accounts(id),
  calendar_id      uuid references calendars(id),
  google_event_id  text unique,
  source_thread_id uuid references email_threads(id),
  zoom_link        text,
  attendees        jsonb default '[]',
  created_at       timestamptz default now()
);

-- Action items surfaced by the nervous system
create table action_items (
  id          uuid primary key default gen_random_uuid(),
  description text not null,
  due_date    date,
  source_type text not null default 'email'
              check (source_type in ('email', 'meeting', 'system')),
  status      text not null default 'open'
              check (status in ('open', 'done')),
  created_at  timestamptz default now()
);

-- Seed: 8 Gmail accounts in priority order
insert into accounts (email, label, purpose, priority) values
  ('account2@gmail.com', 'client-facing', 'Client correspondence and advisory communications', 1),
  ('account3@gmail.com', 'legal',         'Legal matters, contracts, compliance',              2),
  ('account4@gmail.com', 'investments',   'Investment research, brokerage alerts',             3),
  ('account8@gmail.com', 'finance-pro',   'Tax documents, accounting, Plaid',                  4),
  ('account5@gmail.com', 'admin',         'Vendor management, subscriptions',                  5),
  ('account7@gmail.com', 'domains',       'Domain registrations, GoDaddy, hosting',            6),
  ('account6@gmail.com', 'travel',        'Travel bookings, loyalty programs',                 7),
  ('account1@gmail.com', 'personal',      'Personal communications, family, friends',          8);

-- Indexes
create index on email_threads(account_id);
create index on email_threads(received_at desc);
create index on email_threads(classification);
create index on meetings(start_time);
create index on action_items(status, due_date);
