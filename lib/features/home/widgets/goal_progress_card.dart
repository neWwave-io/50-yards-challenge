import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../data/home_data.dart';

/// The week tracker, and the place goals will eventually be set.
///
/// The seven day tiles are real — they come from the lawns submitted this
/// week. Goals themselves have no backing table yet, so the card shows the
/// design's own empty state and [onAddGoal] is left unwired.
class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({super.key, required this.week, this.onAddGoal});

  final MowingWeek week;
  final VoidCallback? onAddGoal;

  static const _labels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Goal Progress', style: AppTypography.cardTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'No Active goals yet? start setting new goals here',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.neutral700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _AddButton(onTap: onAddGoal),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _GoalChips(),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('THIS WEEK', style: AppTypography.overline),
              Text(
                '${week.mowedCount} / ${MowingWeek.length} days',
                style: AppTypography.overlineValue,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (var i = 0; i < MowingWeek.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _DayTile(label: _labels[i], state: week.days[i]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: AppColors.brandFill,
              borderRadius: BorderRadius.circular(AppRadii.summaryRow),
              boxShadow: AppShadows.button,
            ),
            child: SvgPicture.asset(
              'assets/icons/home_plus.svg',
              width: AppSizes.icon,
              height: AppSizes.icon,
            ),
          ),
        ),
      );
}

/// The shape a goal will take once goals exist: how many, how often.
class _GoalChips extends StatelessWidget {
  const _GoalChips();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.olive500),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '12 Lawns',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.neutral800),
              ),
            ),
            Container(width: 1, height: 26, color: AppColors.borderDefault),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xxl,
                right: AppSpacing.md,
              ),
              child: Text(
                'Monthly',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.neutral800),
              ),
            ),
          ],
        ),
      );
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.label, required this.state});

  final String label;
  final DayState state;

  @override
  Widget build(BuildContext context) {
    final dimmed = state == DayState.upcoming;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: dimmed ? const Color(0x1AFAFAFA) : AppColors.dayTile,
        border: Border.all(color: AppColors.dayTileBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: dimmed ? 0.4 : 1,
            child: Text(label, style: AppTypography.dayLabel),
          ),
          const SizedBox(height: AppSpacing.xs),
          _DayRing(state: state),
        ],
      ),
    );
  }
}

class _DayRing extends StatelessWidget {
  const _DayRing({required this.state});

  final DayState state;

  static const _size = 26.0;
  static const _stroke = 3.64;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: CustomPaint(
        painter: _DayRingPainter(state: state),
      ),
    );
  }
}

class _DayRingPainter extends CustomPainter {
  const _DayRingPainter({required this.state});

  final DayState state;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(_DayRing._stroke / 2);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _DayRing._stroke
      ..color = AppColors.neutral500.withValues(alpha: 0.15);
    canvas.drawOval(rect, track);

    switch (state) {
      case DayState.mowed:
        canvas.drawOval(
          rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = _DayRing._stroke
            ..color = AppColors.dayDone,
        );
      case DayState.today:
        // Dashed, the way the design marks a day still in play.
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = AppColors.dayToday;
        const segments = 12;
        const sweep = 6.283185307179586 / segments;
        for (var i = 0; i < segments; i++) {
          canvas.drawArc(rect, i * sweep, sweep * 0.25, false, paint);
        }
      case DayState.missed:
      case DayState.upcoming:
        break;
    }
  }

  @override
  bool shouldRepaint(_DayRingPainter old) => old.state != state;
}
