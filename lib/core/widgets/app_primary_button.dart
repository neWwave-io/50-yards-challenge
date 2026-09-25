import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// The pill-shaped, olive-gradient call to action.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.large = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  /// The 14pt label of a page's main step ("Start Mowing") rather than the
  /// 12pt one of a form's submit.
  final bool large;

  /// An SVG after the label, tinted to match it — the arrow on
  /// "Start Mowing →".
  final String? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final style = large
        ? AppTypography.buttonLarge
        : AppTypography.bodySmall.copyWith(color: AppColors.neutralText100);
    final icon = trailingIcon;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onPressed : null,
        child: Container(
          height: AppSizes.buttonHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          decoration: BoxDecoration(
            gradient: AppColors.brandFill,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            boxShadow: AppShadows.button,
          ),
          child: busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.neutralText100,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Wraps less than it used to: a long label or large
                    // text size ends in an ellipsis rather than overflowing.
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: style,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: AppSpacing.xxs),
                      SvgPicture.asset(
                        icon,
                        width: AppSizes.icon,
                        height: AppSizes.icon,
                        colorFilter: const ColorFilter.mode(
                          AppColors.neutralText100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
