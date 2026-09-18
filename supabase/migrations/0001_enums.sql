-- 0001_enums.sql
-- Types that the v1 Firestore backend stored as unvalidated strings.
-- See docs/backend-schema.json -> enums for the mapping.

create extension if not exists pgcrypto;

create type public.lawn_status          as enum ('pending', 'approved', 'rejected');
create type public.badge_request_status as enum ('pending', 'approved', 'rejected', 'done');
create type public.announcement_type    as enum ('article', 'video');
create type public.gender               as enum ('male', 'female');
create type public.app_role             as enum ('member', 'admin', 'super_admin');

-- NOTE: ShirtLevel does NOT become an enum. Levels are admin-editable content,
-- so they live in the badge_levels table instead.
