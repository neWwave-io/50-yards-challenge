import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../home/data/home_data.dart' show MowedCategory;

/// "Who is this lawn for?" — six square tiles in two rows of three.
class WhoForGrid extends StatelessWidget {
  const WhoForGrid({super.key, required this.selected, required this.onSelect});

  final MowedCategory? selected;
  final ValueChanged<MowedCategory> onSelect;

  /// The design's order, which is not the enum's.
  static const _rows = [
    [MowedCategory.elderly, MowedCategory.disabled, MowedCategory.activeDuty],
    [
      MowedCategory.singleParent,
      MowedCategory.veteran,
      MowedCategory.firstResponder,
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in _rows) ...[
          if (row != _rows.first) const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                for (final who in row) ...[
                  if (who != row.first) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _Tile(
                      who: who,
                      selected: who == selected,
                      onTap: () => onSelect(who),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.who, required this.selected, required this.onTap});

  final MowedCategory who;
  final bool selected;
  final VoidCallback onTap;

  static const _iconSize = 44.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: who.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(AppSpacing.xxs),
            decoration: BoxDecoration(
              color: selected ? AppColors.olive500 : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.row),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(who.iconPath, width: _iconSize, height: _iconSize),
                Text(
                  who.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: selected
                      ? AppTypography.tileLabel.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w500,
                        )
                      : AppTypography.tileLabel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
