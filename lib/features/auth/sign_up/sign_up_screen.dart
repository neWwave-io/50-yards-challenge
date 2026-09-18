import 'package:flutter/material.dart';

import '../../../core/constants/us_cities.dart';
import '../../../core/constants/us_states.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_select_field.dart';
import '../../../core/widgets/app_step_progress.dart';
import '../../../core/widgets/app_text_field.dart';
import 'sign_up_children_screen.dart';
import 'sign_up_controller.dart';
import 'widgets/password_strength_meter.dart';
import 'widgets/sign_in_prompt.dart';

/// Step 1 of 2: the account and where the family is.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.onNext, this.onSignIn});

  static const routeName = 'SignUp2';
  static const routePath = '/signUpV2';

  /// Overrides the default push to [SignUpChildrenScreen].
  final VoidCallback? onNext;
  final VoidCallback? onSignIn;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _controller = SignUpStepOneController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    final onNext = widget.onNext;
    if (onNext != null) {
      onNext();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SignUpChildrenScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.olive50,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xxl,
                  AppSpacing.xl,
                  AppSpacing.huge,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight -
                        AppSpacing.xxl -
                        AppSpacing.huge,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Form(controller: _controller),
                        // Keeps a gap when the form is taller than the
                        // viewport, and pins the button to the bottom when it
                        // is not.
                        const SizedBox(height: AppSpacing.xxl),
                        const Expanded(child: SizedBox.shrink()),
                        AppPrimaryButton(
                          label: 'Next',
                          onPressed: _controller.isComplete ? _next : null,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        SignInPrompt(onTap: widget.onSignIn),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.controller});

  final SignUpStepOneController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppStepProgress(step: 1, totalSteps: 2),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style: AppTypography.displayLarge,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        Text('Personal Information', style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Full Name',
          controller: controller.fullName,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Email',
          controller: controller.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Password',
          controller: controller.password,
          obscurable: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Confirm Password',
          controller: controller.confirmPassword,
          obscurable: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
        ),
        if (controller.password.text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          PasswordStrengthMeter(strength: controller.passwordStrength),
        ],
        const SizedBox(height: AppSpacing.xxxl),
        AppSelectField(
          label: 'Relationship',
          options: kRelationships,
          value: controller.relationship,
          onChanged: (value) => controller.relationship = value,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSelectField(
          label: 'City',
          options: kUsCities,
          value: controller.city,
          searchable: true,
          onChanged: (value) => controller.city = value,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSelectField(
          label: 'State',
          options: kUsStates,
          value: controller.state,
          searchable: true,
          onChanged: (value) => controller.state = value,
        ),
      ],
    );
  }
}
