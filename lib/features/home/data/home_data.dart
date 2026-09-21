/// Everything the home page shows, gathered in one read.
class HomeData {
  const HomeData({
    required this.profile,
    required this.streak,
    required this.week,
    required this.categories,
    required this.announcements,
    required this.activity,
    this.training,
  });

  final HomeProfile profile;
  final DayStreak streak;
  final MowingWeek week;

  /// One entry per category in [kMowedCategories], in display order.
  final List<CategoryTally> categories;

  final List<Announcement> announcements;
  final List<ActivityEntry> activity;

  /// The newest video announcement, if there is one.
  final Announcement? training;
}

class HomeProfile {
  const HomeProfile({
    required this.displayName,
    required this.state,
    required this.joinedAt,
    required this.totalLawns,
    required this.totalHours,
    this.childName,
    this.photoUrl,
    this.badgeName,
    this.badgeRank,
  });

  final String displayName;
  final String? state;
  final DateTime? joinedAt;
  final int totalLawns;
  final double totalHours;
  final String? childName;
  final String? photoUrl;

  /// Null until the badge levels are imported.
  final String? badgeName;

  /// The level's position in the ladder, 1-based.
  final int? badgeRank;

  /// The challenge is fifty lawns — that is the whole point of it.
  static const goal = 50;

  double get progress => (totalLawns / goal).clamp(0, 1).toDouble();

  int get nextLawnNumber => totalLawns + 1;

  /// The greeting uses the first word, so "Chris Baker" becomes "Chris".
  String get firstName {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return 'there';
    return trimmed.split(RegExp(r'\s+')).first;
  }
}

/// Consecutive days with a lawn, from `profile_day_streaks`.
class DayStreak {
  const DayStreak({required this.current, required this.longest});

  const DayStreak.none() : current = 0, longest = 0;

  final int current;
  final int longest;
}

/// Which days of the current week were mowed.
class MowingWeek {
  const MowingWeek({required this.days});

  /// Seven entries, Sunday first, matching the design's tracker.
  final List<DayState> days;

  int get mowedCount => days.where((d) => d == DayState.mowed).length;

  static const length = 7;
}

enum DayState {
  /// A lawn was submitted that day.
  mowed,

  /// Today, nothing yet — still winnable.
  today,

  /// A day that has been and gone with nothing on it.
  missed,

  /// Later this week.
  upcoming,
}

/// How many lawns went to one kind of neighbour.
class CategoryTally {
  const CategoryTally({
    required this.category,
    required this.count,
    required this.share,
  });

  final MowedCategory category;
  final int count;

  /// This category's slice of everything mowed, for the ring.
  final double share;
}

/// The six kinds of neighbour the design has an illustration for.
enum MowedCategory {
  elderly('Elderly', 'elderly', ['elderly']),
  singleParent('Single parent', 'single_parent', ['single parent']),
  activeDuty('Active Duty', 'active_duty', ['active duty', 'deployed military']),
  veteran('Veteran', 'veteran', ['veteran']),
  firstResponder('First Responder', 'first_responder', ['first responder']),
  disabled('Disabled', 'disabled', ['disabled', 'disable']);

  const MowedCategory(this.label, this.asset, this.aliases);

  final String label;
  final String asset;

  /// `lawns.who_for` is free text, and v1 wrote its own wording — "Deployed
  /// Military" for what the design now calls Active Duty. Matched in
  /// lower case so old rows still land on the right tile.
  final List<String> aliases;

  String get iconPath => 'assets/images/home/$asset.png';

  static MowedCategory? match(String? whoFor) {
    if (whoFor == null) return null;
    final needle = whoFor.trim().toLowerCase();
    for (final c in MowedCategory.values) {
      if (c.aliases.contains(needle)) return c;
    }
    return null;
  }
}

const kMowedCategories = MowedCategory.values;

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description,
    this.imageUrl,
    this.articleLink,
    this.videoLink,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final String? description;
  final String? imageUrl;
  final String? articleLink;
  final String? videoLink;

  /// Whichever link the card should open.
  String? get link => videoLink ?? articleLink;
}

/// A lawn somebody in the community finished.
class ActivityEntry {
  const ActivityEntry({
    required this.name,
    required this.at,
    this.whoFor,
  });

  final String name;
  final DateTime at;
  final String? whoFor;
}
