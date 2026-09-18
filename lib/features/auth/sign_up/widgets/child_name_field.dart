import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_field_shell.dart';

/// "Child Name  +" — type a name, tap the plus, and a new entry card opens
/// with that name already filled in. An empty name opens a blank card.
class ChildNameField extends StatefulWidget {
  const ChildNameField({super.key, required this.onAdd});

  final ValueChanged<String> onAdd;

  @override
  State<ChildNameField> createState() => _ChildNameFieldState();
}

class _ChildNameFieldState extends State<ChildNameField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _focusNode.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _focusNode.removeListener(_rebuild);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _add() {
    widget.onAdd(_controller.text.trim());
    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AppFieldShell(
      label: 'Child Name',
      focused: _focusNode.hasFocus,
      filled: _controller.text.isNotEmpty,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              cursorColor: AppColors.olive600,
              style: AppTypography.bodyMedium,
              onSubmitted: (_) => _add(),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Child Name',
                hintStyle: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Add child',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _add,
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: SvgPicture.asset(
                  'assets/icons/plus.svg',
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
