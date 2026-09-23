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

  /// The passport asset's own shape, trimmed to the booklet. Held here so
  /// the art can be sized off the card's height without being cropped.
  static const _passportRatio = 257 / 329;

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
            // As tall as the card and no taller, so the whole booklet shows
            // rather than being cut off top and bottom. Out past the card's
            // own padding, so it starts at the card's edge and the ring sits
            // over its middle.
            // Out past the card's padding on three sides — exactly to its
            // edges, never beyond.
            left: -AppSpacing.lg,
            top: -AppSpacing.lg,
            bottom: -AppSpacing.lg,
            child: IgnorePointer(
              // Softened, but still recognisably a passport. The design
              // stacks two blurs here: the image's own layer blur and a
              // "Background blur 4" over it. Each is a 2px CSS blur (Figma
              // shows double), i.e. sigma 2, and two gaussians combine as
              // sqrt(2² + 2²) ≈ 2.8.
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 2.8, sigmaY: 2.8),
                child: Opacity(
                  opacity: 0.4,
                  // The Stack leaves the width unbounded, so the ratio is
                  // what turns the card's height into a width. Given a fixed
                  // width instead, the booklet was cropped down to a sliver.
                  child: AspectRatio(
                    aspectRatio: _passportRatio,
                    child: Image.asset(
                      'assets/images/home/passport_glow.png',
                      fit: BoxFit.contain,
                    ),
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
