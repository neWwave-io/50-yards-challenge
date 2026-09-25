import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/achievement_data.dart';

/// The "Lawn 7" tag in a card's top-left corner.
///
/// The number says which lawn it is; the colour says how it came back from
/// review. That is the whole status indicator — there is no separate word
/// for it on the card.
class LawnStatusChip extends StatelessWidget {
  const LawnStatusChip({super.key, required this.number, required this.review});

  final int number;
  final LawnReview review;

  @override
  Widget build(BuildContext context) {
    final (fill, ink, style) = switch (review) {
      LawnReview.approved => (
          AppColors.statusApprovedFill,
          AppColors.olive500,
          AppTypography.statusApproved,
        ),
      LawnReview.rejected => (
          AppColors.statusRejectedFill,
          AppColors.red500,
          AppTypography.statusRejected,
        ),
    };

    return Semantics(
      label: 'Lawn $number, ${review.name}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: ink.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(AppRadii.detailRow),
        ),
        child: Text('Lawn $number', style: style),
      ),
    );
  }
}
