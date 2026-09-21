import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';
import 'package:the_50_yard_challenge/features/home/widgets/mowed_for_grid.dart';

void main() {
  List<CategoryTally> tallies(Map<MowedCategory, int> counts) {
    final busiest = counts.values.fold(0, (a, b) => a > b ? a : b);
    return [
      for (final category in kMowedCategories)
        CategoryTally(
          category: category,
          count: counts[category] ?? 0,
          share: busiest == 0 ? 0 : (counts[category] ?? 0) / busiest,
        ),
    ];
  }

  Future<void> pumpGrid(WidgetTester tester, List<CategoryTally> data) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: MowedForGrid(tallies: data),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // A Container given an `alignment` expands to fill bounded constraints, so
  // every badge grew to the size of its tile and swallowed the grid.
  testWidgets('the count badge stays a badge', (tester) async {
    await pumpGrid(
      tester,
      tallies({
        MowedCategory.elderly: 4,
        MowedCategory.singleParent: 3,
        MowedCategory.veteran: 2,
        MowedCategory.firstResponder: 1,
      }),
    );

    for (final count in ['4', '3', '2', '1']) {
      // The pill itself, not the text inside it: an expanded container
      // still holds a small, centred number.
      final badge = tester.getRect(
        find
            .ancestor(of: find.text(count), matching: find.byType(Container))
            .first,
      );
      expect(badge.width, lessThan(30), reason: 'the $count badge is $badge');
      expect(badge.height, lessThan(30), reason: 'the $count badge is $badge');
    }
  });

  testWidgets('a category with nothing mowed shows no count', (tester) async {
    await pumpGrid(tester, tallies({MowedCategory.elderly: 4}));

    expect(find.text('4'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('every category keeps its own tile', (tester) async {
    await pumpGrid(tester, tallies({MowedCategory.elderly: 2}));

    for (final category in kMowedCategories) {
      expect(find.text(category.label), findsOneWidget);
    }
  });

  testWidgets('the badge follows the arc round as the count grows',
      (tester) async {
    await pumpGrid(
      tester,
      tallies({
        MowedCategory.elderly: 4, // the busiest: half a turn
        MowedCategory.singleParent: 1, // a quarter of that
      }),
    );

    final busiest = tester.getRect(find.text('4'));
    final smallest = tester.getRect(find.text('1'));
    final busiestTile = tester.getRect(find.text('Elderly'));
    final smallestTile = tester.getRect(find.text('Single parent'));

    // The full arc ends at the bottom of its ring, the short one up to the
    // right — so relative to its own tile, the small count sits higher.
    expect(busiest.center.dy - busiestTile.center.dy,
        greaterThan(smallest.center.dy - smallestTile.center.dy));
  });
}
