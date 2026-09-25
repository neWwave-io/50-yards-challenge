import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../../submit_lawn/data/lawn_draft.dart' show LawnPhoto;
import '../data/achievement_data.dart';
import 'lawn_detail_row.dart';
import 'lawn_photo_tile.dart';
import 'lawn_status_chip.dart';
import 'lawn_view_button.dart';
import 'safety_check_panel.dart';

/// One reviewed lawn: its number and outcome, the facts of the job, and —
/// once opened — the photos the child sent in.
class LawnCard extends StatelessWidget {
  const LawnCard({
    super.key,
    required this.lawn,
    required this.open,
    required this.onToggle,
  });

  final SubmittedLawn lawn;
  final bool open;
  final VoidCallback onToggle;

  /// A rejected lawn cannot be opened, as the design draws it — its View
  /// button is greyed out.
  bool get _canOpen =>
      lawn.review == LawnReview.approved && lawn.hasDetail;

  @override
  Widget build(BuildContext context) {
    final dimmed = lawn.review == LawnReview.rejected;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardGlass,
        borderRadius: BorderRadius.circular(AppRadii.lawnCard),
        boxShadow: AppShadows.cardRaised,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LawnStatusChip(number: lawn.number, review: lawn.review),
              LawnViewButton(
                open: open,
                onTap: _canOpen ? onToggle : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _Facts(lawn: lawn, dimmed: dimmed),
          if (open && _canOpen) ...[
            const SizedBox(height: AppSpacing.xl),
            _Proof(lawn: lawn),
          ],
        ],
      ),
    );
  }
}

/// Who it was for, what was done, where, and when — each row left out when
/// the lawn has no answer for it.
class _Facts extends StatelessWidget {
  const _Facts({required this.lawn, required this.dimmed});

  final SubmittedLawn lawn;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      if (lawn.mowedFor != null)
        LawnDetailRow(
          label: 'Mowed For',
          value: lawn.mowedFor!,
          dimmed: dimmed,
        ),
      if (lawn.service != null)
        LawnDetailRow(label: 'Service', value: lawn.service!, dimmed: dimmed),
      if (lawn.address != null)
        LawnDetailRow(label: 'Location', value: lawn.address!, dimmed: dimmed),
    ];

    final date = lawn.mowedOn;
    final hours = lawn.hoursLabel;
    if (date != null || hours != null) {
      rows.add(
        Row(
          children: [
            if (date != null)
              Expanded(
                child: LawnDetailRow.icon(
                  icon: 'assets/icons/calendar.svg',
                  value: dayMonthYear(date),
                  dimmed: dimmed,
                ),
              ),
            if (date != null && hours != null)
              const SizedBox(width: AppSpacing.rowGap),
            if (hours != null)
              Expanded(
                child: LawnDetailRow.icon(
                  icon: 'assets/icons/clock.svg',
                  value: hours,
                  dimmed: dimmed,
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows) ...[
          row,
          if (row != rows.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

/// The four proof shots, two to a row, then the safety check.
class _Proof extends StatelessWidget {
  const _Proof({required this.lawn});

  final SubmittedLawn lawn;

  @override
  Widget build(BuildContext context) {
    const steps = SubmittedLawn.proofSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var j = i; j < i + 2 && j < steps.length; j++) ...[
                if (j > i) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: LawnPhotoTile(
                    label: steps[j].$2,
                    url: lawn.photos[steps[j].$1],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        SafetyCheckPanel(
          woreGear: lawn.woreSafetyGear,
          photoUrl: lawn.photos[LawnPhoto.safety],
        ),
      ],
    );
  }
}
