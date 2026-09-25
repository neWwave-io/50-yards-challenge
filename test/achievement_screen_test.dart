import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/achievement/achievement_screen.dart';
import 'package:the_50_yard_challenge/features/achievement/data/achievement_data.dart';
import 'package:the_50_yard_challenge/features/achievement/data/achievement_repository.dart';
import 'package:the_50_yard_challenge/features/achievement/widgets/lawn_card.dart';
import 'package:the_50_yard_challenge/features/achievement/widgets/lawn_detail_row.dart';
import 'package:the_50_yard_challenge/features/achievement/widgets/lawn_photo_tile.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/data/lawn_draft.dart'
    show LawnPhoto;

/// Serves a fixed history, so the screen can be exercised without Supabase.
class FakeAchievementRepository implements AchievementRepository {
  FakeAchievementRepository(this.lawns);

  final List<SubmittedLawn> lawns;

  @override
  Future<List<SubmittedLawn>> reviewedLawns() async => lawns;
}

SubmittedLawn buildLawn({
  String id = 'a',
  int number = 1,
  LawnReview review = LawnReview.approved,
  String? address,
  bool? woreSafetyGear = true,
  Map<LawnPhoto, String> photos = const {},
}) =>
    SubmittedLawn(
      id: id,
      number: number,
      review: review,
      mowedFor: 'Elderly',
      service: 'Lawn Mowing',
      address: address,
      mowedOn: DateTime(2026, 8, 20),
      hours: 2,
      woreSafetyGear: woreSafetyGear,
      photos: photos,
    );

/// [key] forces a fresh State when one test pumps the screen twice — the
/// screen builds its controller once, in initState, so reusing the element
/// would keep serving the first repository.
Future<void> pumpScreen(
  WidgetTester tester,
  List<SubmittedLawn> lawns, {
  Key? key,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AchievementScreen(
        key: key,
        repository: FakeAchievementRepository(lawns),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists a reviewed lawn with its number and facts',
      (tester) async {
    await pumpScreen(tester, [buildLawn(number: 7)]);

    expect(find.text('Achievement'), findsOneWidget);
    expect(find.text('Lawn 7'), findsOneWidget);
    expect(find.text('Elderly'), findsOneWidget);
    expect(find.text('Lawn Mowing'), findsOneWidget);
    expect(find.text('20th/ Aug/ 2026'), findsOneWidget);
    expect(find.text('2.0'), findsOneWidget);
  });

  testWidgets('leaves the Location row out until a lawn has an address',
      (tester) async {
    await pumpScreen(tester, [buildLawn()], key: const Key('without'));
    expect(find.text('Location'), findsNothing);

    await pumpScreen(
      tester,
      [buildLawn(address: 'St.099, #009, Pluto')],
      key: const Key('with'),
    );
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('St.099, #009, Pluto'), findsOneWidget);
  });

  testWidgets('View opens one card at a time', (tester) async {
    // Tall enough that an open card cannot push the next card's View button
    // past the bottom edge, where a tap would silently miss it.
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    const photos = {LawnPhoto.before: 'u', LawnPhoto.safety: 'u'};
    await pumpScreen(tester, [
      buildLawn(id: 'a', number: 1, photos: photos),
      buildLawn(id: 'b', number: 2, photos: photos),
    ]);

    expect(find.byType(LawnPhotoTile), findsNothing);

    await tester.tap(find.text('View').first);
    await tester.pumpAndSettle();
    // The four proof slots, filled or not, plus the safety photo.
    expect(find.byType(LawnPhotoTile), findsNWidgets(5));
    expect(find.text('Lawn Before Photo'), findsOneWidget);
    expect(find.text('Safety check'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);

    // Opening the other closes the first: still one card's worth of slots.
    await tester.tap(find.text('View').last);
    await tester.pumpAndSettle();
    expect(find.byType(LawnPhotoTile), findsNWidgets(5));

    // Tapping the open one shuts it.
    await tester.tap(find.text('View').last);
    await tester.pumpAndSettle();
    expect(find.byType(LawnPhotoTile), findsNothing);
  });

  testWidgets('a rejected lawn cannot be opened', (tester) async {
    await pumpScreen(tester, [
      buildLawn(review: LawnReview.rejected, photos: {LawnPhoto.before: 'u'}),
    ]);

    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    expect(find.byType(LawnPhotoTile), findsNothing);
  });

  testWidgets('says so when nothing has been reviewed', (tester) async {
    await pumpScreen(tester, const []);

    expect(find.byType(LawnCard), findsNothing);
    expect(find.text('Nothing reviewed yet'), findsOneWidget);
  });

  /// The numbers below are read straight off the Figma frame (node
  /// 2088:11151) at its 393pt width, so a later refactor cannot quietly
  /// change the spacing the design asks for.
  testWidgets('matches the measurements in the design', (tester) async {
    tester.view.physicalSize = const Size(393, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpScreen(tester, [
      buildLawn(address: 'St.099, #009, pluto, Mars', photos: {
        LawnPhoto.before: 'u',
        LawnPhoto.after: 'u',
        LawnPhoto.safety: 'u',
      }),
    ]);

    // The content column is 353 wide: a 393 screen less 20 each side.
    expect(tester.getSize(find.byType(LawnCard)).width, 353);

    // A proof photo is 120 tall, two to a row with 12 between them.
    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    final tiles = tester.widgetList<LawnPhotoTile>(find.byType(LawnPhotoTile));
    expect(tiles.first.height, 120);
    final before = tester.getRect(find.byType(LawnPhotoTile).at(0));
    final after = tester.getRect(find.byType(LawnPhotoTile).at(1));
    expect(before.height, 120);
    expect(after.left - before.right, 12);

    // The safety photo runs the full width of the card's inner column and is
    // 140 tall: 353 less the card's 12 padding and the panel's 8, twice over.
    final safety = tester.getRect(find.byType(LawnPhotoTile).last);
    expect(safety.height, 140);
    expect(safety.width, 353 - 2 * 12 - 2 * 8);

    // Detail rows sit 10 apart, not the 8 the spacing scale would suggest.
    final first = tester.getRect(find.byType(LawnDetailRow).at(0));
    final second = tester.getRect(find.byType(LawnDetailRow).at(1));
    expect(second.top - first.bottom, 10);
  });

  testWidgets('lays out without overflow on a narrow phone', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpScreen(tester, [
      buildLawn(
        address: 'St.099, #009, pluto, Mars',
        photos: {
          LawnPhoto.before: 'u',
          LawnPhoto.after: 'u',
          LawnPhoto.action: 'u',
          LawnPhoto.homeowner: 'u',
          LawnPhoto.safety: 'u',
        },
      ),
    ]);
    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
