-- 0009_v1_compat_views.sql
--
-- Presents the clean v2 tables in the SHAPE the v1 FlutterFlow app expects,
-- so the existing screens can run on Supabase without being rewritten.
--
-- Why views rather than Dart adapter code: the v2 schema deliberately changed
-- STRUCTURE, not just names — arrays became child tables, nested structs became
-- columns, and the denormalized leaderboard became a query. Rebuilding those
-- document shapes in Dart would mean N+1 fetches and a lot of hand-written
-- assembly. Postgres does it in one query with json aggregation.
--
-- Reads go through these views. Writes go through the RPCs in 0010.
--
-- These are a migration shim. Delete them once v2 screens talk to the real
-- tables directly.

-- Rebuilds one v1 PhotoDetail struct from a lawn_photos row.
create or replace function public._v1_photo(p_lawn_id uuid, p_kind text)
returns jsonb
language sql
stable
as $$
  select jsonb_build_object(
           'image',           coalesce(lp.url, ''),
           'hash_code_image', coalesce(lp.blurhash, '')
         )
    from public.lawn_photos lp
   where lp.lawn_id = p_lawn_id
     and lp.photo_kind = p_kind
   order by lp.sort_order
   limit 1;
$$;

-- ── users ────────────────────────────────────────────────────────────
-- v1 `users` doc: scalar fields + user_profile struct + group_detail array
create or replace view public.v1_users
with (security_invoker = true) as
select
  p.id::text                                   as id,
  p.email,
  p.display_name,
  p.id::text                                   as uid,
  p.created_at                                 as created_time,
  p.phone_number,
  p.state,
  p.region,
  p.total_lawns,
  bl.name                                      as shirt_level,
  p.is_hall_of_fame,
  coalesce(r.role::text, 'member')             as role,
  p.updated_at,
  p.total_hours,
  jsonb_build_object(
    'image',           coalesce(p.photo_url, ''),
    'hash_code_image', coalesce(p.photo_blurhash, '')
  )                                            as user_profile,
  p.photo_url,
  p.is_group,
  coalesce(
    (select jsonb_agg(jsonb_build_object(
        'child_name', c.name,
        'shirt_size', coalesce(c.shirt_size, ''),
        'gender',     coalesce(initcap(c.gender::text), '')
      ) order by c.created_at)
       from public.children c
      where c.profile_id = p.id),
    '[]'::jsonb
  )                                            as group_detail,
  coalesce(initcap(p.gender::text), '')        as gender,
  p.child_name
from public.profiles p
left join public.badge_levels bl on bl.id = p.current_badge_level_id
left join public.user_roles   r  on r.profile_id = p.id;

-- ── lawns ────────────────────────────────────────────────────────────
-- v1 `lawns` doc: the four-slot `photos` struct rebuilt from lawn_photos rows
create or replace view public.v1_lawns
with (security_invoker = true) as
select
  l.id::text                  as id,
  l.profile_id::text          as user_ref,
  l.who_for,
  l.hours_taken,
  jsonb_build_object(
    'before',    public._v1_photo(l.id, 'before'),
    'after',     public._v1_photo(l.id, 'after'),
    'action',    public._v1_photo(l.id, 'action'),
    'homeowner', public._v1_photo(l.id, 'homeowner')
  )                           as photos,
  l.status::text              as status,
  l.verified_by::text         as verified_by,
  l.verified_at,
  l.created_at,
  l.notes,
  l.updated_at
from public.lawns l;

-- ── shirt_requests -> badge_requests ─────────────────────────────────
create or replace view public.v1_shirt_requests
with (security_invoker = true) as
select
  br.id::text                    as id,
  br.profile_id::text            as user_ref,
  br.child_name,
  br.state,
  br.region,
  bl.name                        as shirt_level,
  br.is_group,
  br.lawn_count_at_request,
  br.status::text                as status,
  br.created_at,
  br.updated_at                  as update_at,   -- v1 field name
  coalesce(
    (select jsonb_agg(jsonb_build_object(
        'child_name', rc.name,
        'shirt_size', coalesce(rc.shirt_size, ''),
        'gender',     coalesce(initcap(rc.gender::text), '')
      ))
       from public.badge_request_children rc
      where rc.badge_request_id = br.id),
    '[]'::jsonb
  )                              as group_detail,
  p.display_name                 as name
from public.badge_requests br
left join public.badge_levels bl on bl.id = br.badge_level_id
left join public.profiles     p  on p.id = br.profile_id;

-- ── shirt_levels -> badge_levels ─────────────────────────────────────
-- min_lawns is deliberately cast back to text: v1 stored it as a String.
create or replace view public.v1_shirt_levels
with (security_invoker = true) as
select
  bl.id::text        as id,
  bl.min_lawns::text as min_lawns,
  bl.description,
  bl.image_url,
  bl.name
from public.badge_levels bl;

-- ── announcement ─────────────────────────────────────────────────────
create or replace view public.v1_announcement
with (security_invoker = true) as
select
  a.id::text     as id,
  a.title,
  a.description,
  a.type::text   as type,
  a.article_link,
  jsonb_build_object(
    'image',           coalesce(a.image_url, ''),
    'hash_code_image', coalesce(a.image_blurhash, '')
  )              as image_detail,
  a.created_at,
  a.updated_at   as update_at,   -- v1 field name
  a.video_link
from public.announcements a;

-- ── notifications ────────────────────────────────────────────────────
-- v1 named the recipient reference `notification`.
create or replace view public.v1_notifications
with (security_invoker = true) as
select
  n.id::text               as id,
  n.profile_id::text       as notification,
  n.title,
  n.body,
  n.type,
  n.badge_request_id::text as shirt_request_ref,
  p.state,
  p.region,
  bl.name                  as shirt_level,
  n.status,
  n.is_read,
  n.created_at,
  p.display_name           as user_name
from public.notifications n
left join public.profiles     p  on p.id = n.profile_id
left join public.badge_levels bl on bl.id = n.badge_level_id;

-- ── admins -> user_roles + profiles ──────────────────────────────────
create or replace view public.v1_admins
with (security_invoker = true) as
select
  r.profile_id::text as id,
  r.profile_id::text as user_ref,
  p.email,
  p.display_name     as name,
  p.photo_url,
  r.role::text       as role,
  r.active,
  r.assigned_region,
  r.created_at
from public.user_roles r
join public.profiles p on p.id = r.profile_id
where r.role in ('admin', 'super_admin');

-- ── settings ─────────────────────────────────────────────────────────
-- v1 kept three lookup tables as arrays on one document. Rebuild them.
create or replace view public.v1_settings
with (security_invoker = true) as
select
  'settings'::text               as id,
  s.max_lawn_photos,
  s.auto_badge_unlock            as auto_shirt_unlock,
  true                           as auto_leaderboard_refresh,
  0                              as refresh_interval_hours,
  s.allow_dynamic_categories,
  coalesce((select array_agg(mc.name order by mc.sort_order, mc.name)
              from public.mowed_categories mc), '{}')          as allow_mowed_categories,
  coalesce((select array_agg(us.name order by us.name)
              from public.us_states us), '{}')                 as list_state,
  coalesce((select jsonb_agg(jsonb_build_object(
              'title',  t.title,
              'detail', coalesce(t.detail, ''))
            order by t.sort_order)
              from public.find_lawn_tips t), '[]'::jsonb)      as find_lawns
from public.app_settings s;

-- ── leaderboards ─────────────────────────────────────────────────────
-- v1 stored one doc per region holding a top_users[] array. Rebuild that
-- shape from the live leaderboard, so it can never go stale.
create or replace view public.v1_leaderboards
with (security_invoker = true) as
select
  lb.region                       as id,
  lb.region,
  now()                           as last_updated,
  lb.top_users,
  fm.profile_id::text             as star_of_month
from (
  select
    coalesce(l.region, '') as region,
    jsonb_agg(jsonb_build_object(
      'user_ref',        l.profile_id::text,
      'name',            coalesce(l.display_name, ''),
      'photo_url',       coalesce(l.photo_url, ''),
      'total_lawns',     l.total_lawns,
      'state',           coalesce(l.state, ''),
      'hash_code_image', coalesce(l.photo_blurhash, ''),
      'total_hours',     l.total_hours
    ) order by l.region_rank) as top_users
  from public.leaderboard l
  where l.region_rank <= 50
  group by coalesce(l.region, '')
) lb
left join public.featured_members fm
       on fm.region = lb.region
      and fm.month = date_trunc('month', current_date)::date;

grant select on public.v1_users          to anon, authenticated;
grant select on public.v1_lawns          to anon, authenticated;
grant select on public.v1_shirt_requests to anon, authenticated;
grant select on public.v1_shirt_levels   to anon, authenticated;
grant select on public.v1_announcement   to anon, authenticated;
grant select on public.v1_notifications  to anon, authenticated;
grant select on public.v1_admins         to anon, authenticated;
grant select on public.v1_settings       to anon, authenticated;
grant select on public.v1_leaderboards   to anon, authenticated;
