import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// A child's round photo. Most children have none yet, so the gradient disc
/// is the normal case rather than an error state.
class LeaderboardAvatar extends StatelessWidget {
  const LeaderboardAvatar({super.key, required this.photoUrl, required this.size});

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.avatarDisc,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null
          ? null
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
    );
  }
}
