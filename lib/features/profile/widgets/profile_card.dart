import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import 'cropped_image.dart';

/// The white card every profile section sits in.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => AppCard(
        raised: true,
        clip: true,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: child,
      );
}

/// A section's round illustration and heading.
class ProfileCardTitle extends StatelessWidget {
  const ProfileCardTitle({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.gap = AppSpacing.md,
    this.style,
  });

  final CroppedImage icon;
  final String title;
  final Widget? trailing;
  final double gap;
  final TextStyle? style;

  /// The section illustrations are 32px, as in the design.
  static const iconSize = 32.0;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          icon,
          SizedBox(width: gap),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style ?? AppTypography.sectionTitle.copyWith(height: 1.2),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

/// The small round olive button used for "add" and "open".
class ProfileRoundButton extends StatelessWidget {
  const ProfileRoundButton({
    super.key,
    required this.icon,
    required this.size,
    required this.onTap,
    required this.semanticLabel,
  });

  final Widget icon;
  final double size;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: semanticLabel,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.olive600,
              shape: BoxShape.circle,
              boxShadow: AppShadows.button,
            ),
            child: icon,
          ),
        ),
      );
}
