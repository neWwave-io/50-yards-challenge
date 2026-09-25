-- 0022_leaderboard_first_names_only.sql
-- The participants are children, and this view is readable with the public
-- anon key — it runs as its owner, so RLS on profiles does not narrow it.
-- Trimming names in the app protects nothing; the view itself must not hand
-- out full names.
--
-- display_name now carries only a first name, taken from display_name or,
-- failing that, child_name. child_name is always null. The columns keep
-- their names and types so dependents (v1_leaderboards, the profile screen)
-- keep working, and searching display_name can no longer match a surname.

create or replace view public.leaderboard
with (security_invoker = false) as
select
  p.id             as profile_id,
  split_part(
    regexp_replace(
      trim(coalesce(nullif(trim(p.display_name), ''), p.child_name)),
      '\s+', ' ', 'g'),
    ' ', 1)        as display_name,
  null::text       as child_name,
  p.photo_url,
  p.photo_blurhash,
  p.state,
  p.region,
  p.total_lawns,
  p.total_hours,
  p.is_hall_of_fame,
  bl.name          as badge_level,
  bl.image_url     as badge_image_url,
  row_number() over (partition by p.region order by p.total_lawns desc, p.created_at, p.id) as region_rank,
  row_number() over (                      order by p.total_lawns desc, p.created_at, p.id) as global_rank,
  row_number() over (partition by p.state  order by p.total_lawns desc, p.created_at, p.id) as state_rank
from public.profiles p
left join public.badge_levels bl on bl.id = p.current_badge_level_id
where coalesce(nullif(trim(p.display_name), ''), nullif(trim(p.child_name), '')) is not null
  and not exists (
  select 1
    from public.user_roles r
   where r.profile_id = p.id
     and r.active
     and r.role in ('admin', 'super_admin')
);

grant select on public.leaderboard to anon, authenticated;
