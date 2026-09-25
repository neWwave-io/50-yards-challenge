import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'lawn_photo_tile.dart';

/// The Safety Check, read back: the answer the child gave and the photo of
/// them in their gear.
class SafetyCheckPanel extends StatelessWidget {
  const SafetyCheckPanel({
    super.key,
    required this.woreGear,
    required this.photoUrl,
  });

  /// Null on a lawn submitted before the form asked.
  final bool? woreGear;

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final woreGear = this.woreGear;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.olive100,
        borderRadius: BorderRadius.circular(AppRadii.detailRow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Safety check', style: AppTypography.safetyLabel),
              if (woreGear != null) _Answer(yes: woreGear),
            ],
          ),
          if (photoUrl != null) ...[
            const SizedBox(height: AppSpacing.md),
            LawnPhotoTile(
              label: 'Photo',
              url: photoUrl,
              height: AppSizes.safetyPhotoHeight,
            ),
          ],
        ],
      ),
    );
  }
}

/// The answer as it was given — never a control. Changing it is the submit
/// form's business, and the lawn has already been reviewed.
class _Answer extends StatelessWidget {
  const _Answer({required this.yes});

  final bool yes;

  @override
  Widget build(BuildContext context) {
    final ink = yes ? AppColors.olive500 : AppColors.red500;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.olive100,
        border: Border.all(color: ink.withValues(alpha: 0.5), width: 2),
        borderRadius: BorderRadius.circular(AppRadii.field),
        boxShadow: AppShadows.answer,
      ),
      child: Text(
        yes ? 'Yes' : 'No',
        style: AppTypography.safetyAnswer.copyWith(color: ink),
      ),
    );
  }
}
