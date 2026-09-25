import '../../../core/supabase/supabase_config.dart';
import '../../submit_lawn/data/lawn_draft.dart' show LawnPhoto;
import 'achievement_data.dart';

/// Raised when the page cannot be read.
class AchievementFailure implements Exception {
  const AchievementFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only file in the achievement feature that knows Supabase exists —
/// including who is signed in, which is why [reviewedLawns] takes no
/// arguments.
class AchievementRepository {
  const AchievementRepository();

  static const _columns = 'id, who_for, service, address, hours_taken, '
      'mowed_on, created_at, status, wore_safety_gear, '
      'lawn_photos(photo_kind, url, sort_order)';

  /// Every lawn an admin has already ruled on, newest first.
  ///
  /// The whole history is read, pending lawns included, and filtered here
  /// rather than in the query: "Lawn 7" counts from the child's first
  /// submission, so a pending lawn still occupies its number. The challenge
  /// stops at fifty lawns, so this is never a large read.
  Future<List<SubmittedLawn>> reviewedLawns() async {
    final profileId = currentProfileId;
    if (profileId == null) {
      throw const AchievementFailure('You are signed out.');
    }

    final rows = await supabase
        .from('lawns')
        .select(_columns)
        .eq('profile_id', profileId)
        .order('created_at', ascending: true);

    final reviewed = <SubmittedLawn>[];
    for (var i = 0; i < rows.length; i++) {
      final review = LawnReview.parse(rows[i]['status']);
      // Still in the queue, so not an achievement yet. It keeps its number.
      if (review == null) continue;
      reviewed.add(_lawn(rows[i], number: i + 1, review: review));
    }
    // Read oldest first to number them; shown newest first.
    return reviewed.reversed.toList();
  }

  SubmittedLawn _lawn(
    Map<String, dynamic> row, {
    required int number,
    required LawnReview review,
  }) =>
      SubmittedLawn(
        id: row['id'] as String,
        number: number,
        review: review,
        mowedFor: _text(row['who_for']),
        service: _text(row['service']),
        address: _text(row['address']),
        // `mowed_on` is a date; v1 rows have none, so the day it was logged
        // stands in — it is the closest thing on the row to when it was done.
        mowedOn: _date(row['mowed_on']) ?? _date(row['created_at']),
        hours: _number(row['hours_taken']),
        woreSafetyGear: row['wore_safety_gear'] as bool?,
        photos: _photos(row['lawn_photos']),
      );

  /// Keyed by step, so the card can ask for the shot it wants to draw. A
  /// duplicate kind keeps the lowest `sort_order`, which is the one the
  /// submit flow wrote first.
  static Map<LawnPhoto, String> _photos(Object? value) {
    if (value is! List) return const {};
    final rows = [...value.whereType<Map<String, dynamic>>()]..sort(
        (a, b) => (a['sort_order'] as int? ?? 0)
            .compareTo(b['sort_order'] as int? ?? 0),
      );

    final photos = <LawnPhoto, String>{};
    for (final row in rows) {
      final url = _text(row['url']);
      if (url == null) continue;
      for (final step in LawnPhoto.values) {
        if (step.kind == row['photo_kind']) {
          photos.putIfAbsent(step, () => url);
          break;
        }
      }
    }
    return photos;
  }

  /// Blank text in the database reads the same as no text at all.
  static String? _text(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// `numeric` comes back as a String from postgrest, not a double.
  static double? _number(Object? value) => switch (value) {
        num n => n.toDouble(),
        String s => double.tryParse(s),
        _ => null,
      };

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;
}
