-- 0004_views.sql
-- The v1 `leaderboards` collection was a denormalized top_users[] array that a
-- cron job had to rebuild and that was stale in between. Here it is a query.

-- ─────────────────────────────────────────────────────────────────────────
-- IMPORTANT — these views deliberately run with the OWNER's privileges
-- (security_invoker = false), so they bypass RLS on public.profiles.
--
-- That is the point: the leaderboard is public, but public.profiles is
-- locked down to owner + admin. The view is the ONLY way an ordinary member
-- sees another member, and it exposes a deliberately narrow column set:
-- no email, no phone_number, no exact region beyond what is already shown
-- in the app.
--
-- Supabase's security advisor will flag these as "SECURITY DEFINER view".
-- That is expected and intentional. Do not "fix" it by switching to
-- security_invoker without also widening the profiles select policy, which
-- would expose far more.
-- ─────────────────────────────────────────────────────────────────────────

create or replace view public.leaderboard
with (security_invoker = false) as
select
  p.id             as profile_id,
  p.display_name,
  p.child_name,
  p.photo_url,
  p.photo_blurhash,
  p.state,
  p.region,
  p.total_lawns,
  p.total_hours,
  p.is_hall_of_fame,
  bl.name          as badge_level,
  bl.image_url     as badge_image_url,
  rank() over (partition by p.region order by p.total_lawns desc, p.total_hours desc) as region_rank,
  rank() over (                      order by p.total_lawns desc, p.total_hours desc) as global_rank
from public.profiles p
left join public.badge_levels bl on bl.id = p.current_badge_level_id
where p.total_lawns > 0;

create or replace view public.hall_of_fame
with (security_invoker = false) as
select
  p.id         as profile_id,
  p.display_name,
  p.child_name,
  p.photo_url,
  p.photo_blurhash,
  p.state,
  p.region,
  p.total_lawns,
  p.total_hours,
  bl.name      as badge_level,
  bl.image_url as badge_image_url
from public.profiles p
left join public.badge_levels bl on bl.id = p.current_badge_level_id
where p.is_hall_of_fame;

-- Replaces custom_functions.getDuplicate(), which tallied categories in Dart
-- on the client. MowedCategories was never a stored type — it was this query.
create or replace view public.my_mowed_categories
with (security_invoker = true) as
select
  l.profile_id,
  l.who_for            as who,
  count(*)             as num_mow,
  sum(l.hours_taken)   as total_hours
from public.lawns l
where l.status = 'approved'
group by l.profile_id, l.who_for;

grant select on public.leaderboard         to anon, authenticated;
grant select on public.hall_of_fame        to anon, authenticated;
grant select on public.my_mowed_categories to authenticated;
