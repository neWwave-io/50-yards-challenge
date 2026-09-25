-- 0024_lawn_address.sql
-- The v2 achievement card shows a "Location" row — the street the lawn was
-- on. v1 never stored one, and 0023_lawn_submission_v2.sql did not add it:
-- the submit form does not ask for an address yet.
--
-- The column goes in now so the card can read it, and the card leaves the row
-- out while it is null. Nothing writes it until the submit flow collects one.
--
-- Deliberately not backfilled. An invented address on a real family's lawn is
-- worse than a missing row.

alter table public.lawns
  add column if not exists address text;

comment on column public.lawns.address is
  'Free text, as the child typed it on the submit form. Not geocoded. '
  'Null on every lawn submitted before the form asked for it.';
