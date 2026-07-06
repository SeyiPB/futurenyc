"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { getPlayState, joinSession, submitAnswer } from "./actions";

type PlayState = Awaited<ReturnType<typeof getPlayState>>;

export function Play() {
  const [code, setCode] = useState("");
  const [pin, setPin] = useState("");
  const [joined, setJoined] = useState(false);
  const [displayName, setDisplayName] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [state, setState] = useState<PlayState | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const timer = useRef<ReturnType<typeof setInterval> | null>(null);

  const refresh = useCallback(async () => {
    if (!code || !pin) return;
    const s = await getPlayState(code, pin);
    setState(s);
  }, [code, pin]);

  useEffect(() => {
    if (!joined) return;
    refresh();
    timer.current = setInterval(refresh, 1500); // poll live state
    return () => {
      if (timer.current) clearInterval(timer.current);
    };
  }, [joined, refresh]);

  async function handleJoin(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setBusy(true);
    try {
      const res = await joinSession(code, pin);
      if (res.ok) {
        setDisplayName(res.displayName);
        setJoined(true);
      } else {
        setError(res.error || "Could not join");
      }
    } catch {
      setError("Something went wrong joining. Please try again.");
    } finally {
      setBusy(false);
    }
  }

  async function answer(optionId: string, questionId: string) {
    setSubmitting(true);
    try {
      const res = await submitAnswer(code, pin, questionId, optionId);
      if (!res.ok) setError(res.error || "Could not submit");
    } catch {
      setError("Something went wrong submitting your answer.");
    } finally {
      setSubmitting(false);
      refresh();
    }
  }

  // ---- Join screen ----
  if (!joined) {
    return (
      <div className="grid min-h-screen place-items-center px-4">
        <form onSubmit={handleJoin} className="w-full max-w-sm rounded-2xl bg-white p-8 text-slate-900 shadow-xl">
          <div className="mb-6 text-center">
            <div className="mx-auto mb-3 h-1.5 w-12 rounded-full bg-accent" />
            <h1 className="text-xl font-bold text-navy">Join the Quiz</h1>
            <p className="text-sm text-slate-500">Enter the code on screen + your PIN</p>
          </div>
          {error && (
            <p className="mb-4 rounded-lg bg-red-50 px-3 py-2 text-sm text-red-700">{error}</p>
          )}
          <label className="block text-sm font-medium text-slate-700">Join code</label>
          <input
            value={code}
            onChange={(e) => setCode(e.target.value.toUpperCase())}
            autoCapitalize="characters"
            maxLength={6}
            required
            className="mt-1 mb-4 w-full rounded-lg border border-slate-300 px-3 py-2 text-center text-2xl font-bold tracking-widest uppercase focus:border-brand focus:outline-none"
          />
          <label className="block text-sm font-medium text-slate-700">Your PIN</label>
          <input
            value={pin}
            onChange={(e) => setPin(e.target.value.replace(/\D/g, ""))}
            inputMode="numeric"
            maxLength={4}
            required
            className="mt-1 mb-6 w-full rounded-lg border border-slate-300 px-3 py-2 text-center text-2xl font-bold tracking-widest focus:border-brand focus:outline-none"
          />
          <button
            disabled={busy}
            className="w-full rounded-lg bg-navy py-2.5 font-semibold text-white hover:bg-navyhover disabled:opacity-50"
          >
            {busy ? "Joining…" : "Join"}
          </button>
        </form>
      </div>
    );
  }

  // ---- Joined: render by status ----
  return (
    <div className="grid min-h-screen place-items-center px-4 py-8">
      <div className="w-full max-w-md text-center">
        <p className="mb-4 text-sm text-slate-400">Playing as <span className="font-semibold text-white">{displayName}</span></p>

        {(!state || !state.ok) && <p className="text-slate-300">Connecting…</p>}

        {state && state.ok && state.status === "lobby" && (
          <div className="rounded-2xl bg-white/5 p-8">
            <div className="mb-3 text-4xl">⏳</div>
            <p className="text-lg font-semibold">You&apos;re in!</p>
            <p className="text-sm text-slate-400">Waiting for the facilitator to start…</p>
            <p className="mt-3 text-sm text-accent">{state.lobbyCount} players ready</p>
          </div>
        )}

        {state && state.ok && state.status === "active" && state.question && (
          <div>
            <h2 className="mb-6 text-xl font-bold">{state.question.prompt}</h2>
            <div className="grid gap-3">
              {state.options.map((o) => {
                const isMine = state.myOptionId === o.id;
                const revealed = state.revealed;
                const correct = "isCorrect" in o ? (o as { isCorrect?: boolean }).isCorrect : undefined;
                let cls = "bg-white/10 hover:bg-white/20";
                if (revealed) {
                  if (correct) cls = "bg-emerald-500 text-white";
                  else if (isMine) cls = "bg-rose-500 text-white";
                  else cls = "bg-white/5 text-slate-400";
                } else if (isMine) {
                  cls = "bg-accent text-navy";
                }
                return (
                  <button
                    key={o.id}
                    disabled={state.answered || revealed || submitting}
                    onClick={() => answer(o.id, state.question!.id)}
                    className={`rounded-xl px-4 py-4 text-left text-lg font-medium transition disabled:cursor-default ${cls}`}
                  >
                    {revealed && correct && "✅ "}
                    {revealed && isMine && !correct && "❌ "}
                    {o.label}
                  </button>
                );
              })}
            </div>
            {state.answered && !state.revealed && (
              <p className="mt-5 text-sm text-accent">Answer locked in — waiting for results…</p>
            )}
            {revealedHint(state)}
          </div>
        )}

        {state && state.ok && state.status === "ended" && (
          <div className="rounded-2xl bg-white/5 p-8">
            <div className="mb-3 text-5xl">🎉</div>
            <p className="text-lg font-semibold">Nice work, {displayName}!</p>
            <p className="mt-2 text-3xl font-extrabold text-accent">
              {state.finalCorrect}/{state.totalQuestions}
            </p>
            <p className="text-sm text-slate-400">correct</p>
            {state.pointsAwarded > 0 && (
              <p className="mt-3 rounded-lg bg-accent/20 px-3 py-2 text-sm text-accent">
                +{state.pointsAwarded} points added to the leaderboard!
              </p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

function revealedHint(state: Extract<PlayState, { ok: true }>) {
  if (state.status !== "active" || !state.revealed) return null;
  const mine = state.options.find((o) => o.id === state.myOptionId) as
    | { isCorrect?: boolean }
    | undefined;
  if (!state.answered)
    return <p className="mt-5 text-sm text-slate-400">Time&apos;s up — here&apos;s the answer.</p>;
  return (
    <p className={`mt-5 text-sm font-semibold ${mine?.isCorrect ? "text-emerald-400" : "text-rose-400"}`}>
      {mine?.isCorrect ? "Correct! 🎯" : "Not quite this time."}
    </p>
  );
}
