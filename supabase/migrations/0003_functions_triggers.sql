-- 0003_functions_triggers.sql
-- Server-authoritative logic. This is what makes totals and badge levels
-- impossible to forge from the client — the single biggest fix over v1.

-- ─────────────────────────────────────────────────────────────────────────
-- updated_at
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger profiles_set_updated_at       before update on public.profiles
  for each row execute function public.set_updated_at();
create trigger lawns_set_updated_at          before update on public.lawns
  for each row execute function public.set_updated_at();
create trigger badge_requests_set_updated_at before update on public.badge_requests
  for each row execute function public.set_updated_at();
create trigger announcements_set_updated_at  before update on public.announcements
  for each row execute function public.set_updated_at();
create trigger app_settings_set_updated_at   before update on public.app_settings
  for each row execute function public.set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────
-- Role check used by every admin RLS policy.
-- SECURITY DEFINER so it can read user_roles regardless of the caller's RLS.
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.user_roles
     where profile_id = auth.uid()
       and active
       and role in ('admin', 'super_admin')
  );
$$;

create or replace function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.user_roles
     where profile_id = auth.uid()
       and active
       and role = 'super_admin'
  );
$$;

revoke execute on function public.is_admin()       from public;
revoke execute on function public.is_super_admin() from public;
grant execute on function public.is_admin()        to authenticated;
grant execute on function public.is_super_admin()  to authenticated;

-- ─────────────────────────────────────────────────────────────────────────
-- Badge level derived from total_lawns.
-- In v1 this was computed client-side and stored in users.shirt_level.
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.apply_badge_level()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_level uuid;
begin
  select id into v_level
    from public.badge_levels
   where min_lawns <= new.total_lawns
   order by min_lawns desc
   limit 1;

  new.current_badge_level_id := v_level;
  return new;
end;
$$;

create trigger profiles_apply_badge_level
  before insert or update of total_lawns on public.profiles
  for each row execute function public.apply_badge_level();

-- ─────────────────────────────────────────────────────────────────────────
-- Totals recomputed from APPROVED lawns only.
-- In v1 users.total_lawns / total_hours were written by the client.
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.recalc_profile_totals()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_profile uuid;
begin
  v_profile := coalesce(new.profile_id, old.profile_id);

  update public.profiles p
     set total_lawns = (
           select count(*)
             from public.lawns l
            where l.profile_id = v_profile
              and l.status = 'approved'
         ),
         total_hours = (
           select coalesce(sum(l.hours_taken), 0)
             from public.lawns l
            where l.profile_id = v_profile
              and l.status = 'approved'
         )
   where p.id = v_profile;

  return null;
end;
$$;

create trigger lawns_recalc_totals
  after insert or delete or update of status, hours_taken, profile_id on public.lawns
  for each row execute function public.recalc_profile_totals();

-- Full backfill. Run after the data import, then diff against the values
-- that came out of Firestore (see docs/backend-schema.json -> verification).
create or replace function public.recalc_all_profile_totals()
returns void
language sql
security definer
set search_path = public
as $$
  update public.profiles p
     set total_lawns = coalesce(agg.n, 0),
         total_hours = coalesce(agg.h, 0)
    from (
      select pr.id,
             count(l.id) filter (where l.status = 'approved') as n,
             coalesce(sum(l.hours_taken) filter (where l.status = 'approved'), 0) as h
        from public.profiles pr
        left join public.lawns l on l.profile_id = pr.id
       group by pr.id
    ) agg
   where p.id = agg.id;
$$;

revoke execute on function public.recalc_all_profile_totals() from public, authenticated, anon;

-- ─────────────────────────────────────────────────────────────────────────
-- New auth user -> profile + member role
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name, photo_url)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'display_name',
             new.raw_user_meta_data ->> 'full_name',
             new.raw_user_meta_data ->> 'name'),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;

  insert into public.user_roles (profile_id, role)
  values (new.id, 'member')
  on conflict (profile_id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
