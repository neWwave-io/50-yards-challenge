-- 0019_leaderboard_everyone.sql
-- Every participant is on the leaderboard, including those with no approved
-- lawns yet — they share the last place. Active admins are left out: they run
-- the challenge rather than take part in it.
--
-- Columns are unchanged, so dependents such as v1_leaderboards keep working.

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
where not exists (
  select 1
    from public.user_roles r
   where r.profile_id = p.id
     and r.active
     and r.role in ('admin', 'super_admin')
);

grant select on public.leaderboard to anon, authenticated;
