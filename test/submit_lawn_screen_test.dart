import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:the_50_yard_challenge/core/widgets/app_primary_button.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart'
    show MowedCategory;
import 'package:the_50_yard_challenge/features/submit_lawn/data/lawn_draft.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/data/submit_lawn_repository.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/data/submit_result.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/submit_lawn_controller.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/submit_lawn_screen.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/widgets/lawn_logged_view.dart';
import 'package:the_50_yard_challenge/features/submit_lawn/widgets/level_look.dart';

/// A 1x1 transparent PNG, so Image.memory has something real to decode.
final _png = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// Records every submit and answers with [result], or throws [failure].
class FakeSubmitLawnRepository implements SubmitLawnRepository {
  FakeSubmitLawnRepository({this.result, this.failure, this.gate});

  SubmitResult? result;
  Object? failure;

  /// When set, submit waits on it — to hold the request in flight.
  Completer<void>? gate;

  final submitted = <LawnDraft>[];

  @override
  Future<SubmitResult> submit(LawnDraft draft) async {
    submitted.add(draft);
    if (gate != null) await gate!.future;
    if (failure != null) throw failure!;
    return result!;
  }
}

/// Stands in for the camera / library: every pick returns [_png].
class FakeImagePicker extends ImagePickerPlatform {
  var picks = 0;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    picks++;
    return XFile.fromData(_png, mimeType: 'image/png', name: 'p$picks.png');
  }
}

const rookie = Level(name: 'Rookie Mower', minLawns: 10, rank: 1);
const master = Level(name: 'Master Cutter', minLawns: 50, rank: 5);

SubmitResult resultFor(int n, {Level? level, double hours = 1.5}) =>
    SubmitResult(
      lawnNumber: n,
      hoursAdded: hours,
      verifiedHours: 12,
      level: level,
    );

Future<void> pumpScreen(
  WidgetTester tester,
  SubmitLawnRepository repo, {
  VoidCallback? onClose,
}) async {
  tester.view.physicalSize = const Size(393, 852) * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    home: SubmitLawnScreen(repository: repo, onClose: onClose),
  ));
  await tester.pumpAndSettle();
}

AppPrimaryButton mainButton(WidgetTester tester) =>
    tester.widget<AppPrimaryButton>(find.byType(AppPrimaryButton));

bool buttonEnabled(WidgetTester tester) => mainButton(tester).onPressed != null;

Finder get hoursField => find.byType(TextField).at(0);
Finder get noteField => find.byType(TextField).at(1);

Future<void> chooseService(WidgetTester tester, [String s = 'Lawn Mowing']) async {
  await tester.tap(find.text('Service'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(s).last);
  await tester.pumpAndSettle();
}

Future<void> fillDetails(WidgetTester tester, {String hours = '1.5'}) async {
  await tester.tap(find.text('Elderly'));
  await tester.pump();
  await chooseService(tester);
  await tester.enterText(hoursField, hours);
  await tester.pump();
}

Future<void> tapMain(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(AppPrimaryButton));
  await tester.tap(find.byType(AppPrimaryButton));
  await tester.pumpAndSettle();
}

Future<void> pickPhoto(WidgetTester tester, String label) async {
  final slot = find.bySemanticsLabel('Add $label');
  await tester.ensureVisible(slot);
  await tester.tap(slot);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Take a photo'));
  await tester.pumpAndSettle();
}

/// Walks all four steps to the Submit button.
Future<void> fillToSubmit(WidgetTester tester) async {
  await fillDetails(tester);
  await tapMain(tester);
  await pickPhoto(tester, 'Lawn before photo');
  await pickPhoto(tester, 'Lawn after photo');
  await tapMain(tester);
  await pickPhoto(tester, 'Child in action');
  await pickPhoto(tester, 'Child with owner');
  await tapMain(tester);
  await tester.tap(find.text('Yes'));
  await tester.pump();
  await pickPhoto(tester, 'Take picture of your kid.');
}

/// Loads the bundled Onest under the names google_fonts asks for, so text
/// is measured as on a device rather than in the test font.
Future<void> loadOnest() async {
  const files = {
    'Onest_400': 'Regular',
    'Onest_regular': 'Regular',
    'Onest_500': 'Medium',
    'Onest_600': 'SemiBold',
    'Onest_700': 'Bold',
    'Onest_900': 'Black',
  };
  for (final e in files.entries) {
    await (FontLoader(e.key)
          ..addFont(rootBundle.load('assets/fonts/Onest-${e.value}.ttf')))
        .load();
  }
}

void main() {
  late FakeImagePicker picker;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadOnest();
  });

  setUp(() {
    picker = FakeImagePicker();
    ImagePickerPlatform.instance = picker;
  });

  group('step 1 — My Lawn', () {
    testWidgets('the button stays disabled until the step is complete',
        (tester) async {
      await pumpScreen(tester, FakeSubmitLawnRepository());
      expect(find.text('My Lawn'), findsOneWidget);
      expect(buttonEnabled(tester), isFalse);

      await tester.tap(find.text('Elderly'));
      await tester.pump();
      expect(buttonEnabled(tester), isFalse);

      await chooseService(tester);
      expect(buttonEnabled(tester), isFalse, reason: 'hours still missing');

      await tester.enterText(hoursField, '2');
      await tester.pump();
      expect(buttonEnabled(tester), isTrue);
    });

    for (final (typed, ok) in const [
      ('0', false),
      ('25', false),
      ('abc', false),
      ('1.5', true),
      ('24', true),
      ('0.25', true),
    ]) {
      testWidgets('hours "$typed" ${ok ? 'is' : 'is not'} accepted',
          (tester) async {
        await pumpScreen(tester, FakeSubmitLawnRepository());
        await fillDetails(tester, hours: typed);
        expect(buttonEnabled(tester), ok);
      });
    }

    testWidgets('letters never reach the hours field', (tester) async {
      await pumpScreen(tester, FakeSubmitLawnRepository());
      await tester.enterText(hoursField, 'abc');
      await tester.pump();
      expect(tester.widget<TextField>(hoursField).controller!.text, isEmpty);
    });

    testWidgets('Back on the first step calls onClose', (tester) async {
      var closed = 0;
      await pumpScreen(tester, FakeSubmitLawnRepository(),
          onClose: () => closed++);
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(closed, 1);
    });
  });

  testWidgets('Back on step 2 returns to step 1 with the typed text kept',
      (tester) async {
    var closed = 0;
    await pumpScreen(tester, FakeSubmitLawnRepository(),
        onClose: () => closed++);
    await fillDetails(tester, hours: '1.5');
    await tester.enterText(noteField, 'Mrs Lee, corner lot');
    await tester.pump();
    await tapMain(tester);
    expect(find.text('Lawn\nDifferences'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(closed, 0);
    expect(find.text('My Lawn'), findsOneWidget);
    expect(find.text('1.5'), findsOneWidget);
    expect(find.text('Mrs Lee, corner lot'), findsOneWidget);
    expect(buttonEnabled(tester), isTrue);
  });

  testWidgets('photo steps need both photos before moving on',
      (tester) async {
    await pumpScreen(tester, FakeSubmitLawnRepository());
    await fillDetails(tester);
    await tapMain(tester);
    expect(buttonEnabled(tester), isFalse);
    await pickPhoto(tester, 'Lawn before photo');
    expect(buttonEnabled(tester), isFalse);
    await pickPhoto(tester, 'Lawn after photo');
    expect(buttonEnabled(tester), isTrue);
    expect(find.bySemanticsLabel('Replace Lawn before photo'), findsOneWidget);
  });

  testWidgets('the last step says Submit and needs an answer and a photo',
      (tester) async {
    await pumpScreen(tester, FakeSubmitLawnRepository());
    await fillDetails(tester);
    await tapMain(tester);
    await pickPhoto(tester, 'Lawn before photo');
    await pickPhoto(tester, 'Lawn after photo');
    await tapMain(tester);
    await pickPhoto(tester, 'Child in action');
    await pickPhoto(tester, 'Child with owner');
    await tapMain(tester);

    expect(find.text('Safety Check'), findsOneWidget);
    expect(mainButton(tester).label, 'Submit');
    expect(buttonEnabled(tester), isFalse);
    await tester.tap(find.text('No'));
    await tester.pump();
    expect(buttonEnabled(tester), isFalse);
    await pickPhoto(tester, 'Take picture of your kid.');
    expect(buttonEnabled(tester), isTrue);
  });

  testWidgets('a failed submit shows a SnackBar and stays on the form',
      (tester) async {
    final repo = FakeSubmitLawnRepository(
      failure: const SubmitLawnFailure('Your photos could not be uploaded.'),
    );
    await pumpScreen(tester, repo);
    await fillToSubmit(tester);
    await tapMain(tester);

    expect(repo.submitted, hasLength(1));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Your photos could not be uploaded.'), findsOneWidget);
    expect(find.byType(LawnLoggedView), findsNothing);
    expect(find.text('Safety Check'), findsOneWidget);
    expect(buttonEnabled(tester), isTrue, reason: 'can try again');
  });

  testWidgets('an unexpected error also shows a SnackBar', (tester) async {
    final repo = FakeSubmitLawnRepository(failure: StateError('boom'));
    await pumpScreen(tester, repo);
    await fillToSubmit(tester);
    await tapMain(tester);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(LawnLoggedView), findsNothing);
  });

  testWidgets('the draft sent carries everything that was filled in',
      (tester) async {
    final repo = FakeSubmitLawnRepository(result: resultFor(8));
    await pumpScreen(tester, repo);
    await fillToSubmit(tester);
    await tapMain(tester);

    final d = repo.submitted.single;
    expect(d.whoFor, MowedCategory.elderly);
    expect(d.service, 'Lawn Mowing');
    expect(d.hours, 1.5);
    expect(d.woreSafetyGear, isTrue);
    expect(d.photos.keys.toSet(), LawnPhoto.values.toSet());
    final now = DateTime.now();
    expect(d.mowedOn, DateTime(now.year, now.month, now.day));
  });

  testWidgets('a double tap on Submit sends the lawn once', (tester) async {
    final gate = Completer<void>();
    final repo = FakeSubmitLawnRepository(result: resultFor(8), gate: gate);
    await pumpScreen(tester, repo);
    await fillToSubmit(tester);

    await tester.ensureVisible(find.byType(AppPrimaryButton));
    await tester.tap(find.byType(AppPrimaryButton));
    await tester.pump();
    await tester.tap(find.byType(AppPrimaryButton), warnIfMissed: false);
    await tester.pump();
    expect(repo.submitted, hasLength(1));

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.byType(LawnLoggedView), findsOneWidget);
  });

  testWidgets('a successful submit shows the logged view; Done closes',
      (tester) async {
    var closed = 0;
    final repo = FakeSubmitLawnRepository(result: resultFor(8));
    await pumpScreen(tester, repo, onClose: () => closed++);
    await fillToSubmit(tester);
    await tapMain(tester);

    expect(find.byType(LawnLoggedView), findsOneWidget);
    expect(find.text('LAWN #8 LOGGED'), findsOneWidget);
    await tester.tap(find.text('Done'));
    expect(closed, 1);
  });

  group('LawnLoggedView text', () {
    Future<void> pumpLogged(WidgetTester tester, SubmitResult r) async {
      tester.view.physicalSize = const Size(393, 852) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: LawnLoggedView(result: r, onDone: () {})),
      ));
      await tester.pumpAndSettle();
    }

    String levelLine(WidgetTester tester) => tester
        .widgetList<RichText>(find.byType(RichText))
        .map((t) => t.text.toPlainText())
        .firstWhere((s) => s.startsWith('You '));

    testWidgets('N=8 is still a Starter Baby', (tester) async {
      await pumpLogged(tester, resultFor(8));
      expect(find.text('LAWN #8 LOGGED'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('Keep Going!'), findsOneWidget);
      expect(levelLine(tester), 'You are currently a Starter Baby');
      expect(find.text('+1.5 hrs on your Passport'), findsOneWidget);
      expect(find.text('12 verified hours · pending'), findsOneWidget);
    });

    testWidgets('N=10 levels up to Rookie Mower', (tester) async {
      await pumpLogged(tester, resultFor(10, level: rookie));
      expect(find.text('LAWN #10 LOGGED'), findsOneWidget);
      expect(levelLine(tester), 'You have leveled up to a Rookie Mower');
    });

    testWidgets('N=13 is currently a Rookie Mower', (tester) async {
      await pumpLogged(tester, resultFor(13, level: rookie));
      expect(levelLine(tester), 'You are currently a Rookie Mower');
    });

    testWidgets('N=50 levels up to Master Cutter', (tester) async {
      await pumpLogged(tester, resultFor(50, level: master, hours: 2));
      expect(find.text('50'), findsOneWidget);
      expect(levelLine(tester), 'You have leveled up to a Master Cutter');
      expect(find.text('+2 hrs on your Passport'), findsOneWidget);
    });

    testWidgets('does not overflow on a small phone', (tester) async {
      tester.view.physicalSize = const Size(320, 568) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LawnLoggedView(result: resultFor(8), onDone: () {}),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  // Bugs found in review, kept as regression tests.
  group('fixed in review', () {
    testWidgets('an unknown lawn number says "Lawn logged", not "#1"',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LawnLoggedView(
            result: const SubmitResult(
              lawnNumber: null,
              hoursAdded: 2,
              verifiedHours: 0,
              level: null,
            ),
            onDone: () {},
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('LAWN LOGGED'), findsOneWidget);
      expect(find.textContaining('#'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the progress track spans the full width at N=8',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LawnLoggedView(result: resultFor(8), onDone: () {}),
        ),
      ));
      await tester.pumpAndSettle();
      final track = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == LevelLook.starter.track,
      );
      // 393 wide less 20 either side.
      expect(tester.getSize(track).width, closeTo(353, 1));
    });

    testWidgets('Start Mowing fits at 130% text size', (tester) async {
      tester.view.physicalSize = const Size(393, 852) * 2;
      tester.view.devicePixelRatio = 2;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(MaterialApp(
        home: SubmitLawnScreen(repository: FakeSubmitLawnRepository()),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('the logged view fits an iPhone SE under its status bar',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568) * 2;
      tester.view.devicePixelRatio = 2;
      tester.view.padding = const FakeViewPadding(top: 40);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LawnLoggedView(result: resultFor(8), onDone: () {}),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('LevelLook.forRank', () {
    test('0 and null are the plain starter page', () {
      expect(LevelLook.forRank(null), same(LevelLook.starter));
      expect(LevelLook.forRank(0), same(LevelLook.starter));
      expect(LevelLook.forRank(-1), same(LevelLook.starter));
      expect(LevelLook.starter.isColoured, isFalse);
      expect(LevelLook.starter.chrome, isNull);
    });

    test('1..5 are the five coloured levels, in order', () {
      final shirts = [
        for (var r = 1; r <= 5; r++) LevelLook.forRank(r).shirt,
      ];
      expect(shirts, [
        'assets/images/submit_lawn/shirt_rookie.png',
        'assets/images/submit_lawn/shirt_junior.png',
        'assets/images/submit_lawn/shirt_super.png',
        'assets/images/submit_lawn/shirt_pro.png',
        'assets/images/submit_lawn/shirt_master.png',
      ]);
      for (var r = 1; r <= 5; r++) {
        expect(LevelLook.forRank(r).isColoured, isTrue, reason: 'rank $r');
      }
      expect(LevelLook.forRank(5).number, isNot(LevelLook.forRank(1).number),
          reason: 'Master has a gold number');
    });

    test('ranks past the fifth keep the Master look', () {
      expect(LevelLook.forRank(6), same(LevelLook.forRank(5)));
      expect(LevelLook.forRank(99), same(LevelLook.forRank(5)));
    });
  });

  group('SubmitResult', () {
    test('progress is N/50, clamped', () {
      expect(resultFor(0).progress, 0);
      expect(resultFor(25).progress, 0.5);
      expect(resultFor(50).progress, 1);
      expect(resultFor(73).progress, 1);
      expect(resultFor(-3).progress, 0);
    });

    test('leveledUp only on the exact threshold lawn', () {
      expect(resultFor(9).leveledUp, isFalse);
      expect(resultFor(10, level: rookie).leveledUp, isTrue);
      expect(resultFor(11, level: rookie).leveledUp, isFalse);
      expect(resultFor(50, level: master).leveledUp, isTrue);
    });
  });

  group('SubmitLawnController', () {
    SubmitLawnController make([SubmitLawnRepository? repo]) =>
        SubmitLawnController(
          repository: repo ?? FakeSubmitLawnRepository(result: resultFor(1)),
          today: DateTime(2026, 9, 25, 18, 45),
        );

    void fillAll(SubmitLawnController c) {
      c
        ..chooseWhoFor(MowedCategory.veteran)
        ..chooseService('Dog Walking')
        ..setHours(' 2.5 ');
      c.next();
      c
        ..setPhoto(LawnPhoto.before, _png)
        ..setPhoto(LawnPhoto.after, _png);
      c.next();
      c
        ..setPhoto(LawnPhoto.action, _png)
        ..setPhoto(LawnPhoto.homeowner, _png);
      c.next();
      c
        ..answerSafety(woreGear: false)
        ..setPhoto(LawnPhoto.safety, _png);
    }

    test('the date defaults to today, without a time', () {
      expect(make().draft.mowedOn, DateTime(2026, 9, 25));
    });

    test('chooseDate drops the time of day', () {
      final c = make()..chooseDate(DateTime(2026, 9, 20, 23, 59));
      expect(c.draft.mowedOn, DateTime(2026, 9, 20));
    });

    test('setHours parses, trims, and clears on junk', () {
      final c = make()..setHours(' 1.25 ');
      expect(c.draft.hours, 1.25);
      c.setHours('x');
      expect(c.draft.hours, isNull);
    });

    test('next does nothing on an incomplete step', () {
      final c = make()..next();
      expect(c.step, SubmitStep.details);
    });

    test('back is false on the first step and walks back otherwise', () {
      final c = make();
      expect(c.back(), isFalse);
      fillAll(c);
      expect(c.step, SubmitStep.safety);
      expect(c.back(), isTrue);
      expect(c.step, SubmitStep.actionPhotos);
    });

    test('submit before the last step is a no-op', () async {
      final repo = FakeSubmitLawnRepository(result: resultFor(1));
      final c = make(repo)
        ..chooseWhoFor(MowedCategory.veteran)
        ..chooseService('Dog Walking')
        ..setHours('1');
      expect(await c.submit(), isNull);
      expect(repo.submitted, isEmpty);
    });

    test('submit stores the result and a second call is ignored', () async {
      final gate = Completer<void>();
      final repo =
          FakeSubmitLawnRepository(result: resultFor(4), gate: gate);
      final c = make(repo);
      fillAll(c);
      final first = c.submit();
      expect(c.submitting, isTrue);
      expect(c.canContinue, isFalse);
      final second = await c.submit();
      expect(second, isNull);
      gate.complete();
      expect(await first, isNull);
      expect(repo.submitted, hasLength(1));
      expect(c.result!.lawnNumber, 4);
      expect(c.submitting, isFalse);
    });

    test('a SubmitLawnFailure comes back as its message', () async {
      final c = make(FakeSubmitLawnRepository(
          failure: const SubmitLawnFailure('You are signed out.')));
      fillAll(c);
      expect(await c.submit(), 'You are signed out.');
      expect(c.result, isNull);
      expect(c.submitting, isFalse);
    });

    test('LawnDraft.isComplete per step', () {
      final base = LawnDraft(mowedOn: DateTime(2026, 9, 25));
      expect(base.isComplete(SubmitStep.details), isFalse);
      final details = base.copyWith(
        whoFor: MowedCategory.elderly,
        service: 'Other',
        hours: () => 24,
      );
      expect(details.isComplete(SubmitStep.details), isTrue);
      expect(details.copyWith(hours: () => 24.01).isComplete(SubmitStep.details),
          isFalse);
      expect(details.copyWith(hours: () => 0).isComplete(SubmitStep.details),
          isFalse);
      expect(details.copyWith(hours: () => -1).isComplete(SubmitStep.details),
          isFalse);
      expect(base.copyWith(photos: {LawnPhoto.before: _png})
          .isComplete(SubmitStep.lawnPhotos), isFalse);
      expect(base.copyWith(woreSafetyGear: false)
          .isComplete(SubmitStep.safety), isFalse,
          reason: 'safety photo missing');
      expect(base.copyWith(
        woreSafetyGear: false,
        photos: {LawnPhoto.safety: _png},
      ).isComplete(SubmitStep.safety), isTrue);
    });
  });
}
