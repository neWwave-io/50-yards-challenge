-- 0011_day_streak.sql
-- The home page shows a "Day Streak". Nothing stored it, and a stored column
-- would drift every time a lawn is added, edited, rejected or deleted, so it
-- is derived from `lawns` on read instead.
--
-- Consecutive days are found with gaps-and-islands: number the distinct days a
-- profile mowed, subtract the row number from the date, and every run of
-- consecutive days collapses to a single constant. Group by it to get the runs.
--
-- ⚠️ Days are counted in UTC. A lawn mowed late in a US evening lands on the
-- next UTC day, which can split a run. Fixing that properly needs the local
-- calendar date of the mow recorded at submission time (a `lawns.mowed_on`
-- column the v2 submit flow would fill); until that exists this is the
-- closest honest answer.
create or replace function public.profile_day_streaks(p_profile_id uuid)
returns table (current_streak integer, longest_streak integer)
language sql
stable
security invoker
set search_path = public
as $$
  with mowed_days as (
    select distinct (l.created_at at time zone 'UTC')::date as day
    from public.lawns l
    where l.profile_id = p_profile_id
      -- A rejected lawn was not a day's work.
      and l.status <> 'rejected'
  ),
  islands as (
    select day,
           day - (row_number() over (order by day))::integer as run_key
    from mowed_days
  ),
  runs as (
    select count(*)::integer as length, max(day) as last_day
    from islands
    group by run_key
  )
  select
    -- Today still counts as unbroken, and so does yesterday: the streak is
    -- only lost once a whole day passes with nothing mowed.
    coalesce((
      select r.length from runs r
      where r.last_day >= (current_date at time zone 'UTC')::date - 1
      order by r.last_day desc
      limit 1
    ), 0) as current_streak,
    coalesce((select max(r.length) from runs r), 0) as longest_streak;
$$;

comment on function public.profile_day_streaks(uuid) is
  'Current and longest run of consecutive days a profile mowed, from lawns.';
