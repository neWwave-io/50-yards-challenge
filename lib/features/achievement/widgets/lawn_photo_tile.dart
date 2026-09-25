import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_field_shell.dart';

/// One proof photo, in the same notched box the submit form uses for its
/// slots — the design draws both with the "Customer/textfield" component.
///
/// A step the child never filled in, or one that did not exist when they
/// submitted, keeps its place and shows an empty box. Reshuffling the grid
/// would put "Child In Action" under the wrong caption.
class LawnPhotoTile extends StatelessWidget {
  const LawnPhotoTile({
    super.key,
    required this.label,
    required this.url,
    this.height = AppSizes.lawnPhotoHeight,
  });

  final String label;

  /// Null leaves the box empty.
  final String? url;

  final double height;

  /// The picture sits a hair inside the 16px border, as in the design.
  static const _innerRadius = AppRadii.field - 1;

  @override
  Widget build(BuildContext context) {
    final url = this.url;

    return AppFieldShell(
      label: label,
      // Always on: the caption is what names the step.
      filled: true,
      height: height,
      padding: EdgeInsets.zero,
      background: AppColors.olive50,
      borderColor: AppColors.photoBorder,
      shadow: AppShadows.fieldFocused,
      labelStyle: AppTypography.photoLabel,
      child: url == null
          ? const SizedBox.expand()
          : ClipRRect(
              borderRadius: BorderRadius.circular(_innerRadius),
              child: Image.network(
                url,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                // A photo that will not load should leave the box empty
                // rather than drop a broken-image glyph into the grid.
                errorBuilder: (context, _, __) => const SizedBox.expand(),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : const SizedBox.expand(),
              ),
            ),
    );
  }
}
