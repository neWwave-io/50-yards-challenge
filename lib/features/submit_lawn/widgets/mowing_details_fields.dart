import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/app_date_picker_dialog.dart';
import '../../../core/widgets/app_field_shell.dart';
import '../../../core/widgets/app_select_field.dart';
import '../../../core/widgets/app_tap_field.dart';
import '../data/lawn_draft.dart';

/// "Mowing Details": service, date, time spent and a note.
class MowingDetailsFields extends StatelessWidget {
  const MowingDetailsFields({
    super.key,
    required this.draft,
    required this.hours,
    required this.note,
    required this.onService,
    required this.onDate,
    required this.onHours,
    required this.onNote,
  });

  final LawnDraft draft;

  /// Owned by the screen so the typed text survives moving between steps.
  final TextEditingController hours;
  final TextEditingController note;

  final ValueChanged<String> onService;
  final ValueChanged<DateTime> onDate;
  final ValueChanged<String> onHours;
  final ValueChanged<String> onNote;

  Future<void> _pickDate(BuildContext context) async {
    final today = DateTime.now();
    final picked = await showAppDatePicker(
      context,
      initialDate: draft.mowedOn,
      // Late submissions are fine; a whole season late is a typo.
      firstDate: DateTime(today.year - 1, today.month, today.day),
      lastDate: today,
      title: 'Date mowed',
    );
    if (picked != null) onDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelectField(
          label: 'Service',
          options: kLawnServices,
          value: draft.service,
          onChanged: onService,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: AppTapField(
                label: 'Date',
                value: dayMonthYear(draft.mowedOn),
                onTap: () => _pickDate(context),
                trailing: const _Icon('assets/icons/calendar.svg'),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: _HoursField(controller: hours, onChanged: onHours)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _NoteField(controller: note, onChanged: onNote),
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        asset,
        width: AppSizes.icon,
        height: AppSizes.icon,
      );
}

/// A text field in the shared field shell, with its focus tracked so the
/// label rises the way the other fields' do.
class _ShellTextField extends StatefulWidget {
  const _ShellTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.trailing,
    this.height = AppSizes.fieldHeight,
    this.multiline = false,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Widget? trailing;
  final double height;
  final bool multiline;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_ShellTextField> createState() => _ShellTextFieldState();
}

class _ShellTextFieldState extends State<_ShellTextField> {
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
    final field = TextField(
      controller: widget.controller,
      focusNode: _focus,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.multiline ? null : 1,
      expands: widget.multiline,
      textAlignVertical: widget.multiline ? TextAlignVertical.top : null,
      textCapitalization: widget.multiline
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      cursorColor: AppColors.olive600,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: widget.label,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
      ),
    );

    return AppFieldShell(
      label: widget.label,
      focused: _focus.hasFocus,
      filled: widget.controller.text.isNotEmpty,
      height: widget.height,
      padding: widget.multiline
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            )
          : const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: widget.multiline
          ? field
          : Row(
              children: [
                Expanded(child: field),
                if (widget.trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  widget.trailing!,
                ],
              ],
            ),
    );
  }
}

class _HoursField extends StatelessWidget {
  const _HoursField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => _ShellTextField(
        label: 'Time Spent',
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        // Digits and one decimal point, at most two places: "1.25".
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,2})?')),
        ],
        trailing: const _Icon('assets/icons/clock.svg'),
      );
}

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => _ShellTextField(
        label: 'Note',
        controller: controller,
        onChanged: onChanged,
        height: AppSizes.noteHeight,
        multiline: true,
        keyboardType: TextInputType.multiline,
      );
}
