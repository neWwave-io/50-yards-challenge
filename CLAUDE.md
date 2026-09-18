# CLAUDE.md — The 50 Yard Challenge

## Context

Flutter app for The 50 Yard Challenge: kids mow 50 lawns free for people in their community,
submit photo proof, and earn badges.

**State as of 2026-09-18: the repo is a clean slate for the v2 rebuild.**

v1 was a FlutterFlow export on Firebase. Firebase has been **completely removed**, and with it
every v1 screen — all of them queried Firestore directly, so nothing survived the backend going
away. What remains is an app shell, the Supabase client, and a handful of dependency-free UI
helpers.

**The v1 code is intact in git at `f4ee223`.** Use it as the reference when rebuilding:

```bash
git show f4ee223:lib/pages/submit_lawn/submit_lawn_widget.dart   # read one screen
git show f4ee223 --stat                                          # what was there
```

Read before non-trivial work:
- [docs/backend-schema.json](docs/backend-schema.json) — every Firestore field and its Supabase target
- [docs/SUPABASE_MIGRATION.md](docs/SUPABASE_MIGRATION.md) — Postgres schema, RLS, data cutover
- [docs/MIGRATION_PLAN.md](docs/MIGRATION_PLAN.md) — target architecture and phases
- [docs/PROJECT_OVERVIEW.md](docs/PROJECT_OVERVIEW.md) — what v1 did and what the data means

## What is in `lib/` now

```
lib/
  main.dart                     app shell + placeholder screen
  core/supabase/                Supabase client + config
  flutter_flow/                 leftover dependency-free UI helpers (theme, buttons,
                                dropdowns, form controllers). Useful as reference for
                                the v2 design tokens; delete as v2 replaces them.
```

Everything else — `pages/`, `admin_folder/`, `component/`, `backend/`, `auth/` — is gone.

## Backend

**Supabase only.** There is no Firebase anywhere in this repo.

- Project `50_yard_challange`, ref `dimcpsyrtsnualmjispb`
- `https://dimcpsyrtsnualmjispb.supabase.co`
- Schema is applied and tested — `supabase/migrations/` (8 migrations)
- Client config: [lib/core/supabase/supabase_config.dart](lib/core/supabase/supabase_config.dart)

Auth: email/password works (signup returns a session immediately; confirmation is off).
Google and Apple still need credentials. Anonymous, GitHub and JWT are dropped by decision.

⚠️ **RLS is OFF on every table by choice.** Apply `supabase/security/rls_lockdown.sql` before
importing real data or shipping a build that points at this project.

⚠️ The project is in `ap-southeast-1` (Singapore) but should be US — blocked on a free-tier
project slot. Re-running the migrations against a new US project is a one-minute job.

⚠️ **There is no push notification capability.** `firebase_messaging` went with Firebase, and
Supabase has no push service. Re-adding push means an Edge Function calling FCM (or another
provider) plus a client SDK. The `device_tokens` table is already in the schema for it.

## Commands

```bash
flutter pub get
flutter analyze        # baseline: 0 errors, 0 warnings, 37 infos
flutter test
flutter run -d <device>
```

## Rules for writing code here

**Never reintroduce FlutterFlow patterns.** No `*_widget.dart` / `*_model.dart` pairs, no
`FlutterFlowModel`, no `FFAppState`. Follow the architecture in the migration plan:
`features/<name>/` with screen → controller → repository.

**Widgets never touch the database.** Screen → controller → repository → Supabase. Only
`data/` knows a backend exists.

**No hardcoded colors, fonts, spacing, or radii in feature code.** Everything comes from
`lib/core/theme`. This is what keeps the Figma v2 handoff cheap.

**Keep screen files under ~300 lines.** Extract widgets.

**Security.** The user base is children. RLS is off for development convenience only — never
build anything that assumes it will stay off, and flag anything that would expose user data.

## Naming

v1 had typos baked into folder and route names (`achivement`, `news_annocument`,
`how_to_sumit_old`). They are gone with the old code — do not reintroduce them.

v2 renames **shirt → badge** (Figma calls them badges). The Supabase schema already uses
`badge_levels` / `badge_requests`. Use `badge` everywhere in new code.
