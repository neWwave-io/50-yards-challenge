import 'package:flutter/widgets.dart';

import 'data/sign_up_draft.dart';
import 'widgets/password_strength_meter.dart';

/// Form state for step 1 of sign-up. It owns the text controllers and knows
/// when the step is complete; it never talks to a backend. Step 2 carries
/// [toDraft] over to `SignUpRepository`, which creates the account once both
/// halves are answered.
class SignUpStepOneController extends ChangeNotifier {
  SignUpStepOneController() {
    for (final c in [fullName, email, password, confirmPassword]) {
      c.addListener(notifyListeners);
    }
  }

  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  String? _relationship;
  String? _city;
  String? _state;

  String? get relationship => _relationship;
  String? get city => _city;
  String? get state => _state;

  set relationship(String? value) {
    _relationship = value;
    notifyListeners();
  }

  set city(String? value) {
    _city = value;
    notifyListeners();
  }

  set state(String? value) {
    if (_state == value) return;
    _state = value;
    // Cities are offered per state, so the old choice is now meaningless —
    // this is what kept "Fresno, Wisconsin" reachable.
    _city = null;
    notifyListeners();
  }

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  PasswordStrength get passwordStrength => PasswordStrength.of(password.text);

  /// Only once the second box has something in it — an empty confirm field
  /// is unfinished, not wrong.
  bool get showPasswordMismatch =>
      confirmPassword.text.isNotEmpty && !passwordsMatch;

  bool get passwordsMatch =>
      password.text.isNotEmpty && password.text == confirmPassword.text;

  /// Every field answered and internally consistent.
  bool get isComplete =>
      fullName.text.trim().isNotEmpty &&
      _emailPattern.hasMatch(email.text.trim()) &&
      password.text.length >= 8 &&
      passwordsMatch &&
      (_relationship?.isNotEmpty ?? false) &&
      (_city?.isNotEmpty ?? false) &&
      (_state?.isNotEmpty ?? false);

  /// Only valid once [isComplete] is true.
  SignUpDraft toDraft() => SignUpDraft(
        fullName: fullName.text.trim(),
        email: email.text.trim(),
        password: password.text,
        relationship: _relationship!,
        city: _city!,
        state: _state!,
      );

  @override
  void dispose() {
    for (final c in [fullName, email, password, confirmPassword]) {
      c.removeListener(notifyListeners);
      c.dispose();
    }
    super.dispose();
  }
}
