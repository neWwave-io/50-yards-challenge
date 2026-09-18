import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/core/constants/child_options.dart';
import 'package:the_50_yard_challenge/features/auth/sign_up/child.dart';
import 'package:the_50_yard_challenge/features/auth/sign_up/data/sign_up_draft.dart';
import 'package:the_50_yard_challenge/features/auth/sign_up/data/sign_up_repository.dart';
import 'package:the_50_yard_challenge/features/auth/sign_up/sign_up_children_screen.dart';

const _account = SignUpDraft(
  fullName: 'Chris Baker',
  email: 'chris@example.com',
  password: 'Mow50Lawns!',
  relationship: 'Parents',
  city: 'Austin',
  state: 'Texas',
);

/// Records what the screen would have sent, without touching Supabase.
class RecordingSignUpRepository implements SignUpRepository {
  SignUpDraft? account;
  List<Child>? children;

  @override
  Future<void> signUp({
    required SignUpDraft account,
    required List<Child> children,
  }) async {
    this.account = account;
    this.children = children;
  }
}

void main() {
  Future<RecordingSignUpRepository> pumpScreen(
    WidgetTester tester, {
    VoidCallback? onCompleted,
  }) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = RecordingSignUpRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: SignUpChildrenScreen(
          account: _account,
          repository: repository,
          onCompleted: onCompleted,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  /// Fills in the entry card that is currently open and commits it.
  Future<void> completeOpenCard(WidgetTester tester) async {
    await tester.tap(find.text('Date of birth'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gender'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Shirt Size'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Youth Large').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders step 2 with no children yet', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Step 2 of 2'), findsOneWidget);
    expect(find.text('Child(ren) Information'), findsOneWidget);
    expect(find.text('Child Name'), findsWidgets);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.text('CHILD 1'), findsNothing);
  });

  testWidgets('the plus opens an entry card seeded with the typed name',
      (tester) async {
    await pumpScreen(tester);

    await tester.enterText(
        find.widgetWithText(TextField, 'Child Name'), 'Emma');
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Add child'));
    await tester.pumpAndSettle();

    expect(find.text('CHILD 1'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Emma'), findsOneWidget);
  });

  testWidgets('a completed child collapses into a summary card, then signs up',
      (tester) async {
    var completed = false;
    final repository = await pumpScreen(tester, onCompleted: () => completed = true);

    // Submitting a name on the "Child Name" field opens the entry card.
    await tester.enterText(
        find.widgetWithText(TextField, 'Child Name'), 'Emma');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('CHILD 1'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);

    await completeOpenCard(tester);

    // Now a read-only summary, not the entry card.
    expect(find.text('CHILD 1'), findsNothing);
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Emma · Female'), findsOneWidget);
    expect(find.text('Youth Large'), findsOneWidget);

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(repository.account, same(_account));
    expect(repository.children!.single.name, 'Emma');
    expect(repository.children!.single.shirtSize, 'Youth Large');
    expect(repository.children!.single.gender, ChildGender.female);
    expect(completed, isTrue);
  });

  testWidgets('Remove drops the child', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(
        find.widgetWithText(TextField, 'Child Name'), 'Emma');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('CHILD 1'), findsNothing);
  });

  group('formatBirthday', () {
    test('uses an ordinal day and a short month', () {
      expect(formatBirthday(DateTime(2014, 9, 12)), '12th/Sep');
      expect(formatBirthday(DateTime(2014, 1, 1)), '1st/Jan');
      expect(formatBirthday(DateTime(2014, 3, 22)), '22nd/Mar');
      expect(formatBirthday(DateTime(2014, 12, 3)), '3rd/Dec');
      expect(formatBirthday(DateTime(2014, 5, 11)), '11th/May');
    });
  });
}
