import { createClient } from "@/lib/supabase/server";
import { Nav } from "@/components/Nav";
import { StudentDetailClient } from "./StudentDetailClient";
import Link from "next/link";
import type { Attendance, PointAward, ProgramDay, PointCategory } from "@/lib/types";

export const dynamic = "force-dynamic";

export default async function StudentDetailPage({
  params,
}: {
  params: { id: string };
}) {
  const supabase = createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const [
    { data: student, error: studentError },
    { data: attendance },
    { data: awards },
    { data: programDays },
    { data: categories },
  ] = await Promise.all([
    supabase.from("students").select("*").eq("id", params.id).maybeSingle(),
    supabase.from("attendance").select("*").eq("student_id", params.id),
    supabase.from("point_awards").select("*").eq("student_id", params.id),
    supabase.from("program_days").select("*").order("day_number"),
    supabase.from("point_categories").select("*").order("sort_order"),
  ]);

  if (studentError || !student) {
    return (
      <>
        <Nav email={user?.email} />
        <main className="mx-auto max-w-6xl px-4 py-10">
          <div className="rounded-2xl border border-slate-200 bg-white p-8 text-center shadow-sm">
            <h2 className="text-xl font-bold text-navy">Student Not Found</h2>
            <p className="mt-2 text-slate-500">
              The student with the specified ID could not be found or has been deleted.
            </p>
            <Link
              href="/students"
              className="mt-4 inline-block rounded-lg bg-navy px-4 py-2 font-semibold text-white hover:bg-navyhover"
            >
              Back to Students
            </Link>
          </div>
        </main>
      </>
    );
  }

  return (
    <>
      <Nav email={user?.email} />
      <main className="mx-auto max-w-6xl px-4 py-6">
        <StudentDetailClient
          student={student}
          attendanceRecords={(attendance || []) as Attendance[]}
          awardsRecords={(awards || []) as PointAward[]}
          programDays={(programDays || []) as ProgramDay[]}
          categories={(categories || []) as PointCategory[]}
        />
      </main>
    </>
  );
}
