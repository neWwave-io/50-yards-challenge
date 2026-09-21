import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The white, deeply rounded card the home page is built from.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.raised = false,
    this.gradient,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsets padding;

  /// The challenge card sits over the header and casts a deeper shadow.
  final bool raised;

  /// Replaces the plain white ground, as on the passport card.
  final Gradient? gradient;

  /// Clips decoration that bleeds past the corners.
  final bool clip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadii.dialog),
        boxShadow: raised ? AppShadows.cardRaised : AppShadows.card,
      ),
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: child,
    );
  }
}
