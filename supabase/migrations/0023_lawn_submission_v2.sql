-- 0023_lawn_submission_v2.sql
-- The v2 submit flow asks for three things v1 never stored:
--   service           — what was done ("Lawn Mowing", …); free text so the
--                        list can change without a migration
--   mowed_on          — the day the work was done, which may be before the
--                        day it is submitted (created_at)
--   wore_safety_gear  — the Safety Check answer
--
-- Photos stay in lawn_photos, one row per shot. Kinds used by v2:
--   before, after      — Lawn Differences
--   action, homeowner  — My Action (kept from v1 so old rows still read)
--   safety             — Safety Check, the child in their gear

alter table public.lawns
  add column if not exists service          text,
  add column if not exists mowed_on         date,
  add column if not exists wore_safety_gear boolean;

-- A lawn cannot be done in the future.
alter table public.lawns
  drop constraint if exists lawns_mowed_on_not_future;
alter table public.lawns
  add constraint lawns_mowed_on_not_future
  check (mowed_on is null or mowed_on <= (now() at time zone 'utc')::date + 1);
