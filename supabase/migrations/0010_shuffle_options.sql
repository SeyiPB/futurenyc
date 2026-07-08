-- =============================================================================
-- Migration 0010: randomize answer-option order
-- =============================================================================
-- Questions were authored with the correct answer first, so students learned
-- to always pick option A. Shuffle each question's option positions randomly.
--
-- Two passes with a LARGE +1000000 offset so the target range is always
-- disjoint from any current position value (even a partially-shuffled state
-- where some rows are already in the low thousands). A disjoint target range
-- guarantees the unique(question_id, position) constraint is never violated,
-- even transiently, regardless of the row-update order.
-- Safe to re-run; also repairs any half-shuffled state.
-- =============================================================================

-- Pass 1: assign a fresh random order, parked far above any existing value.
update public.quiz_options o
set position = 1000000 + s.new_pos
from (
  select id,
         row_number() over (partition by question_id order by random()) as new_pos
  from public.quiz_options
) s
where o.id = s.id;

-- Pass 2: bring them back down to 1..n in their new shuffled order.
update public.quiz_options
set position = position - 1000000
where position > 1000000;
