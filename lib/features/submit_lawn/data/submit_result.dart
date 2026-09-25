/// What the "lawn logged" screen shows once a lawn is in.
class SubmitResult {
  const SubmitResult({
    required this.lawnNumber,
    required this.hoursAdded,
    required this.verifiedHours,
    required this.level,
  });

  /// This lawn's place among the child's lawns, pending ones included —
  /// "Lawn #18 logged". Rejected lawns do not count. Null if it could not be
  /// read back, so the screen never shows a wrong number.
  final int? lawnNumber;

  /// The hours on the lawn just sent.
  final double hoursAdded;

  /// Hours on approved lawns only; the new one is still pending.
  final double verifiedHours;

  /// The level [lawnNumber] reaches, or null below the first one.
  final Level? level;

  /// The challenge is fifty lawns; the bar fills toward that.
  static const goal = 50;

  double get progress => ((lawnNumber ?? 0) / goal).clamp(0.0, 1.0);

  /// True on the lawn that crosses into [level] — "You have leveled up".
  bool get leveledUp => level != null && lawnNumber == level!.minLawns;
}

/// One badge level, from `badge_levels`.
class Level {
  const Level({required this.name, required this.minLawns, required this.rank});

  final String name;
  final int minLawns;

  /// 1 for the first level (Rookie Mower), 2 for the next, and so on.
  final int rank;
}
