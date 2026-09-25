import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'leaderboard_avatar.dart';

/// One ranked child: position, photo, name and lawns.
///
/// [mine] draws the signed-in child's row — the brand-green one that says
/// "Me".
class RankRow extends StatelessWidget {
  const RankRow({
    super.key,
    required this.rank,
    required this.name,
    required this.photoUrl,
    required this.totalLawns,
    this.mine = false,
  });

  final int rank;
  final String name;
  final String? photoUrl;
  final int totalLawns;
  final bool mine;

  static const _avatarSize = 50.0;

  /// The design gives the number a 30px column; wider ranks may grow it.
  static const _rankWidth = 30.0;

  @override
  Widget build(BuildContext context) {
    final rankStyle = mine
        ? AppTypography.rankNumber.copyWith(color: AppColors.surface)
        : AppTypography.rankNumber;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: mine ? null : AppColors.rowFill,
        gradient: mine ? AppColors.brandFill : null,
        borderRadius: BorderRadius.circular(AppRadii.row),
        boxShadow: AppShadows.cardRaised,
      ),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _rankWidth),
            child: Text('$rank', style: rankStyle),
          ),
          const SizedBox(width: AppSpacing.xs),
          LeaderboardAvatar(photoUrl: photoUrl, size: _avatarSize),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mine ? 'Me' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mine ? AppTypography.rankNameMine : AppTypography.rankName,
                ),
                if (mine) const SizedBox(height: 2),
                Text(
                  'Mowed Lawn $totalLawns',
                  maxLines: 1,
                  style: mine
                      ? AppTypography.rankDetailMine
                      : AppTypography.rankDetail,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
