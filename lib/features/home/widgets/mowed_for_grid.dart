import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_progress_ring.dart';
import '../data/home_data.dart';

/// Six tiles, one per kind of neighbour, each ringed by how much of the
/// mowing went to them.
class MowedForGrid extends StatelessWidget {
  const MowedForGrid({super.key, required this.tallies});

  final List<CategoryTally> tallies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Who I Mowed For', style: AppTypography.sectionTitle),
        const SizedBox(height: AppSpacing.xxl),
        GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [for (final tally in tallies) _Tile(tally: tally)],
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.tally});

  final CategoryTally tally;

  /// The arc starts at twelve o'clock and runs clockwise.
  static const _start = -math.pi / 2;

  /// Half a turn for the busiest category. Measured off the design, whose
  /// longest arc ends near 160 degrees and shortest near 50.
  static const _maxSweep = math.pi;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        final thickness = size / 9;
        final sweep = _maxSweep * tally.share;

        // With nothing mowed for this group there is no arc to measure, so
        // the track closes into a full circle rather than leaving a half ring
        // hanging off one side.
        final track = tally.count == 0 ? math.pi * 2 : _maxSweep;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AppProgressRing(
              diameter: size,
              thickness: thickness,
              progress: tally.share,
              color: AppColors.olive600,
              startAngle: _start,
              sweep: track,
            ),
            Padding(
              // Clear of the ring, so a two-line label cannot run under it.
              padding: EdgeInsets.all(thickness + 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    tally.category.iconPath,
                    width: size * 0.4,
                    height: size * 0.4,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    tally.category.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMuted, height: 1.1),
                  ),
                ],
              ),
            ),
            // Nothing mowed for this group yet, so no count to show.
            if (tally.count > 0)
              _CountBadge(
                count: tally.count,
                // Rides the end of the arc, as in the design.
                offset: Offset.fromDirection(
                  _start + sweep,
                  (size - thickness) / 2,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.offset});

  final int count;

  /// From the centre of the tile.
  final Offset offset;

  static const _size = 18.0;

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: offset,
        child: Container(
          // Fixed height, and at least as wide, so a narrow digit like 1
          // still draws a circle rather than an upright oval. Two digits let
          // it grow sideways into a pill.
          //
          // Sized this way rather than with an `alignment`: a Container given
          // one expands to whatever bounded space it is offered, and in a
          // Stack that is the entire tile.
          height: _size,
          constraints: const BoxConstraints(minWidth: _size),
          // Tight enough that any single digit still fits inside the circle;
          // two digits push past it and the pill stretches.
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: AppColors.olive600,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 2),
                blurRadius: 1.2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  color: AppColors.surface,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      );
}
