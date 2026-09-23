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
  // as a sliver behind the ring instead of filling the card.
  testWidgets('the passport fills the card rather than a sliver of it',
      (tester) async {
    await pumpCard(tester);

    final card = tester.getRect(find.byType(AppCard));
    final passport = tester.getRect(find.byType(Image));

    expect(passport.height, greaterThan(card.height),
        reason: 'the booklet should run past the card, top and bottom');
    // Square asset, so its width follows its height.
    expect(passport.width, closeTo(passport.height, 0.5));
    // It belongs on the left, under the ring — not spread over the copy.
    expect(passport.left, lessThan(card.left),
        reason: 'the booklet should reach the card edge');
    expect(passport.center.dx, lessThan(card.center.dx));
  });

  testWidgets('shows the hours against the goal', (tester) async {
    await pumpCard(tester);

    expect(find.text('40H'), findsOneWidget);
    expect(find.text('50H'), findsOneWidget);
    expect(find.text('Start Mowing'), findsOneWidget);
  });
}
