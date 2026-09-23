import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/core/widgets/app_card.dart';
import 'package:the_50_yard_challenge/features/home/widgets/passport_card.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(20),
            child: PassportCard(totalHours: 40),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Boxed to a fixed 99px and cropped with BoxFit.cover, the booklet showed
  // as a sliver; sized past the card it was cut off top and bottom instead.
  testWidgets('the whole passport fits the card, uncut', (tester) async {
    await pumpCard(tester);

    final card = tester.getRect(find.byType(AppCard));
    final passport = tester.getRect(find.byType(Image));

    // As tall as the card, and no taller: nothing is cropped away.
    expect(passport.height, closeTo(card.height, 0.5));
    expect(passport.top, greaterThanOrEqualTo(card.top - 0.5));
    expect(passport.bottom, lessThanOrEqualTo(card.bottom + 0.5));
    // Upright, following the art's own shape rather than a square.
    expect(passport.width, lessThan(passport.height));
    // It belongs on the left, under the ring — not spread over the copy.
    expect(passport.left, lessThanOrEqualTo(card.left));
    expect(passport.right, lessThan(card.center.dx));
  });

  testWidgets('shows the hours against the goal', (tester) async {
    await pumpCard(tester);

    expect(find.text('40H'), findsOneWidget);
    expect(find.text('50H'), findsOneWidget);
    expect(find.text('Start Mowing'), findsOneWidget);
  });
}
