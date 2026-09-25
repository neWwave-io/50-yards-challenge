import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The design's "Empty card": a heading and supporting line, a picture, an
/// amber "Pending", then a title and explanation. Used wherever a list has
/// nothing in it yet — the leaderboard before anyone has mowed, the badges
/// tab before a lawn is checked.
class AppEmptyCard extends StatelessWidget {
  const AppEmptyCard({
    super.key,
    required this.heading,
    required this.subheading,
    required this.title,
    required this.body,
    this.image = 'assets/images/leaderboard/empty_trophy.png',
    this.status = 'Pending',
  });

  final String heading;
  final String subheading;
  final String title;
  final String body;

  /// A square picture, drawn at 100.
  final String image;

  /// The amber word above [title].
  final String status;

  static const _imageSize = 100.0;

  /// The design wraps the explanation at 270.
  static const _bodyWidth = 270.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.rowFill,
        borderRadius: BorderRadius.circular(AppRadii.row),
        boxShadow: AppShadows.cardRaised,
      ),
      child: Column(
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: AppTypography.emptyTitle.copyWith(height: null),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subheading,
            textAlign: TextAlign.center,
            style: AppTypography.emptyCaption,
          ),
          const SizedBox(height: AppSpacing.lg),
          Image.asset(image, width: _imageSize, height: _imageSize),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: _bodyWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xxs,
                  ),
                  child: Text(status, style: AppTypography.statusPending),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyTitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyBody,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
