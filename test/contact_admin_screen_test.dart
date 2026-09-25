import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/contact_admin/contact_admin_screen.dart';
import 'package:the_50_yard_challenge/features/contact_admin/data/admin_message.dart';
import 'package:the_50_yard_challenge/features/contact_admin/data/contact_admin_repository.dart';
import 'package:the_50_yard_challenge/features/contact_admin/widgets/past_messages_header.dart';

import 'submit_lawn_screen_test.dart' show loadOnest;

const _longText = 'Please select the type of service you provided for this '
    'lawn so we can accurately record your contribution and track your '
    'progress.';

/// Keeps messages in memory, so the screen runs without Supabase.
class FakeContactAdminRepository implements ContactAdminRepository {
  FakeContactAdminRepository([List<AdminMessage>? messages])
      : messages = messages ?? [];

  final List<AdminMessage> messages;
  var failSend = false;

  @override
  Future<List<AdminMessage>> list() async => List.of(messages);

  @override
  Future<AdminMessage> send(String body) async {
    if (failSend) throw const ContactAdminFailure('Could not send.');
    final message = AdminMessage(
      id: 'new-${messages.length}',
      body: body,
      status: AdminMessageStatus.sent,
      sentAt: DateTime(2026, 9, 25),
    );
    messages.insert(0, message);
    return message;
  }
}

List<AdminMessage> _twoMessages() => [
      AdminMessage(
        id: 'a',
        body: _longText,
        status: AdminMessageStatus.viewed,
        sentAt: DateTime(2026, 8, 20),
      ),
      AdminMessage(
        id: 'b',
        body: 'Older message',
        status: AdminMessageStatus.deleted,
        sentAt: DateTime(2026, 8, 10),
      ),
    ];

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadOnest();
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    FakeContactAdminRepository repository,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(home: ContactAdminScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows past messages with their status', (tester) async {
    await pumpScreen(tester, FakeContactAdminRepository(_twoMessages()));

    expect(find.text('Contact Admin'), findsOneWidget);
    expect(find.text('Replies are disabled'), findsOneWidget);
    expect(find.text('Viewed'), findsOneWidget);
    expect(find.text('Deleted'), findsOneWidget);
    expect(find.text('20th/ Aug/ 2026'), findsOneWidget);
  });

  testWidgets('says so when nothing has been sent yet', (tester) async {
    await pumpScreen(tester, FakeContactAdminRepository());
    expect(find.text('Messages you send will show up here.'), findsOneWidget);
  });

  testWidgets('sending adds the message to the top and clears the box',
      (tester) async {
    final repository = FakeContactAdminRepository(_twoMessages());
    await pumpScreen(tester, repository);

    await tester.enterText(find.byType(TextField), '  My mower broke  ');
    await tester.pump();
    await tester.tap(find.text('Send Message'));
    await tester.pumpAndSettle();

    expect(repository.messages.first.body, 'My mower broke');
    expect(find.text('My mower broke'), findsOneWidget);
    expect(find.text('Sent'), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('a blank message is not sent', (tester) async {
    final repository = FakeContactAdminRepository();
    await pumpScreen(tester, repository);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    await tester.tap(find.text('Send Message'));
    await tester.pumpAndSettle();

    expect(repository.messages, isEmpty);
  });

  testWidgets('a failed send keeps the text and says why', (tester) async {
    final repository = FakeContactAdminRepository()..failSend = true;
    await pumpScreen(tester, repository);

    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.pump();
    await tester.tap(find.text('Send Message'));
    await tester.pumpAndSettle();

    expect(find.text('Could not send.'), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, 'Hello');
  });

  testWidgets('the sort button flips the order', (tester) async {
    await pumpScreen(tester, FakeContactAdminRepository(_twoMessages()));

    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(top('Viewed'), lessThan(top('Deleted')));

    await tester.tap(find.descendant(
      of: find.byType(PastMessagesHeader),
      matching: find.byType(GestureDetector),
    ));
    await tester.pump();
    expect(top('Deleted'), lessThan(top('Viewed')));
  });

  testWidgets('tapping a message opens it in full', (tester) async {
    await pumpScreen(tester, FakeContactAdminRepository(_twoMessages()));

    Text body() => tester.widget<Text>(find.text(_longText));
    expect(body().maxLines, 1);

    await tester.tap(find.text(_longText));
    await tester.pumpAndSettle();
    expect(body().maxLines, isNull);
  });
}
