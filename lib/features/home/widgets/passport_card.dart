import 'dart:ui' as ui;
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
      child: Stack(
        children: [
          Positioned(
            left: -1,
            top: -1,
            bottom: -1,
            child: IgnorePointer(
              // Blurred until it reads as a wash of colour rather than a
              // picture — the design blurs this layer and lays a second
              // blur over it.
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/images/home/passport_glow.png',
                    width: 99,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Row(
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
                      // Title case, as the design sets it.
                      'Hours, Lawns And Neighbors Helped, All Timestamped.',
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
          AppProgressRing(
            diameter: 120,
            thickness: 10,
            progress: hours / PassportCard.goalHours,
            trackColor: AppColors.olive900,
            trackOpacity: 0.08,
            // The design leaves a gap at the bottom of the ring.
            startAngle: math.pi * 0.65,
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
