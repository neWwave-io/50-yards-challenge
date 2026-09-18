import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase connection for the v2 backend.
///
/// The publishable key is a public client credential, designed to ship in the
/// app. Access is meant to be controlled by Row Level Security, not by keeping
/// this secret.
///
/// ⚠️ RLS IS CURRENTLY DISABLED on this project. Until
/// `supabase/security/rls_lockdown.sql` is applied, this key grants full read
/// and write access to every table. Do not point a public build at it, and do
/// not import real user data before closing that.
///
/// Override per environment with:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://dimcpsyrtsnualmjispb.supabase.co',
  );

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_bz9be9AWxpKMtewRqfrObA_8AA-FUSL',
  );

  /// Project ref, for logs and debugging.
  static const String projectRef = 'dimcpsyrtsnualmjispb';
}

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
}

/// Shortcut to the Supabase client.
SupabaseClient get supabase => Supabase.instance.client;

/// The signed-in Supabase user, or null.
User? get currentSupabaseUser => supabase.auth.currentUser;

/// The signed-in user's id, or null. This is `profiles.id`.
String? get currentProfileId => supabase.auth.currentUser?.id;
