-- =============================================================================
-- Migration 0003: enable Supabase Realtime for the live leaderboard
-- =============================================================================
-- The public /leaderboard subscribes to point_awards inserts/updates/deletes so
-- it updates instantly when the facilitator awards points. Realtime respects
-- RLS; point_awards already has a public read policy (migration 0001), so the
-- anon role can subscribe.
-- =============================================================================

alter publication supabase_realtime add table public.point_awards;
