-- 0006_storage.sql
-- Buckets replacing Firebase Storage (gs://the-50-yard-challenge...).
--
-- ⚠️  All three buckets are PUBLIC and the policies are wide open, matching
-- the development posture in 0005_open_access_dev.sql. lawn-photos in
-- particular should become private before real data lands — the tightened
-- version is in supabase/security/rls_lockdown.sql.

insert into storage.buckets (id, name, public)
values
  ('avatars',       'avatars',       true),
  ('announcements', 'announcements', true),
  ('lawn-photos',   'lawn-photos',   true)
on conflict (id) do nothing;

-- storage.objects always has RLS enabled and it cannot be turned off, so
-- "open" here means permissive policies rather than no policies.
create policy storage_dev_read on storage.objects
  for select to anon, authenticated
  using (bucket_id in ('avatars', 'announcements', 'lawn-photos'));

create policy storage_dev_insert on storage.objects
  for insert to anon, authenticated
  with check (bucket_id in ('avatars', 'announcements', 'lawn-photos'));

create policy storage_dev_update on storage.objects
  for update to anon, authenticated
  using (bucket_id in ('avatars', 'announcements', 'lawn-photos'))
  with check (bucket_id in ('avatars', 'announcements', 'lawn-photos'));

create policy storage_dev_delete on storage.objects
  for delete to anon, authenticated
  using (bucket_id in ('avatars', 'announcements', 'lawn-photos'));
