import type { PointAward, ProgramDay, Student } from "./types";

export interface RankRow {
  student_id: string;
  name: string;
  total: number;
  today: number;
  rank: number;
}

// Compute rankings for a given week filter ("all" | 1 | 2 | 3 | 4).
// `todayId` scopes the "points today" column. Ties share a rank (standard
// competition ranking: 1, 2, 2, 4).
export function computeRankings(
  students: Student[],
  awards: PointAward[],
  dayWeek: Map<string, number>, // day_id -> week_number
  weekFilter: "all" | number,
  todayId: string | null,
): RankRow[] {
  const totals = new Map<string, number>();
  const today = new Map<string, number>();

  for (const s of students) {
    totals.set(s.id, 0);
    today.set(s.id, 0);
  }

  for (const a of awards) {
    if (!totals.has(a.student_id)) continue;
    const wk = dayWeek.get(a.day_id);
    if (weekFilter !== "all" && wk !== weekFilter) continue;
    totals.set(a.student_id, (totals.get(a.student_id) || 0) + a.points_awarded);
    if (todayId && a.day_id === todayId) {
      today.set(a.student_id, (today.get(a.student_id) || 0) + a.points_awarded);
    }
  }

  const rows = students
    .map((s) => ({
      student_id: s.id,
      name: s.name,
      total: totals.get(s.id) || 0,
      today: today.get(s.id) || 0,
      rank: 0,
    }))
    .sort((a, b) => b.total - a.total || a.name.localeCompare(b.name));

  let lastTotal: number | null = null;
  let lastRank = 0;
  rows.forEach((r, i) => {
    if (r.total !== lastTotal) {
      lastRank = i + 1;
      lastTotal = r.total;
    }
    r.rank = lastRank;
  });

  return rows;
}
