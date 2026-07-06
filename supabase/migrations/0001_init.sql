-- =============================================================================
-- FutureNYC AI Summer Camp — Attendance & Points Tracker
-- Migration 0001: schema + RLS + seed data
-- =============================================================================
-- Design decisions (locked):
--   * status/category constraints use CHECK, not native enums (easier to evolve)
--   * point_categories carries behavior flags (manual entry, min/max, day gating)
--     so the frontend never hardcodes category names or day numbers
--   * RLS: public READ on all tables (leaderboard needs names + points with no
--     auth); WRITE restricted to authenticated users only
--   * point_awards has NO unique constraint (multiple awards/student/day/category
--     are valid; duplicate warning is a UI read-before-write concern)
--   * attendance HAS a unique constraint (one status per student per day)
-- =============================================================================

create extension if not exists "pgcrypto";

-- -----------------------------------------------------------------------------
-- Tables
-- -----------------------------------------------------------------------------

create table if not exists public.students (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  nickname    text,
  cohort_year int  not null default 2026,
  created_at  timestamptz not null default now()
);

create table if not exists public.program_days (
  id          uuid primary key default gen_random_uuid(),
  day_number  int  not null unique check (day_number between 1 and 20),
  date        date not null unique,
  week_number int  not null check (week_number between 1 and 4),
  title       text not null,
  theme       text,
  created_at  timestamptz not null default now()
);

create table if not exists public.attendance (
  id           uuid primary key default gen_random_uuid(),
  student_id   uuid not null references public.students(id) on delete cascade,
  day_id       uuid not null references public.program_days(id) on delete cascade,
  status       text not null default 'present'
                 check (status in ('present','absent','late','excused')),
  arrival_time time,
  notes        text,
  recorded_by  text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique (student_id, day_id)
);

create table if not exists public.point_categories (
  id                     uuid primary key default gen_random_uuid(),
  name                   text not null,
  points                 int  not null default 0,   -- default fill; overridable
  description            text,
  icon                   text,
  is_active              bool not null default true,
  -- behavior flags (drive the UI generically)
  requires_manual_points bool not null default false, -- Demo Day, Bonus, deduction
  requires_note          bool not null default false, -- deductions, bonus
  min_points             int,                          -- e.g. Demo Day = 0
  max_points             int,                          -- e.g. Demo Day = 30
  min_day_number         int,                          -- e.g. stand-up = 17
  max_day_number         int,                          -- e.g. stand-up = 20
  sort_order             int  not null default 100,
  created_at             timestamptz not null default now()
);

create table if not exists public.point_awards (
  id             uuid primary key default gen_random_uuid(),
  student_id     uuid not null references public.students(id) on delete cascade,
  day_id         uuid not null references public.program_days(id) on delete cascade,
  category_id    uuid not null references public.point_categories(id) on delete restrict,
  points_awarded int  not null,        -- allows override + negatives (deductions)
  note           text,
  awarded_by     text,
  created_at     timestamptz not null default now()
);

create table if not exists public.leaderboard_snapshots (
  id          uuid primary key default gen_random_uuid(),
  snapshot_at timestamptz not null default now(),
  rankings    jsonb not null default '[]'::jsonb
);

-- -----------------------------------------------------------------------------
-- Indexes (hot read paths: per-student history, per-day rollups, leaderboard)
-- -----------------------------------------------------------------------------

create index if not exists idx_awards_student on public.point_awards(student_id);
create index if not exists idx_awards_day     on public.point_awards(day_id);
create index if not exists idx_awards_category on public.point_awards(category_id);
create index if not exists idx_attendance_day on public.attendance(day_id);
create index if not exists idx_attendance_student on public.attendance(student_id);

-- -----------------------------------------------------------------------------
-- updated_at trigger for attendance
-- -----------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_attendance_updated_at on public.attendance;
create trigger trg_attendance_updated_at
  before update on public.attendance
  for each row execute function public.set_updated_at();

-- -----------------------------------------------------------------------------
-- Leaderboard view (server- and public-readable aggregate)
-- -----------------------------------------------------------------------------

create or replace view public.student_totals as
select
  s.id            as student_id,
  s.name,
  s.nickname,
  coalesce(sum(pa.points_awarded), 0) as total_points
from public.students s
left join public.point_awards pa on pa.student_id = s.id
group by s.id, s.name, s.nickname;

-- =============================================================================
-- Row Level Security
-- =============================================================================
-- Model: public READ everywhere (leaderboard is unauthenticated), and
-- WRITE only for authenticated sessions. The service-role key bypasses RLS
-- entirely and must NEVER be exposed to the browser (server-only env var).
-- =============================================================================

alter table public.students             enable row level security;
alter table public.program_days         enable row level security;
alter table public.attendance           enable row level security;
alter table public.point_categories     enable row level security;
alter table public.point_awards         enable row level security;
alter table public.leaderboard_snapshots enable row level security;

-- Public read on the leaderboard-relevant tables
create policy "public read students"        on public.students         for select using (true);
create policy "public read program_days"    on public.program_days     for select using (true);
create policy "public read point_categories" on public.point_categories for select using (true);
create policy "public read point_awards"    on public.point_awards     for select using (true);
-- Attendance contains notes; keep reads authenticated-only (not on leaderboard)
create policy "auth read attendance"        on public.attendance       for select using (auth.role() = 'authenticated');
create policy "auth read snapshots"         on public.leaderboard_snapshots for select using (auth.role() = 'authenticated');

-- Authenticated write (insert/update/delete) on everything
create policy "auth write students"     on public.students         for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth write program_days" on public.program_days     for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth write attendance"   on public.attendance       for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth write categories"   on public.point_categories for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth write awards"       on public.point_awards     for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth write snapshots"    on public.leaderboard_snapshots for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- =============================================================================
-- Seed data
-- =============================================================================

-- Program days: July 6–31 2026, weekdays only (exactly 20 days)
insert into public.program_days (day_number, date, week_number, title, theme) values
  (1,  '2026-07-06', 1, 'Orientation & What Is AI?',              'Week 1: AI Fluency & Foundations'),
  (2,  '2026-07-07', 1, 'Introduction to Prompting',              'Week 1: AI Fluency & Foundations'),
  (3,  '2026-07-08', 1, 'AI Ethics, Bias & Responsible Use',      'Week 1: AI Fluency & Foundations'),
  (4,  '2026-07-09', 1, 'Research with AI',                       'Week 1: AI Fluency & Foundations'),
  (5,  '2026-07-10', 1, 'Mini-Project: AI as My Learning Assistant', 'Week 1: AI Fluency & Foundations'),
  (6,  '2026-07-13', 2, 'Introduction to Storytelling with AI',   'Week 2: Creative AI & Media'),
  (7,  '2026-07-14', 2, 'Introduction to AI Image Generation',    'Week 2: Creative AI & Media'),
  (8,  '2026-07-15', 2, 'Introduction to AI Audio & Video Tools', 'Week 2: Creative AI & Media'),
  (9,  '2026-07-16', 2, 'Editing, Remixing & Publishing',         'Week 2: Creative AI & Media'),
  (10, '2026-07-17', 2, 'Mini-Project: AI-Powered Media Piece',   'Week 2: Creative AI & Media'),
  (11, '2026-07-20', 3, 'What Are Automations & AI Agents?',      'Week 3: Automation & Agents'),
  (12, '2026-07-21', 3, 'Building Your First Zap',                'Week 3: Automation & Agents'),
  (13, '2026-07-22', 3, 'Connecting AI to Zapier',               'Week 3: Automation & Agents'),
  (14, '2026-07-23', 3, 'Forms, Data & Structured Outputs',       'Week 3: Automation & Agents'),
  (15, '2026-07-24', 3, 'Mini-Project: AI Workflow',             'Week 3: Automation & Agents'),
  (16, '2026-07-27', 4, 'Capstone Ideation & Project Selection',  'Week 4: Capstone & Demo Day'),
  (17, '2026-07-28', 4, 'Project Planning & MVP Design',          'Week 4: Capstone & Demo Day'),
  (18, '2026-07-29', 4, 'Build Sprint 1: Integration',            'Week 4: Capstone & Demo Day'),
  (19, '2026-07-30', 4, 'Build Sprint 2: Testing & Rehearsal',    'Week 4: Capstone & Demo Day'),
  (20, '2026-07-31', 4, 'Demo Day',                               'Week 4: Capstone & Demo Day')
on conflict (day_number) do nothing;

-- Point categories
insert into public.point_categories
  (name, points, description, icon, requires_manual_points, requires_note, min_points, max_points, min_day_number, max_day_number, sort_order)
values
  ('Completed daily activity',                  5,  'Finished the assigned daily activity.',                 '✅', false, false, null, null, null, null, 10),
  ('Standout observation in discussion',        3,  'Made a notable point during class discussion.',         '💡', false, false, null, null, null, null, 20),
  ('Presented a mini-project',                  10, 'Presented work to the class.',                          '🎤', false, false, null, null, null, null, 30),
  ('Helped a classmate (facilitator-verified)', 5,  'Verified peer support.',                                '🤝', false, false, null, null, null, null, 40),
  ('Found & verified an AI factual error',      10, 'Caught and verified an AI mistake.',                    '🔍', false, false, null, null, null, null, 50),
  ('Won a prompt challenge (class vote)',       15, 'Won the prompt challenge by class vote.',               '🏆', false, false, null, null, null, null, 60),
  ('Morning stand-up participation',            2,  'Participated in the morning stand-up (Days 17–20).',    '🌅', false, false, null, null, 17,   20,   70),
  ('Demo Day capstone presentation',            0,  'Capstone score, 0–30 (see rubric).',                    '🚀', true,  false, 0,    30,   20,   20,   80),
  ('Bonus (custom, facilitator discretion)',    0,  'Discretionary bonus points.',                           '⭐', true,  true,  null, null, null, null, 90),
  ('Code of Conduct deduction',                 0,  'Negative adjustment; note required.',                   '⚠️', true,  true,  null, 0,    null, null, 100)
on conflict do nothing;

-- 25 placeholder students (editable in-app)
insert into public.students (name) values
  ('Student 01'), ('Student 02'), ('Student 03'), ('Student 04'), ('Student 05'),
  ('Student 06'), ('Student 07'), ('Student 08'), ('Student 09'), ('Student 10'),
  ('Student 11'), ('Student 12'), ('Student 13'), ('Student 14'), ('Student 15'),
  ('Student 16'), ('Student 17'), ('Student 18'), ('Student 19'), ('Student 20'),
  ('Student 21'), ('Student 22'), ('Student 23'), ('Student 24'), ('Student 25')
on conflict do nothing;
