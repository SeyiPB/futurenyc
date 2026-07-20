-- =============================================================================
-- Migration 0011: make the leaderboard facilitator-only
-- =============================================================================
-- The leaderboard used to be public, so migration 0001 granted anonymous
-- (public) SELECT on the tables it reads. It is now behind the facilitator
-- login, so drop those public-read policies.
--
-- Authenticated access is unaffected: the existing "auth write ..." policies
-- are FOR ALL (using auth.role() = 'authenticated'), which already covers
-- SELECT for the logged-in facilitator. The public /play student flow is also
-- unaffected — it reads/writes exclusively through the service-role key, which
-- bypasses RLS.
-- =============================================================================

drop policy if exists "public read students"         on public.students;
drop policy if exists "public read program_days"     on public.program_days;
drop policy if exists "public read point_categories" on public.point_categories;
drop policy if exists "public read point_awards"     on public.point_awards;
