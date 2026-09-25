import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../badges_controller.dart';

/// The Earned / Locked switch above the grid.
class BadgeTabToggle extends StatelessWidget {
  const BadgeTabToggle({super.key, required this.selected, required this.onSelect});

  final BadgeTab selected;
  final ValueChanged<BadgeTab> onSelect;

  static const _height = 38.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: AppShadows.glassCard,
      ),
      child: Row(
        children: [
          for (final tab in BadgeTab.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: tab == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelect(tab),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tab == selected ? AppColors.olive500 : null,
                      borderRadius: BorderRadius.circular(AppRadii.segment),
                      boxShadow: tab == selected ? AppShadows.segment : null,
                    ),
                    child: Text(
                      tab == BadgeTab.earned ? 'Earned' : 'Locked',
                      style: tab == selected
                          ? AppTypography.segmentActive
                          : AppTypography.segmentIdle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
