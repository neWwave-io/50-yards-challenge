import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// The white pop-up an [AppSelectField] opens: an optional search row on top
/// of a divided list of options.
class AppDropdownPanel extends StatelessWidget {
  const AppDropdownPanel({
    super.key,
    required this.options,
    required this.selected,
    required this.searchable,
    required this.query,
    required this.maxHeight,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final bool searchable;
  final ValueNotifier<String> query;
  final double maxHeight;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.olive100),
          borderRadius: BorderRadius.circular(AppRadii.dropdown),
          boxShadow: AppShadows.dropdown,
        ),
        clipBehavior: Clip.antiAlias,
        child: ValueListenableBuilder<String>(
          valueListenable: query,
          builder: (context, text, _) {
            final needle = text.trim().toLowerCase();
            final matches = needle.isEmpty
                ? options
                : options
                    .where((o) => o.toLowerCase().contains(needle))
                    .toList(growable: false);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (searchable) _SearchRow(query: query),
                Flexible(
                  child: matches.isEmpty
                      ? const _EmptyRow()
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: matches.length,
                          separatorBuilder: (_, __) => const _PanelDivider(),
                          itemBuilder: (_, i) => _OptionRow(
                            label: matches[i],
                            selected: matches[i] == selected,
                            onTap: () => onSelected(matches[i]),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchRow extends StatefulWidget {
  const _SearchRow({required this.query});

  final ValueNotifier<String> query;

  @override
  State<_SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<_SearchRow> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.query.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: AppSizes.fieldHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    cursorColor: AppColors.olive600,
                    style: AppTypography.bodyMedium,
                    onChanged: (value) => widget.query.value = value,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
                const AppChevronDown(),
              ],
            ),
          ),
        ),
        const _PanelDivider(),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: selected ? AppColors.olive600 : AppColors.olive900,
          ),
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Text(
          'No matches',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      );
}

class _PanelDivider extends StatelessWidget {
  const _PanelDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: AppColors.olive100);
}

/// The chevron the design puts on the right of every select field and on the
/// panel's search row.
class AppChevronDown extends StatelessWidget {
  const AppChevronDown({super.key});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        'assets/icons/chevron_down.svg',
        width: AppSizes.icon,
        height: AppSizes.icon,
      );
}
