import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";
import { resolveCurrentDay } from "./program";
import type { ProgramDay } from "./types";

// Compute a student's participation streak ending at `dayNumber`:
// the number of consecutive program days (…, dayNumber-1, dayNumber) on which
// the student has a quiz_results row. Used for the streak bonus.
async function computeStreak(
  supabase: SupabaseClient,
  studentId: string,
  dayNumber: number,
  dayNumberById: Map<string, number>,
): Promise<number> {
  const { data: results } = await supabase
    .from("quiz_results")
    .select("day_id")
    .eq("student_id", studentId);

  const playedDays = new Set<number>();
  (results || []).forEach((r: { day_id: string | null }) => {
    if (r.day_id) {
      const n = dayNumberById.get(r.day_id);
      if (n != null) playedDays.add(n);
    }
  });
  playedDays.add(dayNumber); // include the session about to be recorded

  let streak = 0;
  let d = dayNumber;
  while (playedDays.has(d)) {
    streak += 1;
    d -= 1;
  }
  return streak;
}

// On session end: tally each participant's correct answers, award leaderboard
// points ONCE per (quiz, student) for the first scored attempt, and track
// best/attempts for replays. Returns how many students were newly awarded.
export async function awardQuizPointsForSession(
  supabase: SupabaseClient,
  sessionId: string,
  awardedBy: string,
): Promise<{ ok: true; awarded: number } | { ok: false; error: string }> {
  const { data: session } = await supabase
    .from("quiz_sessions")
    .select("id, quiz_id")
    .eq("id", sessionId)
    .single();
  if (!session) return { ok: false, error: "Session not found" };

  const { data: quiz } = await supabase
    .from("quizzes")
    .select("*")
    .eq("id", session.quiz_id)
    .single();
  if (!quiz) return { ok: false, error: "Quiz not found" };

  // Program days (with dates) for streaks + resolving the played day.
  const { data: days } = await supabase
    .from("program_days")
    .select("id, day_number, date, week_number, title, theme");
  const dayNumberById = new Map<string, number>(
    (days || []).map((d: { id: string; day_number: number }) => [d.id, d.day_number]),
  );

  // Award points to the day the quiz is actually PLAYED (today), not the quiz's
  // curriculum day — so hosting the "Day 1 Review" on Day 2 credits Day 2.
  // Falls back to the quiz's own day if today isn't a program day.
  const today = resolveCurrentDay((days || []) as ProgramDay[]);
  const dayId = (today?.id ?? (quiz.day_id as string | null)) as string | null;
  const thisDayNumber = dayId ? dayNumberById.get(dayId) ?? 0 : 0;

  // Quiz performance category for the leaderboard award.
  const { data: cat } = await supabase
    .from("point_categories")
    .select("id")
    .eq("name", "Quiz performance")
    .maybeSingle();

  // Questions for this quiz (count + time limits for the optional speed bonus).
  const { data: questions } = await supabase
    .from("quiz_questions")
    .select("id, time_limit_seconds")
    .eq("quiz_id", session.quiz_id);
  const totalQuestions = (questions || []).length;
  const timeLimitById = new Map<string, number>(
    (questions || []).map((q: { id: string; time_limit_seconds: number }) => [
      q.id,
      q.time_limit_seconds,
    ]),
  );
  const speedBonusOn = quiz.speed_bonus === true;

  // Participants in this session.
  const { data: participants } = await supabase
    .from("quiz_participants")
    .select("id, student_id")
    .eq("session_id", sessionId);

  let awarded = 0;

  for (const p of participants || []) {
    if (!p.student_id) continue;

    // Answers this session (with timing for the speed bonus).
    const { data: answers } = await supabase
      .from("quiz_answers")
      .select("is_correct, response_ms, question_id")
      .eq("session_id", sessionId)
      .eq("participant_id", p.id);
    const correctAnswers = (answers || []).filter(
      (a: { is_correct: boolean }) => a.is_correct,
    );
    const correct = correctAnswers.length;

    // Speed bonus: faster correct answers earn up to +50% of the per-correct
    // value, scaled by how much of the question's time limit remained.
    let speedBonus = 0;
    if (speedBonusOn) {
      const perCorrect = quiz.points_per_correct as number;
      for (const a of correctAnswers as { response_ms: number | null; question_id: string }[]) {
        const limitMs = (timeLimitById.get(a.question_id) ?? 20) * 1000;
        const remaining = Math.max(0, Math.min(1, 1 - (a.response_ms ?? limitMs) / limitMs));
        speedBonus += Math.round(perCorrect * 0.5 * remaining);
      }
    }

    // Update participant running score.
    await supabase.from("quiz_participants").update({ total_score: correct }).eq("id", p.id);

    // Existing result row?
    const { data: existing } = await supabase
      .from("quiz_results")
      .select("*")
      .eq("quiz_id", session.quiz_id)
      .eq("student_id", p.student_id)
      .maybeSingle();

    const now = new Date().toISOString();

    if (existing && existing.points_awarded > 0) {
      // Replay/practice — update best + attempts, do NOT award again.
      await supabase
        .from("quiz_results")
        .update({
          attempts: existing.attempts + 1,
          best_correct: Math.max(existing.best_correct, correct),
          last_attempt_at: now,
        })
        .eq("id", existing.id);
      continue;
    }

    // First scored attempt — compute points + streak bonus, award once.
    const streak = await computeStreak(supabase, p.student_id, thisDayNumber, dayNumberById);
    const basePoints = correct * (quiz.points_per_correct as number);
    const streakBonus = (quiz.streak_bonus_per_day as number) * streak;
    const points = basePoints + streakBonus + speedBonus;

    if (cat && dayId && points > 0) {
      const extras = [
        streak > 1 ? `${streak}-day streak (+${streakBonus})` : "",
        speedBonus > 0 ? `speed (+${speedBonus})` : "",
      ].filter(Boolean);
      await supabase.from("point_awards").insert({
        student_id: p.student_id,
        day_id: dayId,
        category_id: cat.id,
        points_awarded: points,
        note: `Quiz: ${correct}/${totalQuestions} correct${extras.length ? ` · ${extras.join(" · ")}` : ""}`,
        awarded_by: awardedBy,
      });
    }

    await supabase.from("quiz_results").upsert(
      {
        ...(existing ? { id: existing.id } : {}),
        quiz_id: session.quiz_id,
        student_id: p.student_id,
        day_id: dayId,
        attempts: (existing?.attempts ?? 0) + 1,
        first_correct: correct,
        best_correct: Math.max(existing?.best_correct ?? 0, correct),
        total_questions: totalQuestions ?? 0,
        points_awarded: points,
        streak_at_award: streak,
        first_at: existing?.first_at ?? now,
        last_attempt_at: now,
      },
      { onConflict: "quiz_id,student_id" },
    );

    awarded += 1;
  }

  return { ok: true, awarded };
}
