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

    final results = await Future.wait([
      _profile(profileId),
      _streak(profileId),
      _lawns(profileId),
      _announcements(),
      _activity(),
    ]);

    final profile = results[0] as HomeProfile;
    final streak = results[1] as DayStreak;
    final lawns = results[2] as List<_LawnRow>;
    final announcements = results[3] as List<Announcement>;
    final activity = results[4] as List<ActivityEntry>;

    return HomeData(
      profile: profile,
      streak: streak,
      week: _weekFrom(lawns),
      categories: _tally(lawns),
      announcements:
          announcements.where((a) => a.videoLink == null).take(2).toList(),
      training:
          announcements.where((a) => a.videoLink != null).firstOrNull,
      activity: activity,
    );
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

  Future<List<ActivityEntry>> _activity() async {
    final rows = await supabase
        .from('lawns')
        .select('who_for, created_at, profiles(display_name)')
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
  static MowingWeek _weekFrom(List<_LawnRow> lawns) {
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
            final day when mowedDays.contains(day) => DayState.mowed,
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

class _LawnRow {
  const _LawnRow({required this.whoFor, required this.at});

  final String? whoFor;
  final DateTime at;
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
