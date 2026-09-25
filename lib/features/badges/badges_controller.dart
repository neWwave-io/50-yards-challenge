import 'package:flutter/foundation.dart';

import 'data/badge_data.dart';
import 'data/badges_repository.dart';

enum BadgeTab { earned, locked }

/// Loads the badges page and holds what it is showing.
class BadgesController extends ChangeNotifier {
  BadgesController({this.repository = const BadgesRepository()});

  final BadgesRepository repository;

  BadgesData? _data;
  Object? _error;
  var _loading = false;

  BadgesData? get data => _data;
  Object? get error => _error;

  /// True only on the very first load, when there is nothing to show yet.
  bool get isFirstLoad => _loading && _data == null;

  var tab = BadgeTab.earned;

  /// Cards turned over to show their description.
  final _flipped = <String>{};

  bool isFlipped(ChallengeBadge badge) => _flipped.contains(badge.id);

  void selectTab(BadgeTab value) {
    if (tab == value) return;
    tab = value;
    notifyListeners();
  }

  void flip(ChallengeBadge badge) {
    if (!_flipped.remove(badge.id)) _flipped.add(badge.id);
    notifyListeners();
  }

  List<ChallengeBadge> get visible {
    final all = _data;
    if (all == null) return const [];
    return tab == BadgeTab.earned ? all.started : all.locked;
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await repository.load();
    } catch (e) {
      // Keep whatever is already on screen.
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Sends a request and reloads so the card shows it as waiting. Returns a
  /// message to show if it failed.
  Future<String?> requestBadge({
    required ChallengeBadge badge,
    required String explanation,
    required Uint8List photo,
  }) async {
    try {
      await repository.requestBadge(
        badgeId: badge.id,
        explanation: explanation,
        photo: photo,
      );
    } on BadgesFailure catch (e) {
      return e.message;
    } catch (e) {
      return 'Your request could not be sent: $e';
    }
    await load();
    return null;
  }
}
