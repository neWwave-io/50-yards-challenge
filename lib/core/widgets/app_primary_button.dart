import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The pill-shaped, olive-gradient call to action.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;

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
              : Text(
                  label,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.neutralText100),
                ),
        ),
      ),
    );
  }
}
