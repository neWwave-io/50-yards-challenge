import 'package:flutter/material.dart';
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '/backend/backend.dart';
import '/backend/schema/users_record.dart';
import '/backend/supabase_compat/compat_types.dart';
import '/core/supabase/supabase_config.dart';
import '../auth_manager.dart';
import 'supabase_auth_manager.dart';

export '../auth_manager.dart';

/// The same globals the v1 screens use (`currentUserDocument` alone appears
/// 123 times), now backed by Supabase instead of Firebase.

final AuthManager authManager = SupabaseAuthManager();

String get currentUserEmail => currentUserDocument?.email ?? '';

String get currentUserUid => supabase.auth.currentUser?.id ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ??
    supabase.auth.currentUser?.userMetadata?['display_name'] as String? ??
    '';

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ??
    supabase.auth.currentUser?.userMetadata?['avatar_url'] as String? ??
    '';

String get currentPhoneNumber => currentUserDocument?.phoneNumber ?? '';

String get currentJwtToken => supabase.auth.currentSession?.accessToken ?? '';

bool get currentUserEmailVerified =>
    supabase.auth.currentUser?.emailConfirmedAt != null;

/// The signed-in user's profile row, kept in memory the way v1 did.
UsersRecord? currentUserDocument;

/// Points at the signed-in user's row in the `v1_users` compat view.
DocumentReference? get currentUserReference => supabase.auth.currentUser == null
    ? null
    : DocumentReference('v1_users', supabase.auth.currentUser!.id);

final Stream<UsersRecord?> authenticatedUserStream = supabase
    .auth
    .onAuthStateChange
    .map<String>((state) => state.session?.user.id ?? '')
    .asyncMap<UsersRecord?>((uid) async {
      if (uid.isEmpty) {
        currentUserDocument = null;
        return null;
      }
      currentUserDocument = await UsersRecord.getDocumentOnceOrNull(
        DocumentReference('v1_users', uid),
      );
      return currentUserDocument;
    })
    .asBroadcastStream();

/// v1 initialized FCM here. Push is not wired up on Supabase; the stream is
/// kept so the call sites in main.dart still compile.
final Stream<String> fcmTokenUserStream = const Stream<String>.empty();

final Stream<String> jwtTokenStream = supabase.auth.onAuthStateChange
    .map((state) => state.session?.accessToken ?? '')
    .asBroadcastStream();


/// v1 wrapped widgets that depend on the signed-in user's document so they
/// rebuild when it loads. Kept with the same name and behaviour.
class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({super.key, required this.builder});

  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) => StreamBuilder<UsersRecord?>(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}
