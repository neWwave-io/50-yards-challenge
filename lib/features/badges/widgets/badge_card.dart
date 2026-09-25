import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/badge_data.dart';

/// A badge's card. Tapping it turns it over to show what the badge is for,
/// and tapping again turns it back.
class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.badge,
    required this.flipped,
    required this.onFlip,
  });

  final ChallengeBadge badge;
  final bool flipped;
  final VoidCallback onFlip;

  /// Both faces share one height, so the grid does not jump as cards turn.
  static const height = 172.0;

  static const _flipDuration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: flipped ? 'Show ${badge.name}' : 'About ${badge.name}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onFlip,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: flipped ? math.pi : 0),
          duration: _flipDuration,
          curve: Curves.easeInOut,
          builder: (context, angle, _) {
            final showingBack = angle > math.pi / 2;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: showingBack
                  // Turned the rest of the way so the back does not read
                  // mirrored.
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: _Face(child: _Back(badge: badge)),
                    )
                  : _Face(child: _Front(badge: badge)),
            );
          },
        ),
      ),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.child});

  final Widget child;

  static const _tagSize = 28.0;

  @override
  Widget build(BuildContext context) => Container(
        height: BadgeCard.height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          boxShadow: AppShadows.cardRaised,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: child,
              ),
            ),
            // The turn-over tag, in the corner of both faces.
            Positioned(
              top: 0,
              right: 1,
              child: Container(
                width: _tagSize,
                height: _tagSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.olive500,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/badge_flip.svg',
                  width: 8.61539,
                  height: 7.63636,
                ),
              ),
            ),
          ],
        ),
      );
}

class _Front extends StatelessWidget {
  const _Front({required this.badge});

  final ChallengeBadge badge;

  static const _artSize = 80.0;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            // Locked badges show what is coming, faded.
            opacity: badge.isStarted ? 1 : 0.4,
            child: _Art(url: badge.imageUrl, size: _artSize),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            badge.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.badgeCardName,
          ),
          const SizedBox(height: AppSpacing.sm),
          _Footer(badge: badge),
        ],
      );
}

class _Back extends StatelessWidget {
  const _Back({required this.badge});

  final ChallengeBadge badge;

  @override
  Widget build(BuildContext context) {
    final earnedAt = badge.earnedAt;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          badge.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.badgeCardName,
        ),
        const SizedBox(height: AppSpacing.md),
        Flexible(
          child: Text(
            badge.description ?? badge.howToEarn,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: AppTypography.badgeBack,
          ),
        ),
        // The description says what it is for; this says how to get it,
        // unless the description is already standing in for that.
        if (badge.description != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            earnedAt != null
                ? 'Earned ${dayAndMonth(earnedAt)}, ${earnedAt.year}'
                : badge.howToEarn,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.badgeBack.copyWith(color: AppColors.olive600),
          ),
        ],
      ],
    );
  }
}

/// "Completed", or how far along, as a pill that fills up.
class _Footer extends StatelessWidget {
  const _Footer({required this.badge});

  final ChallengeBadge badge;

  static const _width = 146.0;
  static const _height = 34.0;

  String get _label {
    if (badge.earned) return 'Completed';
    if (badge.isRequested) {
      return switch (badge.claimStatus) {
        ClaimStatus.pending => 'Waiting for review',
        ClaimStatus.rejected => 'Not approved',
        _ => 'Request to earn',
      };
    }
    return '${badge.progress} /${badge.requiredLawns ?? 0} completed';
  }

  @override
  Widget build(BuildContext context) {
    final done = badge.earned;

    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: AppColors.accentSubtle,
        borderRadius: BorderRadius.circular(AppRadii.badgeFooter),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (badge.fraction > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: _width * badge.fraction,
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.olive600
                      : AppColors.olive500.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadii.summaryRow),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              _label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: done
                  ? AppTypography.badgeFooter.copyWith(color: AppColors.surface)
                  : AppTypography.badgeFooter,
            ),
          ),
        ],
      ),
    );
  }
}

class _Art extends StatelessWidget {
  const _Art({required this.url, required this.size});

  final String? url;
  final double size;

  /// Until an admin uploads a picture, the design's badge stands in.
  static const _placeholder = 'assets/images/profile/badge_placeholder.png';

  @override
  Widget build(BuildContext context) {
    final image = url;
    Widget fallback() =>
        Image.asset(_placeholder, width: size, height: size, fit: BoxFit.cover);
    if (image == null) return fallback();
    return Image.network(
      image,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }
}
