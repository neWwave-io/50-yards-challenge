import 'package:flutter/widgets.dart';

import 'widgets/password_strength_meter.dart';

/// Form state for step 1 of sign-up. It owns the text controllers and knows
/// when the step is complete; it does not talk to a backend — that belongs in
/// a repository once step 2 exists.
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
    _state = value;
    notifyListeners();
  }

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  PasswordStrength get passwordStrength => PasswordStrength.of(password.text);

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

  @override
  void dispose() {
    for (final c in [fullName, email, password, confirmPassword]) {
      c.removeListener(notifyListeners);
      c.dispose();
    }
    super.dispose();
  }
}
