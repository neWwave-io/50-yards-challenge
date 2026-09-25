import 'package:flutter/foundation.dart';

import 'data/achievement_data.dart';
import 'data/achievement_repository.dart';

/// Loads the child's reviewed lawns and remembers which card is open.
class AchievementController extends ChangeNotifier {
  AchievementController({this.repository = const AchievementRepository()});

  final AchievementRepository repository;

  List<SubmittedLawn> _lawns = const [];
  Object? _error;
  var _loaded = false;

  /// At most one card is open at a time, as in the design.
  String? _openLawnId;

  List<SubmittedLawn> get lawns => _lawns;
  Object? get error => _error;
  bool get isFirstLoad => !_loaded && _error == null;

  bool isOpen(SubmittedLawn lawn) => lawn.id == _openLawnId;

  Future<void> load() async {
    _error = null;
    notifyListeners();
    try {
      _lawns = await repository.reviewedLawns();
      // The open card may have just been filtered away by a refresh.
      if (!_lawns.any((lawn) => lawn.id == _openLawnId)) _openLawnId = null;
      _loaded = true;
    } catch (e) {
      // Keep whatever is on screen; a failed refresh should not blank it.
      _error = e;
    } finally {
      notifyListeners();
    }
  }

  /// Opens [lawn], closing whichever card was open. Tapping the open one
  /// closes it.
  void toggle(SubmittedLawn lawn) {
    _openLawnId = isOpen(lawn) ? null : lawn.id;
    notifyListeners();
  }
}
