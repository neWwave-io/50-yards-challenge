import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_config.dart';
import 'lawn_draft.dart';
import 'submit_result.dart';

/// Raised when a lawn cannot be submitted, with a message fit to show.
class SubmitLawnFailure implements Exception {
  const SubmitLawnFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The only file in the submit feature that knows Supabase exists.
class SubmitLawnRepository {
  const SubmitLawnRepository();

  static const _bucket = 'lawn-photos';

  /// Saves [draft] as a pending lawn for the signed-in child, then reads
  /// back where that leaves them.
  ///
  /// The lawn row goes first so its id can name the photo folder. If any
  /// photo then fails, the half-made lawn is deleted rather than left in the
  /// review queue with pictures missing.
  Future<SubmitResult> submit(LawnDraft draft) async {
    final profileId = currentProfileId;
    if (profileId == null) {
      throw const SubmitLawnFailure('You are signed out.');
    }

    final Map<String, dynamic> lawn;
    try {
      lawn = await supabase
          .from('lawns')
          .insert({
            'profile_id': profileId,
            'who_for': draft.whoFor?.label,
            'service': draft.service,
            'mowed_on': _isoDate(draft.mowedOn),
            'hours_taken': draft.hours,
            'notes': draft.note.trim().isEmpty ? null : draft.note.trim(),
            'wore_safety_gear': draft.woreSafetyGear,
          })
          .select('id')
          .single();
    } catch (e) {
      debugPrint('Submit lawn: insert failed — $e');
      throw const SubmitLawnFailure(
        'Your lawn could not be saved. Check your connection and try again.',
      );
    }
    final lawnId = lawn['id'] as String;

    final uploaded = <String>[];
    try {
      final rows = <Map<String, dynamic>>[];
      var order = 0;
      for (final photo in LawnPhoto.values) {
        final bytes = draft.photos[photo];
        if (bytes == null) continue;

        // Grouped by child, then lawn, so a storage policy can key on the
        // first folder once lawn-photos stops being public.
        final path = '$profileId/$lawnId/${photo.kind}.jpg';
        await supabase.storage.from(_bucket).uploadBinary(
              path,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
              ),
            );
        uploaded.add(path);
        rows.add({
          'lawn_id': lawnId,
          'photo_kind': photo.kind,
          'url': supabase.storage.from(_bucket).getPublicUrl(path),
          'sort_order': order++,
        });
      }
      await supabase.from('lawn_photos').insert(rows);
    } catch (e) {
      debugPrint('Submit lawn: photos failed — $e');
      await _undo(lawnId, uploaded);
      throw const SubmitLawnFailure(
        'Your photos could not be uploaded. Check your connection and try '
        'again.',
      );
    }

    // The lawn is in. If the summary cannot be read, the child should still
    // hear it worked, so fall back to what is known locally.
    try {
      return await _result(profileId, draft.hours ?? 0);
    } catch (e) {
      debugPrint('Submit lawn: could not read the summary — $e');
      return SubmitResult(
        lawnNumber: null,
        hoursAdded: draft.hours ?? 0,
        verifiedHours: 0,
        level: null,
      );
    }
  }

  Future<SubmitResult> _result(String profileId, double hoursAdded) async {
    final (counted, profile, levelRows) = await (
      supabase
          .from('lawns')
          .select('id')
          .eq('profile_id', profileId)
          .neq('status', 'rejected')
          .count(CountOption.exact),
      supabase
          .from('profiles')
          .select('total_hours')
          .eq('id', profileId)
          .maybeSingle(),
      supabase
          .from('badge_levels')
          .select('name, min_lawns, sort_order')
          .order('min_lawns', ascending: true),
    ).wait;

    final lawnNumber = counted.count;
    final levels = [
      for (final row in levelRows)
        Level(
          name: (row['name'] as String?) ?? '',
          minLawns: (row['min_lawns'] as num?)?.toInt() ?? 0,
          // sort_order is zero-based; the first level is rank 1.
          rank: ((row['sort_order'] as num?)?.toInt() ?? 0) + 1,
        ),
    ];

    return SubmitResult(
      lawnNumber: lawnNumber,
      hoursAdded: hoursAdded,
      verifiedHours: _number(profile?['total_hours']),
      level: levels.lastWhereOrNull((l) => l.minLawns <= lawnNumber),
    );
  }

  static double _number(Object? value) => switch (value) {
        num n => n.toDouble(),
        String s => double.tryParse(s) ?? 0,
        _ => 0,
      };

  /// Best effort: the submit has already failed, and a failure here must not
  /// hide the reason why.
  Future<void> _undo(String lawnId, List<String> uploaded) async {
    try {
      if (uploaded.isNotEmpty) {
        await supabase.storage.from(_bucket).remove(uploaded);
      }
      await supabase.from('lawns').delete().eq('id', lawnId);
    } catch (e) {
      debugPrint('Submit lawn: could not clean up lawn $lawnId — $e');
    }
  }

  static String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
