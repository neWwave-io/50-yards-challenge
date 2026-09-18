import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_field_shell.dart';
import '../child.dart';

/// A committed child, shown as a read-only card labelled "Child 1".
///
/// The design has no controls on it; tapping re-opens the entry card, which
/// is where Remove lives.
class ChildSummaryCard extends StatelessWidget {
  const ChildSummaryCard({
    super.key,
    required this.index,
    required this.child,
    required this.onEdit,
  });

  /// One-based.
  final int index;

  final Child child;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final dob = child.dateOfBirth;

    return AppFieldShell(
      label: 'Child $index',
      focused: true,
      height: null,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _Photo(child: child),
          ),
          const SizedBox(height: AppSpacing.xs),
          _SummaryRow(
            left: Text(
              child.summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.summaryValue,
            ),
            right: dob == null
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/cake.svg',
                        width: AppSizes.icon,
                        height: AppSizes.icon,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        formatBirthday(dob),
                        style: AppTypography.summaryValue,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _SummaryRow(
            left: Text('Shirt Size', style: AppTypography.summaryKey),
            right: Text(
              child.shirtSize ?? '',
              style: AppTypography.summaryValue,
            ),
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.child});

  final Child child;

  @override
  Widget build(BuildContext context) {
    final photo = child.photo;

    return Container(
      width: AppSizes.photo,
      height: AppSizes.photo,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      clipBehavior: Clip.antiAlias,
      child: photo == null
          ? SvgPicture.asset(
              'assets/icons/camera.svg',
              width: AppSizes.icon,
              height: AppSizes.icon,
            )
          : Image.memory(
              photo,
              width: AppSizes.photo,
              height: AppSizes.photo,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.left, this.right});

  final Widget left;
  final Widget? right;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.olive50,
          borderRadius: BorderRadius.circular(AppRadii.summaryRow),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Flexible(child: left), if (right != null) right!],
        ),
      );
}
