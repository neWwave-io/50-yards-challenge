-- 0016_availability.sql
-- A family can go offline — for a holiday, a busy week — and optionally say
-- when they will be back. The home header's smiley shows which state they are
-- in, and time away does not break their day streak.
--
-- Away time is kept as periods rather than a flag on the profile, because the
-- streak needs to know about past absences, not just the current one: a run
-- that spans a week away is still one run.

create table if not exists public.away_periods (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles(id) on delete cascade,
  starts_on   date not null default current_date,
  -- The day they are back. Null: away until they say otherwise.
  returns_on  date,
  created_at  timestamptz not null default now(),
  constraint away_periods_ends_after_start
    check (returns_on is null or returns_on > starts_on)
);

create index if not exists away_periods_profile_idx
  on public.away_periods (profile_id, starts_on desc);

-- ─────────────────────────────────────────────────────────────────────────
-- Reading the current state.
--
-- Days are UTC, matching profile_day_streaks — see the note in 0011.
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.profile_availability(p_profile_id uuid)
returns table (is_away boolean, returns_on date, available_since date)
language sql
stable
security invoker
set search_path = public
as $$
  with current_period as (
    select a.returns_on
      from public.away_periods a
     where a.profile_id = p_profile_id
       and a.starts_on <= current_date
       and (a.returns_on is null or a.returns_on > current_date)
     order by a.starts_on desc
     limit 1
  )
  select
    exists (select 1 from current_period),
    (select c.returns_on from current_period c),
    -- The last time they came back, or when they joined if they never left.
    coalesce(
      (select max(a.returns_on) from public.away_periods a
        where a.profile_id = p_profile_id and a.returns_on <= current_date),
      (select (p.created_at at time zone 'UTC')::date
         from public.profiles p where p.id = p_profile_id)
    );
$$;

-- ─────────────────────────────────────────────────────────────────────────
-- Changing it. These act on the signed-in family only, so the client cannot
-- set someone else away.
-- ─────────────────────────────────────────────────────────────────────────

-- Go offline, or change the return date while already away.
create or replace function public.set_away(p_returns_on date default null)
returns void
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_me uuid := auth.uid();
  v_current uuid;
begin
  if v_me is null then
    raise exception 'Not signed in';
  end if;
  if p_returns_on is not null and p_returns_on <= current_date then
    raise exception 'The return date has to be after today';
  end if;

  select id into v_current
    from public.away_periods
   where profile_id = v_me
     and starts_on <= current_date
     and (returns_on is null or returns_on > current_date)
   order by starts_on desc
   limit 1;

  if v_current is not null then
    update public.away_periods set returns_on = p_returns_on
     where id = v_current;
  else
    insert into public.away_periods (profile_id, starts_on, returns_on)
    values (v_me, current_date, p_returns_on);
  end if;
end;
$$;

-- Come back, early or on time.
create or replace function public.set_available()
returns void
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_me uuid := auth.uid();
begin
  if v_me is null then
    raise exception 'Not signed in';
  end if;

  -- Left and came back the same day: the period covered nothing, drop it.
  delete from public.away_periods
   where profile_id = v_me
     and starts_on = current_date;

  update public.away_periods set returns_on = current_date
   where profile_id = v_me
     and starts_on < current_date
     and (returns_on is null or returns_on > current_date);
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────
-- Day streak, now bridging time away.
--
-- A day away neither counts towards a run nor breaks it: mowed days and away
-- days together form the islands, but only mowed days are counted in each.
-- ─────────────────────────────────────────────────────────────────────────
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
       and l.status <> 'rejected'
  ),
  away_days as (
    select generate_series(
             a.starts_on,
             least(coalesce(a.returns_on, current_date + 1) - 1, current_date),
             interval '1 day'
           )::date as day
      from public.away_periods a
     where a.profile_id = p_profile_id
       and a.starts_on <= current_date
  ),
  covered as (
    select day, bool_or(mowed) as mowed
      from (
        select day, true  as mowed from mowed_days
        union all
        select day, false as mowed from away_days
      ) d
     group by day
  ),
  islands as (
    select day, mowed,
           day - (row_number() over (order by day))::integer as run_key
      from covered
  ),
  runs as (
    select (count(*) filter (where mowed))::integer as length,
           max(day) as last_day
      from islands
     group by run_key
  )
  select
    coalesce((
      select r.length from runs r
       where r.last_day >= current_date - 1
       order by r.last_day desc
       limit 1
    ), 0),
    coalesce((select max(r.length) from runs r), 0);
$$;
