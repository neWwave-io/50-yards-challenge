import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The dark green banner at the top of the leaderboard.
///
/// Like the home header, it runs behind the podium card, which overlaps its
/// lower edge; the screen stacks the card on top.
class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({super.key, required this.state, this.compact = false});

  /// The signed-in child's state, for the "Team …" chip.
  final String? state;

  /// The shorter banner of the empty board, whose card is smaller.
  final bool compact;

  /// Banner height below the status bar.
  static const height = 304.0;
  static const compactHeight = 239.0;

  /// Where the card over the banner starts, below the status bar.
  static const cardTop = 105.0;
  static const compactCardTop = 113.0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Container(
      height: top + (compact ? compactHeight : height),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.dialog),
        ),
        border: Border.all(color: AppColors.surface.withValues(alpha: 0.1)),
        boxShadow: AppShadows.header,
        gradient: const RadialGradient(
          // Anchored off the top-left corner, as on the home header.
          center: Alignment(-1.2, -1.4),
          radius: 1.9,
          colors: AppColors.headerWash,
          stops: [0, 0.56, 0.78, 1],
        ),
      ),
      padding: EdgeInsets.only(top: top + AppSpacing.xl),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Leaderboard', style: AppTypography.headerTitle),
          if (state != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            _TeamChip(state: state!),
          ],
        ],
      ),
    );
  }
}

class _TeamChip extends StatelessWidget {
  const _TeamChip({required this.state});

  final String state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.cardRaised,
      ),
      child: Text(
        'Team $state',
        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
