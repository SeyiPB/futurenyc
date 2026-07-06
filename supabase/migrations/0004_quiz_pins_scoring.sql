-- =============================================================================
-- Migration 0004: student PINs + once-only quiz scoring + streaks
-- =============================================================================
-- Live-host quizzes where students join with a personal 4-digit PIN. Points
-- count once per quiz (first completed attempt); replays are practice. A daily
-- streak bonus rewards participating on consecutive program days.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Student PINs (permanent identity for joining live quizzes)
-- -----------------------------------------------------------------------------

alter table public.students add column if not exists pin text;

-- Backfill unique, non-sequential 4-digit PINs for existing students.
do $$
declare
  r record;
  new_pin text;
begin
  for r in select id from public.students where pin is null loop
    loop
      new_pin := lpad((floor(random() * 9000) + 1000)::int::text, 4, '0');
      exit when not exists (select 1 from public.students where pin = new_pin);
    end loop;
    update public.students set pin = new_pin where id = r.id;
  end loop;
end $$;

alter table public.students
  add constraint students_pin_unique unique (pin);
alter table public.students
  add constraint students_pin_format check (pin is null or pin ~ '^[0-9]{4}$');

-- -----------------------------------------------------------------------------
-- 2. Quiz results: one row per (quiz, student) — drives once-only scoring,
--    best-score practice tracking, and streak computation.
-- -----------------------------------------------------------------------------

create table if not exists public.quiz_results (
  id              uuid primary key default gen_random_uuid(),
  quiz_id         uuid not null references public.quizzes(id) on delete cascade,
  student_id      uuid not null references public.students(id) on delete cascade,
  day_id          uuid references public.program_days(id) on delete set null,
  attempts        int  not null default 0,
  first_correct   int,              -- correct count on the scoring (first) attempt
  best_correct    int  not null default 0,
  total_questions int  not null default 0,
  points_awarded  int  not null default 0, -- leaderboard points already granted (once)
  streak_at_award int  not null default 0, -- streak length when points were awarded
  first_at        timestamptz,
  last_attempt_at timestamptz,
  unique (quiz_id, student_id)
);

create index if not exists idx_quiz_results_student on public.quiz_results(student_id);
create index if not exists idx_quiz_results_day on public.quiz_results(day_id);

alter table public.quiz_results enable row level security;
create policy "auth all quiz_results" on public.quiz_results for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- -----------------------------------------------------------------------------
-- 3. Quiz config: per-quiz streak bonus (points added when a student's
--    participation streak is active). Default 2 bonus points per streak day.
-- -----------------------------------------------------------------------------

alter table public.quizzes
  add column if not exists streak_bonus_per_day int not null default 2;

-- Live session needs a per-question "revealed" flag (show correct answer + tally).
alter table public.quiz_sessions
  add column if not exists current_revealed bool not null default false;

-- -----------------------------------------------------------------------------
-- 4. One quiz shell per program day (so every day has a live quiz to host).
--    Questions get authored/seeded later from the curriculum. The Day 2 sample
--    quiz from migration 0002 already exists; create shells for the rest.
-- -----------------------------------------------------------------------------

insert into public.quizzes (day_id, title, description, points_per_correct, speed_bonus, created_by)
select d.id,
       'Day ' || d.day_number || ' Review',
       'Daily review quiz for: ' || d.title,
       5, true, 'seed'
from public.program_days d
where not exists (
  select 1 from public.quizzes q where q.day_id = d.id
);
