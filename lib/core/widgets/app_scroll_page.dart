import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A form page: [body] at the top, [footer] (the main button and its small
/// print) at the bottom.
///
/// On a tall screen the footer sits at the bottom edge; once the body grows
/// past the screen, the whole page scrolls and the footer follows the body.
///
/// This deliberately avoids `IntrinsicHeight`. That asks every child to
/// predict its height before layout, and a prediction that comes in short —
/// text measured before its web font arrives, for one — overflows the page.
/// Here the column is laid out at its real size and only ever stretched, so
/// it cannot come up short.
class AppScrollPage extends StatelessWidget {
  const AppScrollPage({
    super.key,
    required this.padding,
    required this.body,
    required this.footer,
  });

  final EdgeInsets padding;
  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: math.max(0, constraints.maxHeight - padding.vertical),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              body,
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxl),
                child: footer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
