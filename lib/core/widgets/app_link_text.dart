import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A line of body text ending in one tappable, underlined phrase — the
/// "Already have an account? Sign In here" pattern the auth screens share.
class AppLinkText extends StatefulWidget {
  const AppLinkText({
    super.key,
    required this.text,
    required this.linkText,
    this.onTap,
  });

  /// The plain part. A trailing space is added before [linkText].
  final String text;

  final String linkText;
  final VoidCallback? onTap;

  @override
  State<AppLinkText> createState() => _AppLinkTextState();
}

class _AppLinkTextState extends State<AppLinkText> {
  late final TapGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = TapGestureRecognizer()..onTap = () => widget.onTap?.call();
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTypography.bodySmall,
        children: [
          TextSpan(text: '${widget.text} '),
          TextSpan(
            text: widget.linkText,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.olive700,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.olive700,
            ),
            recognizer: _recognizer,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
