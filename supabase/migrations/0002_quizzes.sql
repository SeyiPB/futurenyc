-- =============================================================================
-- Migration 0002: Live (synchronous) quizzes + auto point awards
-- =============================================================================
-- Design decisions (locked):
--   * Students have NO accounts. They join a live session via a short join_code
--     and pick their name from the roster. All student reads/writes go through
--     Next.js Server Actions using the service-role key (code-validated) — the
--     anon key NEVER writes quiz data, and quiz_options.is_correct NEVER leaves
--     the server boundary. Therefore RLS on quiz tables is authenticated-only.
--   * Quiz mode is LIVE: facilitator advances question-by-question; the current
--     question + its start time live on quiz_sessions.
--   * Scoring auto-feeds the leaderboard via a "Quiz performance" point category.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Quiz definitions (authored by facilitator)
-- -----------------------------------------------------------------------------

create table if not exists public.quizzes (
  id                 uuid primary key default gen_random_uuid(),
  day_id             uuid references public.program_days(id) on delete set null,
  title              text not null,
  description        text,
  points_per_correct int  not null default 5,   -- default; question can override
  speed_bonus        bool not null default false, -- faster correct answers score more
  is_active          bool not null default true,
  created_by         text,
  created_at         timestamptz not null default now()
);

create table if not exists public.quiz_questions (
  id                 uuid primary key default gen_random_uuid(),
  quiz_id            uuid not null references public.quizzes(id) on delete cascade,
  position           int  not null default 1,        -- display order
  prompt             text not null,
  question_type      text not null default 'mc'
                       check (question_type in ('mc','tf')),
  time_limit_seconds int  not null default 20,
  points_override    int,                            -- null = use quiz default
  created_at         timestamptz not null default now(),
  unique (quiz_id, position)
);

create table if not exists public.quiz_options (
  id          uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.quiz_questions(id) on delete cascade,
  position    int  not null default 1,
  label       text not null,
  is_correct  bool not null default false,   -- NEVER exposed to student clients
  created_at  timestamptz not null default now(),
  unique (question_id, position)
);

-- -----------------------------------------------------------------------------
-- Live session state
-- -----------------------------------------------------------------------------

create table if not exists public.quiz_sessions (
  id                         uuid primary key default gen_random_uuid(),
  quiz_id                    uuid not null references public.quizzes(id) on delete cascade,
  join_code                  text not null unique,   -- short, e.g. 6 chars
  status                     text not null default 'lobby'
                               check (status in ('lobby','active','ended')),
  current_question_id        uuid references public.quiz_questions(id) on delete set null,
  current_question_started_at timestamptz,
  created_by                 text,
  created_at                 timestamptz not null default now(),
  ended_at                   timestamptz
);

create table if not exists public.quiz_participants (
  id           uuid primary key default gen_random_uuid(),
  session_id   uuid not null references public.quiz_sessions(id) on delete cascade,
  student_id   uuid references public.students(id) on delete set null, -- picked from roster
  display_name text not null,
  total_score  int  not null default 0,
  joined_at    timestamptz not null default now(),
  unique (session_id, student_id)
);

create table if not exists public.quiz_answers (
  id             uuid primary key default gen_random_uuid(),
  session_id     uuid not null references public.quiz_sessions(id) on delete cascade,
  participant_id uuid not null references public.quiz_participants(id) on delete cascade,
  question_id    uuid not null references public.quiz_questions(id) on delete cascade,
  option_id      uuid references public.quiz_options(id) on delete set null,
  is_correct     bool not null default false,
  response_ms    int,                  -- time to answer, for speed bonus
  points_earned  int  not null default 0,
  created_at     timestamptz not null default now(),
  unique (session_id, participant_id, question_id)  -- one answer per question
);

-- -----------------------------------------------------------------------------
-- Indexes
-- -----------------------------------------------------------------------------

create index if not exists idx_quiz_questions_quiz on public.quiz_questions(quiz_id);
create index if not exists idx_quiz_options_question on public.quiz_options(question_id);
create index if not exists idx_quiz_sessions_code on public.quiz_sessions(join_code);
create index if not exists idx_quiz_participants_session on public.quiz_participants(session_id);
create index if not exists idx_quiz_answers_session on public.quiz_answers(session_id);
create index if not exists idx_quiz_answers_participant on public.quiz_answers(participant_id);

-- -----------------------------------------------------------------------------
-- RLS — authenticated-only on ALL quiz tables.
-- Student devices reach these tables exclusively through Server Actions using
-- the service-role key (which bypasses RLS). The anon/public role has no access.
-- -----------------------------------------------------------------------------

alter table public.quizzes            enable row level security;
alter table public.quiz_questions     enable row level security;
alter table public.quiz_options       enable row level security;
alter table public.quiz_sessions      enable row level security;
alter table public.quiz_participants  enable row level security;
alter table public.quiz_answers       enable row level security;

create policy "auth all quizzes"        on public.quizzes           for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth all quiz_questions" on public.quiz_questions    for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth all quiz_options"   on public.quiz_options      for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth all quiz_sessions"  on public.quiz_sessions     for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth all quiz_participants" on public.quiz_participants for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "auth all quiz_answers"   on public.quiz_answers      for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- -----------------------------------------------------------------------------
-- Points integration: a category for quiz auto-awards.
-- When a session ends, a Server Action rolls each participant's quiz score into
-- a single point_awards row under this category (student_id matched from roster).
-- -----------------------------------------------------------------------------

insert into public.point_categories
  (name, points, description, icon, requires_manual_points, requires_note, sort_order)
values
  ('Quiz performance', 0, 'Auto-awarded from live quiz results.', '🧠', false, false, 85)
on conflict do nothing;

-- =============================================================================
-- Seed: one sample quiz tied to Day 2 (Introduction to Prompting), editable
-- =============================================================================

do $$
declare
  v_day  uuid;
  v_quiz uuid;
  v_q    uuid;
begin
  select id into v_day from public.program_days where day_number = 2;

  insert into public.quizzes (day_id, title, description, points_per_correct, speed_bonus, created_by)
  values (v_day, 'Prompting Basics', 'Quick check on Day 2 prompting concepts.', 5, true, 'seed')
  returning id into v_quiz;

  -- Q1 (multiple choice)
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  values (v_quiz, 1, 'What is a "prompt" when working with an AI model?', 'mc', 20)
  returning id into v_q;
  insert into public.quiz_options (question_id, position, label, is_correct) values
    (v_q, 1, 'The instruction or question you give the AI', true),
    (v_q, 2, 'The AI''s hardware', false),
    (v_q, 3, 'A type of error message', false),
    (v_q, 4, 'The internet connection', false);

  -- Q2 (true/false)
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  values (v_quiz, 2, 'Giving the AI more context usually improves its answer.', 'tf', 15)
  returning id into v_q;
  insert into public.quiz_options (question_id, position, label, is_correct) values
    (v_q, 1, 'True',  true),
    (v_q, 2, 'False', false);

  -- Q3 (multiple choice)
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  values (v_quiz, 3, 'Which of these makes a prompt clearer?', 'mc', 20)
  returning id into v_q;
  insert into public.quiz_options (question_id, position, label, is_correct) values
    (v_q, 1, 'Being specific about what you want', true),
    (v_q, 2, 'Using as few words as possible always', false),
    (v_q, 3, 'Never giving examples', false),
    (v_q, 4, 'Typing in all capitals', false);
end $$;
