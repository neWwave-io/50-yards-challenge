import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/leaderboard/data/leaderboard_data.dart';
import 'package:the_50_yard_challenge/features/leaderboard/data/leaderboard_repository.dart';
import 'package:the_50_yard_challenge/features/leaderboard/leaderboard_controller.dart';
import 'package:the_50_yard_challenge/features/leaderboard/leaderboard_screen.dart';
import 'package:the_50_yard_challenge/features/leaderboard/widgets/podium_card.dart';
import 'package:the_50_yard_challenge/features/leaderboard/widgets/rank_row.dart';

LeaderboardEntry entry(
  String name,
  int nationalRank, {
  int? stateRank,
  String state = 'Alabama',
  int? lawns,
}) =>
    LeaderboardEntry(
      profileId: 'id-$name',
      name: name,
      photoUrl: null,
      state: state,
      totalLawns: lawns ?? 30 - nationalRank,
      totalHours: 0,
      nationalRank: nationalRank,
      stateRank: stateRank ?? nationalRank,
    );

/// Serves fixed rows and records what the screen asked for.
class FakeLeaderboardRepository implements LeaderboardRepository {
  FakeLeaderboardRepository({
    required this.top,
    required this.rest,
    this.standing,
  });

  final List<LeaderboardEntry> top;
  final List<LeaderboardEntry> rest;
  final MyStanding? standing;

  final queries = <({String? state, String? search, int offset})>[];

  @override
  Future<List<LeaderboardEntry>> topFive() async => top;

  @override
  Future<MyStanding?> mine() async => standing;

  @override
  Future<List<LeaderboardEntry>> participants({
    String? state,
    String? search,
    required int offset,
    required int limit,
  }) async {
    queries.add((state: state, search: search, offset: offset));
    return rest
        .where((e) => state == null || e.state == state)
        .where((e) =>
            search == null ||
            e.name.toLowerCase().contains(search.trim().toLowerCase()))
        .skip(offset)
        .take(limit)
        .toList();
  }
}

void main() {
  final top = [
    entry('Alexandra', 1),
    entry('Bida', 2),
    entry('Carl', 3),
    entry('Kyle', 4),
    entry('Kylie', 5),
  ];
  final rest = [
    entry('Samantha', 6),
    entry('Liam', 7, state: 'Texas', stateRank: 1),
    entry('Ava', 8),
  ];

  Future<FakeLeaderboardRepository> pump(
    WidgetTester tester, {
    MyStanding? standing,
  }) async {
    tester.view.physicalSize = const Size(393, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository =
        FakeLeaderboardRepository(top: top, rest: rest, standing: standing);
    await tester.pumpWidget(
      MaterialApp(home: LeaderboardScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('shows the podium, places four and five, then the rest',
      (tester) async {
    await pump(tester);

    for (final name in ['Alexandra', 'Bida', 'Carl', 'Kyle', 'Kylie',
        'Samantha', 'Liam', 'Ava']) {
      expect(find.text(name), findsOneWidget, reason: name);
    }
    expect(find.text('28 lawns'), findsOneWidget); // second place
    expect(find.text('Mowed Lawn 26'), findsOneWidget); // fourth place
  });

  testWidgets('highlights the signed-in child where they rank',
      (tester) async {
    await pump(
      tester,
      standing: MyStanding(
        state: 'Alabama',
        photoUrl: null,
        entry: entry('Liam', 7, state: 'Texas', stateRank: 1),
      ),
    );

    expect(find.text('Team Alabama'), findsOneWidget);
    final mine = find.byWidgetPredicate((w) => w is RankRow && w.mine);
    expect(mine, findsOneWidget);
    expect(find.descendant(of: mine, matching: find.text('7')), findsOneWidget);
    expect(find.descendant(of: mine, matching: find.text('Me')), findsOneWidget);
  });

  testWidgets('no "Me" row when the child is not in the list',
      (tester) async {
    await pump(
      tester,
      standing: MyStanding(state: null, photoUrl: null, entry: entry('Zoe', 40)),
    );

    expect(find.byWidgetPredicate((w) => w is RankRow && w.mine), findsNothing);
    expect(find.text('Me'), findsNothing);
    expect(find.textContaining('Team'), findsNothing);
  });

  testWidgets('searching waits for typing to stop', (tester) async {
    final repository = await pump(tester);
    final before = repository.queries.length;

    await tester.enterText(find.byType(TextField), 'Li');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'Liam');
    await tester.pump(const Duration(milliseconds: 100));
    expect(repository.queries.length, before);

    await tester.pumpAndSettle(const Duration(milliseconds: 400));
    expect(repository.queries.length, before + 1);
    expect(repository.queries.last.search, 'Liam');
    expect(find.text('Samantha'), findsNothing);
    expect(
      find.descendant(of: find.byType(RankRow), matching: find.text('Liam')),
      findsOneWidget,
    );
  });

  testWidgets('choosing a state ranks within it', (tester) async {
    final repository = await pump(tester);

    await tester.tap(find.text('State'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Tex');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Texas').last);
    await tester.pumpAndSettle();

    expect(repository.queries.last.state, 'Texas');
    expect(find.text('Participants in Texas.'), findsOneWidget);
    final liam = find.ancestor(
      of: find.text('Liam'),
      matching: find.byType(RankRow),
    );
    expect(find.descendant(of: liam, matching: find.text('1')), findsOneWidget);
    expect(find.text('Samantha'), findsNothing);
  });

  group('edge cases', edgeCases);
}

// ---------------------------------------------------------------------------
// Edge cases, paging and the controller's stale-page guard.
// ---------------------------------------------------------------------------

List<LeaderboardEntry> top5() => [
      entry('Alexandra', 1),
      entry('Bida', 2),
      entry('Carl', 3),
      entry('Kyle', 4),
      entry('Kylie', 5),
    ];

/// Hands back futures the test resolves by hand, so it can choose the order
/// replies arrive in.
class GatedLeaderboardRepository extends FakeLeaderboardRepository {
  GatedLeaderboardRepository({required super.top, required super.rest});

  final pending = <Completer<List<LeaderboardEntry>>>[];

  @override
  Future<List<LeaderboardEntry>> participants({
    String? state,
    String? search,
    required int offset,
    required int limit,
  }) {
    queries.add((state: state, search: search, offset: offset));
    final c = Completer<List<LeaderboardEntry>>();
    pending.add(c);
    return c.future;
  }
}

void edgeCases() {
  Future<FakeLeaderboardRepository> pumpWith(
    WidgetTester tester, {
    required List<LeaderboardEntry> top,
    List<LeaderboardEntry> rest = const [],
    MyStanding? standing,
    double width = 393,
  }) async {
    tester.view.physicalSize = Size(width, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository =
        FakeLeaderboardRepository(top: top, rest: rest, standing: standing);
    await tester.pumpWidget(
      MaterialApp(home: LeaderboardScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('an empty board shows the empty cards and no podium',
      (tester) async {
    await pumpWith(tester, top: const []);

    expect(tester.takeException(), isNull);
    expect(find.text('No participants yet'), findsOneWidget);
    expect(find.text('No national rankings yet'), findsOneWidget);
    expect(find.byType(PodiumCard), findsNothing);
    expect(find.byType(RankRow), findsNothing);
    expect(find.text('No one found'), findsNothing);
  });

  testWidgets('nobody has mowed yet: trophy card, everyone in the list',
      (tester) async {
    await pumpWith(
      tester,
      top: [
        for (var i = 1; i <= 5; i++) entry('Kid$i', i, lawns: 0),
      ],
      rest: [entry('Kid6', 6, lawns: 0)],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No national rankings yet'), findsOneWidget);
    expect(find.byType(PodiumCard), findsNothing);
    // The would-be podium joins the list rather than disappearing.
    for (var i = 1; i <= 6; i++) {
      expect(
        find.descendant(
          of: find.byType(RankRow),
          matching: find.text('Kid$i'),
        ),
        findsOneWidget,
        reason: 'Kid$i',
      );
    }
    expect(find.text('No participants yet'), findsNothing);
  });

  testWidgets('with no lawns yet, my row becomes the "not on the board" card',
      (tester) async {
    final me = entry('Zed', 6, lawns: 0);
    await pumpWith(
      tester,
      top: [for (var i = 1; i <= 5; i++) entry('Kid$i', i, lawns: 10 - i)],
      rest: [me],
      standing: MyStanding(state: 'Alabama', photoUrl: null, entry: me),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No achievement yet'), findsOneWidget);
    expect(find.text("You're not on the board yet"), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RankRow && w.mine), findsNothing);
    expect(find.byType(PodiumCard), findsOneWidget);
  });

  testWidgets('once I have a lawn, my row is back and the card is gone',
      (tester) async {
    final me = entry('Zed', 6, lawns: 1);
    await pumpWith(
      tester,
      top: [for (var i = 1; i <= 5; i++) entry('Kid$i', i, lawns: 10 - i)],
      rest: [me],
      standing: MyStanding(state: 'Alabama', photoUrl: null, entry: me),
    );

    expect(find.text('No achievement yet'), findsNothing);
    expect(find.byWidgetPredicate((w) => w is RankRow && w.mine), findsOneWidget);
  });

  testWidgets('one approved lawn is enough for the podium', (tester) async {
    await pumpWith(
      tester,
      top: [entry('Ava', 1, lawns: 1), entry('Bo', 2, lawns: 0)],
    );

    expect(find.byType(PodiumCard), findsOneWidget);
    expect(find.text('No national rankings yet'), findsNothing);
  });

  testWidgets('a search with no matches says no one was found',
      (tester) async {
    await pumpWith(
      tester,
      top: [entry('Alexandra', 1)],
      rest: [entry('Samantha', 6)],
    );

    await tester.enterText(find.byType(TextField), 'Zzz');
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('No one found'), findsOneWidget);
    expect(find.text('Samantha'), findsNothing);
    // The podium stays; only the list is filtered.
    expect(find.byType(PodiumCard), findsOneWidget);
  });

  for (final count in [1, 2]) {
    testWidgets('a board of $count renders without errors', (tester) async {
      final people = [entry('Alexandra', 1), entry('Bida', 2)].take(count);
      await pumpWith(tester, top: people.toList());

      expect(tester.takeException(), isNull);
      expect(find.byType(PodiumCard), findsOneWidget);
      expect(find.text('Alexandra'), findsOneWidget);
      expect(find.text('Bida'), count == 2 ? findsOneWidget : findsNothing);
      expect(find.byType(RankRow), findsNothing);
    });
  }

  // The live board today has exactly five people, so this is what ships.
  testWidgets('five or fewer people, no filter: no "No one found"',
      (tester) async {
    await pumpWith(tester, top: top5());

    expect(find.text('Kylie'), findsOneWidget);
    expect(
      find.text('No one found'),
      findsNothing,
      reason: 'nobody searched or filtered; an empty list after the podium '
          'is not a failed search',
    );
  });

  testWidgets('long names, big counts and 3-digit ranks do not overflow',
      (tester) async {
    const long = 'Maximiliana-Alexandrina-Wolfeschlegelsteinhausen';
    await pumpWith(
      tester,
      width: 320,
      top: [
        entry(long, 1, lawns: 1234),
        entry(long, 2, lawns: 999),
        entry(long, 3, lawns: 100),
        entry(long, 4, lawns: 99),
        entry(long, 5, lawns: 1),
      ],
      rest: [entry(long, 123, lawns: 0), entry('Ava', 999)],
      standing: MyStanding(
        state: 'District of Columbia',
        photoUrl: null,
        entry: entry('Ava', 999),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('123'), findsOneWidget);
    expect(find.text('999'), findsOneWidget);
    expect(find.text('1 lawn'), findsNothing); // fifth place is a row
    expect(find.text('1234 lawns'), findsOneWidget);
    expect(find.text('Team District of Columbia'), findsOneWidget);
  });

  testWidgets('scrolling to the bottom asks for the next page',
      (tester) async {
    final rest = [for (var i = 6; i < 6 + 45; i++) entry('Kid$i', i)];
    final repository = await pumpWith(tester, top: top5(), rest: rest);
    expect(repository.queries.single.offset, 0);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -6000));
    await tester.pumpAndSettle();
    expect(repository.queries.map((q) => q.offset), contains(30));

    // The second page was short, so paging stops there.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -6000));
    await tester.pumpAndSettle();
    expect(repository.queries.where((q) => q.offset > 30), isEmpty);
    expect(find.text('Kid50'), findsOneWidget);
  });

  test('a page that lands after the filter changed is dropped', () async {
    final full = [for (var i = 6; i < 36; i++) entry('Kid$i', i)];
    final repository = GatedLeaderboardRepository(top: top5(), rest: full);
    final controller = LeaderboardController(repository: repository);

    final loading = controller.load();
    await pumpEventQueue();
    repository.pending.single.complete(full);
    await loading;
    expect(controller.participants, hasLength(30));
    expect(controller.hasMore, isTrue);

    // Page two sets off, then the child picks a state before it lands.
    final more = controller.loadMore();
    expect(repository.queries.last.offset, 30);
    controller.chooseState('Texas');
    expect(repository.queries.last, (state: 'Texas', search: '', offset: 0));

    final texas = [entry('Liam', 7, state: 'Texas', stateRank: 1)];
    repository.pending[2].complete(texas);
    await pumpEventQueue();
    // The stale national page arrives last.
    repository.pending[1]
        .complete([for (var i = 36; i < 66; i++) entry('Kid$i', i)]);
    await more;
    await pumpEventQueue();

    expect(controller.participants, texas);
    expect(controller.loadingPage, isFalse);
    expect(controller.hasMore, isFalse);
    controller.dispose();
  });

  test('a refresh that lands after the filter changed does not overwrite it',
      () async {
    final national = [for (var i = 6; i < 16; i++) entry('Kid$i', i)];
    final repository = GatedLeaderboardRepository(top: top5(), rest: national);
    final controller = LeaderboardController(repository: repository);

    final first = controller.load();
    await pumpEventQueue();
    repository.pending.single.complete(national);
    await first;

    // Pull to refresh, then pick a state while the refresh is in flight.
    final refresh = controller.load();
    controller.chooseState('Texas');
    final texas = [entry('Liam', 7, state: 'Texas', stateRank: 1)];
    repository.pending[2].complete(texas); // the state reload
    await pumpEventQueue();
    repository.pending[1].complete(national); // the refresh's national page
    await refresh;

    expect(controller.state, 'Texas');
    expect(
      controller.participants,
      texas,
      reason: 'the refresh fetched the national list before the state was '
          'chosen, and must not replace the Texas list',
    );
    controller.dispose();
  });
}
