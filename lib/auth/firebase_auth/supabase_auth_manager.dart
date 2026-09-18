import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '/backend/backend.dart';
import '/core/supabase/supabase_config.dart';
import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import 'auth_util.dart';
import 'firebase_user_provider.dart';

/// Supabase implementation of the v1 AuthManager interface.
///
/// The signatures are unchanged so the sign-in and sign-up screens work as
/// they did. Providers v1 never actually used (GitHub, JWT, anonymous) throw
/// rather than pretending to succeed.
class SupabaseAuthManager extends AuthManager
    with EmailSignInManager, AnonymousSignInManager, AppleSignInManager,
        GoogleSignInManager, JwtSignInManager, PhoneSignInManager {
  @override
  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      await supabase.auth
          .updateUser(sb.UserAttributes(password: newPassword));
    } on sb.AuthException catch (e) {
        _snack(context, e.message);
    }
  }

  @override
  Future signOut() => supabase.auth.signOut();

  @override
  Future deleteUser(BuildContext context) async {
    _snack(context, 'Account deletion must be done by an administrator.');
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await supabase.auth.updateUser(sb.UserAttributes(email: email));
      await updateUserDocument(email: email);
    } on sb.AuthException catch (e) {
      _snack(context, e.message);
    }
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      _snack(context, 'Password reset email sent');
    } on sb.AuthException catch (e) {
      _snack(context, e.message);
    }
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _guard(context, () async {
        final res = await supabase.auth.signInWithPassword(
          email: email.trim(),
          password: password,
        );
        return res.user;
      });

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _guard(context, () async {
        final res = await supabase.auth.signUp(
          email: email.trim(),
          password: password,
        );
        return res.user;
      });

  @override
  Future<BaseAuthUser?> signInAnonymously(BuildContext context) =>
      _unsupported(context, 'Anonymous sign-in');

  @override
  Future<BaseAuthUser?> signInWithApple(BuildContext context) =>
      _unsupported(context, 'Apple sign-in');

  @override
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) =>
      _unsupported(context, 'Google sign-in');

  @override
  Future<BaseAuthUser?> signInWithGithub(BuildContext context) =>
      _unsupported(context, 'GitHub sign-in');

  @override
  Future<BaseAuthUser?> signInWithJwtToken(
    BuildContext context,
    String jwtToken,
  ) =>
      _unsupported(context, 'JWT sign-in');

  @override
  Future beginPhoneAuth({
    required BuildContext context,
    required String phoneNumber,
    required Function onCodeSent,
  }) async =>
      _snack(context, 'Phone sign-in is not enabled.');

  @override
  Future verifySmsCode({
    required BuildContext context,
    required String smsCode,
  }) async =>
      _unsupported(context, 'Phone sign-in');

  Future<BaseAuthUser?> _guard(
    BuildContext context,
    Future<sb.User?> Function() action,
  ) async {
    try {
      final user = await action();
      if (user == null) return null;
      await maybeCreateUser(user);
      return SupabaseAuthUser(user);
    } on sb.AuthException catch (e) {
      _snack(context, e.message);
      return null;
    } catch (e) {
      _snack(context, 'Something went wrong. Please try again.');
      return null;
    }
  }

  Future<BaseAuthUser?> _unsupported(BuildContext context, String what) async {
    _snack(context, '$what is not enabled for this app.');
    return null;
  }

  void _snack(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
