/// One child on the leaderboard, from the `leaderboard` view.
///
/// Ranking is decided by the database: more approved lawns ranks higher, and
/// on a tie whoever joined first. Every place is unique. The app never
/// re-sorts.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.profileId,
    required this.name,
    required this.photoUrl,
    required this.state,
    required this.totalLawns,
    required this.totalHours,
    required this.nationalRank,
    required this.stateRank,
  });

  final String profileId;

  /// First name only — the participants are children, and the view itself
  /// never hands out more.
  final String name;

  final String? photoUrl;
  final String? state;
  final int totalLawns;
  final double totalHours;
  final int nationalRank;
  final int stateRank;

  /// The position to print beside this entry while [stateFilter] is chosen.
  int rankFor(String? stateFilter) =>
      stateFilter == null ? nationalRank : stateRank;
}

/// The signed-in child, for the "Team …" chip and to highlight their row.
class MyStanding {
  const MyStanding({
    required this.state,
    required this.photoUrl,
    required this.entry,
  });

  final String? state;
  final String? photoUrl;

  /// Null when they are not on the board — an admin, or signed in without a
  /// profile row yet.
  final LeaderboardEntry? entry;
}
