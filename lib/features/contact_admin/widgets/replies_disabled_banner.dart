import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// Tells the family nobody will write back here.
class RepliesDisabledBanner extends StatelessWidget {
  const RepliesDisabledBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.amber100),
          borderRadius: BorderRadius.circular(AppRadii.summaryRow),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.iconButton,
              height: AppSizes.iconButton,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.summaryRow),
                boxShadow: AppShadows.alertIcon,
              ),
              child: SvgPicture.asset(
                'assets/icons/contact_alert.svg',
                width: AppSizes.icon,
                height: AppSizes.icon,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Replies are disabled', style: AppTypography.bannerTitle),
                  const SizedBox(height: 2),
                  Text(
                    'This is a one-way message channel to the admin team.',
                    style: AppTypography.badgeMeta,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
