import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';
import 'package:the_50_yard_challenge/features/home/data/home_repository.dart';
import 'package:the_50_yard_challenge/features/profile/data/profile_data.dart';
import 'package:the_50_yard_challenge/features/profile/data/profile_repository.dart';
import 'package:the_50_yard_challenge/features/profile/profile_screen.dart';

/// Serves a fixed page, so the screen can be exercised without Supabase.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this.data);

  final ProfileData data;

  @override
  HomeRepository get home => throw UnimplementedError();

  @override
  Future<ProfileData> load() async => data;
}

const kLevels = [
  BadgeLevel(name: 'Rookie Mower', minLawns: 10, rank: 0),
  BadgeLevel(name: 'Junior Mower', minLawns: 20, rank: 1),
  BadgeLevel(name: 'Super Mower', minLawns: 30, rank: 2),
  BadgeLevel(name: 'Pro Cutter', minLawns: 40, rank: 3),
  BadgeLevel(name: 'Master Cutter', minLawns: 50, rank: 4),
];

ProfileData buildProfile({
  int lawns = 3,
  EarnedBadge? badge,
  Ranking ranking = const Ranking(national: 10, state: 4),
  List<ProfileChild>? children,
}) =>
    ProfileData(
      profile: HomeProfile(
        displayName: 'Marcus Reed',
        state: 'Alabama',
        joinedAt: DateTime(2025, 8, 10),
        totalLawns: lawns,
        totalHours: 24,
        badgeName: 'Starter Baby',
      ),
      streak: const DayStreak(current: 1, longest: 2),
      guardian: const Guardian(name: 'Patrick', relationship: 'Guardian'),
      children: children ??
          [
            ProfileChild(
              name: 'Emma',
              gender: 'Female',
              shirtSize: 'M',
              dateOfBirth: DateTime(2014, 1, 12),
            ),
            ProfileChild(
              name: 'Liam',
              gender: 'Male',
              shirtSize: 'L',
              dateOfBirth: DateTime(2016, 6, 12),
            ),
          ],
      categories: [
        for (final (i, c) in kMowedCategories.indexed)
          CategoryTally(category: c, count: i + 1, share: (i + 1) / 6),
      ],
      latestBadge: badge,
      ranking: ranking,
      levels: kLevels,
    );

void main() {
  Future<void> pumpProfile(WidgetTester tester, ProfileData data) async {
    tester.view.physicalSize = const Size(393, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          repository: FakeProfileRepository(data),
          onOpenSettings: () {},
          onOpenBadges: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('reuses the home header and progress card', (tester) async {
    await pumpProfile(tester, buildProfile());

    expect(find.text('Hi, Marcus'), findsOneWidget);
    expect(find.text('Available Since 10th Aug'), findsOneWidget);
    expect(find.text('Progress Overview'), findsOneWidget);
    expect(find.text('6%'), findsOneWidget); // 3 of 50
    expect(find.text('Starter Baby'), findsOneWidget);
    expect(find.bySemanticsLabel('Settings'), findsOneWidget);
  });

  testWidgets('lists the guardian and each child', (tester) async {
    await pumpProfile(tester, buildProfile());

    expect(find.text('Guardian'), findsOneWidget);
    expect(find.text('Patrick'), findsOneWidget);
    expect(find.text('Emma · Female · M'), findsOneWidget);
    expect(find.text('12th Jan'), findsOneWidget);
    expect(find.text('Liam · Male · L'), findsOneWidget);
  });

  testWidgets('totals the impact summary', (tester) async {
    await pumpProfile(tester, buildProfile());

    expect(find.text('Impact Summary'), findsOneWidget);
    expect(find.text('21'), findsOneWidget); // 1 + 2 + … + 6
    expect(find.text('First Responder'), findsOneWidget);
  });

  testWidgets('pads the rankings as the design does', (tester) async {
    await pumpProfile(tester, buildProfile());

    expect(find.text('# 10'), findsOneWidget);
    expect(find.text('# 04'), findsOneWidget);
  });

  testWidgets('an unranked child sees dashes', (tester) async {
    await pumpProfile(tester, buildProfile(ranking: const Ranking()));

    expect(find.text('—'), findsNWidgets(2));
  });

  testWidgets('counts down to the next shirt', (tester) async {
    await pumpProfile(tester, buildProfile(lawns: 3));

    expect(find.text('7 lawns to next shirt'), findsOneWidget);
    expect(find.text('7 lawns to next shirt (Orange Shirt)'), findsOneWidget);
  });

  testWidgets('says every shirt is earned at fifty', (tester) async {
    await pumpProfile(tester, buildProfile(lawns: 50));

    expect(find.text('Every shirt earned'), findsNWidgets(2));
  });

  testWidgets('shows the latest badge and when it was awarded',
      (tester) async {
    await pumpProfile(
      tester,
      buildProfile(
        badge: EarnedBadge(
          name: 'Rookie Mower',
          description: 'Ten lawns in — the orange shirt.',
          awardedAt: DateTime(2026, 9, 9),
        ),
      ),
    );

    expect(find.text('Rookie Mower'), findsNWidgets(2));
    expect(find.text('Awarded 9th Sep, 2026'), findsOneWidget);
  });

  testWidgets('before any badge, points at the first one', (tester) async {
    await pumpProfile(tester, buildProfile());

    expect(find.text('No badge yet'), findsNWidgets(2));
    expect(find.text('Mow 10 lawns to earn Rookie Mower.'), findsOneWidget);
  });

  testWidgets('the sharing opt-in starts off and toggles locally',
      (tester) async {
    await pumpProfile(tester, buildProfile());

    expect(find.text('Turn on sharing to see families near you.'),
        findsOneWidget);
    await tester.tap(find.text('Share my contact info with nearby families'));
    await tester.pump();
    expect(find.text('Turn on sharing to see families near you.'),
        findsNothing);
  });
}
