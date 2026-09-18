import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// "Step 1 of 2" plus the pill indicator underneath it.
class AppStepProgress extends StatelessWidget {
  const AppStepProgress({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  /// One-based.
  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Step $step of $totalSteps', style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= totalSteps; i++) ...[
              if (i > 1) const SizedBox(width: AppSpacing.sm),
              _Pill(active: i == step),
            ],
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) => Container(
        width: active ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: active
              ? AppColors.olive500
              : AppColors.neutralText500.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      );
}
