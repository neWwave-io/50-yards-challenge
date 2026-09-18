# Firebase → Supabase Migration

> Written 2026-09-18. Companion to [MIGRATION_PLAN.md](MIGRATION_PLAN.md) and
> [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md).
> Supabase project already exists. Nothing has been migrated yet.

---

## 0. The single most important decision

**Do the Supabase migration and the v2 rewrite as ONE piece of work, not two.**

The v2 plan already introduces a `data/repositories/` layer as the seam between screens and the
backend. That seam is exactly where Firebase gets swapped for Supabase. If we build those
repositories against Supabase from day one, the v2 screens never touch Firebase and we migrate
once. If we do them separately we rewrite the same data layer twice.

So the revised order is: **schema + RLS in Supabase → repositories against Supabase → v2 screens
on top → data cutover → delete Firebase.**

---

## 1. What actually moves

| Firebase service | Supabase equivalent | Difficulty |
| --- | --- | --- |
| Firestore (9 collections) | Postgres tables | **Hard** — document → relational is a data-model rewrite |
| Firebase Auth (email, Google, Apple, anon) | Supabase Auth | Medium — all four are supported; password hashes need care |
| Firebase Storage | Supabase Storage | Easy — copy files, rewrite URLs |
| Cloud Functions | Edge Functions (Deno) + Postgres triggers | Medium |
| Firestore security rules | Row Level Security | **This is the big win** — see §5 |
| **FCM (push)** | **No Supabase equivalent** | See §7 — Firebase does not fully go away |
| Firebase Performance | Drop it, or Sentry | Easy |

### Flutter packages

Remove: `cloud_firestore`, `firebase_auth`, `firebase_storage`, `cloud_functions`,
`firebase_performance` (+ all their `_web` / `_platform_interface` siblings — roughly 20 entries
in `pubspec.yaml`).

Add: `supabase_flutter`.

**Keep:** `firebase_core` + `firebase_messaging` — only for push. See §7.

---

## 2. Proposed Postgres schema

This is a redesign, not a transliteration. Firestore's shape forced compromises that Postgres
does not. The wins are marked.

```sql
-- ── enums ────────────────────────────────────────────────────────────
create type lawn_status         as enum ('pending','approved','rejected');
create type badge_request_status as enum ('pending','approved','rejected','done');
create type announcement_type   as enum ('article','video');
create type gender              as enum ('male','female');
create type app_role            as enum ('member','admin','super_admin');

-- ── profiles (was `users`) ───────────────────────────────────────────
create table profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  email         text not null,
  display_name  text,
  phone_number  text,
  state         text,
  region        text,
  gender        gender,
  child_name    text,
  photo_url     text,
  is_hall_of_fame boolean not null default false,
  is_group      boolean not null default false,
  -- maintained by trigger, NEVER writable by the client (see §5)
  total_lawns   integer not null default 0,
  total_hours   numeric not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- ── children  ◀ WIN: replaces the groupDetail JoinGroup[] array ──────
create table children (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  name       text not null,
  shirt_size text,
  gender     gender
);

-- ── lawns ────────────────────────────────────────────────────────────
create table lawns (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid not null references profiles(id) on delete cascade,
  who_for      text,
  hours_taken  numeric,
  status       lawn_status not null default 'pending',
  verified_by  uuid references profiles(id),
  verified_at  timestamptz,
  notes        text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index on lawns (profile_id, status);
create index on lawns (status, created_at desc);

-- ── lawn_photos  ◀ replaces the nested LawnsPhotos struct ────────────
-- A child table rather than four fixed columns: app_settings.max_lawn_photos is
-- configurable, and the v2 Figma flow has a different set of photo steps
-- (lawnpic / action / safety) than v1's before/after/action/homeowner.
create table lawn_photos (
  id         uuid primary key default gen_random_uuid(),
  lawn_id    uuid not null references lawns(id) on delete cascade,
  photo_kind text not null,          -- before | after | action | homeowner | ...
  url        text not null,
  blurhash   text,
  sort_order integer not null default 0
);
create index on lawn_photos (lawn_id);

-- ── badge_levels (was `shirt_levels`) ◀ WIN: min_lawns is an int now ─
create table badge_levels (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,          -- starter, orange, green, blue, red, black
  min_lawns   integer not null,       -- was a STRING in Firestore
  description text,
  image_url   text,
  sort_order  integer not null
);

-- ── badge_requests (was `shirt_requests`) ────────────────────────────
create table badge_requests (
  id                    uuid primary key default gen_random_uuid(),
  profile_id            uuid not null references profiles(id) on delete cascade,
  badge_level_id        uuid not null references badge_levels(id),
  child_name            text,
  state                 text,
  region                text,
  is_group              boolean not null default false,
  lawn_count_at_request integer not null,
  status                badge_request_status not null default 'pending',
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create table badge_request_children (
  id               uuid primary key default gen_random_uuid(),
  badge_request_id uuid not null references badge_requests(id) on delete cascade,
  name             text not null,
  shirt_size       text,
  gender           gender
);

-- ── announcements ────────────────────────────────────────────────────
create table announcements (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  description  text,
  type         announcement_type not null,
  article_link text,
  video_link   text,
  image_url    text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ── notifications ────────────────────────────────────────────────────
create table notifications (
  id               uuid primary key default gen_random_uuid(),
  profile_id       uuid not null references profiles(id) on delete cascade,
  title            text not null,
  body             text,
  type             text,
  badge_request_id uuid references badge_requests(id) on delete set null,
  state            text,
  region           text,
  is_read          boolean not null default false,
  created_at       timestamptz not null default now()
);
create index on notifications (profile_id, is_read, created_at desc);

-- ── roles  ◀ WIN: replaces the world-readable `admins` collection ────
create table user_roles (
  profile_id      uuid primary key references profiles(id) on delete cascade,
  role            app_role not null default 'member',
  assigned_region text,
  active          boolean not null default true,
  created_at      timestamptz not null default now()
);
-- surfaced into the JWT via a custom access token hook, so RLS can read it cheaply

-- ── lookups (were arrays inside the single `settings` doc) ───────────
create table mowed_categories (id serial primary key, name text unique not null);
create table us_states        (code text primary key, name text not null);
create table find_lawn_tips   (id serial primary key, title text, detail text, sort_order int);

create table app_settings (
  id                       boolean primary key default true check (id),
  max_lawn_photos          integer not null default 4,
  auto_badge_unlock        boolean not null default false,
  allow_dynamic_categories boolean not null default false
);

-- ── featured_members  ◀ the only part of `leaderboards` that survives ─
-- star_of_month is an editorial pick, so the leaderboard view cannot derive it.
create table featured_members (
  id         uuid primary key default gen_random_uuid(),
  region     text not null,
  profile_id uuid not null references profiles(id) on delete cascade,
  month      date not null,
  unique (region, month)
);

-- ── device tokens (was the fcm_tokens subcollection) ─────────────────
create table device_tokens (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references profiles(id) on delete cascade,
  fcm_token   text unique not null,
  device_type text,
  created_at  timestamptz not null default now()
);
```

### ◀ The biggest win: `leaderboards` disappears entirely

In Firestore the leaderboard is a denormalized `topUsers[]` array that a client or a cron job has
to rebuild. In Postgres it is a query:

```sql
create view leaderboard as
select
  p.id, p.display_name, p.photo_url, p.state, p.region,
  p.total_lawns, p.total_hours,
  rank() over (partition by p.region order by p.total_lawns desc) as region_rank,
  rank() over (order by p.total_lawns desc)                        as global_rank
from profiles p
where p.total_lawns > 0;
```

That deletes a collection, the `TopUsersStruct`, the `top10Leaderboard()` custom function, the
whole `leaderboard_admin` refresh flow, and the `autoLeaderboardRefresh` / `refreshIntervalHours`
settings. It is always correct and never stale.

### ◀ Second win: `total_lawns` becomes server-authoritative

Today any client can write their own `totalLawns`. In Postgres:

```sql
create function recalc_profile_totals() returns trigger as $$
begin
  update profiles p set
    total_lawns = (select count(*)             from lawns l
                   where l.profile_id = p.id and l.status = 'approved'),
    total_hours = (select coalesce(sum(hours_taken),0) from lawns l
                   where l.profile_id = p.id and l.status = 'approved')
  where p.id = coalesce(new.profile_id, old.profile_id);
  return null;
end $$ language plpgsql security definer;

create trigger lawns_recalc after insert or update or delete on lawns
  for each row execute function recalc_profile_totals();
```

Combined with an RLS policy that forbids clients writing those columns, the counts become
impossible to forge.

---

## 3. Naming: shirt → badge

v2 Figma renames shirts to **badges** (`EarnedBadge`, `Request a Badge`, `add-badge-page`).
Since we are rebuilding the schema from scratch anyway, the new tables use `badge_*`. There is no
migration cost — it is a rename during the data transform, done once.

---

## 4. Field-by-field mapping

**The complete, machine-readable version is [backend-schema.json](backend-schema.json)** — all 85
fields with their current type, what they mean today, what they become, and the transform. It is
generated with a coverage check, so no field can be silently forgotten. The table below is the
summary.

| Firestore | Postgres | Note |
| --- | --- | --- |
| `users` | `profiles` | `uid` drops (it's the PK) |
| `users.groupDetail[]` | `children` table | array → rows |
| `users.role` | `user_roles.role` | |
| `users.totalLawns/.totalHours` | trigger-maintained columns | no longer client-writable |
| `lawns.photos.{before,after,action,homeowner}` | `lawn_photos` rows | struct → child table |
| `lawns.userRef` (DocumentReference) | `profile_id uuid` FK | needs ID mapping, see §6 |
| `shirt_levels.minLawns` (String) | `badge_levels.min_lawns` (int) | **type fix** |
| `shirt_requests` | `badge_requests` | renamed |
| `shirt_requests.groupDetail[]` | `badge_request_children` | array → rows |
| `leaderboards` | `leaderboard` **view** | collection deleted |
| `leaderboards.star_of_month` | `featured_members` | the one part a view can't derive |
| `admins` | `user_roles` + JWT claim | collection deleted |
| `settings.allowMowedCategories[]` | `mowed_categories` table | |
| `settings.listState[]` | `us_states` table | |
| `settings.findLawns[]` | `find_lawn_tips` table | |
| `settings` (rest) | `app_settings` single row | |
| `announcement` | `announcements` | pluralized |
| `fcm_tokens` subcollection | `device_tokens` | |

---

## 5. RLS — this fixes the repo's worst problem

Today [firestore.rules](../firebase/firestore.rules) is `allow read: if true` on almost
everything. Every collection, including children's PII, is world-readable. RLS replaces it with
default-deny:

```sql
alter table profiles enable row level security;

-- a member reads and edits only their own profile
create policy "own profile read"  on profiles for select
  using (auth.uid() = id);
create policy "own profile write" on profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- admins read everything in their region
create policy "admin read" on profiles for select
  using ( (auth.jwt() ->> 'app_role') in ('admin','super_admin') );

-- a member creates and reads only their own lawns; only admins may verify
create policy "own lawns" on lawns for all
  using (auth.uid() = profile_id) with check (auth.uid() = profile_id);
create policy "admin verify lawns" on lawns for update
  using ( (auth.jwt() ->> 'app_role') in ('admin','super_admin') );
```

Two things to build carefully:
- **Column-level protection** so `total_lawns` / `total_hours` / `status` are not writable by
  members. Use a `before update` trigger that reverts protected columns, or split writes behind
  a `security definer` RPC.
- **Leaderboard visibility.** The leaderboard is public by design but exposes children's names
  and photos. Decide what a non-admin may see — probably display name + photo + count, never
  email, phone, or state/region precise enough to locate a child. This is a safeguarding
  question, not just a technical one.

---

## 6. Data migration mechanics

Supabase's documented path is three Node scripts —
`collections.js` (list), `firestore2json.js` (export), `json2supabase.js` (import) — and the
docs are explicit that they map **one collection to one table** with only
`text` / `numeric` / `boolean` / `jsonb` columns. Our schema is relational, so the middle step is
ours to write.

**Plan: export to JSON, transform with our own script, then `COPY` into Postgres.**

```
firebase export ──► raw JSON per collection
        │
        ▼
  transform script (Node or Dart)
        │  • allocate a uuid per Firestore doc id
        │  • keep an id_map table: (collection, firestore_id, uuid)
        │  • resolve DocumentReference paths → uuid FKs via id_map
        │  • explode groupDetail[] → children rows
        │  • flatten photos struct → 4 url columns
        │  • parse minLawns String → int
        │  • rename shirt → badge
        ▼
  CSV / SQL ──► psql \copy into Supabase
```

The `id_map` table is the crux. Firestore stores relationships as `DocumentReference` paths
(`users/abc123`); Postgres needs UUIDs. Build the map first, in one pass over all collections,
then resolve references in a second pass. Keep the map after migration — it makes verification
and any re-run possible.

Order of import (FK dependencies): `profiles` → `children` → `badge_levels` → `lawns` →
`badge_requests` → `badge_request_children` → `announcements` → `notifications` → lookups.

### Auth status (as of 2026-09-18)

| Method | State |
| --- | --- |
| Email / password | ✅ Enabled and tested end to end. Confirmation is **off**, so signup returns a session immediately, matching v1. |
| Google | ⬜ Needs a client ID + secret in the dashboard plus matching native config. Use `signInWithIdToken`. |
| Apple | ⬜ Needs a Services ID + key from the Apple Developer account. |
| Anonymous | ❌ **Dropped.** Nothing in the v1 UI ever called it — it was FlutterFlow scaffolding. |
| GitHub / JWT | ❌ Dropped — scaffolding, never used. |

A new signup automatically gets a `profiles` row and a `member` row in `user_roles`,
via the `handle_new_user` trigger. Verified against the live API.

### Auth users

Firebase hashes passwords with a modified **scrypt**; Supabase uses **bcrypt**. They are not
interchangeable, and this is the one step that can force a password reset on your whole user
base if handled wrong.

The path that preserves passwords:
1. In Firebase Console → Authentication → Users → ⋮ → **Password hash parameters**, copy
   `base64_signer_key`, `base64_salt_separator`, `rounds`, `mem_cost`.
2. Export users (including `passwordHash` and `salt`) via the Admin SDK.
3. Import into `auth.users` with the Firebase scrypt parameters, using the
   `supabase-community/firebase-to-supabase` auth tooling.

**Verify this on a handful of throwaway accounts before committing to a cutover date.** If
password preservation turns out not to work on the current tooling, the fallback is a forced
password-reset email to every user — workable, but it needs to be a deliberate decision and a
comms plan, not a surprise on launch day.

Google and Apple users are simpler: they re-link by email on first sign-in, no password involved.
Make sure the email on the Supabase side matches, or you get duplicate accounts.

### Storage

Copy `gs://the-50-yard-challenge...` objects into Supabase Storage buckets
(`lawn-photos`, `avatars`, `announcements`), then rewrite the URL columns. Do the copy while the
app still runs on Firebase — it is the slowest step and it is safely repeatable. Run a final
delta copy during the cutover window.

---

## 7. Push notifications — Firebase does NOT fully go away

Supabase has no push service. The documented approach is: Postgres trigger → Supabase Edge
Function → FCM HTTP v1 API → device.

So `firebase_core` and `firebase_messaging` stay in `pubspec.yaml`, and the Firebase project
stays alive for FCM only. Everything else — Firestore, Auth, Storage, Functions — goes.

The current [firebase/functions/index.js](../firebase/functions/index.js) FCM logic ports
directly to an Edge Function; the `fcm_tokens` subcollection becomes the `device_tokens` table.

If you want Firebase gone completely, the alternative is OneSignal — but it still uses FCM on
Android and APNs on iOS underneath, so it trades a Firebase dependency for a vendor dependency.
My recommendation is **keep FCM**. It works, it is free, and it is the smallest surface to leave
behind.

---

## 8. The real risk for THIS app: offline

Firestore has offline persistence built in. **Supabase does not.**

That matters here more than in most apps: kids are submitting lawns *outdoors*, uploading four
photos each, often on weak rural signal. Today Firestore silently queues that write and syncs it
later. After migration, a failed upload is just a failed upload.

We need to build what Firestore was giving us for free:
- A local queue (`drift` or `sqflite`) holding pending lawn submissions and their photo files
- Background retry with exponential backoff
- Clear UI state: "saved, will upload when you're back online"

This is not optional — it is the difference between a kid losing an hour of work and not. Budget
real time for it in the submit-lawn screen.

Secondary: Firestore `snapshots()` streams become Supabase Realtime subscriptions. Realtime has
per-plan connection limits, so subscribe narrowly (one channel for the member's own notifications,
not a firehose on every table).

---

## 9. Execution order

### Phase A — Build (no downtime, app keeps running on Firebase)
- [ ] Write the schema as versioned migrations in `supabase/migrations/`
- [ ] Write RLS policies + a test suite that asserts a member **cannot** read another member's row
- [ ] Custom access token hook to put `app_role` in the JWT
- [ ] Triggers: `recalc_profile_totals`, protected-column guard, `updated_at`
- [ ] `leaderboard` view
- [ ] Seed lookups (`us_states`, `mowed_categories`, `badge_levels`, `find_lawn_tips`)
- [ ] Edge Function for push + `device_tokens`
- [ ] Storage buckets + policies

### Phase B — Flutter data layer
- [ ] Add `supabase_flutter`, initialize alongside Firebase
- [ ] Build `data/models` + `data/repositories` against Supabase
- [ ] Build the offline queue (§8)
- [ ] Auth service: email, Google (`signInWithIdToken`), Apple, anonymous

### Phase C — Data transform (rehearse repeatedly)
- [ ] Export script + `id_map`
- [ ] Transform script
- [ ] **Dry run into a Supabase branch**, then diff counts against Firestore
- [ ] Auth import test on throwaway accounts — confirm old passwords work
- [ ] Bulk storage copy

### Phase D — Cutover (one maintenance window)
- [ ] Freeze writes (ship a "back in 30 minutes" build or a remote kill switch)
- [ ] Final delta export + import + storage delta
- [ ] Flip the app to Supabase, release
- [ ] Keep Firebase **read-only, not deleted**, for at least 30 days

### Phase E — Cleanup
- [ ] Delete Firestore data, Firebase Auth, Storage, Functions
- [ ] Keep only the FCM half of the Firebase project
- [ ] Remove ~20 Firebase packages from `pubspec.yaml`

**Recommendation: big-bang cutover, not dual-write.** Dual-write doubles the code and introduces
consistency bugs. This app's data is small and its users are not transacting money — a 30-minute
Saturday-morning window is fine and far safer.

---

## 10. What I need from you

1. **Data volume** — how many `users`, `lawns`, `shirt_requests` rows, and roughly how many
   photos / GB in Storage? Decides whether the transform is a laptop script or needs batching.
2. **Is v1 live in the stores?** If yes, the cutover needs a forced-update mechanism, because old
   Firebase builds will keep writing to a dead backend.
3. **Passwords:** if hash import fails verification, is a forced password reset acceptable?
4. **Supabase project access** — the Supabase MCP connector in this session is **not authorized**,
   so I cannot see your project yet. You'll need to authorize it in your claude.ai connector
   settings, or give me the project ref and I'll work through the CLI and migration files instead.
5. **Confirm shirt → badge** rename, and whether it applies to user-facing copy everywhere.

---

## Sources

- [Migrate from Firebase Firestore to Supabase](https://supabase.com/docs/guides/platform/migrating-to-supabase/firestore-data)
- [Migrate from Firebase Auth to Supabase](https://supabase.com/docs/guides/platform/migrating-to-supabase/firebase-auth)
- [supabase-community/firebase-to-supabase](https://github.com/supabase-community/firebase-to-supabase/tree/main/auth)
- [Sending Push Notifications (Supabase Edge Functions)](https://supabase.com/docs/guides/functions/examples/push-notifications)
- [supabase/auth issue #1750 — Firebase scrypt vs bcrypt](https://github.com/supabase/auth/issues/1750)
