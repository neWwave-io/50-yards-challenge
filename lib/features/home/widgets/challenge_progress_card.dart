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
              const Positioned(
                right: -60,
                bottom: -104,
                child: _Glow(),
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
                child: _RingLabel(lawns: profile.totalLawns),
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

class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Opacity(
          opacity: 0.7,
          child: Image.asset(
            'assets/images/home/progress_glow.png',
            width: 207,
            height: 242,
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _RingLabel extends StatelessWidget {
  const _RingLabel({required this.lawns});

  final int lawns;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$lawns', style: AppTypography.ringNumber),
            Text(
              'of ${HomeProfile.goal}',
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 16,
                color: AppColors.moss500,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
}

class _Level extends StatelessWidget {
  const _Level({required this.profile});

  final HomeProfile profile;

  @override
  Widget build(BuildContext context) {
    final rank = profile.badgeRank;
    final name = profile.badgeName;

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
          // The badge ladder is empty until the levels are imported, so say
          // so rather than inventing a rank.
          if (rank != null)
            Text('$rank', style: AppTypography.levelNumber)
          else
            Text('—', style: AppTypography.levelNumber),
          Text(
            name ?? 'No badge yet',
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
