import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/leaderboard_data.dart';
import 'leaderboard_avatar.dart';

/// The glass card over the header: "National Top 5" and the 1-2-3 podium.
///
/// Places four and five are ordinary rows under the card; the screen draws
/// those.
class PodiumCard extends StatelessWidget {
  const PodiumCard({super.key, required this.leaders});

  /// Best first. Fewer than three is fine — empty places stay empty. The
  /// screen shows the empty-board card instead when there is nobody.
  final List<LeaderboardEntry> leaders;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
        boxShadow: AppShadows.glassCard,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: double.infinity,
            color: AppColors.surface.withValues(alpha: 0.08),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text('National Top 5', style: AppTypography.headerCardTitle),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Top participants across all states.',
                  style: AppTypography.headerCardSubtitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                _Podium(leaders: leaders),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The three pedestals, laid out exactly as the design places them.
class _Podium extends StatelessWidget {
  const _Podium({required this.leaders});

  final List<LeaderboardEntry> leaders;

  static const _width = 300.0;
  static const _height = 190.0;

  @override
  Widget build(BuildContext context) {
    LeaderboardEntry? at(int i) => i < leaders.length ? leaders[i] : null;

    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          _Place(
            left: 0,
            top: 39,
            imageTop: 47,
            image: 'assets/images/leaderboard/podium_second.png',
            imageSize: const Size(120, 97),
            entry: at(1),
          ),
          _Place(
            left: 181,
            top: 50,
            imageTop: 45,
            image: 'assets/images/leaderboard/podium_third.png',
            imageSize: const Size(119, 95),
            entry: at(2),
          ),
          // First is drawn last so its pedestal overlaps its neighbours'.
          _Place(
            left: 87,
            top: 0,
            imageTop: 41,
            image: 'assets/images/leaderboard/podium_first.png',
            imageSize: const Size(120, 144),
            entry: at(0),
          ),
        ],
      ),
    );
  }
}

class _Place extends StatelessWidget {
  const _Place({
    required this.left,
    required this.top,
    required this.imageTop,
    required this.image,
    required this.imageSize,
    required this.entry,
  });

  final double left;
  final double top;

  /// How far below the name block the pedestal starts.
  final double imageTop;
  final String image;
  final Size imageSize;
  final LeaderboardEntry? entry;

  static const _labelWidth = 73.0;
  static const _avatarSize = 42.0;
  static const _tagMinWidth = 63.0;

  @override
  Widget build(BuildContext context) {
    final e = entry;

    return Positioned(
      left: left,
      top: top,
      width: imageSize.width,
      height: imageTop + imageSize.height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: imageTop,
            child: Image.asset(
              image,
              width: imageSize.width,
              height: imageSize.height,
              fit: BoxFit.fill,
            ),
          ),
          if (e != null)
            SizedBox(
              width: _labelWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: LeaderboardAvatar(
                      photoUrl: e.photoUrl,
                      size: _avatarSize,
                    ),
                  ),
                  Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.podiumName,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: _tagMinWidth),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.olive100,
                      borderRadius: BorderRadius.circular(AppRadii.tag),
                      boxShadow: AppShadows.tag,
                    ),
                    child: Text(
                      e.totalLawns == 1 ? '1 lawn' : '${e.totalLawns} lawns',
                      textAlign: TextAlign.center,
                      style: AppTypography.podiumTag,
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
