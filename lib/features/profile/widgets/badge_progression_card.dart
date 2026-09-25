import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/profile_data.dart';
import 'cropped_image.dart';
import 'profile_card.dart';

/// The shirt the child has now, the next one, and how far away it is.
///
/// Each badge level comes with a shirt, and the design talks about the shirt,
/// so the copy says "shirt" even though the code calls the levels badges.
class BadgeProgressionCard extends StatelessWidget {
  const BadgeProgressionCard({
    super.key,
    required this.current,
    required this.next,
    required this.lawnsToNext,
  });

  /// Null before the first level.
  final BadgeLevel? current;

  /// Null once every level is reached.
  final BadgeLevel? next;
  final int? lawnsToNext;

  static const _tileSize = 100.0;

  @override
  Widget build(BuildContext context) {
    final upcoming = next;
    final remaining = lawnsToNext;
    final toNext = upcoming == null || remaining == null
        ? 'Every shirt earned'
        : '$remaining ${remaining == 1 ? 'lawn' : 'lawns'} to next shirt';

    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Shirt Progression',
                  style: AppTypography.sectionTitle.copyWith(height: 1.2),
                ),
              ),
              const CroppedImage(
                'assets/images/profile/shirt_progression.png',
                width: ProfileCardTitle.iconSize,
                height: ProfileCardTitle.iconSize,
                scaleX: 1.1674,
                scaleY: 1.1674,
                insetLeft: 0.073,
                insetTop: 0.0687,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Tile(
                  width: _tileSize,
                  height: _tileSize,
                  color: AppColors.olive50,
                  label: Text('Shirt', style: AppTypography.shirtTitle),
                  shirt: _Shirt(
                    shirt: current?.shirt ?? BadgeShirt.white,
                    width: 51,
                    height: 60,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _Tile(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.olive200, width: 2),
                    label: Text(
                      toNext,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.shirtCaption,
                    ),
                    shirt: upcoming == null
                        ? null
                        : _Shirt(shirt: upcoming.shirt, width: 42, height: 50),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.olive500),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Row(
              children: [
                const CroppedImage(
                  'assets/images/profile/next_shirt.png',
                  width: 24,
                  height: 24,
                  scaleX: 1.1836,
                  scaleY: 1.1851,
                  insetLeft: 0.0821,
                  insetTop: 0.085,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    upcoming == null
                        ? toNext
                        : '$toNext (${upcoming.shirt.label} Shirt)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.shirtCaption
                        .copyWith(color: AppColors.olive700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.color,
    required this.label,
    this.shirt,
    this.border,
    this.width,
    this.height,
  });

  final Color color;
  final Widget label;
  final Widget? shirt;
  final BoxBorder? border;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          boxShadow: AppShadows.cardRaised,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            label,
            if (shirt != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              // The design's 100px tile is a few pixels short of its own
              // contents and clips the shirt; shrinking it keeps it whole.
              Flexible(child: FittedBox(child: shirt!)),
            ],
          ],
        ),
      );
}

class _Shirt extends StatelessWidget {
  const _Shirt({required this.shirt, required this.width, required this.height});

  final BadgeShirt shirt;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // The design's two exports carry a margin it crops away; the v1 shirts
    // standing in for the other colours are already trimmed.
    if (!shirt.isDesignExport) {
      return Image.asset(shirt.imagePath, width: width, height: height, fit: BoxFit.contain);
    }
    final orange = shirt == BadgeShirt.orange;
    return CroppedImage(
      shirt.imagePath,
      width: width,
      height: height,
      scaleX: orange ? 1.3122 : 1.2925,
      scaleY: orange ? 1.1116 : 1.1053,
      insetLeft: orange ? 0.1561 : 0.1462,
      insetTop: orange ? 0.0558 : 0.0526,
    );
  }
}
