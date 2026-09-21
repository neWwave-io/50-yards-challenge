import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';
import 'package:the_50_yard_challenge/features/home/data/home_repository.dart';
import 'package:the_50_yard_challenge/features/home/home_screen.dart';

/// Serves a fixed page, so the screen can be exercised without Supabase.
class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository(this.data);

  final HomeData data;
  var loads = 0;

  @override
  Future<HomeData> load() async {
    loads++;
    return data;
  }
}

HomeData buildData({
  int lawns = 3,
  double hours = 24,
  DayStreak streak = const DayStreak(current: 1, longest: 2),
  List<CategoryTally>? categories,
  List<Announcement> announcements = const [],
  List<ActivityEntry> activity = const [],
  Announcement? training,
}) =>
    HomeData(
      profile: HomeProfile(
        displayName: 'Marcus Reed',
        state: 'Alabama',
        joinedAt: DateTime(2025, 8, 10),
        totalLawns: lawns,
        totalHours: hours,
        badgeName: 'Starter',
        badgeRank: 3,
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

    expect(find.text('3'), findsWidgets); // lawns on the ring
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
        training: Announcement(
          id: 'v',
          title: 'Lawn Mower Maintenance',
          videoLink: 'https://example.com/v',
          createdAt: DateTime(2025, 8, 1),
        ),
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
}
