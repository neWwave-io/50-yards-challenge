import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../data/home_data.dart';

/// The latest training video: a still, what it covers, and a way to watch it.
class TrainingHubCard extends StatelessWidget {
  const TrainingHubCard({super.key, required this.video, this.onWatch});

  final Announcement video;
  final ValueChanged<Announcement>? onWatch;

  @override
  Widget build(BuildContext context) {
    final image = video.imageUrl;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.dialog),
              child: Image.network(
                image,
                height: 187,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (image != null) const SizedBox(height: AppSpacing.md),
          Text(
            video.title,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutralText900,
            ),
          ),
          if (video.description case final body? when body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.itemBody.copyWith(height: 1.5),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: 'Watch the video',
            onPressed: onWatch == null ? null : () => onWatch!(video),
          ),
        ],
      ),
    );
  }
}
