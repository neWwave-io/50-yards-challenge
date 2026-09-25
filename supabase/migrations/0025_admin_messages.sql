-- 0025_admin_messages.sql
-- "Contact admin": a family sends a short message to the admin team from the
-- profile page. It is one-way — the design says "Replies are disabled" — so
-- there is no thread and no reply column.
--
-- The family sees each message they sent, tagged with where it stands:
--
--   sent     nobody on the admin team has opened it yet
--   viewed   an admin has read it
--   deleted  an admin has dismissed it. Kept, not removed, so the family can
--            still see that it was seen and dealt with.
--
-- Admins write only viewed_* and deleted_*. The status is derived from them,
-- so it can never disagree with the timestamps.

create table public.admin_messages (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  body       text not null
             check (length(btrim(body)) between 1 and 2000),
  viewed_at  timestamptz,
  viewed_by  uuid references public.profiles(id) on delete set null,
  deleted_at timestamptz,
  deleted_by uuid references public.profiles(id) on delete set null,
  status     text generated always as (
               case
                 when deleted_at is not null then 'deleted'
                 when viewed_at  is not null then 'viewed'
                 else 'sent'
               end
             ) stored,
  created_at timestamptz not null default now()
);

-- the family's own list, newest first
create index admin_messages_profile_created_idx
  on public.admin_messages (profile_id, created_at desc);

-- the admin inbox: everything not yet dismissed, newest first
create index admin_messages_inbox_idx
  on public.admin_messages (created_at desc)
  where deleted_at is null;

comment on table public.admin_messages is
  'One-way messages from a family to the admin team. Admins mark them viewed '
  'or deleted; nothing is ever sent back.';
comment on column public.admin_messages.status is
  'Derived: deleted if deleted_at is set, else viewed if viewed_at is set, '
  'else sent. Never written directly.';
comment on column public.admin_messages.deleted_at is
  'Soft delete by an admin. The row stays so the family still sees it, '
  'tagged Deleted.';
