import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_config.dart';
import '../child.dart';
import 'sign_up_draft.dart';

/// Anything that went wrong creating the account, already phrased for a child
/// or their parent to read.
class SignUpFailure implements Exception {
  const SignUpFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only thing in the sign-up feature that knows a backend exists.
class SignUpRepository {
  const SignUpRepository();

  static const _avatarsBucket = 'avatars';

  /// Creates the account, fills in the profile, and stores one row per child.
  ///
  /// A `profiles` row already exists by the time this returns — the
  /// `on_auth_user_created` trigger writes it — so the profile step is an
  /// update, not an insert.
  Future<void> signUp({
    required SignUpDraft account,
    required List<Child> children,
  }) async {
    final user = await _createAccount(account);

    try {
      await _writeProfile(user.id, account, children);
      await _writeChildren(user.id, children);
    } on PostgrestException catch (e) {
      throw SignUpFailure(
        'Your account was created but we could not save your details: '
        '${e.message}. Sign in, then open Create Account again and we will '
        'fill in the rest.',
      );
    } catch (e) {
      // Usually the connection dropping mid-way. Say so, and say that the
      // account survived, because retrying the same address would otherwise
      // fail with "already registered" and leave nowhere to go.
      throw SignUpFailure(
        'Your account was created but we could not save your details '
        '(${_describe(e)}). Sign in, then open Create Account again and we '
        'will fill in the rest.',
      );
    }
  }

  Future<User> _createAccount(SignUpDraft account) async {
    final email = account.email.trim();

    // An earlier attempt may have created the account and then failed to save
    // the details. We are still signed in as that address, so carry on with
    // it rather than registering it again — otherwise the family is stuck:
    // the email is taken and their profile is empty.
    final signedIn = supabase.auth.currentUser;
    if (signedIn != null &&
        (signedIn.email ?? '').toLowerCase() == email.toLowerCase()) {
      return signedIn;
    }

    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: account.password,
        data: {'display_name': account.fullName.trim()},
      );
      final user = res.user;
      if (user == null) {
        throw const SignUpFailure('Could not create your account.');
      }
      return user;
    } on AuthException catch (e) {
      throw SignUpFailure(e.message);
    } on SignUpFailure {
      rethrow;
    } catch (e) {
      throw SignUpFailure('Could not create your account: ${_describe(e)}.');
    }
  }

  /// Turns a transport-layer object into something a parent can read, without
  /// throwing away what it actually said.
  static String _describe(Object error) {
    final text = error.toString().trim();
    return text.isEmpty ? error.runtimeType.toString() : text;
  }

  Future<void> _writeProfile(
    String profileId,
    SignUpDraft account,
    List<Child> children,
  ) async {
    final first = children.firstOrNull;

    await supabase.from('profiles').update({
      'email': account.email.trim(),
      'display_name': account.fullName.trim(),
      'relationship': account.relationship,
      // v1 called the city "region"; the column kept the name.
      'region': account.city,
      'state': account.state,
      'is_group': children.length > 1,
      // Denormalised onto the profile in v1, and the leaderboard views still
      // read them from here.
      'child_name': first?.name,
      'gender': first?.gender?.value,
      // updated_at is maintained by the profiles_set_updated_at trigger.
    }).eq('id', profileId);
  }

  Future<void> _writeChildren(String profileId, List<Child> children) async {
    // The screen holds the complete list, so replace rather than append —
    // that keeps a second run after a half-finished sign-up from doubling
    // everyone up.
    await supabase.from('children').delete().eq('profile_id', profileId);

    final rows = <Map<String, dynamic>>[];

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      rows.add({
        'profile_id': profileId,
        'name': child.name.trim(),
        'shirt_size': child.shirtSize,
        'gender': child.gender?.value,
        'date_of_birth': _asDate(child.dateOfBirth),
        'photo_url': await _uploadPhoto(profileId, i, child),
      });
    }

    if (rows.isNotEmpty) await supabase.from('children').insert(rows);
  }

  /// A birthday is a date, not an instant — sending it with a time would let
  /// it drift a day across time zones.
  static String? _asDate(DateTime? date) {
    if (date == null) return null;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  /// A failed upload must not cost the family their account, so this returns
  /// null rather than throwing — the photo can be added again later.
  Future<String?> _uploadPhoto(String profileId, int index, Child child) async {
    final bytes = child.photo;
    if (bytes == null) return null;

    final path = 'children/$profileId/$index.jpg';
    try {
      await supabase.storage.from(_avatarsBucket).uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      return supabase.storage.from(_avatarsBucket).getPublicUrl(path);
    } catch (_) {
      // Optional by design — a dropped upload must not fail the sign-up.
      return null;
    }
  }
}
