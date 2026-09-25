import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../profile/widgets/cropped_image.dart';

/// "Badge Progress": how many of the badges are won, and the way to ask for
/// one that is earned by request.
class BadgeProgressCard extends StatelessWidget {
  const BadgeProgressCard({
    super.key,
    required this.earned,
    required this.total,
    this.onRequest,
  });

  final int earned;
  final int total;

  /// Disabled when null — nothing is open to request.
  final VoidCallback? onRequest;

  static const _barHeight = 16.0;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : earned / total;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        // The design's 50% white, flattened: left translucent, the card's own
        // shadow shows through and greys it.
        color: AppColors.rowFill,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text('Badge Progress', style: AppTypography.sectionTitle),
              ),
              Text('$earned/$total', style: AppTypography.badgeTally),
              const SizedBox(width: AppSpacing.xxs),
              Text('Badges Earned', style: AppTypography.statLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const CroppedImage(
                'assets/images/badges/progress_bottle.png',
                width: 13,
                height: 23.477,
                scaleX: 2.1733,
                scaleY: 1.2035,
                insetLeft: 0.5858,
                insetTop: 0.1008,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                    height: _barHeight,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius:
                          BorderRadius.circular(AppRadii.progressTrack),
                    ),
                    child: Container(
                      // Never narrower than the knob, so "0" still shows.
                      width: (constraints.maxWidth * fraction)
                          .clamp(_barHeight, constraints.maxWidth)
                          .toDouble(),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandFill,
                        borderRadius:
                            BorderRadius.circular(AppRadii.progressTrack),
                      ),
                      child: Container(
                        width: _barHeight,
                        height: _barHeight,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.badgeKnob,
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          child: Text(
                            '$earned',
                            style: AppTypography.impactCount,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(label: 'Request For Badge', onPressed: onRequest),
        ],
      ),
    );
  }
}
