import '/backend/supabase_compat/compat_types.dart';
import '/core/supabase/supabase_config.dart';

/// Deletes notifications. v1 used a Firestore WriteBatch; Postgres does it in
/// a single statement.
///
/// Passing [refs] deletes exactly those rows; passing nothing deletes every
/// notification belonging to the signed-in user.
Future<void> deleteAllNotifications([List<DocumentReference>? refs]) async {
  if (refs != null && refs.isNotEmpty) {
    await supabase
        .from('notifications')
        .delete()
        .inFilter('id', refs.map((r) => r.id).toList());
    return;
  }
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return;
  await supabase.from('notifications').delete().eq('profile_id', uid);
}
