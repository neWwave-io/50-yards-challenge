import 'package:flutter/widgets.dart';

/// Form state for sign-in. It knows when the button should light up and
/// nothing else; the screen hands the values to the auth manager.
class SignInController extends ChangeNotifier {
  SignInController() {
    for (final c in [email, password]) {
      c.addListener(notifyListeners);
    }
  }

  final email = TextEditingController();
  final password = TextEditingController();

  bool get isComplete =>
      email.text.trim().isNotEmpty && password.text.isNotEmpty;

  @override
  void dispose() {
    for (final c in [email, password]) {
      c.removeListener(notifyListeners);
      c.dispose();
    }
    super.dispose();
  }
}
