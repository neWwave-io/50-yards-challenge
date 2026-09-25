import 'package:flutter/foundation.dart';

import '../../../core/supabase/supabase_config.dart';
import 'home_data.dart';

/// Raised when the page cannot be read.
class HomeFailure implements Exception {
  const HomeFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only file in the home feature that knows Supabase exists — including
/// who is signed in, which is why [load] takes no arguments.
class HomeRepository {
  const HomeRepository();

  /// Reads everything the page needs for the signed-in family.
  ///
  /// The queries are independent, so they run together rather than in a chain.
  Future<HomeData> load() async {
    final profileId = currentProfileId;
    if (profileId == null) {
      throw const HomeFailure('You are signed out.');
    }

    // Only the profile is essential. The rest of the page is worth showing
    // even if one section cannot be read, so those fall back to empty and
    // say why on the console rather than replacing the page with an error.
    final results = await Future.wait([
      _profile(profileId),
      _optional('day streak', () => _streak(profileId), const DayStreak.none()),
      _optional('lawns', () => _lawns(profileId), const <_LawnRow>[]),
      _optional('announcements', _announcements, const <Announcement>[]),
      _optional('activity feed', _activity, const <ActivityEntry>[]),
      _optional('training videos', _training, const <TrainingVideo>[]),
      _optional('availability', () => _availability(profileId),
          const Availability.available()),
      _optional('away days', () => _awayPeriods(profileId),
          const <_AwayPeriod>[]),
    ]);

    final profile = results[0] as HomeProfile;
    final streak = results[1] as DayStreak;
    final lawns = results[2] as List<_LawnRow>;
    final announcements = results[3] as List<Announcement>;
    final activity = results[4] as List<ActivityEntry>;
    final training = results[5] as List<TrainingVideo>;
    final availability = results[6] as Availability;
    final away = results[7] as List<_AwayPeriod>;

    return HomeData(
      profile: profile,
      availability: availability,
      streak: streak,
      week: _weekFrom(lawns, away),
      categories: _tally(lawns),
      announcements: announcements.take(2).toList(),
      training: training,
      activity: activity,
    );
  }

  // --- shared with the profile page ------------------------------------------

  /// The header and challenge card's data.
  Future<HomeProfile> readProfile(String profileId) => _profile(profileId);

  Future<DayStreak> readStreak(String profileId) => _streak(profileId);

  Future<Availability> readAvailability(String profileId) =>
      _availability(profileId);

  /// Lawns per kind of neighbour, one entry per [kMowedCategories].
  Future<List<CategoryTally>> readCategories(String profileId) async =>
      _tally(await _lawns(profileId));

  /// Runs [read], falling back to [fallback] if it fails.
  static Future<T> _optional<T>(
    String what,
    Future<T> Function() read,
    T fallback,
  ) async {
    try {
      return await read();
    } catch (e) {
      debugPrint('Home: could not load $what — $e');
      return fallback;
    }
  }

  Future<HomeProfile> _profile(String profileId) async {
    final row = await supabase
        .from('profiles')
        .select(
          'display_name, child_name, state, photo_url, total_lawns, '
          'total_hours, created_at, badge_levels(name, sort_order)',
        )
        .eq('id', profileId)
        .maybeSingle();

    if (row == null) {
      // Signed in but no row yet: show the page rather than an error.
      return const HomeProfile(
        displayName: '',
        state: null,
        joinedAt: null,
        totalLawns: 0,
        totalHours: 0,
      );
    }

    final badge = row['badge_levels'] as Map<String, dynamic>?;
    return HomeProfile(
      displayName: (row['display_name'] as String?) ?? '',
      childName: row['child_name'] as String?,
      state: row['state'] as String?,
      photoUrl: (row['photo_url'] as String?)?.trim(),
      totalLawns: (row['total_lawns'] as num?)?.toInt() ?? 0,
      totalHours: (row['total_hours'] as num?)?.toDouble() ?? 0,
      joinedAt: DateTime.tryParse((row['created_at'] as String?) ?? ''),
      badgeName: badge?['name'] as String?,
      // sort_order is zero-based; people count from one.
      badgeRank: badge == null
          ? null
          : ((badge['sort_order'] as num?)?.toInt() ?? 0) + 1,
    );
  }

  Future<DayStreak> _streak(String profileId) async {
    final rows = await supabase
        .rpc('profile_day_streaks', params: {'p_profile_id': profileId});
    final row = (rows as List).firstOrNull as Map<String, dynamic>?;
    if (row == null) return const DayStreak.none();
    return DayStreak(
      current: (row['current_streak'] as num?)?.toInt() ?? 0,
      longest: (row['longest_streak'] as num?)?.toInt() ?? 0,
    );
  }

  Future<List<_LawnRow>> _lawns(String profileId) async {
    final rows = await supabase
        .from('lawns')
        .select('who_for, created_at, status')
        .eq('profile_id', profileId)
        .neq('status', 'rejected');

    return [
      for (final row in rows as List)
        if (DateTime.tryParse((row['created_at'] as String?) ?? '')
            case final at?)
          _LawnRow(whoFor: row['who_for'] as String?, at: at.toLocal()),
    ];
  }

  Future<List<Announcement>> _announcements() async {
    final rows = await supabase
        .from('announcements')
        .select(
          'id, title, description, image_url, article_link, video_link, '
          'created_at',
        )
        .order('created_at', ascending: false)
        .limit(10);

    return [
      for (final row in rows as List)
        Announcement(
          id: row['id'] as String,
          title: (row['title'] as String?) ?? '',
          description: row['description'] as String?,
          imageUrl: (row['image_url'] as String?)?.trim().nullIfEmpty,
          articleLink: (row['article_link'] as String?)?.trim().nullIfEmpty,
          videoLink: (row['video_link'] as String?)?.trim().nullIfEmpty,
          createdAt:
              DateTime.tryParse((row['created_at'] as String?) ?? '') ??
                  DateTime.now(),
        ),
    ];
  }

  Future<List<TrainingVideo>> _training() async {
    final rows = await supabase
        .from('training_videos')
        .select('id, title, description, video_url, thumbnail_url')
        .eq('is_published', true)
        .order('sort_order', ascending: true)
        .limit(10);

    return [
      for (final row in rows as List)
        TrainingVideo(
          id: row['id'] as String,
          title: (row['title'] as String?) ?? '',
          description: (row['description'] as String?)?.nullIfEmpty,
          videoUrl: (row['video_url'] as String?) ?? '',
          thumbnailUrl: (row['thumbnail_url'] as String?)?.trim().nullIfEmpty,
        ),
    ];
  }

  Future<Availability> _availability(String profileId) async {
    final rows = await supabase
        .rpc('profile_availability', params: {'p_profile_id': profileId});
    final row = (rows as List).firstOrNull as Map<String, dynamic>?;
    if (row == null) return const Availability.available();
    return Availability(
      isAway: row['is_away'] as bool? ?? false,
      returnsOn: _date(row['returns_on']),
      availableSince: _date(row['available_since']),
    );
  }

  Future<List<_AwayPeriod>> _awayPeriods(String profileId) async {
    final rows = await supabase
        .from('away_periods')
        .select('starts_on, returns_on')
        .eq('profile_id', profileId);
    return [
      for (final row in rows as List)
        if (_date(row['starts_on']) case final start?)
          _AwayPeriod(start: start, returns: _date(row['returns_on'])),
    ];
  }

  /// Postgres `date` arrives as "2026-09-30"; keep it a calendar date.
  static DateTime? _date(Object? value) {
    if (value is! String) return null;
    final parsed = DateTime.tryParse(value);
    return parsed == null ? null : DateTime(parsed.year, parsed.month, parsed.day);
  }

  // --- writes ---------------------------------------------------------------

  /// Goes offline, or moves the return date while already away. [returnsOn]
  /// is the day they are back; null means no date yet.
  Future<void> setAway({DateTime? returnsOn}) async {
    await supabase.rpc('set_away', params: {
      'p_returns_on': returnsOn == null ? null : _isoDate(returnsOn),
    });
  }

  /// Back online, early or on time.
  Future<void> setAvailable() async {
    await supabase.rpc('set_available');
  }

  static String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<List<ActivityEntry>> _activity() async {
    final rows = await supabase
        .from('lawns')
        // `lawns` points at `profiles` twice — once for who mowed and once
        // for the admin who approved it — so the constraint has to be named
        // or PostgREST cannot tell which one is meant.
        .select('who_for, created_at, profiles!lawns_profile_id_fkey(display_name)')
        .eq('status', 'approved')
        .order('created_at', ascending: false)
        .limit(2);

    return [
      for (final row in rows as List)
        ActivityEntry(
          name: (row['profiles'] as Map<String, dynamic>?)?['display_name']
                  as String? ??
              'A challenger',
          whoFor: row['who_for'] as String?,
          at: DateTime.tryParse((row['created_at'] as String?) ?? '')
                  ?.toLocal() ??
              DateTime.now(),
        ),
    ];
  }

  /// Sunday-first, matching the design's tracker.
  static MowingWeek _weekFrom(List<_LawnRow> lawns, List<_AwayPeriod> away) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // DateTime.weekday is Mon=1..Sun=7.
    final sunday = today.subtract(Duration(days: today.weekday % 7));

    final mowedDays = {
      for (final lawn in lawns) DateTime(lawn.at.year, lawn.at.month, lawn.at.day),
    };

    return MowingWeek(
      days: [
        for (var i = 0; i < MowingWeek.length; i++)
          switch (sunday.add(Duration(days: i))) {
            // A lawn outranks everything: mowing while "away" still counts.
            final day when mowedDays.contains(day) => DayState.mowed,
            final day when away.any((p) => p.covers(day)) => DayState.away,
            final day when day == today => DayState.today,
            final day when day.isBefore(today) => DayState.missed,
            _ => DayState.upcoming,
          },
      ],
    );
  }

  static List<CategoryTally> _tally(List<_LawnRow> lawns) {
    final counts = <MowedCategory, int>{};
    for (final lawn in lawns) {
      final category = MowedCategory.match(lawn.whoFor);
      if (category != null) counts[category] = (counts[category] ?? 0) + 1;
    }

    // The ring shows this category against the busiest one, so the tiles read
    // as a comparison rather than six nearly-empty rings.
    final busiest = counts.values.fold(0, (a, b) => a > b ? a : b);
    return [
      for (final category in kMowedCategories)
        CategoryTally(
          category: category,
          count: counts[category] ?? 0,
          share: busiest == 0 ? 0 : (counts[category] ?? 0) / busiest,
        ),
    ];
  }
}

class _AwayPeriod {
  const _AwayPeriod({required this.start, this.returns});

  final DateTime start;

  /// The day they are back, so the last day away is the one before.
  final DateTime? returns;

  bool covers(DateTime day) =>
      !day.isBefore(start) && (returns == null || day.isBefore(returns!));
}

class _LawnRow {
  const _LawnRow({required this.whoFor, required this.at});

  final String? whoFor;
  final DateTime at;
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
