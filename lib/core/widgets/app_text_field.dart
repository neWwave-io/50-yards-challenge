import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import 'app_field_shell.dart';

/// Single-line text input. The [label] doubles as the placeholder while the
/// field is empty and idle, and rises into the notch once it is active.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.obscurable = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;

  /// Masks the value and shows the eye toggle.
  final bool obscurable;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _ownsFocusNode = false;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _obscured = widget.obscurable;
    _focusNode.addListener(_onStateChanged);
    widget.controller.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onStateChanged);
    widget.controller.removeListener(_onStateChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppFieldShell(
      label: widget.label,
      focused: _focusNode.hasFocus,
      filled: widget.controller.text.isNotEmpty,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscurable && _obscured,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              autofillHints: widget.autofillHints,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              cursorColor: AppColors.olive600,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.label,
                hintStyle:
                    AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
          if (widget.obscurable)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _obscured = !_obscured),
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: Opacity(
                  opacity: _obscured ? 1 : 0.5,
                  child: SvgPicture.asset(
                    'assets/icons/eye.svg',
                    width: AppSizes.icon,
                    height: AppSizes.icon,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
