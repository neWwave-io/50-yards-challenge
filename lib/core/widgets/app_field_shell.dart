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
  });

  final String label;
  final Widget child;
  final bool focused;
  final bool filled;

  /// Null lets the box grow to fit [child] — used by the child cards.
  final double? height;

  final EdgeInsets padding;
  final VoidCallback? onTap;

  bool get _showLabel => focused || filled;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.field),
        border: Border.all(
          color: focused
              ? AppColors.borderFocused
              : filled
                  ? Colors.transparent
                  : AppColors.borderDefault,
        ),
        boxShadow: focused
            ? AppShadows.fieldFocused
            : filled
                ? AppShadows.field
                : null,
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
                  style: AppTypography.labelSmall.copyWith(
                    color: focused ? AppColors.olive600 : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
