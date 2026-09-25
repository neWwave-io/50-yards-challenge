-- 0017_leaderboard_state_rank.sql
-- The v2 leaderboard screen filters participants by state, so the view needs
-- a rank within each state as well as the national one.
--
-- Ranking at the time: more approved lawns first, more hours broke a tie
-- (hours dropped in 0018).
-- Both totals are kept current by recalc_profile_totals(), so this stays a
-- plain query — no cron job, no Edge Function.
--
-- `create or replace view` may only append columns, which is why state_rank
-- goes last. The security note at the top of 0004_views.sql still applies.

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
  rank() over (                      order by p.total_lawns desc, p.total_hours desc) as global_rank,
  rank() over (partition by p.state  order by p.total_lawns desc, p.total_hours desc) as state_rank
from public.profiles p
left join public.badge_levels bl on bl.id = p.current_badge_level_id
where p.total_lawns > 0;

grant select on public.leaderboard to anon, authenticated;
