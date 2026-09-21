import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_theme.dart';
import '../data/home_data.dart';

/// Somebody in the community finished a lawn.
class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.entry});

  final ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    final whoFor = entry.whoFor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dropdown),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.itemTitle,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            whoFor == null || whoFor.isEmpty ? 'Mowed' : 'Mowed for $whoFor',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.itemBody,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral400,
              borderRadius: BorderRadius.circular(AppRadii.summaryRow),
            ),
            child: Text(
              timeago.format(entry.at),
              style: AppTypography.itemMeta
                  .copyWith(color: const Color(0xFFF5F5F5)),
            ),
          ),
        ],
      ),
    );
  }
}
