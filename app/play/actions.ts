"use server";

import { createAdminClient } from "@/lib/supabase/admin";

// All student actions are UNAUTHENTICATED. They go through the admin client
// (service role) ONLY after validating the join code + PIN here. We never send
// quiz_options.is_correct to the student until the question is revealed.

function normCode(code: string) {
  return code.trim().toUpperCase();
}

async function resolveSessionAndStudent(code: string, pin: string) {
  const supabase = createAdminClient();

  // Look up by code regardless of status so students still see their final
  // score after the session ends. Individual actions enforce status rules.
  const { data: session } = await supabase
    .from("quiz_sessions")
    .select("*")
    .eq("join_code", normCode(code))
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (!session) return { ok: false as const, error: "Session not found." };

  const { data: student } = await supabase
    .from("students")
    .select("id, name, nickname")
    .eq("pin", pin.trim())
    .maybeSingle();
  if (!student) return { ok: false as const, error: "Invalid PIN." };

  return { ok: true as const, supabase, session, student };
}

// Join a live session with a join code + personal PIN.
export async function joinSession(code: string, pin: string) {
  const res = await resolveSessionAndStudent(code, pin);
  if (!res.ok) return { ok: false as const, error: res.error };
  const { supabase, session, student } = res;

  if (session.status === "ended")
    return { ok: false as const, error: "This quiz has already ended." };

  const { data: participant, error } = await supabase
    .from("quiz_participants")
    .upsert(
      {
        session_id: session.id,
        student_id: student.id,
        display_name: student.name,
      },
      { onConflict: "session_id,student_id" },
    )
    .select("id, display_name")
    .single();

  if (error || !participant) return { ok: false as const, error: error?.message || "Join failed" };

  return {
    ok: true as const,
    participantId: participant.id,
    displayName: participant.display_name,
  };
}

// Submit an answer for the current question. Correctness is computed server-side.
export async function submitAnswer(
  code: string,
  pin: string,
  questionId: string,
  optionId: string,
) {
  const res = await resolveSessionAndStudent(code, pin);
  if (!res.ok) return { ok: false as const, error: res.error };
  const { supabase, session, student } = res;

  if (session.status !== "active") return { ok: false as const, error: "Quiz is not active." };
  if (session.current_question_id !== questionId)
    return { ok: false as const, error: "This question is no longer active." };
  if (session.current_revealed)
    return { ok: false as const, error: "Answers are closed for this question." };

  const { data: participant } = await supabase
    .from("quiz_participants")
    .select("id")
    .eq("session_id", session.id)
    .eq("student_id", student.id)
    .maybeSingle();
  if (!participant) return { ok: false as const, error: "You haven't joined this session." };

  // Already answered this question? (one answer per question, enforced by DB too)
  const { data: prior } = await supabase
    .from("quiz_answers")
    .select("id")
    .eq("session_id", session.id)
    .eq("participant_id", participant.id)
    .eq("question_id", questionId)
    .maybeSingle();
  if (prior) return { ok: false as const, error: "Already answered." };

  // Validate the option belongs to this question and compute correctness server-side.
  const { data: option } = await supabase
    .from("quiz_options")
    .select("id, is_correct, question_id")
    .eq("id", optionId)
    .maybeSingle();
  if (!option || option.question_id !== questionId)
    return { ok: false as const, error: "Invalid option." };

  // Server-computed response time (never trust the client) for an optional speed bonus.
  const startedAt = session.current_question_started_at
    ? new Date(session.current_question_started_at).getTime()
    : Date.now();
  const responseMs = Math.max(0, Date.now() - startedAt);

  const { error } = await supabase.from("quiz_answers").insert({
    session_id: session.id,
    participant_id: participant.id,
    question_id: questionId,
    option_id: optionId,
    is_correct: option.is_correct,
    response_ms: responseMs,
    points_earned: option.is_correct ? 1 : 0,
  });

  if (error) return { ok: false as const, error: error.message };
  return { ok: true as const };
}

export type PlayState =
  | { ok: false; error: string }
  | {
      ok: true;
      status: "lobby" | "active" | "ended";
      displayName: string;
      lobbyCount: number;
      revealed: boolean;
      answered: boolean;
      myOptionId: string | null;
      question: { id: string; prompt: string; type: "mc" | "tf"; timeLimit: number } | null;
      options: { id: string; label: string; isCorrect?: boolean }[];
      finalCorrect: number;
      totalQuestions: number;
      pointsAwarded: number;
    };

// Poll the current play state for a student. Returns the current question with
// is_correct STRIPPED unless the question has been revealed.
export async function getPlayState(code: string, pin: string): Promise<PlayState> {
  const res = await resolveSessionAndStudent(code, pin);
  if (!res.ok) return { ok: false, error: res.error };
  const { supabase, session, student } = res;

  const { data: participant } = await supabase
    .from("quiz_participants")
    .select("id, display_name, total_score")
    .eq("session_id", session.id)
    .eq("student_id", student.id)
    .maybeSingle();

  const out: Extract<PlayState, { ok: true }> = {
    ok: true,
    status: session.status,
    displayName: participant?.display_name || student.name,
    lobbyCount: 0,
    revealed: session.current_revealed,
    answered: false,
    myOptionId: null,
    question: null,
    options: [],
    finalCorrect: 0,
    totalQuestions: 0,
    pointsAwarded: 0,
  };

  if (session.status === "lobby") {
    const { count } = await supabase
      .from("quiz_participants")
      .select("id", { count: "exact", head: true })
      .eq("session_id", session.id);
    out.lobbyCount = count ?? 0;
    return out;
  }

  if (session.status === "ended") {
    const { data: result } = await supabase
      .from("quiz_results")
      .select("best_correct, total_questions, points_awarded")
      .eq("quiz_id", session.quiz_id)
      .eq("student_id", student.id)
      .maybeSingle();
    out.finalCorrect = result?.best_correct ?? participant?.total_score ?? 0;
    out.totalQuestions = result?.total_questions ?? 0;
    out.pointsAwarded = result?.points_awarded ?? 0;
    return out;
  }

  // Active — current question without is_correct unless revealed.
  const qId = session.current_question_id;
  if (!qId) return out;

  const { data: question } = await supabase
    .from("quiz_questions")
    .select("id, prompt, question_type, time_limit_seconds")
    .eq("id", qId)
    .single();

  const { data: options } = await supabase
    .from("quiz_options")
    .select("id, label, position, is_correct")
    .eq("question_id", qId)
    .order("position");

  if (participant) {
    const { data: myAnswer } = await supabase
      .from("quiz_answers")
      .select("option_id")
      .eq("session_id", session.id)
      .eq("participant_id", participant.id)
      .eq("question_id", qId)
      .maybeSingle();
    out.myOptionId = myAnswer?.option_id ?? null;
  }
  out.answered = out.myOptionId !== null;

  out.question = question
    ? {
        id: question.id,
        prompt: question.prompt,
        type: question.question_type,
        timeLimit: question.time_limit_seconds,
      }
    : null;

  out.options = (options || []).map((o: { id: string; label: string; is_correct: boolean }) => ({
    id: o.id,
    label: o.label,
    ...(out.revealed ? { isCorrect: o.is_correct } : {}),
  }));

  return out;
}
