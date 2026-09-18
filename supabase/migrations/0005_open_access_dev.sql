-- 0005_open_access_dev.sql
--
-- ⚠️  DEVELOPMENT POSTURE — NOT SAFE FOR REAL DATA  ⚠️
--
-- RLS is intentionally left OFF and every table is granted to anon and
-- authenticated, so anyone holding the publishable key can read and write
-- everything. This is a deliberate choice to move fast while the schema and
-- the v2 app are still changing.
--
-- This is the same posture as the v1 Firestore rules we are migrating away
-- from. It MUST be closed before either of these happens:
--
--   1. Real user data is imported (the import carries children's names,
--      photos, phone numbers and locations), or
--   2. A build pointing at this project reaches a real user.
--
-- To close it, run:  supabase/security/rls_lockdown.sql
-- That file enables RLS on every table, adds owner/admin policies, and
-- narrows write access to a per-column allowlist. It is written and tested
-- against this schema — turning it on is one command, not a project.

grant usage on schema public to anon, authenticated;

grant all on all tables    in schema public to anon, authenticated;
grant all on all sequences in schema public to anon, authenticated;
grant all on all routines  in schema public to anon, authenticated;

-- keep future tables open too, for as long as this posture lasts
alter default privileges in schema public
  grant all on tables    to anon, authenticated;
alter default privileges in schema public
  grant all on sequences to anon, authenticated;
alter default privileges in schema public
  grant all on routines  to anon, authenticated;
