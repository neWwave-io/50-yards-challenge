import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// The small "View" pill that opens and closes a lawn card.
///
/// Greys out, and stops responding, on a card with nothing behind it — a
/// rejected lawn, as the design draws it.
class LawnViewButton extends StatelessWidget {
  const LawnViewButton({
    super.key,
    required this.open,
    required this.onTap,
  });

  /// Whether the card it belongs to is already open.
  final bool open;

  /// Null greys the pill out.
  final VoidCallback? onTap;

  bool get _enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    // The design ships two chevrons rather than one rotated: it points left
    // while the card is shut and down once it is open.
    final chevron = open
        ? 'assets/icons/chevron_down.svg'
        : 'assets/icons/chevron_left.svg';
    final ink = _enabled
        ? AppColors.neutralText100
        : AppColors.surface.withValues(alpha: 0.5);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: open ? 'Hide this lawn' : 'View this lawn',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: AppSizes.viewButtonHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: _enabled ? AppColors.olive600 : null,
            gradient: _enabled ? null : AppColors.disabledFill,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            boxShadow: _enabled ? AppShadows.button : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View', style: AppTypography.bodySmall.copyWith(color: ink)),
              const SizedBox(width: AppSpacing.xxs),
              SvgPicture.asset(
                chevron,
                width: AppSizes.icon,
                height: AppSizes.icon,
                colorFilter: ColorFilter.mode(ink, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
