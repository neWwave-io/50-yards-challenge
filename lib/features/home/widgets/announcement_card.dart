import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/home_data.dart';

/// One announcement: title, a couple of lines, and when it was posted.
/// Announcements with a picture put it on the left.
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement, this.onTap});

  final Announcement announcement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = announcement.imageUrl;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.dropdown),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.dropdown),
                child: Image.network(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.itemTitle,
                  ),
                  if (announcement.description case final body?
                      when body.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.itemBody,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    dayAndMonth(announcement.createdAt),
                    style: AppTypography.itemMeta,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
