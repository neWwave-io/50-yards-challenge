import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../home/data/home_data.dart';
import 'cropped_image.dart';
import 'profile_card.dart';

/// Lawns per kind of neighbour, as a bar each, with the total in the corner.
class ImpactSummaryCard extends StatelessWidget {
  const ImpactSummaryCard({super.key, required this.tallies});

  final List<CategoryTally> tallies;

  /// The design lists the categories in this order, not the home grid's.
  static const _order = [
    MowedCategory.disabled,
    MowedCategory.elderly,
    MowedCategory.firstResponder,
    MowedCategory.activeDuty,
    MowedCategory.veteran,
    MowedCategory.singleParent,
  ];

  @override
  Widget build(BuildContext context) {
    final byCategory = {for (final t in tallies) t.category: t};
    final total = tallies.fold(0, (sum, t) => sum + t.count);

    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileCardTitle(
            icon: const CroppedImage(
              'assets/images/profile/impact.png',
              width: ProfileCardTitle.iconSize,
              height: ProfileCardTitle.iconSize,
              scaleX: 1.1868,
              scaleY: 1.1868,
              insetLeft: 0.0866,
              insetTop: 0.0934,
            ),
            gap: AppSpacing.xxs,
            title: 'Impact Summary',
            trailing: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.olive500.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadii.summaryRow),
              ),
              child: Text('$total', style: AppTypography.impactTotal),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final category in _order) ...[
            if (category != _order.first) const SizedBox(height: AppSpacing.md),
            _Row(
              tally: byCategory[category] ??
                  CategoryTally(category: category, count: 0, share: 0),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.tally});

  final CategoryTally tally;

  static const _iconSize = 32.0;
  static const _barHeight = 16.0;

  /// The shortest bar with a count on it: the knob and as much again.
  static const _minBar = _barHeight * 2;

  /// (bar, knob) per category, from the design.
  static (Color, Color) _colours(MowedCategory c) => switch (c) {
        MowedCategory.disabled => (AppColors.impactLime, _knob),
        MowedCategory.elderly => (AppColors.olive300, _knob),
        MowedCategory.firstResponder => (AppColors.olive400, _knob),
        MowedCategory.activeDuty => (AppColors.emerald800, AppColors.legacyGreen),
        MowedCategory.veteran => (AppColors.impactFern, _knob),
        MowedCategory.singleParent => (AppColors.olive700, _knob),
      };

  static final _knob = AppColors.surface.withValues(alpha: 0.2);

  @override
  Widget build(BuildContext context) {
    final (bar, knob) = _colours(tally.category);

    return Row(
      children: [
        Image.asset(
          tally.category.iconPath,
          width: _iconSize,
          height: _iconSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tally.category.label,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.inkMuted, height: 1),
              ),
              const SizedBox(height: AppSpacing.xxs),
              LayoutBuilder(
                builder: (context, constraints) {
                  final full = constraints.maxWidth;
                  // Longest bar for the busiest category; none at all for an
                  // empty one, just the knob with its zero.
                  final width = tally.count == 0
                      ? _barHeight
                      : (tally.share * full).clamp(_minBar, full).toDouble();

                  return Container(
                    width: width,
                    height: _barHeight,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: tally.count == 0
                          ? bar.withValues(alpha: 0.4)
                          : bar,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Container(
                      width: _barHeight,
                      height: _barHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: knob,
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Text(
                          '${tally.count}',
                          style: AppTypography.impactCount,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
