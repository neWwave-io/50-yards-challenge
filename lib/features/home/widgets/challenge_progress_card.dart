import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_ring.dart';
import '../data/home_data.dart';

/// Lawns done out of fifty, with the badge level and three stats beside it.
///
/// The big ring is deliberately larger than the card and hangs off its left
/// edge, so only the right half of it shows.
class ChallengeProgressCard extends StatelessWidget {
  const ChallengeProgressCard({
    super.key,
    required this.profile,
    required this.streak,
    this.onTap,
  });

  final HomeProfile profile;
  final DayStreak streak;
  final VoidCallback? onTap;

  static const _ringDiameter = 342.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AppCard(
        raised: true,
        clip: true,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 314,
          child: Stack(
            children: [
              Positioned(
                right: -60,
                bottom: -104,
                child: _Glow(level: profile.badgeIndex),
              ),
              Positioned(
                left: -172,
                top: -15,
                child: AppProgressRing(
                  diameter: _ringDiameter,
                  progress: profile.progress,
                  thickness: 34,
                ),
              ),
              Positioned(
                left: -172 + _ringDiameter / 2 + 70 - 60,
                top: -15 + _ringDiameter / 2 - 50,
                child: _RingLabel(profile: profile),
              ),
              Positioned(
                right: AppSpacing.lg,
                top: 19,
                child: _Level(profile: profile),
              ),
              Positioned(
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: _Stats(profile: profile, streak: streak),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The wash in the corner, tinted by how far along the challenge is.
///
/// In the design this is the level's shirt photo, blurred until only its
/// colour is left — so it is painted rather than shipped as five more images.
class _Glow extends StatelessWidget {
  const _Glow({required this.level});

  /// Zero-based badge level, or null before any level is reached.
  final int? level;

  @override
  Widget build(BuildContext context) {
    final index = level;
    final tint = index == null
        ? AppColors.moss500
        : AppColors.badgeGlows[index.clamp(0, AppColors.badgeGlows.length - 1)];

    return IgnorePointer(
      child: Container(
        width: 207,
        height: 242,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              tint.withValues(alpha: AppColors.badgeGlowOpacity),
              tint.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingLabel extends StatelessWidget {
  const _RingLabel({required this.profile});

  final HomeProfile profile;

  @override
  Widget build(BuildContext context) {
    final done = profile.isComplete;

    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${profile.totalLawns}',
            style: done
                ? AppTypography.ringNumber.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.olive700,
                  )
                : AppTypography.ringNumber,
          ),
          Text(
            // Fifty lawns is the whole challenge: stop counting, celebrate.
            done ? 'completed' : 'of ${HomeProfile.goal}',
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 16,
              color: done ? AppColors.olive700 : AppColors.moss500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Level extends StatelessWidget {
  const _Level({required this.profile});

  final HomeProfile profile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 151,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Challenge Progress',
            textAlign: TextAlign.right,
            style: AppTypography.cardTitle.copyWith(color: AppColors.olive700),
          ),
          const SizedBox(height: AppSpacing.md),
          // Lawns again, not the level's rank: every card in the design shows
          // the same number here as on the ring.
          Text('${profile.totalLawns}', style: AppTypography.levelNumber),
          Text(
            // The ladder is empty until the levels are imported, so say that
            // rather than invent a title.
            profile.badgeName ?? 'No badge yet',
            textAlign: TextAlign.right,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.olive700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.profile, required this.streak});

  final HomeProfile profile;
  final DayStreak streak;

  @override
  Widget build(BuildContext context) {
    final hours = profile.totalHours;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Stat(
          value: hours == hours.roundToDouble()
              ? hours.toStringAsFixed(0)
              : hours.toStringAsFixed(1),
          label: 'Total Hours',
          icon: 'assets/icons/home_clock.svg',
        ),
        const SizedBox(height: AppSpacing.md),
        _Stat(
          value: '${streak.longest}',
          label: 'Day Streak',
          icon: 'assets/icons/home_fire.svg',
        ),
        const SizedBox(height: AppSpacing.md),
        _Stat(
          value: '# ${profile.nextLawnNumber}',
          label: 'Next Lawn',
          icon: 'assets/icons/home_leaf.svg',
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppTypography.statValue),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(icon, width: 10, height: 10),
              const SizedBox(width: 2),
              Text(label, style: AppTypography.statLabel),
            ],
          ),
        ],
      );
}
