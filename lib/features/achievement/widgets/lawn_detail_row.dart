import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// The pale olive strip a lawn's facts are printed on: a label on the left, a
/// value on the right.
///
/// [LawnDetailRow.icon] swaps the label for a 16px glyph, which is how the
/// design writes the date and the hours.
class LawnDetailRow extends StatelessWidget {
  const LawnDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.dimmed,
  }) : icon = null;

  const LawnDetailRow.icon({
    super.key,
    required this.icon,
    required this.value,
    required this.dimmed,
  }) : label = null;

  final String? label;
  final String? icon;
  final String value;

  /// A rejected lawn prints its values in grey rather than olive.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final ink = dimmed ? AppColors.neutral400 : AppColors.olive600;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.olive100,
        borderRadius: BorderRadius.circular(AppRadii.detailRow),
      ),
      child: Row(
        children: [
          if (icon != null)
            SvgPicture.asset(icon!, width: AppSizes.icon, height: AppSizes.icon)
          else
            Text(label!, style: AppTypography.detailLabel),
          const SizedBox(width: AppSpacing.sm),
          // The value takes what is left and ends at the right edge, so a
          // long address wraps inside the strip instead of overflowing it.
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.detailValue.copyWith(color: ink),
            ),
          ),
        ],
      ),
    );
  }
}
