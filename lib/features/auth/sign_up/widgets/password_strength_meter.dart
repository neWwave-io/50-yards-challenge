import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// How safe a password looks. Three steps, matching the three bars in the
/// design.
enum PasswordStrength {
  weak,
  fair,
  strong;

  /// A rough, entirely client-side score. It only guides the child filling in
  /// the form — the real rule is enforced on sign-up.
  static PasswordStrength of(String password) {
    if (password.length < 8) return PasswordStrength.weak;

    var points = 0;
    if (RegExp(r'[a-z]').hasMatch(password)) points++;
    if (RegExp(r'[A-Z]').hasMatch(password)) points++;
    if (RegExp(r'\d').hasMatch(password)) points++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) points++;
    if (password.length >= 12) points++;

    if (points >= 4) return PasswordStrength.strong;
    if (points >= 2) return PasswordStrength.fair;
    return PasswordStrength.weak;
  }

  int get filledBars => index + 1;

  String get label => switch (this) {
        PasswordStrength.weak => 'Weak strength',
        PasswordStrength.fair => 'Fair strength',
        PasswordStrength.strong => 'Strong strength',
      };

  Color get color => switch (this) {
        PasswordStrength.weak => AppColors.danger,
        PasswordStrength.fair => AppColors.warning,
        PasswordStrength.strong => AppColors.success,
      };
}

/// Three small bars plus a word describing them.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.strength});

  final PasswordStrength strength;

  static const _barCount = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _barCount; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xxs),
          _Bar(filled: i < strength.filledBars, color: strength.color),
        ],
        const SizedBox(width: AppSpacing.sm),
        Text(strength.label, style: AppTypography.caption),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.filled, required this.color});

  final bool filled;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 10,
        height: 6,
        decoration: BoxDecoration(
          color: filled
              ? color
              : AppColors.neutralText500.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      );
}
