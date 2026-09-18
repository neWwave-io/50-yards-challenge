import '/core/supabase/supabase_config.dart';

/// v1 called this from main(). It now initializes Supabase, so the call site
/// in main.dart is unchanged.
Future<void> initFirebase() => initSupabase();
