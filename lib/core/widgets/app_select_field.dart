import 'package:flutter/material.dart';


import '../theme/app_theme.dart';
import 'app_dropdown_panel.dart';
import 'app_field_shell.dart';

/// A field that opens a dropdown panel instead of a keyboard.
///
/// Tapping it replaces the field, in place, with a white panel listing the
/// options — that panel is the design's dropdown pop-up. When [searchable] is
/// set the panel's first row is a search box, so long lists (states) stay
/// usable.
class AppSelectField extends StatefulWidget {
  const AppSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.searchable = false,
    this.enabled = true,
    this.placeholder,
  });

  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;

  /// Adds the search row to the top of the panel.
  final bool searchable;

  final bool enabled;

  /// Shown instead of [label] while nothing is chosen. Use it to say why a
  /// disabled field is disabled.
  final String? placeholder;

  @override
  State<AppSelectField> createState() => _AppSelectFieldState();
}

class _AppSelectFieldState extends State<AppSelectField> {
  static const _panelMaxHeight = 264.0;
  static const _panelMinHeight = 140.0;

  final _link = LayerLink();
  final _query = ValueNotifier<String>('');
  OverlayEntry? _panel;

  bool get _isOpen => _panel != null;

  @override
  void dispose() {
    _removePanel();
    _query.dispose();
    super.dispose();
  }

  void _removePanel() {
    _panel?.remove();
    _panel = null;
  }

  void _close() {
    if (!_isOpen) return;
    _removePanel();
    if (mounted) setState(() {});
  }

  void _open() {
    if (_isOpen || !widget.enabled || widget.options.isEmpty) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    _query.value = '';
    final width = box.size.width;
    final fieldTop = box.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    // Prefer dropping the panel over the field; flip it upwards when that
    // would run past the bottom of the viewport.
    final roomBelow = screenHeight - bottomInset - fieldTop - AppSpacing.lg;
    final flipUp = roomBelow < _panelMinHeight;
    final maxHeight = flipUp
        ? _panelMaxHeight
        : roomBelow.clamp(AppSizes.fieldHeight, _panelMaxHeight);

    _panel = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: const SizedBox.shrink(),
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: flipUp ? Alignment.bottomLeft : Alignment.topLeft,
            followerAnchor: flipUp ? Alignment.bottomLeft : Alignment.topLeft,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: AppDropdownPanel(
                  options: widget.options,
                  selected: widget.value,
                  searchable: widget.searchable,
                  query: _query,
                  maxHeight: maxHeight,
                  onSelected: (option) {
                    _close();
                    widget.onChanged(option);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_panel!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final hasValue = value != null && value.isNotEmpty;

    return CompositedTransformTarget(
      link: _link,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        // The open panel sits on top of the field, so hide the field while it
        // is open but keep its box in the layout.
        child: Visibility(
          visible: !_isOpen,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: AppFieldShell(
            label: widget.label,
            filled: hasValue,
            onTap: _open,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value : (widget.placeholder ?? widget.label),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: hasValue
                        ? AppTypography.bodyMedium
                        : AppTypography.bodyMedium
                            .copyWith(color: AppColors.textMuted),
                  ),
                ),
                const AppChevronDown(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
