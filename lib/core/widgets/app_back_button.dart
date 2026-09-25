import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// The "‹ Back" affordance the design puts at the top left of a step.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, required this.onTap, this.color});

  final VoidCallback onTap;

  /// Tints the arrow and label — light on a coloured screen. Null keeps the
  /// design's muted grey.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The design reuses the down arrow, turned a quarter turn.
              Transform.rotate(
                angle: 1.5707963267948966,
                child: SvgPicture.asset(
                  'assets/icons/arrow_back.svg',
                  width: AppSizes.icon,
                  height: AppSizes.icon,
                  colorFilter: color == null
                      ? null
                      : ColorFilter.mode(color!, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Back',
                style: color == null
                    ? AppTypography.navAction
                    : AppTypography.navAction.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
