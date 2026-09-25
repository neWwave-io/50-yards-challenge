import 'package:flutter/foundation.dart';

import '../../../core/supabase/supabase_config.dart';
import 'admin_message.dart';

/// Raised when a message cannot be sent or read, with a message fit to show.
class ContactAdminFailure implements Exception {
  const ContactAdminFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only file in the contact-admin feature that knows Supabase exists.
class ContactAdminRepository {
  const ContactAdminRepository();

  static const _table = 'admin_messages';
  static const _columns = 'id, body, status, created_at';

  /// The longest message the table accepts.
  static const maxLength = 2000;

  /// Every message the signed-in family has sent, newest first.
  Future<List<AdminMessage>> list() async {
    final profileId = _profileId();
    try {
      final rows = await supabase
          .from(_table)
          .select(_columns)
          .eq('profile_id', profileId)
          .order('created_at', ascending: false);
      return rows.map(_fromRow).toList();
    } catch (e) {
      debugPrint('Contact admin: list failed — $e');
      throw const ContactAdminFailure(
        'Your past messages could not be loaded.',
      );
    }
  }

  /// Sends [body] to the admin team and returns the saved message.
  Future<AdminMessage> send(String body) async {
    final profileId = _profileId();
    try {
      final row = await supabase
          .from(_table)
          .insert({'profile_id': profileId, 'body': body})
          .select(_columns)
          .single();
      return _fromRow(row);
    } catch (e) {
      debugPrint('Contact admin: send failed — $e');
      throw const ContactAdminFailure(
        'Your message could not be sent. Check your connection and try again.',
      );
    }
  }

  String _profileId() {
    final id = currentProfileId;
    if (id == null) throw const ContactAdminFailure('You are signed out.');
    return id;
  }

  static AdminMessage _fromRow(Map<String, dynamic> row) => AdminMessage(
        id: row['id'] as String,
        body: row['body'] as String,
        status: AdminMessageStatus.parse(row['status'] as String?),
        sentAt: DateTime.parse(row['created_at'] as String).toLocal(),
      );
}
