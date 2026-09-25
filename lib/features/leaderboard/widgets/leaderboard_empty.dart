import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_empty_card.dart';

/// The glass card that stands in for the podium when nobody is on the board.
class NoParticipantsCard extends StatelessWidget {
  const NoParticipantsCard({
    super.key,
    this.title = 'No participants yet',
    this.body =
        'New participants will appear here once they join the challenge.',
  });

  final String title;
  final String body;

  static const _discSize = 76.0;
  static const _iconSize = 38.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
        boxShadow: AppShadows.cardRaised,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: double.infinity,
            color: AppColors.surface.withValues(alpha: 0.04),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Container(
                  width: _discSize,
                  height: _discSize,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.emptyDisc,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/users_round.svg',
                    width: _iconSize,
                    height: _iconSize,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _Message(title: title, body: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "National Top 5" with nobody in it: before anyone has an approved lawn,
/// and below the filters on an empty board.
class NoRankingsCard extends StatelessWidget {
  const NoRankingsCard({super.key});

  @override
  Widget build(BuildContext context) => const AppEmptyCard(
        heading: 'National Top 5',
        subheading: 'Top participants across all states.',
        title: 'No national rankings yet',
        body: 'Complete and submit a task to become one of the first '
            'participants on the board.',
      );
}

/// Stands in for the signed-in child's own row until their first lawn is
/// approved.
class NoLawnsYetCard extends StatelessWidget {
  const NoLawnsYetCard({super.key});

  @override
  Widget build(BuildContext context) => const AppEmptyCard(
        heading: 'No achievement yet',
        subheading: 'Your name joins the board with your first lawn.',
        title: "You're not on the board yet",
        body: 'Submit your first lawn to start climbing the leaderboard.',
      );
}

/// "Pending", a heading and a line of explanation.
class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxs,
          ),
          child: Text('Pending', style: AppTypography.statusPending),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(title, textAlign: TextAlign.center, style: AppTypography.emptyTitle),
        const SizedBox(height: AppSpacing.xxs),
        Text(body, textAlign: TextAlign.center, style: AppTypography.emptyBody),
      ],
    );
  }
}
