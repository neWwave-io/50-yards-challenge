-- ============================================================================
-- NOT APPLIED YET. This file is parked deliberately.
--
-- The project currently runs with migrations/0005_open_access_dev.sql:
-- RLS off, everything granted to anon + authenticated. That was a deliberate
-- call to move fast while the schema and v2 app are still changing.
--
-- RUN THIS FILE BEFORE EITHER OF THESE HAPPENS:
--   1. Real user data is imported (it carries children's names, photos,
--      phone numbers and locations), or
--   2. A build pointing at this project reaches a real user.
--
-- How to apply:
--   supabase db execute --file supabase/security/rls_lockdown.sql
--   (or paste into the SQL editor, or ask Claude to apply it as a migration)
--
-- After applying, re-run the security advisor and confirm zero findings
-- other than the two intentional SECURITY DEFINER views in 0004_views.sql.
-- ============================================================================

-- 0005_rls_and_grants.sql
--
-- This file replaces the v1 Firestore rules, which were `allow read: if true`
-- and `allow create: if true` on 8 of 9 collections. The user base is children,
-- so the posture here is default-deny with narrow, explicit grants.
--
-- Two layers of protection:
--   1. RLS policies decide WHICH ROWS a caller can touch.
--   2. Column-level GRANTs decide WHICH COLUMNS they may write.
-- Layer 2 is what stops a member writing their own total_lawns — the exact
-- hole that existed in v1. Privileged writes go through the SECURITY DEFINER
-- functions in 0006_admin_rpcs.sql instead.

-- ─────────────────────────────────────────────────────────────────────────
-- Start from zero. Supabase grants ALL on public tables to anon/authenticated
-- by default; we take that back and re-grant deliberately.
-- ─────────────────────────────────────────────────────────────────────────
revoke all on all tables    in schema public from anon, authenticated;
revoke all on all sequences in schema public from anon, authenticated;

alter table public.profiles               enable row level security;
alter table public.children               enable row level security;
alter table public.user_roles             enable row level security;
alter table public.lawns                  enable row level security;
alter table public.lawn_photos            enable row level security;
alter table public.badge_levels           enable row level security;
alter table public.badge_requests         enable row level security;
alter table public.badge_request_children enable row level security;
alter table public.announcements          enable row level security;
alter table public.notifications          enable row level security;
alter table public.featured_members       enable row level security;
alter table public.device_tokens          enable row level security;
alter table public.app_settings           enable row level security;
alter table public.us_states              enable row level security;
alter table public.mowed_categories       enable row level security;
alter table public.find_lawn_tips         enable row level security;

-- ─────────────────────────────────────────────────────────────────────────
-- profiles
-- A member never sees another member's row directly. Cross-member visibility
-- happens only through the leaderboard / hall_of_fame views, which expose a
-- narrow column set and no contact details.
-- ─────────────────────────────────────────────────────────────────────────
grant select on public.profiles to authenticated;
grant insert (id, email, display_name, phone_number, state, region,
              gender, child_name, photo_url, photo_blurhash, is_group)
  on public.profiles to authenticated;
grant update (display_name, phone_number, state, region,
              gender, child_name, photo_url, photo_blurhash, is_group)
  on public.profiles to authenticated;
-- deliberately NOT granted: total_lawns, total_hours, current_badge_level_id,
-- is_hall_of_fame, email, id, created_at, updated_at

create policy profiles_select_own_or_admin on public.profiles
  for select to authenticated
  using (id = auth.uid() or public.is_admin());

create policy profiles_insert_self on public.profiles
  for insert to authenticated
  with check (id = auth.uid());

create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────
-- children
-- ─────────────────────────────────────────────────────────────────────────
grant select, delete on public.children to authenticated;
grant insert (profile_id, name, shirt_size, gender) on public.children to authenticated;
grant update (name, shirt_size, gender)             on public.children to authenticated;

create policy children_select on public.children
  for select to authenticated
  using (profile_id = auth.uid() or public.is_admin());

create policy children_insert_own on public.children
  for insert to authenticated
  with check (profile_id = auth.uid());

create policy children_update_own on public.children
  for update to authenticated
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

create policy children_delete_own on public.children
  for delete to authenticated
  using (profile_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────
-- user_roles — readable by the owner and admins, writable only by
-- super_admins (and the service role, which bypasses RLS entirely).
-- ─────────────────────────────────────────────────────────────────────────
grant select on public.user_roles to authenticated;

create policy user_roles_select on public.user_roles
  for select to authenticated
  using (profile_id = auth.uid() or public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────
-- lawns
-- A member may create a lawn and edit it ONLY while it is still pending.
-- status / verified_by / verified_at are not grantable to members at all —
-- review happens through admin_review_lawn().
-- ─────────────────────────────────────────────────────────────────────────
grant select on public.lawns to authenticated;
grant insert (profile_id, who_for, hours_taken, notes) on public.lawns to authenticated;
grant update (who_for, hours_taken, notes)             on public.lawns to authenticated;

create policy lawns_select_own_or_admin on public.lawns
  for select to authenticated
  using (profile_id = auth.uid() or public.is_admin());

create policy lawns_insert_own on public.lawns
  for insert to authenticated
  with check (profile_id = auth.uid());

create policy lawns_update_own_while_pending on public.lawns
  for update to authenticated
  using (profile_id = auth.uid() and status = 'pending')
  with check (profile_id = auth.uid() and status = 'pending');

create policy lawns_delete_own_while_pending on public.lawns
  for delete to authenticated
  using (profile_id = auth.uid() and status = 'pending');
grant delete on public.lawns to authenticated;

-- ─────────────────────────────────────────────────────────────────────────
-- lawn_photos — ownership is inherited from the parent lawn
-- ─────────────────────────────────────────────────────────────────────────
grant select, delete on public.lawn_photos to authenticated;
grant insert (lawn_id, photo_kind, url, blurhash, sort_order)
  on public.lawn_photos to authenticated;

create policy lawn_photos_select on public.lawn_photos
  for select to authenticated
  using (
    public.is_admin()
    or exists (select 1 from public.lawns l
                where l.id = lawn_photos.lawn_id and l.profile_id = auth.uid())
  );

create policy lawn_photos_insert_own on public.lawn_photos
  for insert to authenticated
  with check (
    exists (select 1 from public.lawns l
             where l.id = lawn_photos.lawn_id
               and l.profile_id = auth.uid()
               and l.status = 'pending')
  );

create policy lawn_photos_delete_own on public.lawn_photos
  for delete to authenticated
  using (
    exists (select 1 from public.lawns l
             where l.id = lawn_photos.lawn_id
               and l.profile_id = auth.uid()
               and l.status = 'pending')
  );

-- ─────────────────────────────────────────────────────────────────────────
-- badge_requests — members create; only admins decide. No member update path.
-- ─────────────────────────────────────────────────────────────────────────
grant select on public.badge_requests to authenticated;
grant insert (profile_id, badge_level_id, child_name, state, region,
              is_group, lawn_count_at_request)
  on public.badge_requests to authenticated;

create policy badge_requests_select_own_or_admin on public.badge_requests
  for select to authenticated
  using (profile_id = auth.uid() or public.is_admin());

create policy badge_requests_insert_own on public.badge_requests
  for insert to authenticated
  with check (profile_id = auth.uid());

grant select on public.badge_request_children to authenticated;
grant insert (badge_request_id, name, shirt_size, gender)
  on public.badge_request_children to authenticated;

create policy badge_request_children_select on public.badge_request_children
  for select to authenticated
  using (
    public.is_admin()
    or exists (select 1 from public.badge_requests r
                where r.id = badge_request_children.badge_request_id
                  and r.profile_id = auth.uid())
  );

create policy badge_request_children_insert on public.badge_request_children
  for insert to authenticated
  with check (
    exists (select 1 from public.badge_requests r
             where r.id = badge_request_children.badge_request_id
               and r.profile_id = auth.uid())
  );

-- ─────────────────────────────────────────────────────────────────────────
-- Public read-only content. Writes go through admin RPCs or the service role.
-- ─────────────────────────────────────────────────────────────────────────
grant select on public.badge_levels     to anon, authenticated;
grant select on public.announcements    to anon, authenticated;
grant select on public.featured_members to anon, authenticated;
grant select on public.us_states        to anon, authenticated;
grant select on public.mowed_categories to anon, authenticated;
grant select on public.find_lawn_tips   to anon, authenticated;
grant select on public.app_settings     to authenticated;

create policy badge_levels_read     on public.badge_levels     for select to anon, authenticated using (true);
create policy announcements_read    on public.announcements    for select to anon, authenticated using (true);
create policy featured_members_read on public.featured_members for select to anon, authenticated using (true);
create policy us_states_read        on public.us_states        for select to anon, authenticated using (true);
create policy mowed_categories_read on public.mowed_categories for select to anon, authenticated using (true);
create policy find_lawn_tips_read   on public.find_lawn_tips   for select to anon, authenticated using (true);
create policy app_settings_read     on public.app_settings     for select to authenticated     using (true);

-- ─────────────────────────────────────────────────────────────────────────
-- notifications — a member reads their own and may only flip is_read.
-- Creation is server-side (admin RPC / Edge Function).
-- ─────────────────────────────────────────────────────────────────────────
grant select, delete on public.notifications to authenticated;
grant update (is_read) on public.notifications to authenticated;

create policy notifications_select_own on public.notifications
  for select to authenticated
  using (profile_id = auth.uid() or public.is_admin());

create policy notifications_update_own on public.notifications
  for update to authenticated
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

create policy notifications_delete_own on public.notifications
  for delete to authenticated
  using (profile_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────
-- device_tokens — entirely the owner's
-- ─────────────────────────────────────────────────────────────────────────
grant select, delete on public.device_tokens to authenticated;
grant insert (profile_id, fcm_token, device_type) on public.device_tokens to authenticated;

create policy device_tokens_all_own on public.device_tokens
  for all to authenticated
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────
-- Views (re-granted: the blanket revoke above dropped them)
-- ─────────────────────────────────────────────────────────────────────────
grant select on public.leaderboard         to anon, authenticated;
grant select on public.hall_of_fame        to anon, authenticated;
grant select on public.my_mowed_categories to authenticated;
