import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// The gear on the profile header, where home has the availability badge.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.onTap});

  final VoidCallback onTap;

  static const _gearSize = 20.0;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Settings',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            decoration: const BoxDecoration(
              color: AppColors.gearDisc,
              shape: BoxShape.circle,
              boxShadow: AppShadows.cardRaised,
            ),
            child: SvgPicture.asset(
              'assets/icons/profile_gear.svg',
              width: _gearSize,
              height: _gearSize,
            ),
          ),
        ),
      );
}
