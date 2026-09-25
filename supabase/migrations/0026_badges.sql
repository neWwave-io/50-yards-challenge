-- 0026_badges.sql
-- Badges, separate from the shirt ladder in `badge_levels`.
--
-- A shirt level is reached by total lawns. A badge is set up by an admin —
-- name, description (the back of the card), picture — and is earned one of
-- two ways:
--
--   lawns    automatically, once the child has `required_lawns` approved
--            lawns for `who_for` (any neighbour when null). E.g. "Golden
--            Kindness: 9 lawns for elderly neighbours".
--   request  for service outside mowing. The child sends a claim with an
--            explanation and a photo; an admin approves or rejects it.
--
-- Lawn progress is not stored: profile_badges() derives it from approved
-- lawns on read, so it never drifts and a changed target applies at once.

create table public.badges (
  id             uuid primary key default gen_random_uuid(),
  name           text not null unique
                 check (length(btrim(name)) between 1 and 80),
  -- shown when the card is flipped
  description    text check (length(description) <= 500),
  -- public URL in the `badges` bucket
  image_url      text,
  earned_by      text not null default 'lawns'
                 check (earned_by in ('lawns', 'request')),
  required_lawns integer check (required_lawns > 0),
  -- one of the six neighbour kinds the app draws; null means any lawn
  who_for        text check (who_for in (
                   'elderly', 'single_parent', 'active_duty',
                   'veteran', 'first_responder', 'disabled'
                 )),
  sort_order     integer not null default 0,
  -- lets an admin retire a badge without losing who earned it
  is_active      boolean not null default true,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  -- a lawn badge needs a target; a requested one has none
  constraint badges_target_matches_kind check (
    (earned_by = 'lawns'   and required_lawns is not null) or
    (earned_by = 'request' and required_lawns is null and who_for is null)
  )
);

create index badges_active_order_idx on public.badges (sort_order) where is_active;

create trigger badges_set_updated_at before update on public.badges
  for each row execute function public.set_updated_at();

comment on table public.badges is
  'Admin-defined badges. earned_by = lawns: earned automatically with '
  'required_lawns approved lawns for who_for. earned_by = request: claimed '
  'with proof in badge_claims and approved by an admin. Distinct from the '
  'shirt ladder in badge_levels.';
comment on column public.badges.who_for is
  'elderly | single_parent | active_duty | veteran | first_responder | '
  'disabled, or null for any lawn. Matches MowedCategory in the app.';

-- ─────────────────────────────────────────────────────────────────────────
-- A child's claim for a request-type badge, with the proof an admin checks.
-- ─────────────────────────────────────────────────────────────────────────
create table public.badge_claims (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles(id) on delete cascade,
  badge_id    uuid not null references public.badges(id) on delete cascade,
  explanation text not null
              check (length(btrim(explanation)) between 1 and 1000),
  -- object path in the private `badge-proofs` bucket, not a URL: the photo
  -- is only ever shown to the family and admins, through a signed URL
  photo_path  text,
  status      text not null default 'pending'
              check (status in ('pending', 'approved', 'rejected')),
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- one open or granted claim per badge; a rejected one can be tried again
create unique index badge_claims_one_live_idx
  on public.badge_claims (profile_id, badge_id)
  where status in ('pending', 'approved');

create index badge_claims_queue_idx
  on public.badge_claims (status, created_at desc);

create trigger badge_claims_set_updated_at before update on public.badge_claims
  for each row execute function public.set_updated_at();

-- Only request-type badges can be claimed; a lawn badge is earned by mowing.
create or replace function public.badge_claims_check_kind()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if not exists (
    select 1 from public.badges b
     where b.id = new.badge_id and b.earned_by = 'request' and b.is_active
  ) then
    raise exception 'This badge cannot be requested.'
      using errcode = 'check_violation';
  end if;
  return new;
end;
$$;

create trigger badge_claims_check_kind before insert on public.badge_claims
  for each row execute function public.badge_claims_check_kind();

comment on table public.badge_claims is
  'A request for an earned_by = request badge: an explanation and a proof '
  'photo, approved or rejected by an admin.';

-- ─────────────────────────────────────────────────────────────────────────
-- lawns.who_for is free text, and v1 wrote its own wording ("Deployed
-- Military" for what the design calls Active Duty). Normalise it to the keys
-- above — the same aliases the app's MowedCategory.match uses.
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.who_for_key(p_who_for text)
returns text
language sql
immutable
set search_path = public
as $$
  select case lower(btrim(p_who_for))
    when 'elderly'           then 'elderly'
    when 'single parent'     then 'single_parent'
    when 'active duty'       then 'active_duty'
    when 'deployed military' then 'active_duty'
    when 'veteran'           then 'veteran'
    when 'first responder'   then 'first_responder'
    when 'disabled'          then 'disabled'
    when 'disable'           then 'disabled'
    else null
  end;
$$;

-- ─────────────────────────────────────────────────────────────────────────
-- Every active badge with this profile's standing on it.
--
-- security invoker: once RLS is on a member only sees their own lawns and
-- claims, so asking about someone else returns no progress rather than
-- leaking it.
-- ─────────────────────────────────────────────────────────────────────────
create or replace function public.profile_badges(p_profile_id uuid)
returns table (
  id             uuid,
  name           text,
  description    text,
  image_url      text,
  earned_by      text,
  required_lawns integer,
  who_for        text,
  sort_order     integer,
  progress       integer,
  claim_status   text,
  earned         boolean,
  earned_at      timestamptz
)
language sql
stable
security invoker
set search_path = public
as $$
  with approved as (
    select public.who_for_key(l.who_for) as kind, l.created_at
    from public.lawns l
    where l.profile_id = p_profile_id
      -- a badge is an award, so only lawns an admin has checked count
      and l.status = 'approved'
  )
  select
    b.id, b.name, b.description, b.image_url, b.earned_by,
    b.required_lawns, b.who_for, b.sort_order,
    case when b.earned_by = 'lawns'
         then least(p.done, b.required_lawns) else 0 end::integer as progress,
    c.status as claim_status,
    case when b.earned_by = 'lawns' then p.done >= b.required_lawns
         else coalesce(c.status = 'approved', false) end as earned,
    case when b.earned_by = 'lawns' then
           -- the day the target lawn was approved
           case when p.done >= b.required_lawns then p.reached_at end
         when c.status = 'approved' then c.reviewed_at
    end as earned_at
  from public.badges b
  cross join lateral (
    select count(*)::integer as done,
           (array_agg(a.created_at order by a.created_at))[b.required_lawns]
             as reached_at
    from approved a
    where b.who_for is null or a.kind = b.who_for
  ) p
  left join lateral (
    select bc.status, bc.reviewed_at
    from public.badge_claims bc
    where bc.profile_id = p_profile_id and bc.badge_id = b.id
    order by bc.created_at desc
    limit 1
  ) c on true
  where b.is_active
  order by b.sort_order, b.name;
$$;

grant execute on function public.profile_badges(uuid) to anon, authenticated;

-- ─────────────────────────────────────────────────────────────────────────
-- Storage.
--
-- badges        the artwork. Public to read; only admins add or change it,
--               even in development.
-- badge-proofs  a child's proof photos. PRIVATE from the start — they are
--               pictures of children. A family writes and reads only its own
--               folder (<profile_id>/...); admins read all of them.
-- ─────────────────────────────────────────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('badges', 'badges', true), ('badge-proofs', 'badge-proofs', false)
on conflict (id) do nothing;

create policy badges_bucket_read on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'badges');

create policy badges_bucket_admin_insert on storage.objects
  for insert to authenticated
  with check (bucket_id = 'badges' and public.is_admin());

create policy badges_bucket_admin_update on storage.objects
  for update to authenticated
  using (bucket_id = 'badges' and public.is_admin())
  with check (bucket_id = 'badges' and public.is_admin());

create policy badges_bucket_admin_delete on storage.objects
  for delete to authenticated
  using (bucket_id = 'badges' and public.is_admin());

create policy badge_proofs_insert_own on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'badge-proofs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy badge_proofs_read_own_or_admin on storage.objects
  for select to authenticated
  using (
    bucket_id = 'badge-proofs'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin())
  );

create policy badge_proofs_delete_own on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'badge-proofs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
