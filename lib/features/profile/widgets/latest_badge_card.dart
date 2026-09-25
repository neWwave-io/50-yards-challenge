import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/profile_data.dart';
import 'profile_card.dart';

/// The most recent badge, with a button through to all of them.
class LatestBadgeCard extends StatelessWidget {
  const LatestBadgeCard({
    super.key,
    required this.badge,
    this.firstLevel,
    this.onOpen,
  });

  /// Null before the first badge is awarded.
  final EarnedBadge? badge;

  /// The first rung, for telling a new child what to aim for.
  final BadgeLevel? firstLevel;

  final VoidCallback? onOpen;

  static const _tileSize = 140.0;
  static const _artSize = 80.0;
  static const _buttonSize = 48.0;

  @override
  Widget build(BuildContext context) {
    final earned = badge;
    final awarded = earned?.awardedAt;
    final name = earned?.name ?? 'No badge yet';
    final description = earned?.description ??
        (earned != null
            ? null
            : firstLevel == null
                ? 'Your first badge is on its way.'
                : 'Mow ${firstLevel!.minLawns} lawns to earn '
                    '${firstLevel!.name}.');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: AppShadows.cardRaised,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Latest Badge', style: AppTypography.badgeHeading),
                    ),
                    if (awarded != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.olive500.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          'Awarded ${dayAndMonth(awarded)}, ${awarded.year}',
                          style: AppTypography.badgeMeta
                              .copyWith(color: AppColors.olive500),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      width: _tileSize,
                      height: _tileSize,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.tile),
                        boxShadow: AppShadows.cardRaised,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            // Greyed until there is something to show off.
                            opacity: earned == null ? 0.35 : 1,
                            child: _Art(url: earned?.imageUrl),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.badgeName,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SizedBox(
                        height: _tileSize,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(name, style: AppTypography.badgeName),
                              if (description != null) ...[
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  description,
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.badgeMeta,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onOpen != null)
            // Tucked into the corner, partly under the card's edge.
            Positioned(
              right: -4,
              bottom: -4,
              child: ProfileRoundButton(
                size: _buttonSize,
                onTap: onOpen!,
                semanticLabel: 'See all badges',
                icon: SvgPicture.asset(
                  'assets/icons/profile_arrow_up_right.svg',
                  width: AppSizes.icon,
                  height: AppSizes.icon,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Art extends StatelessWidget {
  const _Art({required this.url});

  final String? url;

  static const _placeholder = 'assets/images/profile/badge_placeholder.png';

  @override
  Widget build(BuildContext context) {
    const size = LatestBadgeCard._artSize;
    final image = url;
    // No level has its own artwork yet, so the design's badge stands in.
    if (image == null) {
      return Image.asset(_placeholder, width: size, height: size, fit: BoxFit.cover);
    }
    return Image.network(
      image,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Image.asset(_placeholder, width: size, height: size, fit: BoxFit.cover),
    );
  }
}
