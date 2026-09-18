import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/auth/sign_in/sign_in_screen.dart';

void main() {
  late List<(String, String)> attempts;
  late List<String> resets;
  String? nextError;

  setUp(() {
    attempts = [];
    resets = [];
    nextError = null;
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: SignInScreen(
          onSignIn: (email, password) async {
            attempts.add((email, password));
            return nextError;
          },
          onForgotPassword: (email) async => resets.add(email),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Opacity buttonOpacity(WidgetTester tester) => tester.widget<Opacity>(
        find
            .ancestor(
              of: find.text('Sign In').last,
              matching: find.byType(Opacity),
            )
            .first,
      );

  testWidgets('renders the design', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Sign In'), findsNWidgets(2)); // title + button
    expect(
        find.text('Welcome back! Please enter your details.'), findsOneWidget);
    expect(find.text('Email or Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Having trouble logging in?'), findsOneWidget);
    expect(find.textContaining('Create Account', findRichText: true),
        findsOneWidget);
  });

  testWidgets('the button waits for both fields', (tester) async {
    await pumpScreen(tester);
    expect(buttonOpacity(tester).opacity, 0.5);

    await tester.enterText(
        find.widgetWithText(TextField, 'Email or Username'), 'a@b.com');
    await tester.pumpAndSettle();
    expect(buttonOpacity(tester).opacity, 0.5);

    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'Mow50Lawns');
    await tester.pumpAndSettle();
    expect(buttonOpacity(tester).opacity, 1.0);
  });

  testWidgets('signing in passes the trimmed email through', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(
        find.widgetWithText(TextField, 'Email or Username'), '  a@b.com  ');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'Mow50Lawns');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In').last);
    await tester.pumpAndSettle();

    expect(attempts, [('a@b.com', 'Mow50Lawns')]);
  });

  testWidgets('a failed sign-in surfaces the reason', (tester) async {
    await pumpScreen(tester);
    nextError = 'Invalid login credentials';

    await tester.enterText(
        find.widgetWithText(TextField, 'Email or Username'), 'a@b.com');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'wrong-password');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In').last);
    await tester.pumpAndSettle();

    expect(find.text('Invalid login credentials'), findsOneWidget);
  });

  testWidgets('Forgot Password? needs an email first', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    expect(resets, isEmpty);
    expect(find.textContaining('Enter your email first'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextField, 'Email or Username'), 'a@b.com');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    expect(resets, ['a@b.com']);
  });
}
