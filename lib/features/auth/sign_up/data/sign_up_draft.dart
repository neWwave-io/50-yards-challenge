/// Everything step 1 collects, carried into step 2 so the account is only
/// created once both halves are answered.
class SignUpDraft {
  const SignUpDraft({
    required this.fullName,
    required this.email,
    required this.password,
    required this.relationship,
    required this.city,
    required this.state,
  });

  final String fullName;
  final String email;
  final String password;

  /// Parents | Guardian | Relative.
  final String relationship;

  final String city;
  final String state;
}
