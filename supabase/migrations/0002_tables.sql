-- 0002_tables.sql
-- The full relational schema. Ordered by FK dependency.
-- Source-of-truth mapping from Firestore: docs/backend-schema.json

-- ─────────────────────────────────────────────────────────────────────────
-- Lookup tables. In v1 these were arrays inside the single `settings` doc.
-- ─────────────────────────────────────────────────────────────────────────

-- was settings.list_state (string[])
create table public.us_states (
  code text primary key,
  name text not null
);

-- was settings.allow_mowed_categories (string[])
create table public.mowed_categories (
  id         integer generated always as identity primary key,
  name       text not null unique,
  sort_order integer not null default 0
);

-- was settings.find_lawns (FindLawns[])
create table public.find_lawn_tips (
  id         integer generated always as identity primary key,
  title      text not null,
  detail     text,
  sort_order integer not null default 0
);

-- was the `shirt_levels` collection.
-- min_lawns was a STRING in Firestore; it is an integer here.
create table public.badge_levels (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  min_lawns   integer not null check (min_lawns >= 0),
  description text,
  image_url   text,
  sort_order  integer not null default 0
);

-- the scalar remainder of the `settings` doc, constrained to a single row
create table public.app_settings (
  id                       boolean primary key default true,
  max_lawn_photos          integer not null default 4 check (max_lawn_photos > 0),
  auto_badge_unlock        boolean not null default false,
  allow_dynamic_categories boolean not null default false,
  updated_at               timestamptz not null default now(),
  constraint app_settings_singleton check (id)
);

-- ─────────────────────────────────────────────────────────────────────────
-- People
-- ─────────────────────────────────────────────────────────────────────────

-- was the `users` collection. id == auth.users.id (was the Firestore doc id).
create table public.profiles (
  id                     uuid primary key references auth.users(id) on delete cascade,
  email                  text not null,
  display_name           text,
  phone_number           text,
  state                  text,
  region                 text,
  gender                 public.gender,
  child_name             text,
  photo_url              text,
  photo_blurhash         text,
  is_group               boolean not null default false,
  is_hall_of_fame        boolean not null default false,
  -- derived from total_lawns by a trigger; never written by the client
  current_badge_level_id uuid references public.badge_levels(id) on delete set null,
  -- maintained by recalc_profile_totals(); never written by the client
  total_lawns            integer not null default 0,
  total_hours            numeric(10, 2) not null default 0,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now()
);
create index profiles_region_rank_idx on public.profiles (region, total_lawns desc);
create index profiles_rank_idx        on public.profiles (total_lawns desc);
create index profiles_hall_of_fame_idx on public.profiles (is_hall_of_fame) where is_hall_of_fame;

-- was users.group_detail (JoinGroup[])
create table public.children (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  name       text not null,
  shirt_size text,
  gender     public.gender,
  created_at timestamptz not null default now()
);
create index children_profile_idx on public.children (profile_id);

-- replaces the world-readable `admins` collection
create table public.user_roles (
  profile_id      uuid primary key references public.profiles(id) on delete cascade,
  role            public.app_role not null default 'member',
  assigned_region text,
  active          boolean not null default true,
  created_at      timestamptz not null default now()
);
create index user_roles_active_role_idx on public.user_roles (role) where active;

-- ─────────────────────────────────────────────────────────────────────────
-- Lawns — the core record
-- ─────────────────────────────────────────────────────────────────────────

create table public.lawns (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles(id) on delete cascade,
  who_for     text,
  hours_taken numeric(6, 2) check (hours_taken >= 0),
  status      public.lawn_status not null default 'pending',
  verified_by uuid references public.profiles(id) on delete set null,
  verified_at timestamptz,
  notes       text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index lawns_profile_status_idx  on public.lawns (profile_id, status);
create index lawns_profile_created_idx on public.lawns (profile_id, created_at desc);
create index lawns_review_queue_idx    on public.lawns (status, created_at desc);

-- was the nested LawnsPhotos struct {before, after, action, homeowner}.
-- A child table, not fixed columns: max_lawn_photos is configurable and the v2
-- flow uses different photo steps (lawnpic / action / safety).
create table public.lawn_photos (
  id         uuid primary key default gen_random_uuid(),
  lawn_id    uuid not null references public.lawns(id) on delete cascade,
  photo_kind text not null,
  url        text not null,
  blurhash   text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);
create index lawn_photos_lawn_idx on public.lawn_photos (lawn_id, sort_order);

-- ─────────────────────────────────────────────────────────────────────────
-- Badges (was "shirts")
-- ─────────────────────────────────────────────────────────────────────────

create table public.badge_requests (
  id                    uuid primary key default gen_random_uuid(),
  profile_id            uuid not null references public.profiles(id) on delete cascade,
  badge_level_id        uuid references public.badge_levels(id) on delete set null,
  child_name            text,
  -- state/region are snapshots taken at request time, not joins
  state                 text,
  region                text,
  is_group              boolean not null default false,
  lawn_count_at_request integer not null default 0,
  status                public.badge_request_status not null default 'pending',
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()   -- was `update_at`
);
create index badge_requests_profile_idx on public.badge_requests (profile_id, created_at desc);
create index badge_requests_queue_idx   on public.badge_requests (status, created_at desc);

-- was shirt_requests.group_detail (JoinGroup[])
create table public.badge_request_children (
  id               uuid primary key default gen_random_uuid(),
  badge_request_id uuid not null references public.badge_requests(id) on delete cascade,
  name             text not null,
  shirt_size       text,
  gender           public.gender
);
create index badge_request_children_req_idx on public.badge_request_children (badge_request_id);

-- ─────────────────────────────────────────────────────────────────────────
-- Content and messaging
-- ─────────────────────────────────────────────────────────────────────────

-- was the `announcement` collection (singular in v1)
create table public.announcements (
  id             uuid primary key default gen_random_uuid(),
  title          text not null,
  description    text,
  type           public.announcement_type not null default 'article',
  article_link   text,
  video_link     text,
  image_url      text,
  image_blurhash text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()   -- was `update_at`
);
create index announcements_created_idx on public.announcements (created_at desc);

create table public.notifications (
  -- was the confusingly named `notification` field: this is the RECIPIENT
  id               uuid primary key default gen_random_uuid(),
  profile_id       uuid not null references public.profiles(id) on delete cascade,
  title            text not null,
  body             text,
  type             text,
  badge_request_id uuid references public.badge_requests(id) on delete set null,
  badge_level_id   uuid references public.badge_levels(id) on delete set null,
  status           text,
  is_read          boolean not null default false,
  created_at       timestamptz not null default now()
);
create index notifications_inbox_idx on public.notifications (profile_id, is_read, created_at desc);

-- was leaderboards.star_of_month — the only part of that collection a view
-- cannot derive, because it is an editorial pick
create table public.featured_members (
  id         uuid primary key default gen_random_uuid(),
  region     text not null,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  month      date not null,
  created_at timestamptz not null default now(),
  unique (region, month)
);

-- was the users/{uid}/fcm_tokens subcollection
create table public.device_tokens (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles(id) on delete cascade,
  fcm_token   text not null unique,
  device_type text,
  created_at  timestamptz not null default now()
);
create index device_tokens_profile_idx on public.device_tokens (profile_id);
