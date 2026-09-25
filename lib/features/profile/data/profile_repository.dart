import 'package:flutter/foundation.dart';

import '../../../core/supabase/supabase_config.dart';
import '../../home/data/home_data.dart';
import '../../home/data/home_repository.dart';
import 'profile_data.dart';

/// Raised when the page cannot be read.
class ProfileFailure implements Exception {
  const ProfileFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only file in the profile feature that knows Supabase exists.
///
/// The header, challenge card and neighbour tallies are the home page's, so
/// those reads are borrowed from [HomeRepository] rather than repeated.
class ProfileRepository {
  const ProfileRepository({this.home = const HomeRepository()});

  final HomeRepository home;

  /// Reads everything the page needs for the signed-in family.
  Future<ProfileData> load() async {
    final profileId = currentProfileId;
    if (profileId == null) {
      throw const ProfileFailure('You are signed out.');
    }

    // Only the profile is essential; every other card can say it is empty.
    final results = await Future.wait([
      home.readProfile(profileId),
      _optional('availability', () => home.readAvailability(profileId),
          const Availability.available()),
      _optional('day streak', () => home.readStreak(profileId),
          const DayStreak.none()),
      _optional('guardian', () => _guardian(profileId), const Guardian()),
      _optional('children', () => _children(profileId), const <ProfileChild>[]),
      _optional('impact', () => home.readCategories(profileId),
          const <CategoryTally>[]),
      _optional('latest badge', () => _latestBadge(profileId), null),
      _optional('ranking', () => _ranking(profileId), const Ranking()),
      _optional('badge levels', _levels, const <BadgeLevel>[]),
    ]);

    return ProfileData(
      profile: results[0] as HomeProfile,
      availability: results[1] as Availability,
      streak: results[2] as DayStreak,
      guardian: results[3] as Guardian,
      children: results[4] as List<ProfileChild>,
      categories: results[5] as List<CategoryTally>,
      latestBadge: results[6] as EarnedBadge?,
      ranking: results[7] as Ranking,
      levels: results[8] as List<BadgeLevel>,
    );
  }

  static Future<T> _optional<T>(
    String what,
    Future<T> Function() read,
    T fallback,
  ) async {
    try {
      return await read();
    } catch (e) {
      debugPrint('Profile: could not load $what — $e');
      return fallback;
    }
  }

  Future<Guardian> _guardian(String profileId) async {
    final row = await supabase
        .from('profiles')
        .select('display_name, relationship')
        .eq('id', profileId)
        .maybeSingle();
    return Guardian(
      name: (row?['display_name'] as String?)?.trim().nullIfEmpty,
      relationship: row?['relationship'] as String?,
    );
  }

  Future<List<ProfileChild>> _children(String profileId) async {
    final rows = await supabase
        .from('children')
        .select('name, gender, shirt_size, date_of_birth')
        .eq('profile_id', profileId)
        .order('created_at', ascending: true);

    return [
      for (final row in rows as List)
        ProfileChild(
          name: (row['name'] as String?)?.trim() ?? '',
          gender: switch (row['gender']) {
            'male' => 'Male',
            'female' => 'Female',
            _ => null,
          },
          shirtSize: (row['shirt_size'] as String?)?.trim().nullIfEmpty,
          dateOfBirth: _date(row['date_of_birth']),
        ),
    ];
  }

  Future<EarnedBadge?> _latestBadge(String profileId) async {
    final row = await supabase
        .from('badge_requests')
        .select('updated_at, badge_levels(name, description, image_url)')
        .eq('profile_id', profileId)
        // "done" is an approved request whose shirt has been sent.
        .inFilter('status', ['approved', 'done'])
        .order('updated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final level = row?['badge_levels'] as Map<String, dynamic>?;
    final name = (level?['name'] as String?)?.trim();
    if (row == null || name == null || name.isEmpty) return null;

    return EarnedBadge(
      name: name,
      description: (level?['description'] as String?)?.trim().nullIfEmpty,
      imageUrl: (level?['image_url'] as String?)?.trim().nullIfEmpty,
      awardedAt:
          DateTime.tryParse((row['updated_at'] as String?) ?? '')?.toLocal(),
    );
  }

  Future<Ranking> _ranking(String profileId) async {
    // The public view, not `profiles`: it is what the leaderboard ranks by.
    final row = await supabase
        .from('leaderboard')
        .select('global_rank, state_rank')
        .eq('profile_id', profileId)
        .maybeSingle();
    return Ranking(
      national: (row?['global_rank'] as num?)?.toInt(),
      state: (row?['state_rank'] as num?)?.toInt(),
    );
  }

  Future<List<BadgeLevel>> _levels() async {
    final rows = await supabase
        .from('badge_levels')
        .select('name, min_lawns, sort_order')
        .order('sort_order', ascending: true);

    return [
      for (final row in rows as List)
        BadgeLevel(
          name: (row['name'] as String?) ?? '',
          minLawns: (row['min_lawns'] as num?)?.toInt() ?? 0,
          rank: (row['sort_order'] as num?)?.toInt() ?? 0,
        ),
    ];
  }

  /// Postgres `date` arrives as "2014-01-12"; keep it a calendar date.
  static DateTime? _date(Object? value) {
    if (value is! String) return null;
    final parsed = DateTime.tryParse(value);
    return parsed == null ? null : DateTime(parsed.year, parsed.month, parsed.day);
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
