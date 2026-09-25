import '../../home/data/home_data.dart';

/// How a badge is won — see `supabase/migrations/0026_badges.sql`.
enum BadgeEarnedBy {
  /// Automatically, with enough approved lawns for the right neighbours.
  lawns,

  /// By sending proof of service outside mowing, which an admin approves.
  request;

  static BadgeEarnedBy parse(Object? value) =>
      value == 'request' ? request : lawns;
}

/// Where a child's request for a badge stands.
enum ClaimStatus {
  pending,
  approved,
  rejected;

  static ClaimStatus? parse(Object? value) => switch (value) {
        'pending' => pending,
        'approved' => approved,
        'rejected' => rejected,
        _ => null,
      };
}

/// One admin-defined badge and the signed-in child's standing on it.
class ChallengeBadge {
  const ChallengeBadge({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.earnedBy = BadgeEarnedBy.lawns,
    this.requiredLawns,
    this.whoFor,
    this.progress = 0,
    this.claimStatus,
    this.earned = false,
    this.earnedAt,
  });

  final String id;
  final String name;

  /// The back of the card.
  final String? description;
  final String? imageUrl;
  final BadgeEarnedBy earnedBy;

  /// The lawn target. Null for a requested badge.
  final int? requiredLawns;

  /// Whose lawns count. Null means any.
  final MowedCategory? whoFor;

  /// Approved lawns towards [requiredLawns], capped at it.
  final int progress;

  /// The latest request for it, if it is a requested badge.
  final ClaimStatus? claimStatus;

  final bool earned;
  final DateTime? earnedAt;

  bool get isRequested => earnedBy == BadgeEarnedBy.request;

  /// 0–1, for the footer's fill.
  double get fraction {
    if (earned) return 1;
    final target = requiredLawns;
    if (target == null || target == 0) return 0;
    return (progress / target).clamp(0, 1).toDouble();
  }

  /// On the Earned tab: won, under way, or waiting on an admin. Everything
  /// else is still locked.
  bool get isStarted =>
      earned || progress > 0 || claimStatus == ClaimStatus.pending;

  /// Can go in the request form: a requested badge not already won or
  /// waiting for review.
  bool get canRequest =>
      isRequested && !earned && claimStatus != ClaimStatus.pending;

  /// "9 lawns for Elderly neighbours", or how to get a requested badge.
  String get howToEarn {
    if (isRequested) return 'Request it with proof of your service.';
    final target = requiredLawns ?? 0;
    final lawns = target == 1 ? 'lawn' : 'lawns';
    final who = whoFor;
    return who == null
        ? '$target $lawns for anyone'
        : '$target $lawns for ${who.label} neighbours';
  }
}

/// Everything the badges page shows.
class BadgesData {
  const BadgesData({required this.badges});

  /// Every active badge, in the admin's order.
  final List<ChallengeBadge> badges;

  int get earnedCount => badges.where((b) => b.earned).length;

  List<ChallengeBadge> get started => [for (final b in badges) if (b.isStarted) b];
  List<ChallengeBadge> get locked => [for (final b in badges) if (!b.isStarted) b];
  List<ChallengeBadge> get requestable => [for (final b in badges) if (b.canRequest) b];
}
