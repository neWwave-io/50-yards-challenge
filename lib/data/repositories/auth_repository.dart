import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase/supabase_config.dart';

/// All authentication goes through here. Screens never call Supabase directly.
class AuthRepository {
  const AuthRepository();

  /// Emits on sign-in, sign-out and token refresh.
  Stream<AuthState> get onAuthStateChange => supabase.auth.onAuthStateChange;

  Session? get currentSession => supabase.auth.currentSession;
  User? get currentUser => supabase.auth.currentUser;
  bool get isSignedIn => supabase.auth.currentUser != null;

  /// Creates the account. A database trigger (`handle_new_user`) creates the
  /// matching `profiles` row and a `member` entry in `user_roles`, so there is
  /// nothing to insert here.
  ///
  /// Email confirmation is currently disabled on the project, so this returns a
  /// live session. If confirmation is ever turned on, [AuthResponse.session]
  /// will be null and the caller must show a "check your email" state.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) {
    return supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        if (displayName != null && displayName.trim().isNotEmpty)
          'display_name': displayName.trim(),
      },
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => supabase.auth.signOut();

  Future<void> sendPasswordReset(String email) =>
      supabase.auth.resetPasswordForEmail(email.trim());
}
