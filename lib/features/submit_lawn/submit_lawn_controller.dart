import 'package:flutter/foundation.dart';

import '../home/data/home_data.dart' show MowedCategory;
import 'data/lawn_draft.dart';
import 'data/submit_lawn_repository.dart';
import 'data/submit_result.dart';

/// Walks the four submit steps and holds the lawn being filled in.
class SubmitLawnController extends ChangeNotifier {
  SubmitLawnController({
    this.repository = const SubmitLawnRepository(),
    DateTime? today,
  }) : _draft = LawnDraft(mowedOn: _dateOnly(today ?? DateTime.now()));

  final SubmitLawnRepository repository;

  LawnDraft _draft;
  var _step = SubmitStep.details;
  var _submitting = false;
  SubmitResult? _result;

  LawnDraft get draft => _draft;

  /// Set once the lawn is in; the screen then shows the "logged" view.
  SubmitResult? get result => _result;
  SubmitStep get step => _step;
  bool get submitting => _submitting;

  bool get isLastStep => _step == SubmitStep.values.last;
  bool get canContinue => _draft.isComplete(_step) && !_submitting;

  /// Moves back a step. False on the first step, where Back leaves the flow.
  bool back() {
    if (_step.index == 0) return false;
    _step = SubmitStep.values[_step.index - 1];
    notifyListeners();
    return true;
  }

  /// Moves on a step. Call [submit] on the last one instead.
  void next() {
    if (!canContinue || isLastStep) return;
    _step = SubmitStep.values[_step.index + 1];
    notifyListeners();
  }

  /// Sends the lawn. Returns a message to show if it failed.
  Future<String?> submit() async {
    if (!canContinue || !isLastStep) return null;
    _submitting = true;
    notifyListeners();
    try {
      _result = await repository.submit(_draft);
      return null;
    } on SubmitLawnFailure catch (e) {
      return e.message;
    } catch (e) {
      debugPrint('Submit lawn: unexpected failure — $e');
      return 'Your lawn could not be submitted. Please try again.';
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  void chooseWhoFor(MowedCategory who) =>
      _update(_draft.copyWith(whoFor: who));

  void chooseService(String service) =>
      _update(_draft.copyWith(service: service));

  void chooseDate(DateTime date) =>
      _update(_draft.copyWith(mowedOn: _dateOnly(date)));

  /// Takes the raw text of the hours field; anything unparseable clears it.
  void setHours(String text) => _update(
        _draft.copyWith(hours: () => double.tryParse(text.trim())),
      );

  void setNote(String note) => _update(_draft.copyWith(note: note));

  void setPhoto(LawnPhoto photo, Uint8List bytes) =>
      _update(_draft.copyWith(photos: {..._draft.photos, photo: bytes}));

  void answerSafety({required bool woreGear}) =>
      _update(_draft.copyWith(woreSafetyGear: woreGear));

  void _update(LawnDraft draft) {
    _draft = draft;
    notifyListeners();
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
