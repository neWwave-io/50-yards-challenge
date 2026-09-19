import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/auth/sign_up/sign_up_screen.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders step 1 of the sign-up form', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Step 1 of 2'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    for (final label in ['Full Name', 'Email', 'Password', 'Confirm Password']) {
      expect(find.text(label), findsOneWidget);
    }
    // City waits on State.
    expect(find.text('Select a state first'), findsOneWidget);
    expect(find.text('City'), findsNothing);
    expect(find.text('Next'), findsOneWidget);
    expect(find.textContaining('Sign In here', findRichText: true),
        findsOneWidget);
  });

  testWidgets('the relationship dropdown opens and selects', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Relationship'));
    await tester.pumpAndSettle();

    expect(find.text('Parents'), findsOneWidget);
    expect(find.text('Guardian'), findsOneWidget);
    expect(find.text('Relative'), findsOneWidget);

    await tester.tap(find.text('Guardian'));
    await tester.pumpAndSettle();

    expect(find.text('Guardian'), findsOneWidget);
    expect(find.text('Parents'), findsNothing);
  });

  testWidgets('the state dropdown filters as you search', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('State'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Search...'), 'tex');
    await tester.pumpAndSettle();

    expect(find.text('Texas'), findsOneWidget);
    expect(find.text('Alaska'), findsNothing);
  });

  testWidgets('Next stays disabled until the step is complete',
      (tester) async {
    await pumpScreen(tester);

    Opacity buttonOpacity() => tester.widget<Opacity>(
          find.ancestor(
            of: find.text('Next'),
            matching: find.byType(Opacity),
          ).first,
        );

    expect(buttonOpacity().opacity, 0.5);

    await tester.enterText(
        find.widgetWithText(TextField, 'Full Name'), 'Chris Baker');
    await tester.enterText(
        find.widgetWithText(TextField, 'Email'), 'chris@example.com');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'Mow50Lawns!');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'Mow50Lawns!');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Relationship'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parents'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('State'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Search...'), 'Texas');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Texas').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('City'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Search...'), 'Austin');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Austin').last);
    await tester.pumpAndSettle();

    expect(buttonOpacity().opacity, 1.0);
  });

  testWidgets('City offers only the chosen state and resets when it changes',
      (tester) async {
    await pumpScreen(tester);

    // The panel is a lazy list, so search rather than scroll for a row.
    // [trigger] is whatever the field currently shows — its label while
    // empty, its value once chosen.
    Future<void> pick(String trigger, String option) async {
      await tester.tap(find.text(trigger).hitTestable());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Search...'), option);
      await tester.pumpAndSettle();
      await tester.tap(find.text(option).last);
      await tester.pumpAndSettle();
    }

    // find.text also matches the search box's own EditableText, so ask the
    // panel whether it went empty instead of looking for the row.
    Future<bool> cityOffers(String city) async {
      await tester.tap(find.text('City').hitTestable());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Search...'), city);
      await tester.pumpAndSettle();
      final offered = find.text('No matches').evaluate().isEmpty;
      await tester.tapAt(const Offset(4, 4)); // dismiss
      await tester.pumpAndSettle();
      return offered;
    }

    await pick('State', 'Wisconsin');
    expect(await cityOffers('Milwaukee'), isTrue);
    // Fresno is in California, so Wisconsin must not offer it.
    expect(await cityOffers('Fresno'), isFalse);

    await pick('City', 'Milwaukee');
    expect(find.text('Milwaukee'), findsOneWidget);

    // Switching state drops the city that no longer belongs to it.
    await pick('Wisconsin', 'California');
    expect(find.text('Milwaukee'), findsNothing);
    expect(find.text('City'), findsOneWidget);

    expect(await cityOffers('Fresno'), isTrue);
    expect(await cityOffers('Milwaukee'), isFalse);
  });

  testWidgets('a mismatched confirm password says so', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'Mow50Lawns');
    await tester.pumpAndSettle();
    // Nothing in the confirm box yet: unfinished, not wrong.
    expect(find.text("Passwords don't match"), findsNothing);

    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'Mow50Lawns!');
    await tester.pumpAndSettle();
    expect(find.text("Passwords don't match"), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextField, 'Mow50Lawns!'), 'Mow50Lawns');
    await tester.pumpAndSettle();
    expect(find.text("Passwords don't match"), findsNothing);
  });
}
