import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';
import 'package:the_50_yard_challenge/features/home/data/home_repository.dart';
import 'package:the_50_yard_challenge/features/home/home_screen.dart';
import 'package:the_50_yard_challenge/features/home/widgets/challenge_progress_card.dart';
import 'package:the_50_yard_challenge/features/home/widgets/training_hub_card.dart';

/// Serves a fixed page, so the screen can be exercised without Supabase.
class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository(this.data);

  /// Replace to simulate what the server returns after a write.
  HomeData data;
  var loads = 0;

  /// Every setAway call, by the return date it asked for.
  final awayCalls = <DateTime?>[];
  var availableCalls = 0;

  @override
  Future<HomeData> load() async {
    loads++;
    return data;
  }

  @override
  Future<void> setAway({DateTime? returnsOn}) async => awayCalls.add(returnsOn);

  @override
  Future<void> setAvailable() async => availableCalls++;
}

HomeData buildData({
  int lawns = 3,
  double hours = 24,
  String? badgeName = 'Starter',
  int? badgeRank = 3,
  DayStreak streak = const DayStreak(current: 1, longest: 2),
  List<CategoryTally>? categories,
  List<Announcement> announcements = const [],
  List<ActivityEntry> activity = const [],
  List<TrainingVideo> training = const [],
  Availability availability = const Availability.available(),
}) =>
    HomeData(
      availability: availability,
      profile: HomeProfile(
        displayName: 'Marcus Reed',
        state: 'Alabama',
        joinedAt: DateTime(2025, 8, 10),
        totalLawns: lawns,
        totalHours: hours,
        badgeName: badgeName,
        badgeRank: badgeRank,
      ),
      streak: streak,
      week: const MowingWeek(days: [
        DayState.mowed, DayState.mowed, DayState.mowed, DayState.mowed,
        DayState.mowed, DayState.today, DayState.upcoming,
      ]),
      categories: categories ??
          [
            for (final c in kMowedCategories)
              CategoryTally(category: c, count: 0, share: 0),
          ],
      announcements: announcements,
      activity: activity,
      training: training,
    );

void main() {
  Future<FakeHomeRepository> pumpHome(WidgetTester tester, HomeData data) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeHomeRepository(data);
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('greets by first name and shows the challenge numbers',
      (tester) async {
    await pumpHome(tester, buildData());

    expect(find.text('Hi, Marcus'), findsOneWidget);
    expect(find.text('Team Alabama'), findsOneWidget);
    expect(find.text('Available Since 10th Aug'), findsOneWidget);

    // Lawns show twice: on the ring and above the level name.
    expect(find.text('3'), findsNWidgets(2));
    expect(find.text('of 50'), findsOneWidget);
    expect(find.text('Starter'), findsOneWidget);
    expect(find.text('24'), findsOneWidget); // hours
    expect(find.text('# 4'), findsOneWidget); // next lawn
  });

  testWidgets('shows the longest day streak', (tester) async {
    await pumpHome(
      tester,
      buildData(streak: const DayStreak(current: 2, longest: 6)),
    );

    expect(find.text('Day Streak'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('the week tracker counts the days mowed', (tester) async {
    await pumpHome(tester, buildData());

    expect(find.text('THIS WEEK'), findsOneWidget);
    expect(find.text('5 / 7 days'), findsOneWidget);
    for (final day in ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']) {
      expect(find.text(day), findsOneWidget);
    }
  });

  testWidgets('empty sections say so rather than showing nothing',
      (tester) async {
    await pumpHome(tester, buildData());

    expect(find.text('Nothing posted yet.'), findsOneWidget);
    expect(find.text('No lawns have been finished yet.'), findsOneWidget);
    expect(find.text('No training videos yet.'), findsOneWidget);
    expect(find.text('No nearby requests yet'), findsOneWidget);
  });

  testWidgets('fills the sections when there is content', (tester) async {
    await pumpHome(
      tester,
      buildData(
        announcements: [
          Announcement(
            id: 'a',
            title: 'Title Announcement',
            description: 'Watch our quick lawn-submission video.',
            createdAt: DateTime(2025, 8, 9),
          ),
        ],
        activity: [
          ActivityEntry(
            name: 'John Wick',
            at: DateTime.now().subtract(const Duration(days: 20)),
          ),
        ],
        training: const [
          TrainingVideo(
            id: 'v',
            title: 'Lawn Mower Maintenance',
            videoUrl: 'https://example.com/v',
          ),
        ],
      ),
    );

    expect(find.text('Title Announcement'), findsOneWidget);
    expect(find.text('9th Aug'), findsOneWidget);
    expect(find.text('John Wick'), findsOneWidget);
    expect(find.text('20 days ago'), findsOneWidget);
    expect(find.text('Lawn Mower Maintenance'), findsOneWidget);
    expect(find.text('Watch the video'), findsOneWidget);
  });

  testWidgets('counts per category appear only once something is mowed',
      (tester) async {
    await pumpHome(
      tester,
      buildData(
        categories: [
          for (final c in kMowedCategories)
            CategoryTally(
              category: c,
              count: c == MowedCategory.elderly ? 7 : 0,
              share: c == MowedCategory.elderly ? 1 : 0,
            ),
        ],
      ),
    );

    expect(find.text('Elderly'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    // The other five have nothing yet, so no badges.
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the requested-lawn toggle flips', (tester) async {
    await pumpHome(tester, buildData());

    // The knob sits left when off and right when on.
    AlignmentGeometry? knobSide() => tester
        .widget<AnimatedContainer>(
          find.descendant(
            of: find.bySemanticsLabel('Take lawn requests from the map'),
            matching: find.byType(AnimatedContainer),
          ),
        )
        .alignment;

    expect(knobSide(), Alignment.centerLeft);

    await tester.tap(find.bySemanticsLabel('Take lawn requests from the map'));
    await tester.pumpAndSettle();

    expect(knobSide(), Alignment.centerRight);
  });

  testWidgets('a finished challenge says completed instead of counting',
      (tester) async {
    await pumpHome(tester, buildData(lawns: 50));

    expect(find.text('completed'), findsOneWidget);
    expect(find.text('of 50'), findsNothing);
    expect(find.text('50'), findsNWidgets(2));
  });

  testWidgets('an unranked family is told so rather than shown a made-up rank',
      (tester) async {
    await pumpHome(tester, buildData(badgeName: null, badgeRank: null));

    expect(find.text('No badge yet'), findsOneWidget);
  });

  // A status bar taller than the design's pushed the greeting down into the
  // challenge card, which then covered it.
  for (final statusBar in const [24.0, 48.0, 59.0]) {
    testWidgets('the greeting clears the card with a ${statusBar}px status bar',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      tester.view.padding = FakeViewPadding(top: statusBar);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(home: HomeScreen(repository: FakeHomeRepository(buildData()))),
      );
      await tester.pumpAndSettle();

      final greeting = tester.getRect(find.text('Hi, Marcus'));
      final joined = tester.getRect(find.text('Available Since 10th Aug'));
      final card = tester.getRect(find.byType(ChallengeProgressCard));

      expect(greeting.bottom, lessThanOrEqualTo(card.top),
          reason: 'the greeting is under the card');
      expect(joined.bottom, lessThanOrEqualTo(card.top),
          reason: 'the join date is under the card');
    });
  }

  testWidgets('the training hub swipes between videos', (tester) async {
    await pumpHome(
      tester,
      buildData(training: const [
        TrainingVideo(
            id: 'a', title: 'How to Submit Lawns', videoUrl: 'https://e/1'),
        TrainingVideo(id: 'b', title: 'Safety First', videoUrl: 'https://e/2'),
      ]),
    );

    // The page and the carousel are both scrollable, so name the page's.
    await tester.scrollUntilVisible(
      find.text('Training Hub'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('How to Submit Lawns'), findsOneWidget);
    expect(find.text('Safety First'), findsNothing);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Safety First'), findsOneWidget);
  });

  testWidgets('a single video needs no carousel', (tester) async {
    await pumpHome(
      tester,
      buildData(training: const [
        TrainingVideo(id: 'a', title: 'Safety First', videoUrl: 'https://e/1'),
      ]),
    );

    expect(find.byType(PageView), findsNothing);
    expect(find.text('Safety First'), findsOneWidget);
  });

  // The tab bar used to float over the scroll view and cover the last card.
  // The overlap only shows at the very bottom of the page, so scroll right
  // to the end rather than just until the button appears.
  testWidgets('the tab bar sits below the content, not over it',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          repository: FakeHomeRepository(buildData(training: const [
            TrainingVideo(
                id: 'a', title: 'Safety First', videoUrl: 'https://e/1'),
          ])),
          // The real bar is ~122px of chrome plus the home-indicator inset.
          bottomBar: const SizedBox(height: 156, child: Text('tabs')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final page = tester.state<ScrollableState>(find.byType(Scrollable).first);
    page.position.jumpTo(page.position.maxScrollExtent);
    await tester.pumpAndSettle();

    // The whole card has to clear the bar, not just the button inside it.
    final card = tester.getRect(find.byType(TrainingHubCard));
    final bar = tester.getRect(find.text('tabs'));

    expect(card.bottom, lessThanOrEqualTo(bar.top),
        reason: 'the tab bar is covering the card');
  });
}
