-- 0008_migration_tooling.sql
-- Scaffolding for the Firestore -> Postgres data import.
-- See docs/backend-schema.json -> id_mapping.

create schema if not exists migration;

-- Firestore stores relationships as DocumentReference PATHS ("users/abc123").
-- Postgres needs UUIDs. Pass 1 fills this table for every document; pass 2
-- uses it to resolve every reference into a real foreign key.
--
-- For the `users` collection the uuid is NOT freshly generated — it is the
-- auth.users.id produced by the auth import, which therefore must run first.
create table migration.id_map (
  collection   text not null,
  firestore_id text not null,
  uuid         uuid not null,
  imported_at  timestamptz not null default now(),
  primary key (collection, firestore_id)
);
create index id_map_uuid_idx on migration.id_map (uuid);

-- Original Firebase Storage URLs, kept so the rewrite to Supabase Storage
-- URLs is reversible if the file copy turns out to be incomplete.
create table migration.storage_url_map (
  firebase_url text primary key,
  supabase_url text,
  bucket       text,
  object_path  text,
  copied_at    timestamptz
);

-- Anything the transform could not map cleanly: unexpected enum values,
-- orphaned references, unparseable min_lawns, profile photo conflicts.
create table migration.import_issues (
  id           bigint generated always as identity primary key,
  collection   text,
  firestore_id text,
  field        text,
  raw_value    text,
  issue        text not null,
  noted_at     timestamptz not null default now()
);

comment on schema migration is
  'Firestore -> Postgres import scaffolding. Safe to drop once the cutover is verified and the rollback window has passed.';
