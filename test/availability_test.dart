import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/core/widgets/app_date_picker_dialog.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';
import 'package:the_50_yard_challenge/features/home/home_screen.dart';
import 'package:the_50_yard_challenge/features/home/widgets/availability_badge.dart';

import 'home_screen_test.dart' show FakeHomeRepository, buildData;

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  Future<FakeHomeRepository> pumpHome(
    WidgetTester tester,
    Availability availability,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository =
        FakeHomeRepository(buildData(availability: availability));
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  group('status line', () {
    testWidgets('an available family shows when they joined', (tester) async {
      await pumpHome(tester, const Availability.available());
      expect(find.text('Available Since 10th Aug'), findsOneWidget);
    });

    testWidgets('a family back from a break counts from their return',
        (tester) async {
      await pumpHome(
        tester,
        Availability.available(availableSince: DateTime(2026, 9, 3)),
      );
      expect(find.text('Available Since 3rd Sep'), findsOneWidget);
    });

    testWidgets('away with a date says when they are back', (tester) async {
      await pumpHome(
        tester,
        Availability(isAway: true, returnsOn: DateTime(2026, 10, 2)),
      );
      expect(find.text('Away until 2nd Oct'), findsOneWidget);
    });

    testWidgets('away with no date says so', (tester) async {
      await pumpHome(tester, const Availability(isAway: true));
      expect(find.text('Away for now'), findsOneWidget);
    });
  });

  group('tap sheet', () {
    testWidgets('going offline asks for no date', (tester) async {
      final repo = await pumpHome(tester, const Availability.available());

      await tester.tap(find.byType(AvailabilityBadge));
      await tester.pumpAndSettle();
      expect(
        find.text('Your day streak is kept safe while you are offline.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Go offline'));
      await tester.pumpAndSettle();

      expect(repo.awayCalls, [null]);
      expect(repo.loads, 2, reason: 'the page reloads after the change');
    });

    testWidgets('an away family can come back', (tester) async {
      final repo = await pumpHome(tester, const Availability(isAway: true));

      await tester.tap(find.byType(AvailabilityBadge));
      await tester.pumpAndSettle();
      expect(find.text('Go offline'), findsNothing);

      await tester.tap(find.textContaining("I'm back"));
      await tester.pumpAndSettle();

      expect(repo.availableCalls, 1);
      expect(repo.awayCalls, isEmpty);
    });

    testWidgets('picking a return date sends that date', (tester) async {
      // Start away with a date so the calendar opens on a known month.
      final back = today.add(const Duration(days: 3));
      final repo = await pumpHome(
        tester,
        Availability(isAway: true, returnsOn: back),
      );

      await tester.tap(find.byType(AvailabilityBadge));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Pick the day'));
      await tester.pumpAndSettle();

      expect(find.text('Set New'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.awayCalls, [back]);
    });
  });

  group('drag', () {
    Future<void> dragOnto(WidgetTester tester, String label) async {
      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(AvailabilityBadge)));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      // The targets only exist while the badge is being dragged.
      expect(find.text(label), findsOneWidget);
      final target = tester.getCenter(find.text(label)) - const Offset(0, 40);
      await gesture.moveTo(target);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
    }

    testWidgets('targets appear only while dragging', (tester) async {
      await pumpHome(tester, const Availability.available());
      expect(find.text('Go offline'), findsNothing);
      expect(find.text('Back on…'), findsNothing);
    });

    testWidgets('dropping on "Go offline" goes offline', (tester) async {
      final repo = await pumpHome(tester, const Availability.available());
      await dragOnto(tester, 'Go offline');

      expect(repo.awayCalls, [null]);
      expect(find.text('Go offline'), findsNothing,
          reason: 'the targets close after the drop');
    });

    testWidgets('dropping on "I\'m back" comes back', (tester) async {
      final repo = await pumpHome(tester, const Availability(isAway: true));
      await dragOnto(tester, "I'm back");

      expect(repo.availableCalls, 1);
    });

    testWidgets('dropping on the calendar opens the Set New sheet',
        (tester) async {
      await pumpHome(tester, const Availability.available());
      await dragOnto(tester, 'Back on…');

      expect(find.text('Set New'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });

  group('Save-mode calendar', () {
    Future<List<DateTime?>> openPicker(WidgetTester tester) async {
      final results = <DateTime?>[];
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => results.add(await showAppDatePicker(
              context,
              title: 'Set New',
              confirmLabel: 'Save',
              firstDate: DateTime(today.year, today.month),
              lastDate: DateTime(today.year, today.month + 1, 0),
            )),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return results;
    }

    testWidgets('Save does nothing until a day is chosen', (tester) async {
      final results = await openPicker(tester);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Set New'), findsOneWidget);
      expect(results, isEmpty);
    });

    testWidgets('tapping a day selects it without closing; Save returns it',
        (tester) async {
      final results = await openPicker(tester);

      await tester.tap(find.text('15').last);
      await tester.pumpAndSettle();
      expect(find.text('Set New'), findsOneWidget,
          reason: 'a tap only selects in Save mode');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(results, [DateTime(today.year, today.month, 15)]);
    });
  });
}
