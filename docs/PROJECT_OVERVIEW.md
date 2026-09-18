# The 50 Yard Challenge — Project Overview

> ## ⚠️ This document describes v1, which is NO LONGER IN THE WORKING TREE.
>
> On 2026-09-18 Firebase was removed, and with it every v1 screen — all of them were built
> directly on Firestore queries, so they could not survive the backend going away.
>
> **The v1 code is intact in git at commit `f4ee223`.** To read a screen while rebuilding it:
> ```bash
> git show f4ee223:lib/pages/submit_lawn/submit_lawn_widget.dart
> git checkout f4ee223 -- lib/pages/   # if you need it back on disk
> ```
>
> This document is kept deliberately, because it is still the record of **what the app does**
> and **what the data means** — both of which the v2 rebuild and the data migration depend on.
> Sections 4 (data model) and 6 (known problems) remain current and authoritative.
>
> For the state of the repo *today*, see [CLAUDE.md](../CLAUDE.md).

---

## 1. What the app is

A Flutter mobile app (Android + iOS, web target present) for **The 50 Yard Challenge** — kids
sign up, mow 50 lawns free for people in their community, submit photo proof of each lawn, and
earn shirt levels as they progress. One binary serves two audiences:

| Audience | Entry point | What they do |
| --- | --- | --- |
| **Member (kid / parent)** | `/signUp`, `/signin` | Submit lawns with photos, track progress to 50, request shirts, view leaderboard, hall of fame, news |
| **Admin** | `/loginAdmin` | Approve/reject lawns and shirt requests, manage leaderboard, publish news and announcements, send push notifications, manage members |

---

## 2. Tech stack as it stands today

| Layer | Current choice |
| --- | --- |
| Framework | Flutter stable (verified against 3.41.2), Dart SDK `>=3.0.0 <4.0.0` |
| Origin | FlutterFlow export (not code-linked — FlutterFlow can no longer round-trip this) |
| Routing | `go_router` 12.1.3, wrapped in FlutterFlow's `FFRoute` |
| State | `provider` + `FFAppState` (ChangeNotifier singleton) + per-page `FlutterFlowModel` |
| Backend | Firebase: Auth, Firestore, Storage, Cloud Functions, Messaging (FCM), Performance |
| Firebase project | `the-50-yard-challenge` |
| App ID | `com.mycompany.the50yardchallenge` (Android + iOS) — placeholder, should be renamed |
| Auth | Email/password, Google, Apple, Anonymous (GitHub + JWT scaffolding present, unused) |
| Theming | `FlutterFlowTheme`, light mode only, `useMaterial3: false` |
| Fonts | `google_fonts` + local files in `assets/fonts` |

### Size and health

- **156 Dart files, ~58,000 lines** in `lib/`
- Largest files are single-page widget trees: [profile_page_widget.dart](../lib/pages/profile_page/profile_page_widget.dart) (4,043 lines),
  [how_to_submit_widget.dart](../lib/pages/how_to_submit/how_to_submit_widget.dart) (2,962),
  [sign_up_widget.dart](../lib/auth/sign_up/sign_up_widget.dart) (2,796),
  [submit_lawn_widget.dart](../lib/pages/submit_lawn/submit_lawn_widget.dart) (2,729),
  [profile_edit_widget.dart](../lib/pages/profile_edit/profile_edit_widget.dart) (2,407)
- **~79 MB of bundled assets** (55 MB images, 24 MB videos) shipped inside the binary
- `flutter analyze`: **0 errors, 859 warnings, 2,873 infos** — it builds, it is just noisy

---

## 3. Repo layout

```
lib/
  main.dart                 Bootstrap: Firebase init, FFAppState, MaterialApp.router
  index.dart                Barrel exporting every page widget
  app_state.dart            FFAppState — global mutable state (optionMowed, listStates, ...)

  auth/                     Auth providers + sign-in / sign-up pages
    firebase_auth/          email, google, apple, anonymous, github, jwt managers
    signin/  sign_up/

  backend/
    backend.dart            Firestore query helpers (queryXRecord / queryXRecordOnce)
    schema/                 One Dart file per Firestore collection
      structs/              Nested map types (LawnsPhotos, PhotoDetail, TopUsers, ...)
      enums/enums.dart      ShirtLevel, ShirtStatus, AnnouncementType, Gender
    firebase/               firebase_config.dart (hardcoded web options)
    firebase_storage/       upload helpers
    cloud_functions/        callable wrappers
    push_notifications/     FCM handler + util

  flutter_flow/             FlutterFlow runtime library (theme, widgets, util, models)
    nav/nav.dart            GoRouter route table
    flutter_flow_theme.dart Colors + typography
    custom_functions.dart   5 hand-written helpers (top10Leaderboard, getDuplicate, ...)

  pages/                    Member screens
    home_page/  leader_board/  achivement/  submit_lawn/  shirt_system/
    announcement/  how_to_submit/  hall_of_fame/  profile_page/  profile_edit/

  admin_folder/             Admin console screens
    login_admin/  home_admin/  shirt_request_admin/  leaderboard_admin/
    notification_admin/  news_annocument/  user_profile_admin/  drawer_admin/

  component/                Reusable widgets + dialogs (nav bar, popups, forms) — 15 folders
  components/               A SECOND component folder (shirt_level, shirt_request)
  custom_code/actions/      delete_all_notifications, new_users
  loading_page/             Post-login splash / router gate
  bin/how_to_sumit_old/     DEAD: old "how to submit" page, still routed
  test/                     DEAD: scratch page TestWidget, still routed

firebase/
  firestore.rules           Security rules
  firestore.indexes.json
  storage.rules
  functions/index.js        FCM token registration + push notification triggers

assets/                     images (55 MB), videos (24 MB), fonts, jsons, pdfs, audios, rive
android/ ios/ web/          Platform shells
```

---

## 4. Data model (Firestore)

**Full machine-readable schema: [backend-schema.json](backend-schema.json)** — every field with
its real Firestore field name, type, description, the security rule that guards it, and the
Supabase column it becomes. Parsed
directly from `lib/backend/schema/*.dart`, so it is the actual shape of the data, not a summary.

**9 collections, 85 fields, 6 structs, 4 enums, 6 Cloud Functions.**

Field names in Firestore are `snake_case`; the Dart getters are `camelCase`. The table below uses
the real Firestore names.

| Collection | Fields | What it holds |
| --- | --- | --- |
| `users` | 19 | One doc per member; doc id **is** the Firebase Auth uid |
| `lawns` | 10 | One doc per lawn submission — the core record |
| `shirt_requests` | 12 | A member asking for the shirt they earned |
| `shirt_levels` | 4 | Lookup: the shirt tiers |
| `leaderboards` | 4 | One doc per region with a precomputed `top_users[]` array |
| `announcement` | 8 | News posts (collection name is singular) |
| `notifications` | 12 | In-app notification feed |
| `admins` | 8 | Admin accounts |
| `settings` | 8 | Single config doc |

Plus the `users/{uid}/fcm_tokens` subcollection and two FlutterFlow-internal push queues
(`ff_push_notifications`, `ff_user_push_notifications`).

### Structs (nested maps, not collections)
`PhotoDetail{image, hash_code_image}` · `LawnsPhotos{before, after, action, homeowner}` ·
`TopUsers{user_ref, name, photo_url, total_lawns, state, hash_code_image, total_hours}` ·
`JoinGroup{child_name, shirt_size, gender}` · `FindLawns{title, detail}` ·
`MowedCategories{who, num_mow}` — this last one is **never stored**; it is computed in memory by
`custom_functions.getDuplicate()`.

### Enums
`ShirtLevel{starter, orange, green, blue, red, black}` ·
`ShirtStatus{pending, approved, rejected, done}` ·
`AnnouncementType{article, video}` · `Gender{Male, Female}`

All four are **stored as plain strings**. Nothing validates them, and several fields that should
use them (`lawns.status`, `shirt_requests.shirt_level`, `users.gender`) are free text instead.

### Data-model quirks worth knowing
- `users.total_lawns` / `total_hours` are **client-written** — a member can set their own totals
- `users.photo_url` and `users.user_profile.image` both store a profile photo
- `users.uid` duplicates the document id
- `shirt_levels.min_lawns` is a **String**, so it sorts and compares as text
- `shirt_requests.shirt_level` is a String, but `users.shirt_level` is an enum — inconsistent
- `announcement.update_at` and `shirt_requests.update_at` — not `updated_at`, unlike every other
  collection
- `notifications.notification` is the **recipient** reference, despite the name
- `settings` hides three lookup tables (`allow_mowed_categories`, `list_state`, `find_lawns`)
  inside arrays on a single document

---

## 5. Routes (current)

**Member:** `/` (auth gate) · `/homePage` · `/signin` · `/signUp` · `/leaderBoard` ·
`/achivement` · `/submitLawn` · `/shirtSystem` · `/announcement` · `/howToSubmit` ·
`/hallOfFame` · `/profilePage?isShirt=` · `/profileEdit` · loading page

**Admin:** `/loginAdmin` · `/homeAdmin` · `/shirtRequestAdmin` · `/leaderboardAdmin` ·
`/notificationAdmin` · `/newsAnnocument` · `/userProfileAdmin?userRef=`

**Dead routes still wired up:** `HowToSumitOldWidget`, `TestWidget`

Route table lives in [nav.dart](../lib/flutter_flow/nav/nav.dart).

---

## 6. Known problems inherited from the FlutterFlow export

Ordered by how much pain each causes. These are what v2 should fix.

1. **Firestore rules are effectively open.** `allow create: if true; allow read: if true` on
   `lawns`, `leaderboards`, `shirt_requests`, `admins`, `settings`, `announcement`,
   `notifications`. Any client — authenticated or not — can read every collection and create
   documents. **Highest-severity item in the repo.** See [firestore.rules](../firebase/firestore.rules).
2. **No server-authoritative business logic.** Shirt eligibility, lawn counts, and leaderboard
   ranking are computed client-side; `totalLawns` is a client-written field. A member can
   write their own totals.
3. **No separation of concerns.** Firestore queries, business logic, and 2,000-line widget
   trees live in the same `initState` / `build`. Nothing is unit-testable.
4. **Everything is `StatefulWidget` + `FlutterFlowModel`.** No repository layer, no view
   models, no dependency injection.
5. **Deep widget nesting with magic numbers** — `Stack > Opacity > Align > Padding > Transform
   > Opacity > Align > ClipRRect > ...`, `fromSTEB(0.0, 1000.0, 0.0, 0.0)`. Unreadable and
   not responsive.
6. **Duplicated component folders** (`component/` and `components/`) and dead code
   (`bin/how_to_sumit_old/`, `lib/test/`).
7. **~100 exact-pinned dependencies** (FlutterFlow style). 123 packages have newer versions
   blocked by those pins; Flutter upgrades will be painful.
8. **Placeholder identifiers** — `com.mycompany.the50yardchallenge`, description "A new Flutter
   project", Android Kotlin path still `com/example/my_project`.
9. **79 MB of assets bundled**, including 24 MB of video, rather than served from Storage/CDN.
10. **Light theme only**, `useMaterial3: false`, no design token layer — v2 Figma will need one.
11. **No tests.** `test/widget_test.dart` is the untouched default template.
12. **Unused Cloud Functions dependencies** — Stripe, Braintree, Razorpay, Mux, LangChain,
    OpenAI, Anthropic all in `functions/package.json`, nothing uses them. Dead attack surface.
13. **Typos baked into route and folder names**: `achivement`, `news_annocument`,
    `how_to_sumit_old`.

---

## 7. What is good and worth keeping

- **The Firestore data model is sound.** Collections and fields map cleanly to the domain.
  v2 should keep the schema (with the fixes above) rather than redesign it.
- **The feature set is complete and proven in production.** v2 is a re-skin plus
  re-architecture, not a re-spec.
- **Cloud Functions FCM plumbing works** and is standard — reusable as-is.
- **Struct and enum definitions** are a good starting point for real domain models.

---

See [MIGRATION_PLAN.md](MIGRATION_PLAN.md) for how we get from here to v2.
