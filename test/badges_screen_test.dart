import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/badges/badges_screen.dart';
import 'package:the_50_yard_challenge/features/badges/data/badge_data.dart';
import 'package:the_50_yard_challenge/features/badges/data/badges_repository.dart';
import 'package:the_50_yard_challenge/features/badges/widgets/request_badge_dialog.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';

/// Serves fixed badges and records requests, so the screen runs without
/// Supabase.
class FakeBadgesRepository implements BadgesRepository {
  FakeBadgesRepository(this.data);

  BadgesData data;
  final requests = <String>[];

  @override
  Future<BadgesData> load() async => data;

  @override
  Future<void> requestBadge({
    required String badgeId,
    required String explanation,
    required Uint8List photo,
  }) async =>
      requests.add(badgeId);
}

const kGolden = ChallengeBadge(
  id: 'golden',
  name: 'Golden Kindness',
  description: 'A rare badge awarded for extraordinary kindness.',
  requiredLawns: 9,
  whoFor: MowedCategory.elderly,
  progress: 4,
);

final kVeteranFriend = ChallengeBadge(
  id: 'veteran',
  name: 'Veteran Friend',
  requiredLawns: 5,
  whoFor: MowedCategory.veteran,
  progress: 5,
  earned: true,
  earnedAt: DateTime(2026, 9, 9),
);

const kFirstFive = ChallengeBadge(id: 'five', name: 'First Five', requiredLawns: 5);

const kHelper = ChallengeBadge(
  id: 'helper',
  name: 'Community Helper',
  description: 'For service beyond mowing.',
  earnedBy: BadgeEarnedBy.request,
);

void main() {
  Future<FakeBadgesRepository> pumpBadges(
    WidgetTester tester,
    List<ChallengeBadge> badges,
  ) async {
    tester.view.physicalSize = const Size(393, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeBadgesRepository(BadgesData(badges: badges));
    await tester.pumpWidget(
      MaterialApp(home: BadgesScreen(repository: repository, onBack: () {})),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('counts the badges earned', (tester) async {
    await pumpBadges(tester, [kGolden, kVeteranFriend, kFirstFive, kHelper]);

    expect(find.text('Earned Badges'), findsOneWidget);
    expect(find.text('1/4'), findsOneWidget);
  });

  testWidgets('Earned lists badges under way; Locked the rest',
      (tester) async {
    await pumpBadges(tester, [kGolden, kVeteranFriend, kFirstFive, kHelper]);

    expect(find.text('4 /9 completed'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('First Five'), findsNothing);

    await tester.tap(find.text('Locked'));
    await tester.pumpAndSettle();

    expect(find.text('First Five'), findsOneWidget);
    expect(find.text('0 /5 completed'), findsOneWidget);
    expect(find.text('Request to earn'), findsOneWidget);
    expect(find.text('Golden Kindness'), findsNothing);
  });

  testWidgets('tapping a card turns it over to its description',
      (tester) async {
    await pumpBadges(tester, [kGolden]);

    expect(find.text(kGolden.description!), findsNothing);
    await tester.tap(find.text('Golden Kindness'));
    await tester.pumpAndSettle();

    expect(find.text(kGolden.description!), findsOneWidget);
    expect(find.text('9 lawns for Elderly neighbours'), findsOneWidget);

    await tester.tap(find.text('Golden Kindness'));
    await tester.pumpAndSettle();
    expect(find.text(kGolden.description!), findsNothing);
  });

  testWidgets('with nothing to request, the button is off', (tester) async {
    await pumpBadges(tester, [kGolden]);

    await tester.tap(find.text('Request For Badge'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestBadgeDialog), findsNothing);
  });

  testWidgets('the request form offers only requestable badges',
      (tester) async {
    await pumpBadges(tester, [kGolden, kHelper]);

    await tester.tap(find.text('Request For Badge'));
    await tester.pumpAndSettle();

    expect(find.byType(RequestBadgeDialog), findsOneWidget);
    final dialog =
        tester.widget<RequestBadgeDialog>(find.byType(RequestBadgeDialog));
    expect(dialog.badges.map((b) => b.id), ['helper']);
  });

  testWidgets('a request waiting for review stays on the Earned tab',
      (tester) async {
    await pumpBadges(tester, [
      const ChallengeBadge(
        id: 'helper',
        name: 'Community Helper',
        earnedBy: BadgeEarnedBy.request,
        claimStatus: ClaimStatus.pending,
      ),
    ]);

    expect(find.text('Waiting for review'), findsOneWidget);
  });

  testWidgets('no badges set up says so', (tester) async {
    await pumpBadges(tester, []);

    expect(find.text('No badges yet'), findsOneWidget);
  });
}
