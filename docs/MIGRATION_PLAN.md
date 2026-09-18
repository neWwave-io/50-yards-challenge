# Migration Plan — FlutterFlow v1 → Hand-written v2

> Written 2026-09-18. Companion to [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md).
> Nothing here is started yet. This is the map, not a commitment to a date.
>
> **Update 2026-09-18:** the backend is also moving **Firebase → Supabase**. That is planned in
> [SUPABASE_MIGRATION.md](SUPABASE_MIGRATION.md) and is folded into the phases below —
> the two migrations share the same `data/repositories/` seam and must be done as one
> piece of work, not two.

---

## 1. The strategy in one paragraph

**Keep this repo. Keep Firebase. Keep the data model. Replace the UI and the layers under it.**

We do *not* start a fresh repo. Git history, platform shells (`android/`, `ios/`, `web/`),
Firebase project wiring, Cloud Functions, and the Firestore schema are all fine and expensive
to recreate. What we throw away is the FlutterFlow runtime (`lib/flutter_flow/`), the generated
page widgets, and the `FlutterFlowModel` pattern — replaced screen by screen as v2 Figma
designs land. The old screens keep working until their replacement ships, so the app is
always releasable.

This is a **strangler migration**, not a big-bang rewrite.

---

## 2. Target architecture

```
lib/
  main.dart
  app/
    app.dart                 MaterialApp.router + theme wiring
    router.dart              go_router config, typed routes, auth redirect
  core/
    theme/                   Design tokens from Figma: colors, typography, spacing, radii
      app_colors.dart
      app_typography.dart
      app_spacing.dart
      app_theme.dart         ThemeData light (+ dark when v2 asks for it), Material 3
    widgets/                 Design-system primitives: AppButton, AppCard, AppTextField, ...
    errors/                  Failure types, error mapping
    utils/                   Formatters, validators, extensions
  data/
    models/                  Immutable domain models (freezed or plain) + fromJson/toJson
    repositories/            UserRepository, LawnRepository, ShirtRepository, ...
    sources/                 FirestoreService, StorageService, FunctionsService, FcmService
  features/
    auth/          { presentation/, controller/ }
    home/
    lawn_submission/
    leaderboard/
    achievements/
    shirts/
    news/
    hall_of_fame/
    profile/
    admin/         (all admin screens under one feature)
```

Rules:
- **Widgets never touch Firestore.** Screens talk to a controller; the controller talks to a
  repository; the repository is the only thing that knows Firebase exists.
- **No hardcoded colors, fonts, sizes, or paddings in feature code.** Everything comes from
  `core/theme`. This is what makes the Figma v2 handoff cheap.
- **Every screen file stays under ~300 lines.** Extract widgets aggressively.
- **Models are immutable** with explicit `fromFirestore` / `toFirestore`.

### Open decision: state management
Needs your call before Phase 1 starts. Options:

| Option | Why | Against |
| --- | --- | --- |
| **Riverpod** (recommended) | Best fit for Firestore streams, compile-safe, testable, no BuildContext coupling | New concept for the team |
| **Bloc** | Very explicit, big ecosystem, good for audited flows | Much more boilerplate for a CRUD app |
| **Provider + ChangeNotifier** | Already in the repo, lowest learning curve | Weakest testability; we'd be keeping the thing that hurt us |

---

## 3. Phases

### Phase 0 — Take ownership (do now, before Figma lands)

Low-risk cleanup that makes everything after it easier. No user-visible change.

- [ ] Rename app identifiers: `com.mycompany.the50yardchallenge` → real bundle ID
      (**needs your decision — this breaks store continuity if the app is already published;
      if it is live, we keep the ID and only fix the Kotlin package path and descriptions**)
- [ ] Fix `pubspec.yaml` description, Android Kotlin path `com/example/my_project`
- [ ] Delete dead code: `lib/bin/how_to_sumit_old/`, `lib/test/`, and their routes
- [ ] Merge `lib/components/` into `lib/component/`
- [ ] Strip unused Cloud Functions deps (Stripe, Braintree, Razorpay, Mux, LangChain, OpenAI,
      Anthropic) — dead attack surface
- [ ] Loosen the ~100 exact version pins to caret ranges; `flutter pub upgrade`; confirm build
- [ ] Add `.gitignore` entries for `android/.gradle/`, build output (currently committed)
- [ ] Add CI: `flutter analyze` + `flutter test` on push
- [ ] Tighten `analysis_options.yaml` and burn down the 859 warnings

### Phase 1 — Security stopgap on Firebase (do in parallel with Phase 0)

The full fix is RLS on Supabase (see [SUPABASE_MIGRATION.md](SUPABASE_MIGRATION.md) §5), but that
is months away and the app is live and wide open **today**. So do the minimum viable lockdown on
Firestore now, and do not over-invest in rules we are going to delete.

- [ ] Lock down [firestore.rules](../firebase/firestore.rules): remove every `if true`. At minimum,
      require `request.auth != null`, and scope `users` reads to the owner + admins
- [ ] Same pass over `storage.rules` (currently unreviewed)
- [ ] Audit what PII is exposed — `users` is currently world-readable and this app's users are
      **children**, so this is a safeguarding issue, not just a bug
- [ ] Strip unused Cloud Functions deps (Stripe, Braintree, Razorpay, Mux, LangChain, OpenAI,
      Anthropic)

Deferred to Supabase rather than fixed twice: server-authoritative `totalLawns`, shirt/badge
eligibility, leaderboard computation, and the `minLawns` String→int fix. All three are solved by
the new schema.

### Phase 2 — Foundations (start the day v2 Figma tokens are available)

- [ ] Extract the Figma design system into `core/theme` — colors, typography, spacing, radii,
      elevation, as named tokens matching the Figma variable names
- [ ] Build `core/widgets` primitives from the Figma component library
- [ ] Write `data/models` — proper immutable models replacing `backend/schema/*_record.dart`,
      shaped to the **Supabase** schema, not the Firestore one
- [ ] Write `data/repositories` — one per table, wrapping **Supabase** (not Firestore).
      This is the seam both migrations share; build it against Supabase from day one so we
      never write it twice
- [ ] Build the offline write queue that Firestore was giving us for free
      (see [SUPABASE_MIGRATION.md](SUPABASE_MIGRATION.md) §8) — critical for lawn submission
- [ ] Stand up the new `app/router.dart` alongside the old one; new screens register here
- [ ] Wire the chosen state management

**We can start the model + repository layer before Figma arrives** — it does not depend on design.
It does depend on the Supabase schema, so that is the true critical path.

### Phase 3 — Member screens, one at a time

Rebuild order (each is: build new screen → swap route → delete old widget + model):

1. Auth (sign in / sign up) — smallest, sets the pattern
2. Home
3. Submit lawn — highest-value, most logic
4. Achievements / progress
5. Shirt system + shirt request
6. Leaderboard
7. Hall of fame
8. News / announcements
9. Profile + profile edit
10. How to submit

Each screen ships behind the existing route, so the app stays releasable throughout.

### Phase 4 — Admin console

**Open decision:** does admin stay inside the mobile app, or move to a separate Flutter Web
app? Recommendation is **split it out** — admin screens are ~40% of the code, ship to every
member's phone for no reason, and are far easier to secure as a separate web deployment.

### Phase 5 — Delete FlutterFlow

Once no screen imports it:
- [ ] Delete `lib/flutter_flow/` entirely
- [ ] Delete `lib/backend/schema/*_record.dart` and `FFAppState`
- [ ] Remove FlutterFlow git dependencies (`dropdown_button2`, `webviewx_plus` forks)
- [ ] Asset diet: move the 24 MB of video and most of the 55 MB of images to Firebase Storage
      / CDN; target an install size under 30 MB

### Phase 6 — Release

- [ ] Golden tests for design-system widgets
- [ ] Unit tests for repositories and shirt/leaderboard logic
- [ ] Staged rollout on both stores
- [ ] Crash + performance monitoring before wide release

---

## 4. What I need from you

Blocking questions, roughly in the order they matter:

1. **Is v1 live in the App Store / Play Store today?** Determines whether we can change the
   bundle ID, and whether v2 is an update (data migration required) or a fresh listing.
2. **State management pick** — Riverpod, Bloc, or stay on Provider.
3. **Admin: in-app or separate web app?**
4. **Does v2 Figma cover the admin screens, or member only?**
5. **Dark mode in v2?** Cheap now, expensive to retrofit.
6. **Web target** — do we keep supporting it, or mobile-only?
7. **Who owns the Firebase project**, and do I get access to deploy rules/functions?

Backend-specific questions are in [SUPABASE_MIGRATION.md](SUPABASE_MIGRATION.md) §10.

## 5. What I can start on without any answers

- Phase 0 cleanup (except the bundle-ID rename)
- Phase 1 Firestore/Storage rules lockdown
- The Supabase schema + RLS migrations in `supabase/migrations/`
- The `data/models` + `data/repositories` layer

Say the word and I'll start with whichever of those you want first.
