import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'cropped_image.dart';
import 'profile_card.dart';

/// The opt-in for sharing the parent's contact details with nearby families.
class NearbyFamiliesCard extends StatelessWidget {
  const NearbyFamiliesCard({
    super.key,
    required this.shares,
    required this.onToggle,
  });

  final bool shares;
  final VoidCallback onToggle;

  static const _boxSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileCardTitle(
            icon: CroppedImage(
              'assets/images/profile/nearby_families.png',
              width: ProfileCardTitle.iconSize,
              height: ProfileCardTitle.iconSize,
              scaleX: 1.1803,
              scaleY: 1.1848,
              insetLeft: 0.082,
              insetTop: 0.078,
            ),
            title: 'Connect with Nearby Families',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Connect with other 50 Yard Challenge families in your city. Only '
            'your parent name, email, and city are shared with families who '
            'turn this on.',
            style: AppTypography.statLabel,
          ),
          const SizedBox(height: AppSpacing.xl),
          Semantics(
            checked: shares,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Container(
                height: AppSizes.fieldHeight,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.neutralText500),
                  borderRadius: BorderRadius.circular(AppRadii.field),
                  boxShadow: AppShadows.fieldFocused,
                ),
                child: Row(
                  children: [
                    Container(
                      width: _boxSize,
                      height: _boxSize,
                      decoration: BoxDecoration(
                        color: shares ? AppColors.olive600 : null,
                        border: Border.all(
                          color: shares
                              ? AppColors.olive600
                              : AppColors.neutralText500,
                        ),
                        borderRadius: BorderRadius.circular(AppRadii.checkbox),
                      ),
                      child: shares
                          ? const Icon(
                              Icons.check_rounded,
                              size: AppSizes.icon,
                              color: AppColors.surface,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Share my contact info with nearby families',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.statLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            shares
                ? 'Nearby families will appear here once sharing launches.'
                : 'Turn on sharing to see families near you.',
            // The design sets this in Onest Light, which the app does not
            // ship; Regular is the nearest bundled weight.
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
