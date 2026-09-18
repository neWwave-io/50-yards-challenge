# The 50 Yard Challenge

Flutter app (Android + iOS) for The 50 Yard Challenge — kids mow 50 lawns free for people in
their community, submit photo proof, and earn shirt levels. Includes a built-in admin console.

Backend is Firebase (Auth, Firestore, Storage, Cloud Functions, Messaging) on project
`the-50-yard-challenge`.

## Getting started

```bash
flutter pub get
flutter run
```

## Documentation

- [docs/PROJECT_OVERVIEW.md](docs/PROJECT_OVERVIEW.md) — architecture, data model, routes, known issues
- [docs/MIGRATION_PLAN.md](docs/MIGRATION_PLAN.md) — the v1 → v2 migration off FlutterFlow
- [docs/SUPABASE_MIGRATION.md](docs/SUPABASE_MIGRATION.md) — the Firebase → Supabase migration
- [CLAUDE.md](CLAUDE.md) — conventions for working in this repo

## Status

v1 was built in FlutterFlow and exported. As of 2026-09-18 FlutterFlow is no longer used — this
repo is the source of truth. Two migrations are in flight and are being done as one piece of
work: **FlutterFlow → hand-written Flutter** (v2 designs coming from Figma) and
**Firebase → Supabase**. See the two migration docs above.
