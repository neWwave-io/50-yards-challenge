import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// Shows the design's "Set Date" calendar and resolves to the chosen day, or
/// null if it was dismissed.
Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) => AppDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

/// The calendar card itself. Exposed so it can be laid out in a preview or a
/// test without a dialog route.
class AppDatePickerDialog extends StatefulWidget {
  const AppDatePickerDialog({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  static const _cardWidth = 330.0;
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];

  late DateTime _visibleMonth;
  DateTime? _selected;
  bool _pickingYear = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    final anchor = widget.initialDate ?? DateTime.now();
    _visibleMonth = DateTime(anchor.year, anchor.month);
  }

  bool get _canGoBack =>
      _visibleMonth.isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));

  bool get _canGoForward =>
      _visibleMonth.isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));

  void _shiftMonth(int delta) => setState(
        () => _visibleMonth =
            DateTime(_visibleMonth.year, _visibleMonth.month + delta),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: Container(
        width: _cardWidth,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.dialog),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 15),
            _selectionRow(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _pickingYear ? _yearGrid() : _monthGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Set Date', style: AppTypography.calendarTitle),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: SvgPicture.asset(
                'assets/icons/close.svg',
                width: 9.33,
                height: 9.33,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectionRow() {
    return SizedBox(
      height: AppSizes.calendarCell,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _pickingYear = !_pickingYear),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  right: AppSpacing.xxs,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                      style: AppTypography.calendarMonth,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Transform.rotate(
                      angle: _pickingYear ? -1.5707963267948966 : 1.5707963267948966,
                      child: SvgPicture.asset(
                        'assets/icons/chevron_right.svg',
                        width: AppSizes.icon,
                        height: AppSizes.icon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavButton(
                  pointsLeft: true,
                  enabled: !_pickingYear && _canGoBack,
                  onTap: () => _shiftMonth(-1),
                ),
                const SizedBox(width: AppSpacing.md),
                _NavButton(
                  pointsLeft: false,
                  enabled: !_pickingYear && _canGoForward,
                  onTap: () => _shiftMonth(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthGrid() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month);
    // DateTime.weekday is Mon=1..Sun=7; the grid starts on Sunday.
    final leadingBlanks = firstOfMonth.weekday % 7;
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final cellCount = ((leadingBlanks + daysInMonth) / 7).ceil() * 7;
    final today = DateUtils.dateOnly(DateTime.now());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final d in _weekdays)
              SizedBox(
                width: AppSizes.calendarCell,
                height: AppSizes.calendarCell,
                child: Center(
                  child: Text(d, style: AppTypography.calendarDay),
                ),
              ),
          ],
        ),
        for (var week = 0; week * 7 < cellCount; week++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var slot = 0; slot < 7; slot++)
                _cell(week * 7 + slot, leadingBlanks, daysInMonth, today),
            ],
          ),
      ],
    );
  }

  Widget _cell(int index, int leadingBlanks, int daysInMonth, DateTime today) {
    final day = index - leadingBlanks + 1;
    if (day < 1 || day > daysInMonth) {
      return const SizedBox.square(dimension: AppSizes.calendarCell);
    }

    final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
    final outOfRange = date.isBefore(DateUtils.dateOnly(widget.firstDate)) ||
        date.isAfter(DateUtils.dateOnly(widget.lastDate));

    return _DayCell(
      day: day,
      selected: _selected != null && DateUtils.isSameDay(_selected, date),
      isToday: DateUtils.isSameDay(today, date),
      enabled: !outOfRange,
      onTap: () {
        setState(() => _selected = date);
        Navigator.of(context).pop(date);
      },
    );
  }

  Widget _yearGrid() {
    final years = [
      for (var y = widget.lastDate.year; y >= widget.firstDate.year; y--) y,
    ];

    return SizedBox(
      width: AppSizes.calendarCell * 7,
      height: AppSizes.calendarCell * 6,
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        children: [
          for (final year in years)
            _YearCell(
              year: year,
              selected: year == _visibleMonth.year,
              onTap: () => setState(() {
                _visibleMonth = DateTime(year, _visibleMonth.month);
                _pickingYear = false;
              }),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.pointsLeft,
    required this.enabled,
    required this.onTap,
  });

  final bool pointsLeft;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xxs),
          decoration: BoxDecoration(
            color: AppColors.olive500,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            boxShadow: const [
              BoxShadow(
                color: Color(0x333A4A1D),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: pointsLeft ? 3.141592653589793 : 0,
            child: SvgPicture.asset(
              'assets/icons/chevron_right_light.svg',
              width: AppSizes.icon,
              height: AppSizes.icon,
            ),
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.enabled,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool isToday;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.calendarCell,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Center(
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.olive500 : null,
              border: isToday && !selected
                  ? Border.all(color: AppColors.olive500)
                  : null,
            ),
            child: Opacity(
              opacity: enabled ? 1 : 0.35,
              child: Text(
                '$day',
                style: AppTypography.calendarDay.copyWith(
                  color: selected
                      ? AppColors.surface
                      : isToday
                          ? AppColors.olive500
                          : AppColors.calendarInk,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _YearCell extends StatelessWidget {
  const _YearCell({
    required this.year,
    required this.selected,
    required this.onTap,
  });

  final int year;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.olive500 : null,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Text(
            '$year',
            style: AppTypography.calendarMonth.copyWith(
              color: selected ? AppColors.surface : AppColors.calendarInk,
            ),
          ),
        ),
      ),
    );
  }
}
