import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// A titled block with an optional "See More" on the right.
class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onSeeMore,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  /// Hidden when there is nowhere to go.
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.sectionTitle
                        .copyWith(color: AppColors.calendarInk),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.inkMuted),
                    ),
                  ],
                ],
              ),
            ),
            if (onSeeMore != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSeeMore,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('See More', style: AppTypography.link),
                    const SizedBox(width: AppSpacing.xxs),
                    SvgPicture.asset(
                      'assets/icons/home_arrow_right.svg',
                      width: AppSizes.icon,
                      height: AppSizes.icon,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        child,
      ],
    );
  }
}

/// What a section shows when it has nothing in it yet.
class HomeSectionEmpty extends StatelessWidget {
  const HomeSectionEmpty({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Text(
        message,
        style: AppTypography.bodySmall.copyWith(color: AppColors.inkMuted),
      );
}
