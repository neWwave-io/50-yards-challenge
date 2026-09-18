-- 0010_v2_signup_fields.sql
-- Columns the v2 sign-up collects that the v1-derived schema had nowhere to
-- put. All nullable, so existing rows and the v1 compatibility views in
-- 0009 are unaffected.

-- How the signing-up adult relates to the child: Parents | Guardian | Relative.
-- Left as text rather than an enum because the option list is still in flux.
alter table public.profiles
  add column if not exists relationship text;

-- v1 never asked for a birthday. Date, not timestamptz: a birthday has no
-- time and must not shift across time zones.
alter table public.children
  add column if not exists date_of_birth date;

-- Each child now gets their own picture, stored in the `avatars` bucket
-- alongside the parent's.
alter table public.children
  add column if not exists photo_url text;

comment on column public.profiles.relationship is
  'v2 sign-up step 1: Parents | Guardian | Relative.';
comment on column public.children.date_of_birth is
  'v2 sign-up step 2. Date only — a birthday must not shift by time zone.';
comment on column public.children.photo_url is
  'Public URL in the `avatars` bucket.';
