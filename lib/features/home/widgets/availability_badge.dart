import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_date_picker_dialog.dart';
import '../data/home_data.dart';

/// The smiley in the home header, showing whether the family is taking lawns.
///
/// Long-press and drag it and drop targets appear beneath it: go offline, go
/// offline until a chosen day, or — when away — come back. A plain tap offers
/// the same choices in a sheet, because a drag is hard to discover and harder
/// still with a screen reader.
class AvailabilityBadge extends StatefulWidget {
  const AvailabilityBadge({
    super.key,
    required this.availability,
    required this.onGoAway,
    required this.onComeBack,
  });

  final Availability availability;

  /// [returnsOn] is the day they are back; null means no date.
  final Future<void> Function({DateTime? returnsOn}) onGoAway;

  final Future<void> Function() onComeBack;

  static const size = 44.0;

  @override
  State<AvailabilityBadge> createState() => _AvailabilityBadgeState();
}

enum _Choice { offline, untilDate, back }

class _AvailabilityBadgeState extends State<AvailabilityBadge> {
  final _link = LayerLink();
  final _targets = OverlayPortalController();

  bool get _away => widget.availability.isAway;

  Future<void> _choose(_Choice choice) async {
    switch (choice) {
      case _Choice.offline:
        await widget.onGoAway();
      case _Choice.back:
        await widget.onComeBack();
      case _Choice.untilDate:
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final picked = await showAppDatePicker(
          context,
          title: 'Set New',
          confirmLabel: 'Save',
          initialDate: widget.availability.returnsOn,
          // You come back tomorrow at the earliest — today you are here.
          firstDate: today.add(const Duration(days: 1)),
          lastDate: today.add(const Duration(days: 365)),
        );
        if (picked != null) await widget.onGoAway(returnsOn: picked);
    }
  }

  List<_Choice> get _choices => _away
      ? const [_Choice.back, _Choice.untilDate]
      : const [_Choice.offline, _Choice.untilDate];

  Future<void> _openSheet() async {
    final choice = await showModalBottomSheet<_Choice>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.dialog),
        ),
      ),
      builder: (context) => _ChoiceSheet(
        away: _away,
        choices: _choices,
      ),
    );
    if (choice != null) await _choose(choice);
  }

  @override
  Widget build(BuildContext context) {
    final face = _Face(away: _away);

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _targets,
        overlayChildBuilder: (_) => CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, AppSpacing.md),
          child: Align(
            alignment: Alignment.topRight,
            child: _DropTargets(
              choices: _choices,
              onChosen: (choice) {
                _targets.hide();
                _choose(choice);
              },
            ),
          ),
        ),
        child: Semantics(
          button: true,
          label: _away
              ? 'You are away. Tap to come back or change your return date.'
              : 'You are available. Tap to go offline.',
          excludeSemantics: true,
          child: LongPressDraggable<_Badge>(
            data: const _Badge(),
            onDragStarted: _targets.show,
            onDragEnd: (_) => _targets.hide(),
            onDraggableCanceled: (_, __) => _targets.hide(),
            feedback: Material(
              color: Colors.transparent,
              child: _Face(away: _away, lifted: true),
            ),
            childWhenDragging: Opacity(opacity: 0.3, child: face),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _openSheet,
              child: face,
            ),
          ),
        ),
      ),
    );
  }
}

/// What travels with the drag. The targets only care that it is the badge.
class _Badge {
  const _Badge();
}

/// The smiley itself: green when available, faded when away.
class _Face extends StatelessWidget {
  const _Face({required this.away, this.lifted = false});

  final bool away;
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      'assets/icons/home_status.svg',
      width: AvailabilityBadge.size,
      height: AvailabilityBadge.size,
    );

    return AnimatedScale(
      scale: lifted ? 1.15 : 1,
      duration: const Duration(milliseconds: 120),
      child: Opacity(opacity: away ? 0.45 : 1, child: icon),
    );
  }
}

class _DropTargets extends StatelessWidget {
  const _DropTargets({required this.choices, required this.onChosen});

  final List<_Choice> choices;
  final ValueChanged<_Choice> onChosen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final choice in choices) ...[
            if (choice != choices.first) const SizedBox(width: AppSpacing.md),
            DragTarget<_Badge>(
              onAcceptWithDetails: (_) => onChosen(choice),
              builder: (context, candidates, _) =>
                  _Target(choice: choice, hovered: candidates.isNotEmpty),
            ),
          ],
        ],
      ),
    );
  }
}

class _Target extends StatelessWidget {
  const _Target({required this.choice, required this.hovered});

  final _Choice choice;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: hovered ? 60 : 52,
            height: hovered ? 60 : 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(
                color: hovered ? AppColors.olive500 : AppColors.borderDefault,
                width: hovered ? 3 : 1,
              ),
              boxShadow: AppShadows.card,
            ),
            child: _TargetIcon(choice: choice),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _label(choice),
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: AppColors.surface),
          ),
        ],
      ),
    );
  }
}

class _TargetIcon extends StatelessWidget {
  const _TargetIcon({required this.choice});

  final _Choice choice;

  @override
  Widget build(BuildContext context) => switch (choice) {
        _Choice.untilDate => SvgPicture.asset(
            'assets/icons/calendar.svg',
            width: 22,
            height: 22,
            colorFilter:
                const ColorFilter.mode(AppColors.olive500, BlendMode.srcIn),
          ),
        _Choice.offline => const _Face(away: true),
        _Choice.back => const _Face(away: false),
      };
}

String _label(_Choice choice) => switch (choice) {
      _Choice.offline => 'Go offline',
      _Choice.untilDate => 'Back on…',
      _Choice.back => "I'm back",
    };

/// The tap route to the same three choices.
class _ChoiceSheet extends StatelessWidget {
  const _ChoiceSheet({required this.away, required this.choices});

  final bool away;
  final List<_Choice> choices;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              away ? "You're away" : "You're available",
              style: AppTypography.cardTitle,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Your day streak is kept safe while you are offline.',
              style: AppTypography.caption,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final choice in choices)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox.square(
                  dimension: AvailabilityBadge.size,
                  child: Center(child: _TargetIcon(choice: choice)),
                ),
                title: Text(_sheetLabel(choice), style: AppTypography.bodyMedium),
                onTap: () => Navigator.of(context).pop(choice),
              ),
          ],
        ),
      ),
    );
  }

  static String _sheetLabel(_Choice choice) => switch (choice) {
        _Choice.offline => 'Go offline',
        _Choice.untilDate => 'Pick the day I’ll be back',
        _Choice.back => "I'm back — take requests again",
      };
}
