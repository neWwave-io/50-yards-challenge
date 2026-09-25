import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The white rounded box every form control in the v2 design sits in, plus the
/// small "notch" label that floats over its top-left corner once the control
/// is active.
///
/// Three resting appearances, straight from Figma:
/// * empty + idle — hairline border, no shadow, no label
/// * filled + idle — no border, soft shadow, muted label
/// * focused — olive border, focus shadow, olive label
class AppFieldShell extends StatelessWidget {
  const AppFieldShell({
    super.key,
    required this.label,
    required this.child,
    this.focused = false,
    this.filled = false,
    this.height = AppSizes.fieldHeight,
    this.padding =
        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.onTap,
    this.background = AppColors.surface,
    this.borderColor,
    this.shadow,
    this.labelStyle,
  });

  final String label;
  final Widget child;
  final bool focused;
  final bool filled;

  /// Null lets the box grow to fit [child] — used by the child cards.
  final double? height;

  final EdgeInsets padding;
  final VoidCallback? onTap;

  /// The four below let a caller that is not a form control — a submitted
  /// photo, say — borrow the box and its notch label without inheriting the
  /// resting / filled / focused palette. Each falls back to that palette.
  final Color background;
  final Color? borderColor;
  final List<BoxShadow>? shadow;
  final TextStyle? labelStyle;

  bool get _showLabel => focused || filled;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.field),
        border: Border.all(
          color: borderColor ??
              (focused
                  ? AppColors.borderFocused
                  : filled
                      ? Colors.transparent
                      : AppColors.borderDefault),
        ),
        boxShadow: shadow ??
            (focused
                ? AppShadows.fieldFocused
                : filled
                    ? AppShadows.field
                    : null),
      ),
      child: child,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        onTap == null
            ? box
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: box,
              ),
        if (_showLabel)
          Positioned(
            left: AppSpacing.md,
            top: -7,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                  boxShadow: AppShadows.field,
                ),
                child: Text(
                  label,
                  style: labelStyle ??
                      AppTypography.labelSmall.copyWith(
                        color:
                            focused ? AppColors.olive600 : AppColors.textMuted,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
