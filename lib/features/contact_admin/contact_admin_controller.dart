import 'package:flutter/foundation.dart';

import 'data/admin_message.dart';
import 'data/contact_admin_repository.dart';

/// Sends messages to the admin team and holds the family's past ones.
class ContactAdminController extends ChangeNotifier {
  ContactAdminController({this.repository = const ContactAdminRepository()});

  final ContactAdminRepository repository;

  List<AdminMessage> _messages = const [];
  Object? _loadError;
  var _loading = false;
  var _sending = false;
  var _newestFirst = true;

  Object? get loadError => _loadError;
  bool get loading => _loading;
  bool get sending => _sending;
  bool get newestFirst => _newestFirst;

  /// The past messages in the order the sort toggle asks for.
  List<AdminMessage> get messages =>
      _newestFirst ? _messages : _messages.reversed.toList();

  Future<void> load() async {
    _loading = true;
    _loadError = null;
    notifyListeners();

    try {
      _messages = await repository.list();
    } catch (e) {
      _loadError = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void toggleOrder() {
    _newestFirst = !_newestFirst;
    notifyListeners();
  }

  /// Sends [text] and puts it at the top of the list. Returns why it failed,
  /// or null once it is sent.
  Future<String?> send(String text) async {
    final body = text.trim();
    if (body.isEmpty || _sending) return null;
    if (body.length > ContactAdminRepository.maxLength) {
      return 'Please keep your message under '
          '${ContactAdminRepository.maxLength} characters.';
    }

    _sending = true;
    notifyListeners();
    try {
      final sent = await repository.send(body);
      _messages = [sent, ..._messages];
      return null;
    } on ContactAdminFailure catch (e) {
      return e.message;
    } catch (_) {
      return 'Your message could not be sent. Try again.';
    } finally {
      _sending = false;
      notifyListeners();
    }
  }
}
