-- =============================================================================
-- Migration 0007: student gender for demographic data
-- =============================================================================
-- Nullable text column with a CHECK for a defined set of values so reporting
-- stays consistent. Existing students default to null (unspecified).
-- =============================================================================

alter table public.students
  add column if not exists gender text
  check (gender in ('male','female','non-binary','other','prefer_not_to_say'));
