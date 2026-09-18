import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/firebase_user_provider.dart';
import '/core/supabase/supabase_config.dart';

/// v1 called this from main(). It now initializes Supabase, so the call site
/// in main.dart is unchanged.
Future<void> initFirebase() async {
  await initSupabase();

  // Seed `currentUser` synchronously from the restored session.
  //
  // `loggedIn` reads this global, and it used to be populated only when the
  // auth stream emitted — which happens after the first frame. That left
  // loggedIn == false during start-up, so the loading page bounced a
  // legitimately signed-in user back to the sign-in screen, and they had to
  // sign in twice.
  currentUser = SupabaseAuthUser(supabase.auth.currentUser);
}
