import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/home_data.dart';

/// The dark green banner at the top of the home page.
///
/// It runs behind the challenge card, which overlaps its lower edge, so the
/// banner is drawn taller than its content and the page stacks the card on
/// top of it.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.profile, this.onStatusTap});

  final HomeProfile profile;
  final VoidCallback? onStatusTap;

  static const height = 263.0;

  /// The avatar-and-greeting row. The design gives it 82px, starting just
  /// under the status bar, which leaves the rest of the banner for the card.
  static const contentHeight = 82.0;

  /// Where the challenge card starts, measured from the top of the banner.
  static const cardTop = 159.0;

  @override
  Widget build(BuildContext context) {
    final joined = profile.joinedAt;

    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.dialog),
        ),
        gradient: RadialGradient(
          // Anchored off the top-left corner, as in the design.
          center: Alignment(-1.2, -1.4),
          radius: 1.9,
          colors: AppColors.headerWash,
          stops: [0, 0.56, 0.78, 1],
        ),
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
            padding: const EdgeInsets.only(top: 4),
            child: SizedBox(
              height: contentHeight,
              child: Row(
                children: [
                  _Avatar(photoUrl: profile.photoUrl),
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
                        if (joined != null)
                          Text(
                            'Available Since ${dayAndMonth(joined)}',
                            style: AppTypography.caption
                                .copyWith(color: AppColors.surface),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onStatusTap,
                    child: SvgPicture.asset(
                      'assets/icons/home_status.svg',
                      width: 44,
                      height: 44,
                    ),
                  ),
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
  const _Avatar({required this.photoUrl});

  final String? photoUrl;

  static const _size = 82.0;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return Container(
      width: _size,
      height: _size,
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
