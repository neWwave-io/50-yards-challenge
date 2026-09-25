import '../../home/data/home_data.dart';

/// Everything the profile page shows, gathered in one read.
class ProfileData {
  const ProfileData({
    required this.profile,
    this.availability = const Availability.available(),
    this.streak = const DayStreak.none(),
    this.guardian = const Guardian(),
    this.children = const [],
    this.categories = const [],
    this.latestBadge,
    this.ranking = const Ranking(),
    this.levels = const [],
  });

  /// The same header and challenge card data the home page uses.
  final HomeProfile profile;
  final Availability availability;
  final DayStreak streak;

  final Guardian guardian;
  final List<ProfileChild> children;

  /// One entry per category in [kMowedCategories], in display order.
  final List<CategoryTally> categories;

  /// Null until the first badge is awarded.
  final EarnedBadge? latestBadge;

  final Ranking ranking;

  /// The badge ladder, lowest first.
  final List<BadgeLevel> levels;

  /// The next level up, or null once the challenge is complete.
  BadgeLevel? get nextLevel {
    for (final level in levels) {
      if (level.minLawns > profile.totalLawns) return level;
    }
    return null;
  }

  /// The level already reached, or null before the first.
  BadgeLevel? get currentLevel {
    BadgeLevel? reached;
    for (final level in levels) {
      if (level.minLawns <= profile.totalLawns) reached = level;
    }
    return reached;
  }

  int? get lawnsToNext =>
      nextLevel == null ? null : nextLevel!.minLawns - profile.totalLawns;
}

/// The adult who signed the family up.
class Guardian {
  const Guardian({this.name, this.relationship});

  final String? name;

  /// Parents | Guardian | Relative, as picked at sign-up.
  final String? relationship;

  /// The card's heading. "Parents" reads oddly above one name.
  String get title => switch (relationship?.trim()) {
        null || '' => 'Guardian',
        'Parents' => 'Parent',
        final other => other,
      };
}

class ProfileChild {
  const ProfileChild({
    required this.name,
    this.gender,
    this.shirtSize,
    this.dateOfBirth,
  });

  final String name;

  /// "Male" / "Female", already capitalised.
  final String? gender;
  final String? shirtSize;
  final DateTime? dateOfBirth;

  /// "Emma · Female · M" — whatever is known, in that order.
  String get summary => [
        name,
        if (gender != null) gender!,
        if (shirtSize != null && shirtSize!.isNotEmpty) shirtSize!,
      ].join(' · ');
}

/// The most recent badge an admin approved.
class EarnedBadge {
  const EarnedBadge({
    required this.name,
    this.description,
    this.imageUrl,
    this.awardedAt,
  });

  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime? awardedAt;
}

/// Positions on the leaderboard. Null when the child is not ranked yet.
class Ranking {
  const Ranking({this.national, this.state});

  final int? national;
  final int? state;
}

/// One rung of the badge ladder. Each rung is also a shirt colour.
class BadgeLevel {
  const BadgeLevel({required this.name, required this.minLawns, required this.rank});

  final String name;
  final int minLawns;

  /// Zero-based position in the ladder.
  final int rank;

  BadgeShirt get shirt => BadgeShirt.forRank(rank);
}

/// The shirt that goes with each badge level, in ladder order (see
/// migration 0012). White is the shirt before the first level.
enum BadgeShirt {
  white('White'),
  orange('Orange'),
  green('Green'),
  blue('Blue'),
  red('Red'),
  black('Black');

  const BadgeShirt(this.label);

  final String label;

  String get imagePath => 'assets/images/profile/shirt_$name.png';

  /// The design's own exports are framed to be cropped into the tile; the
  /// others come from v1's artwork and are shown whole.
  bool get isDesignExport => this == white || this == orange;

  static BadgeShirt forRank(int? rank) {
    if (rank == null) return white;
    final i = rank + 1;
    return i < values.length ? values[i] : values.last;
  }
}
