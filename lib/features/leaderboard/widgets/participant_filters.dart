import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/us_states.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_field_shell.dart';
import '../../../core/widgets/app_select_field.dart';

/// The search box and the state dropdown above the participants list.
class ParticipantFilters extends StatelessWidget {
  const ParticipantFilters({
    super.key,
    required this.search,
    required this.state,
    required this.onSearch,
    required this.onState,
  });

  final TextEditingController search;

  /// Null means every state.
  final String? state;
  final ValueChanged<String> onSearch;
  final ValueChanged<String?> onState;

  static const _allStates = 'All states';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchField(controller: search, onChanged: onSearch),
        const SizedBox(height: AppSpacing.sm),
        AppSelectField(
          label: 'State',
          options: const [_allStates, ...kUsStates],
          value: state,
          searchable: true,
          onChanged: (v) => onState(v == _allStates ? null : v),
        ),
      ],
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_rebuild);
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    _focus.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return AppFieldShell(
      label: 'Search',
      focused: focused,
      filled: widget.controller.text.isNotEmpty,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              cursorColor: AppColors.olive600,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                // Once the label has risen into the notch, say what to type.
                hintText: focused ? 'Name…' : 'Search',
                hintStyle: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SvgPicture.asset(
            'assets/icons/search.svg',
            width: AppSizes.icon,
            height: AppSizes.icon,
          ),
        ],
      ),
    );
  }
}
