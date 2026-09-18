import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_step_progress.dart';
import 'child.dart';
import 'data/sign_up_draft.dart';
import 'data/sign_up_repository.dart';
import 'widgets/add_child_card.dart';
import 'widgets/child_name_field.dart';
import 'widgets/child_summary_card.dart';

/// Step 2 of 2: who is doing the mowing. Submitting creates the account from
/// [account] plus the children entered here.
class SignUpChildrenScreen extends StatefulWidget {
  const SignUpChildrenScreen({
    super.key,
    required this.account,
    this.repository = const SignUpRepository(),
    this.onBack,
    this.onCompleted,
  });

  static const routeName = 'SignUpChildren';
  static const routePath = '/signUp/children';

  final SignUpDraft account;
  final SignUpRepository repository;
  final VoidCallback? onBack;

  /// Where to go once the account exists.
  final VoidCallback? onCompleted;

  @override
  State<SignUpChildrenScreen> createState() => _SignUpChildrenScreenState();
}

class _SignUpChildrenScreenState extends State<SignUpChildrenScreen> {
  final _children = <Child>[];

  /// The one child currently being edited, if any. Only one card is open at a
  /// time, which keeps the page short enough to fill in on a phone.
  String? _editingId;

  var _nextId = 0;
  var _submitting = false;

  bool get _canSubmit =>
      _children.isNotEmpty &&
      _editingId == null &&
      !_submitting &&
      _children.every((c) => c.isComplete);

  void _add(String name) {
    setState(() {
      final child = Child(id: 'child-${_nextId++}', name: name);
      _children.add(child);
      _editingId = child.id;
    });
  }

  void _update(Child child) {
    final i = _children.indexWhere((c) => c.id == child.id);
    if (i == -1) return;
    setState(() => _children[i] = child);
  }

  void _remove(String id) => setState(() {
        _children.removeWhere((c) => c.id == id);
        if (_editingId == id) _editingId = null;
      });

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.repository.signUp(
        account: widget.account,
        children: List.unmodifiable(_children),
      );
      if (mounted) widget.onCompleted?.call();
    } on SignUpFailure catch (e) {
      _showError(e.message);
    } catch (_) {
      // A dropped connection or anything else unforeseen: the button must
      // come back rather than sit there spinning.
      _showError('Something went wrong. Please check your connection and '
          'try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBackButton(
                onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: LayoutBuilder(
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
                            const AppStepProgress(step: 2, totalSteps: 2),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: AppTypography.displayLarge,
                            ),
                            const SizedBox(height: AppSpacing.xxxl),
                            Text(
                              'Child(ren) Information',
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ..._cards(),
                            const SizedBox(height: AppSpacing.xxl),
                            const Expanded(child: SizedBox.shrink()),
                            AppPrimaryButton(
                              label: 'Sign up',
                              busy: _submitting,
                              onPressed: _canSubmit ? _submit : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _cards() {
    final widgets = <Widget>[ChildNameField(onAdd: _add)];

    for (var i = 0; i < _children.length; i++) {
      final child = _children[i];
      widgets
        ..add(const SizedBox(height: AppSpacing.md))
        ..add(
          child.id == _editingId
              ? AddChildCard(
                  key: ValueKey(child.id),
                  index: i + 1,
                  child: child,
                  onChanged: _update,
                  onRemove: () => _remove(child.id),
                  onDone: () => setState(() => _editingId = null),
                )
              : ChildSummaryCard(
                  key: ValueKey(child.id),
                  index: i + 1,
                  child: child,
                  onEdit: () => setState(() => _editingId = child.id),
                ),
        );
    }

    return widgets;
  }
}
