import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The Safety Check's Yes / No pair.
///
/// Both answers are always coloured — green for Yes, red for No — and the
/// chosen one fills in.
class SafetyAnswer extends StatelessWidget {
  const SafetyAnswer({super.key, required this.value, required this.onChanged});

  /// Null until answered.
  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Answer(
            label: 'Yes',
            selected: value == true,
            ink: AppColors.freshCut,
            border: AppColors.olive500.withValues(alpha: 0.5),
            idleFill: AppColors.surface,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _Answer(
            label: 'No',
            selected: value == false,
            ink: AppColors.red500,
            border: AppColors.red500.withValues(alpha: 0.5),
            idleFill: AppColors.redTint,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _Answer extends StatelessWidget {
  const _Answer({
    required this.label,
    required this.selected,
    required this.ink,
    required this.border,
    required this.idleFill,
    required this.onTap,
  });

  final String label;
  final bool selected;

  /// The fill once chosen, and the text colour until then.
  final Color ink;
  final Color border;
  final Color idleFill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: AppSizes.answerHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? ink : idleFill,
            border: Border.all(color: border, width: 2),
            borderRadius: BorderRadius.circular(AppRadii.field),
            boxShadow: AppShadows.answer,
          ),
          child: Text(
            label,
            style: AppTypography.answerLabel.copyWith(
              color: selected ? AppColors.surface : ink,
            ),
          ),
        ),
      ),
    );
  }
}
