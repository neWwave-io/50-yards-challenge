import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_progress_ring.dart';

/// Hours logged, against the hours the challenge asks for.
class PassportCard extends StatelessWidget {
  const PassportCard({super.key, required this.totalHours, this.onOpen});

  final double totalHours;
  final VoidCallback? onOpen;

  /// Fifty hours, to match the fifty lawns. Not yet configurable anywhere.
  static const goalHours = 50;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      clip: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x80EEF4E3), Color(0x80D4E4B8), Color(0x80B8CF96)],
        stops: [0, 0.6, 1],
      ),
      child: Row(
        children: [
          _HoursRing(hours: totalHours),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Passport',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralText900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hours, lawns and neighbors helped, all timestamped.',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                AppPrimaryButton(label: 'Start Mowing', onPressed: onOpen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoursRing extends StatelessWidget {
  const _HoursRing({required this.hours});

  final double hours;

  @override
  Widget build(BuildContext context) {
    final whole = hours == hours.roundToDouble()
        ? hours.toStringAsFixed(0)
        : hours.toStringAsFixed(1);

    return SizedBox.square(
      dimension: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/images/home/passport_glow.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          AppProgressRing(
            diameter: 120,
            thickness: 10,
            progress: hours / PassportCard.goalHours,
            trackColor: AppColors.olive900,
            trackOpacity: 0.08,
            // The design leaves the ring open on the right.
            startAngle: math.pi * 0.85,
            sweep: math.pi * 1.7,
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface.withValues(alpha: 0.8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${whole}H',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.olive500,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Container(width: 60, height: 1, color: AppColors.borderDefault),
                const SizedBox(height: 2),
                Text(
                  '${PassportCard.goalHours}H',
                  style:
                      AppTypography.bodySmall.copyWith(color: AppColors.olive500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
