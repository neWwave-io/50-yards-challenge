import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_link_text.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_scroll_page.dart';
import '../../../core/widgets/app_text_field.dart';
import 'sign_in_controller.dart';

/// Sign-in. The screen owns no auth logic — [onSignIn] and [onForgotPassword]
/// are supplied by the router, which is where the auth manager lives.
class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.onSignIn,
    this.onForgotPassword,
    this.onCreateAccount,
  });

  static const routeName = 'Signin';
  static const routePath = '/signin';

  /// Returns an error message to show, or null when the sign-in succeeded and
  /// navigation has already happened.
  final Future<String?> Function(String email, String password) onSignIn;

  final Future<void> Function(String email)? onForgotPassword;
  final VoidCallback? onCreateAccount;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _controller = SignInController();
  var _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final error = await widget.onSignIn(
        _controller.email.text.trim(),
        _controller.password.text,
      );
      if (error != null) _showMessage(error);
    } catch (_) {
      _showMessage('Something went wrong. Please check your connection and '
          'try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _controller.email.text.trim();
    // Supabase sends the reset link to an address, so there is nothing to do
    // until we have one.
    if (email.isEmpty) {
      _showMessage('Enter your email first, then tap Forgot Password?');
      return;
    }
    await widget.onForgotPassword?.call(email);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.olive50,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => AppScrollPage(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.huge,
                AppSpacing.xl,
                72,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  const SizedBox(height: AppSpacing.xxxl),
                  _fields(),
                ],
              ),
              footer: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppPrimaryButton(
                    label: 'Sign In',
                    busy: _submitting,
                    onPressed:
                        _controller.isComplete && !_submitting ? _submit : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppLinkText(
                    text: "Don't have an account yet?",
                    linkText: 'Create Account',
                    onTap: widget.onCreateAccount,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Having trouble logging in?',
                    textAlign: TextAlign.center,
                    style: AppTypography.footnote,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          'Sign In',
          textAlign: TextAlign.center,
          style: AppTypography.displayLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Welcome back! Please enter your details.',
          textAlign: TextAlign.center,
          style: AppTypography.subtitle,
        ),
      ],
    );
  }

  Widget _fields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Email or Username',
          controller: _controller.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Password',
          controller: _controller.password,
          obscurable: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) {
            if (_controller.isComplete && !_submitting) _submit();
          },
        ),
        const SizedBox(height: AppSpacing.xxs),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _forgotPassword,
            child: Text(
              'Forgot Password?',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.olive700),
            ),
          ),
        ),
      ],
    );
  }
}
