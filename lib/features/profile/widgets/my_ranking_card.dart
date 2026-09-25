import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/profile_data.dart';
import 'cropped_image.dart';
import 'profile_card.dart';

/// Where the child stands nationally and within their state.
class MyRankingCard extends StatelessWidget {
  const MyRankingCard({super.key, required this.ranking, this.onTap});

  final Ranking ranking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ProfileCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileCardTitle(
              icon: const CroppedImage(
                'assets/images/profile/ranking.png',
                width: ProfileCardTitle.iconSize,
                height: ProfileCardTitle.iconSize,
                scaleX: 1.14,
                scaleY: 1.139,
                insetLeft: 0.07,
                insetTop: 0.0544,
              ),
              title: 'My Ranking',
              style: AppTypography.sectionTitle
                  .copyWith(color: AppColors.rankValue, height: 1.2),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: _Tile(label: 'National', rank: ranking.national)),
                const SizedBox(width: 10),
                Expanded(child: _Tile(label: 'State', rank: ranking.state)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.rank});

  final String label;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    final position = rank;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.rankTile,
        borderRadius: BorderRadius.circular(AppRadii.summaryRow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.rankTileLabel),
          const SizedBox(height: 2),
          Text(
            // "# 04", as the design pads it. Unranked until the first lawn.
            position == null ? '—' : '# ${position.toString().padLeft(2, '0')}',
            style: AppTypography.rankTileValue,
          ),
        ],
      ),
    );
  }
}
