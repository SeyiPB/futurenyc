-- =============================================================================
-- Migration 0008: quiz completion status
-- =============================================================================
-- Lets the facilitator mark each day's quiz Done / Upcoming so they can track
-- which reviews have been run. Defaults to 'upcoming'.
-- =============================================================================

alter table public.quizzes
  add column if not exists status text not null default 'upcoming'
  check (status in ('upcoming', 'done'));

-- Day 1 review was already played today — mark it done.
update public.quizzes
set status = 'done'
where day_id = (select id from public.program_days where day_number = 1);
