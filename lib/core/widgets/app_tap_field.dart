import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_field_shell.dart';

/// A read-only field that hands off to something else on tap — the date
/// picker, a photo sheet. It shares the look of [AppTextField] but never
/// takes keyboard input.
class AppTapField extends StatelessWidget {
  const AppTapField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  final String label;

  /// Null or empty shows [label] as the placeholder.
  final String? value;

  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;

    return AppFieldShell(
      label: label,
      filled: filled,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              filled ? value! : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: filled
                  ? AppTypography.bodyMedium
                  : AppTypography.bodyMedium
                      .copyWith(color: AppColors.textMuted),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
