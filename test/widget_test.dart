import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_50_yard_challenge/features/auth/auth_screen.dart';

void main() {
  testWidgets('auth screen renders sign-up form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Create account'), findsOneWidget);
  });

  testWidgets('toggles to sign in', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.tap(find.text('Already have an account? Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
