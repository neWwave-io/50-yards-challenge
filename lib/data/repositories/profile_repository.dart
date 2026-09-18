import '../../core/supabase/supabase_config.dart';
import '../models/profile.dart';

/// Reads and writes `public.profiles`.
class ProfileRepository {
  const ProfileRepository();

  static const _columns = '''
    id, email, display_name, child_name, phone_number, state, region,
    photo_url, is_group, is_hall_of_fame, total_lawns, total_hours,
    badge_levels ( name )
  ''';

  Profile _map(Map<String, dynamic> row) {
    final badge = row['badge_levels'];
    return Profile.fromMap({
      ...row,
      'badge_level': badge is Map ? badge['name'] : null,
    });
  }

  /// The signed-in user's profile, or null if signed out.
  Future<Profile?> fetchMine() async {
    final id = currentProfileId;
    if (id == null) return null;

    final row = await supabase
        .from('profiles')
        .select(_columns)
        .eq('id', id)
        .maybeSingle();

    return row == null ? null : _map(row);
  }

  /// Updates only the columns a member is permitted to write.
  Future<void> updateMine(Profile profile) async {
    final id = currentProfileId;
    if (id == null) throw StateError('Not signed in');

    await supabase.from('profiles').update(profile.toEditableMap()).eq('id', id);
  }
}
