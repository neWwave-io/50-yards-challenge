import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/core/widgets/app_tab_bar.dart';

void main() {
  Future<List<AppTab>> pump(WidgetTester tester, AppTab? current) async {
    final taps = <AppTab>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        bottomNavigationBar: AppTabBar(current: current, onSelect: taps.add),
      ),
    ));
    await tester.pumpAndSettle();
    return taps;
  }

  testWidgets("shows only the active tab's label", (tester) async {
    await pump(tester, AppTab.board);

    expect(tester.takeException(), isNull);
    expect(find.text('Board'), findsOneWidget);
    for (final tab in AppTab.values.where((t) => t != AppTab.board)) {
      expect(find.text(tab.label), findsNothing, reason: tab.label);
    }
  });

  testWidgets('with no current tab no label is shown', (tester) async {
    await pump(tester, null);

    for (final tab in AppTab.values) {
      expect(find.text(tab.label), findsNothing, reason: tab.label);
    }
  });

  testWidgets('tapping a tab reports that tab', (tester) async {
    final taps = await pump(tester, AppTab.home);

    for (final tab in AppTab.values) {
      await tester.tap(find.bySemanticsLabel(tab.label));
      await tester.pumpAndSettle();
    }
    expect(taps, AppTab.values);
  });

  testWidgets('fits the design width at 1.3x text size', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    for (final tab in AppTab.values) {
      await pump(tester, tab);
      expect(tester.takeException(), isNull, reason: tab.label);
    }
  });

  // The bar is sized by its tabs, not stretched to a fixed width, so there
  // is no dead space between the icons. It must stay clear of both edges.
  testWidgets('hugs its tabs rather than filling the screen', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    for (final tab in AppTab.values) {
      await pump(tester, tab);
      final pill = tester.getRect(
        find
            .descendant(
              of: find.byType(AppTabBar),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(pill.width, lessThan(380), reason: tab.label);
      // Never closer to the edge than the bar's own minimum margin.
      expect(pill.left, greaterThanOrEqualTo(8.0), reason: tab.label);
      // Centred, so the margins match.
      expect(pill.left, closeTo(393 - pill.right, 0.5), reason: tab.label);
    }
  });

  // A Center in the Scaffold's bottom slot takes every pixel it is offered,
  // which once left the bar floating in the middle of the screen.
  testWidgets('is only as tall as itself, and sits at the bottom',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        extendBody: true,
        body: const SizedBox.expand(),
        bottomNavigationBar: AppTabBar(current: AppTab.home, onSelect: (_) {}),
      ),
    ));
    await tester.pumpAndSettle();

    final bar = tester.getRect(find.byType(AppTabBar));
    expect(bar.height, lessThan(120));
    expect(bar.bottom, 852);
  });

  // 320dp: iPhone SE (1st gen) and small Android phones.
  testWidgets('fits a small phone with any tab active', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    for (final tab in AppTab.values) {
      await pump(tester, tab);
      expect(tester.takeException(), isNull, reason: tab.label);
    }
  });
}
