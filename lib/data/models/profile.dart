/// A row from `public.profiles`.
///
/// Replaces the v1 `UsersRecord`. Note what is NOT settable here: `totalLawns`,
/// `totalHours` and `badgeLevel` are derived by database triggers from approved
/// lawns, so the client reads them but can never write them.
class Profile {
  const Profile({
    required this.id,
    required this.email,
    this.displayName,
    this.childName,
    this.phoneNumber,
    this.state,
    this.region,
    this.photoUrl,
    this.isGroup = false,
    this.isHallOfFame = false,
    this.totalLawns = 0,
    this.totalHours = 0,
    this.badgeLevel,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? childName;
  final String? phoneNumber;
  final String? state;
  final String? region;
  final String? photoUrl;
  final bool isGroup;
  final bool isHallOfFame;

  /// Derived by the `recalc_profile_totals` trigger. Read-only.
  final int totalLawns;

  /// Derived by the `recalc_profile_totals` trigger. Read-only.
  final double totalHours;

  /// Derived by the `apply_badge_level` trigger. Read-only.
  final String? badgeLevel;

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      email: (map['email'] as String?) ?? '',
      displayName: map['display_name'] as String?,
      childName: map['child_name'] as String?,
      phoneNumber: map['phone_number'] as String?,
      state: map['state'] as String?,
      region: map['region'] as String?,
      photoUrl: map['photo_url'] as String?,
      isGroup: (map['is_group'] as bool?) ?? false,
      isHallOfFame: (map['is_hall_of_fame'] as bool?) ?? false,
      totalLawns: (map['total_lawns'] as num?)?.toInt() ?? 0,
      totalHours: (map['total_hours'] as num?)?.toDouble() ?? 0,
      badgeLevel: map['badge_level'] as String?,
    );
  }

  /// Only the columns a member is allowed to write.
  Map<String, dynamic> toEditableMap() => {
        'display_name': displayName,
        'child_name': childName,
        'phone_number': phoneNumber,
        'state': state,
        'region': region,
        'photo_url': photoUrl,
        'is_group': isGroup,
      };
}
