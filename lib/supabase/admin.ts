import "server-only";

import { createClient } from "@supabase/supabase-js";

// Admin client — service-role key. BYPASSES RLS. Server-only.
// Used exclusively for code-validated student quiz actions (no auth session).
// Never import this into a Client Component; `server-only` enforces that.
export function createAdminClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { autoRefreshToken: false, persistSession: false } },
  );
}
