import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_config.dart';
import '../../home/data/home_data.dart';
import 'badge_data.dart';

/// Raised when the page cannot be read or a request cannot be sent. The
/// message is safe to show.
class BadgesFailure implements Exception {
  const BadgesFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only file in the badges feature that knows Supabase exists.
class BadgesRepository {
  const BadgesRepository();

  /// Private: the photos show children, so only the family and admins can
  /// read them (see 0026_badges.sql).
  static const _proofBucket = 'badge-proofs';

  /// Every active badge with the signed-in child's standing on it.
  Future<BadgesData> load() async {
    final profileId = currentProfileId;
    if (profileId == null) throw const BadgesFailure('You are signed out.');

    final rows = await supabase
        .rpc('profile_badges', params: {'p_profile_id': profileId});

    return BadgesData(
      badges: [
        for (final row in rows as List)
          ChallengeBadge(
            id: row['id'] as String,
            name: (row['name'] as String?) ?? '',
            description: (row['description'] as String?)?.trim().nullIfEmpty,
            imageUrl: (row['image_url'] as String?)?.trim().nullIfEmpty,
            earnedBy: BadgeEarnedBy.parse(row['earned_by']),
            requiredLawns: (row['required_lawns'] as num?)?.toInt(),
            whoFor: _category(row['who_for'] as String?),
            progress: (row['progress'] as num?)?.toInt() ?? 0,
            claimStatus: ClaimStatus.parse(row['claim_status']),
            earned: row['earned'] as bool? ?? false,
            earnedAt:
                DateTime.tryParse((row['earned_at'] as String?) ?? '')?.toLocal(),
          ),
      ],
    );
  }

  /// Sends a request for [badgeId] with the child's [explanation] and a
  /// proof [photo], for an admin to review.
  ///
  /// The photo goes up first under a random name, so a failed upload leaves
  /// no half-made request in the admin queue; a failed insert removes the
  /// photo again.
  Future<void> requestBadge({
    required String badgeId,
    required String explanation,
    required Uint8List photo,
  }) async {
    final profileId = currentProfileId;
    if (profileId == null) throw const BadgesFailure('You are signed out.');

    // Filed under the family's own folder, which is what the storage policy
    // keys on.
    final path = '$profileId/${_randomName()}.jpg';
    try {
      await supabase.storage.from(_proofBucket).uploadBinary(
            path,
            photo,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
    } catch (e) {
      debugPrint('Request badge: upload failed — $e');
      throw const BadgesFailure(
        'Your photo could not be uploaded. Check your connection and try again.',
      );
    }

    try {
      await supabase.from('badge_claims').insert({
        'profile_id': profileId,
        'badge_id': badgeId,
        'explanation': explanation.trim(),
        'photo_path': path,
      });
    } on PostgrestException catch (e) {
      await _discard(path);
      debugPrint('Request badge: insert failed — ${e.code} ${e.message}');
      // The one-live-claim index: a request is already waiting.
      if (e.code == '23505') {
        throw const BadgesFailure('You have already asked for this badge.');
      }
      throw const BadgesFailure(
        'Your request could not be sent. Check your connection and try again.',
      );
    } catch (e) {
      await _discard(path);
      debugPrint('Request badge: insert failed — $e');
      throw const BadgesFailure(
        'Your request could not be sent. Check your connection and try again.',
      );
    }
  }

  Future<void> _discard(String path) async {
    try {
      await supabase.storage.from(_proofBucket).remove([path]);
    } catch (e) {
      debugPrint('Request badge: could not remove $path — $e');
    }
  }

  static String _randomName() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static MowedCategory? _category(String? key) {
    for (final c in MowedCategory.values) {
      if (c.asset == key) return c;
    }
    return null;
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
