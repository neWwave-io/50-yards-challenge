import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_scroll_page.dart';
import 'data/lawn_draft.dart';
import 'data/submit_lawn_repository.dart';
import 'submit_lawn_controller.dart';
import 'widgets/lawn_logged_view.dart';
import 'widgets/mowing_details_fields.dart';
import 'widgets/photo_slot.dart';
import 'widgets/safety_answer.dart';
import 'widgets/who_for_grid.dart';

/// Submitting a lawn: details, before/after photos, action photos and the
/// safety check, then the "lawn logged" screen.
///
/// Back walks the steps; on the first one, and on the logged screen, it
/// leaves via [onClose].
class SubmitLawnScreen extends StatefulWidget {
  const SubmitLawnScreen({
    super.key,
    this.repository = const SubmitLawnRepository(),
    this.onClose,
  });

  // Kept from v1 so the tab bar and Home's links still land here.
  static const routeName = 'SubmitLawn';
  static const routePath = '/submitLawn';

  final SubmitLawnRepository repository;
  final VoidCallback? onClose;

  @override
  State<SubmitLawnScreen> createState() => _SubmitLawnScreenState();
}

class _SubmitLawnScreenState extends State<SubmitLawnScreen> {
  late final _controller = SubmitLawnController(repository: widget.repository);
  final _hours = TextEditingController();
  final _note = TextEditingController();

  static const _titles = {
    SubmitStep.details: 'My Lawn',
    SubmitStep.lawnPhotos: 'Lawn\nDifferences',
    SubmitStep.actionPhotos: 'My Action',
    SubmitStep.safety: 'Safety Check',
  };

  /// The design's main button is a fixed pill, not full width.
  static const _buttonWidth = 182.0;

  @override
  void dispose() {
    _controller.dispose();
    _hours.dispose();
    _note.dispose();
    super.dispose();
  }

  void _close() => widget.onClose != null
      ? widget.onClose!()
      : Navigator.of(context).maybePop();

  void _back() {
    FocusScope.of(context).unfocus();
    if (!_controller.back()) _close();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!_controller.isLastStep) return _controller.next();

    final problem = await _controller.submit();
    if (problem != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(problem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final result = _controller.result;
        return PopScope(
          // The system back gesture steps back through the form too.
          canPop: result != null || _controller.step == SubmitStep.details,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _controller.back();
          },
          child: Scaffold(
            backgroundColor: AppColors.olive50,
            body: result != null
                ? LawnLoggedView(result: result, onDone: _close)
                : _form(context),
          ),
        );
      },
    );
  }

  Widget _form(BuildContext context) {
    final c = _controller;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBackButton(onTap: _back),
            Expanded(
              child: AppScrollPage(
                // SafeArea already clears the home indicator; the design
                // leaves only a sliver more under the button.
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.sm,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Title(step: c.step, text: _titles[c.step]!),
                    const SizedBox(height: AppSpacing.xxl),
                    ..._step(c),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
                footer: Center(
                  child: SizedBox(
                    width: _buttonWidth,
                    child: AppPrimaryButton(
                      label: c.isLastStep ? 'Submit' : 'Start Mowing',
                      large: true,
                      trailingIcon: c.isLastStep
                          ? null
                          : 'assets/icons/home_arrow_right.svg',
                      busy: c.submitting,
                      onPressed: c.canContinue ? _continue : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _step(SubmitLawnController c) {
    final draft = c.draft;
    PhotoSlot slot(String label, LawnPhoto photo) => PhotoSlot(
          label: label,
          photo: draft.photos[photo],
          onPicked: (bytes) => c.setPhoto(photo, bytes),
        );
    const gap = SizedBox(height: AppSpacing.xxl);

    return switch (c.step) {
      SubmitStep.details => [
          Text('Who is this lawn for?', style: AppTypography.prompt),
          const SizedBox(height: AppSpacing.md),
          WhoForGrid(selected: draft.whoFor, onSelect: c.chooseWhoFor),
          gap,
          Text('Mowing Details', style: AppTypography.prompt),
          const SizedBox(height: AppSpacing.md),
          MowingDetailsFields(
            draft: draft,
            hours: _hours,
            note: _note,
            onService: c.chooseService,
            onDate: c.chooseDate,
            onHours: c.setHours,
            onNote: c.setNote,
          ),
        ],
      SubmitStep.lawnPhotos => [
          slot('Lawn before photo', LawnPhoto.before),
          gap,
          slot('Lawn after photo', LawnPhoto.after),
        ],
      SubmitStep.actionPhotos => [
          slot('Child in action', LawnPhoto.action),
          gap,
          slot('Child with owner', LawnPhoto.homeowner),
        ],
      SubmitStep.safety => [
          Text(
            'Did your child wear any safety gear while completing this '
            'lawn?',
            style: AppTypography.prompt,
          ),
          Text(
            '(Safety glasses, hearing protection, and closed-toe shoes)',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          SafetyAnswer(
            value: draft.woreSafetyGear,
            onChanged: (wore) => c.answerSafety(woreGear: wore),
          ),
          gap,
          slot('Take picture of your kid.', LawnPhoto.safety),
        ],
    };
  }
}

/// A step's title. The photo steps set it in an 80pt band, so their content
/// starts at the same height whether the title takes one line or two.
class _Title extends StatelessWidget {
  const _Title({required this.step, required this.text});

  final SubmitStep step;
  final String text;

  static const _band = 80.0;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      text,
      textAlign: TextAlign.center,
      // Two-line titles sit tight, as the design sets them.
      style: step == SubmitStep.lawnPhotos
          ? AppTypography.stepTitle.copyWith(height: 0.9)
          : AppTypography.stepTitle,
    );
    if (step == SubmitStep.details) return title;
    return SizedBox(height: _band, child: Center(child: title));
  }
}
