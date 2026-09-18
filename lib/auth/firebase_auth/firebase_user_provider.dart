import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '/core/supabase/supabase_config.dart';
import '../base_auth_user_provider.dart';

/// Supabase-backed BaseAuthUser.
///
/// The file keeps its v1 name so the ~10 call sites that import it still
/// resolve; only the implementation changed.
class SupabaseAuthUser extends BaseAuthUser {
  SupabaseAuthUser(this.user);

  final sb.User? user;

  @override
  bool get loggedIn => user != null;

  @override
  bool get emailVerified => user?.emailConfirmedAt != null;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.id,
        email: user?.email,
        displayName: user?.userMetadata?['display_name'] as String? ??
            user?.userMetadata?['full_name'] as String?,
        photoUrl: user?.userMetadata?['avatar_url'] as String?,
        phoneNumber: user?.phone,
      );

  @override
  Future? delete() async {
    // Deleting an auth user requires the service role; not available client-side.
  }

  @override
  Future? updateEmail(String email) =>
      supabase.auth.updateUser(sb.UserAttributes(email: email));

  @override
  Future? updatePassword(String newPassword) =>
      supabase.auth.updateUser(sb.UserAttributes(password: newPassword));

  @override
  Future? sendEmailVerification() async {
    final email = user?.email;
    if (email == null) return;
    await supabase.auth.resend(type: sb.OtpType.signup, email: email);
  }
}

BaseAuthUser? currentUser;

/// Emits on sign-in, sign-out and token refresh. Named as in v1 so main.dart
/// is unchanged.
Stream<BaseAuthUser> the50YardChallengeFirebaseUserStream() => supabase
    .auth
    .onAuthStateChange
    .map<BaseAuthUser>((state) => SupabaseAuthUser(state.session?.user))
    .startWith(SupabaseAuthUser(supabase.auth.currentUser))
    .map((user) {
      currentUser = user;
      return user;
    });
