import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The round button floating at the bottom right of the profile page that
/// opens the contact-admin screen.
class ContactAdminButton extends StatelessWidget {
  const ContactAdminButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Contact admin',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: AppSizes.fab,
            height: AppSizes.fab,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: AppColors.brandFill,
              shape: BoxShape.circle,
              boxShadow: AppShadows.button,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: AppSizes.fabIcon,
              color: AppColors.neutralText100,
            ),
          ),
        ),
      );
}
