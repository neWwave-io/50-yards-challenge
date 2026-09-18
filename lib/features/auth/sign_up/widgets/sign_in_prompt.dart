import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// "Already have an account? Sign In here"
class SignInPrompt extends StatefulWidget {
  const SignInPrompt({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<SignInPrompt> createState() => _SignInPromptState();
}

class _SignInPromptState extends State<SignInPrompt> {
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
          const TextSpan(text: 'Already have an account? '),
          TextSpan(
            text: 'Sign In here',
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
