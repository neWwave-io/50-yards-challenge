-- 0018_leaderboard_lawns_only.sql
-- The leaderboard ranks on approved lawns alone. Hours no longer break a
-- tie: children with the same number of lawns share a place (rank() gives
-- 1, 2, 2, 4). Columns are unchanged, so dependents such as
-- v1_leaderboards keep working.

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
  rank() over (partition by p.region order by p.total_lawns desc) as region_rank,
  rank() over (                      order by p.total_lawns desc) as global_rank,
  rank() over (partition by p.state  order by p.total_lawns desc) as state_rank
from public.profiles p
left join public.badge_levels bl on bl.id = p.current_badge_level_id
where p.total_lawns > 0;

grant select on public.leaderboard to anon, authenticated;
