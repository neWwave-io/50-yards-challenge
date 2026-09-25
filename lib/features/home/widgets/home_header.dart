import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/home_data.dart';
import 'availability_badge.dart';

/// The dark green banner at the top of the home and profile pages.
///
/// It runs behind the challenge card, which overlaps its lower edge, so the
/// banner is drawn taller than its content and the page stacks the card on
/// top of it.
///
/// Home shows the availability badge on the right; the profile passes its own
/// [trailing] control instead.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.profile,
    required this.availability,
    this.onGoAway,
    this.onComeBack,
    this.trailing,
    this.avatarSize = contentHeight,
    this.topGap = 4,
    this.gradient = homeWash,
  });

  final HomeProfile profile;
  final Availability availability;

  /// Needed for the availability badge, which is shown when there is no
  /// [trailing] control.
  final Future<void> Function({DateTime? returnsOn})? onGoAway;
  final Future<void> Function()? onComeBack;

  /// Replaces the availability badge.
  final Widget? trailing;

  /// The avatar is also the row's height.
  final double avatarSize;

  /// Space between the status bar and the avatar row.
  final double topGap;

  final Gradient gradient;

  /// The home page's radial wash, anchored off the top-left corner.
  static const homeWash = RadialGradient(
    center: Alignment(-1.2, -1.4),
    radius: 1.9,
    colors: AppColors.headerWash,
    stops: [0, 0.56, 0.78, 1],
  );

  /// The line under the greeting says where the family stands right now.
  String? get statusLine {
    if (availability.isAway) {
      final back = availability.returnsOn;
      return back == null ? 'Away for now' : 'Away until ${dayAndMonth(back)}';
    }
    // Their last return, falling back to when they joined.
    final since = availability.availableSince ?? profile.joinedAt;
    return since == null ? null : 'Available Since ${dayAndMonth(since)}';
  }

  static const height = 263.0;

  /// The avatar-and-greeting row. The design gives it 82px, starting just
  /// under the status bar, which leaves the rest of the banner for the card.
  static const contentHeight = 82.0;

  /// Where the challenge card starts, measured from the top of the banner.
  static const cardTop = 159.0;

  @override
  Widget build(BuildContext context) {
    final status = statusLine;
    final goAway = onGoAway;
    final comeBack = onComeBack;
    final end = trailing ??
        (goAway == null || comeBack == null
            ? null
            : AvailabilityBadge(
                availability: availability,
                onGoAway: goAway,
                onComeBack: comeBack,
              ));

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.dialog),
        ),
        gradient: gradient,
      ),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: SafeArea(
        bottom: false,
        // Pinned just below the status bar rather than centred in the banner:
        // the banner's lower half is covered by the challenge card, and a
        // centred row would sit underneath it.
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topGap),
            child: SizedBox(
              height: avatarSize,
              child: Row(
                children: [
                  _Avatar(photoUrl: profile.photoUrl, size: avatarSize),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TeamLine(state: profile.state),
                        Text(
                          'Hi, ${profile.firstName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.greeting,
                        ),
                        if (status != null)
                          Text(
                            status,
                            style: AppTypography.caption
                                .copyWith(color: AppColors.surface),
                          ),
                      ],
                    ),
                  ),
                  if (end != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    end,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamLine extends StatelessWidget {
  const _TeamLine({required this.state});

  final String? state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(weekdayName(DateTime.now()), style: AppTypography.greetingMeta),
        if (state != null && state!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/home/grass_tuft.png',
                width: 12,
                height: 12,
              ),
            ),
          ),
          Flexible(
            child: Text(
              'Team $state',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.greetingMeta,
            ),
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl, required this.size});

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.avatarDisc,
        boxShadow: [
          BoxShadow(color: Color(0x332D5A1B), offset: Offset(0, 7), blurRadius: 16),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      // No photo is the normal case for a new family, so the gradient disc
      // stands on its own rather than showing a broken image.
      child: url == null || url.isEmpty
          ? null
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
    );
  }
}
