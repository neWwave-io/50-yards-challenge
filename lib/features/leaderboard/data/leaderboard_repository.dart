import '../../../core/supabase/supabase_config.dart';
import 'leaderboard_data.dart';

/// The only file in the leaderboard feature that knows Supabase exists.
///
/// Everything is read from the `leaderboard` view, which exposes a narrow,
/// public column set — never `profiles` directly, except for the signed-in
/// child's own row.
class LeaderboardRepository {
  const LeaderboardRepository();

  // display_name is already a first name: the view never hands out more.
  static const _columns = 'profile_id, display_name, photo_url, '
      'state, total_lawns, total_hours, global_rank, state_rank';

  /// How many places the podium card shows.
  static const podiumSize = 5;

  /// The national top five, best first.
  ///
  Future<List<LeaderboardEntry>> topFive() async {
    final rows = await supabase
        .from('leaderboard')
        .select(_columns)
        // postgrest-dart sorts descending unless told otherwise.
        .order('global_rank', ascending: true)
        .order('profile_id', ascending: true)
        .limit(podiumSize);
    return _entries(rows);
  }

  /// One page of the participants list.
  ///
  /// With no [state] and no [search] the list carries on from where the
  /// podium stops. Choosing a state ranks within it; searching looks at
  /// everyone, podium included, so a child can always find themselves.
  Future<List<LeaderboardEntry>> participants({
    String? state,
    String? search,
    required int offset,
    required int limit,
  }) async {
    var query = supabase.from('leaderboard').select(_columns);

    if (state != null) query = query.eq('state', state);
    final term = search?.trim() ?? '';
    if (term.isNotEmpty) {
      query = query.ilike('display_name', '%${_escapeLike(term)}%');
    }
    // With no filter the list carries on from the podium's last row.
    final skip = state == null && term.isEmpty ? podiumSize : 0;

    final rows = await query
        .order(state == null ? 'global_rank' : 'state_rank', ascending: true)
        .order('profile_id', ascending: true)
        .range(skip + offset, skip + offset + limit - 1);
    return _entries(rows);
  }

  /// The signed-in child's own standing.
  Future<MyStanding?> mine() async {
    final profileId = currentProfileId;
    if (profileId == null) return null;

    final results = await Future.wait([
      supabase
          .from('profiles')
          .select('state, photo_url')
          .eq('id', profileId)
          .maybeSingle(),
      supabase
          .from('leaderboard')
          .select(_columns)
          .eq('profile_id', profileId)
          .maybeSingle(),
    ]);

    final profile = results[0];
    final ranked = results[1];
    return MyStanding(
      state: (profile?['state'] as String?)?.trim().nullIfEmpty,
      photoUrl: (profile?['photo_url'] as String?)?.trim().nullIfEmpty,
      entry: ranked == null ? null : _entry(ranked),
    );
  }

  static List<LeaderboardEntry> _entries(List<Map<String, dynamic>> rows) =>
      [for (final row in rows) _entry(row)];

  static LeaderboardEntry _entry(Map<String, dynamic> row) =>
      LeaderboardEntry(
        profileId: row['profile_id'] as String,
        name: (row['display_name'] as String?)?.trim() ?? '',
        photoUrl: (row['photo_url'] as String?)?.trim().nullIfEmpty,
        state: (row['state'] as String?)?.trim().nullIfEmpty,
        totalLawns: (row['total_lawns'] as num?)?.toInt() ?? 0,
        // numeric arrives as a string from PostgREST.
        totalHours: _number(row['total_hours']),
        nationalRank: (row['global_rank'] as num?)?.toInt() ?? 0,
        stateRank: (row['state_rank'] as num?)?.toInt() ?? 0,
      );

  static double _number(Object? value) => switch (value) {
        num n => n.toDouble(),
        String s => double.tryParse(s) ?? 0,
        _ => 0,
      };

  /// `ilike` treats `%` and `_` as wildcards, and PostgREST reads `*` as `%`;
  /// a name search should treat all three literally.
  static String _escapeLike(String s) =>
      s.replaceAllMapped(RegExp(r'[\\%_*]'), (m) => '\\${m[0]}');
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
