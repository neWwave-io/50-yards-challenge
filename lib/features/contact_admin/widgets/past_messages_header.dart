import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// "Past Messages" and the button that flips the list's order.
class PastMessagesHeader extends StatelessWidget {
  const PastMessagesHeader({
    super.key,
    required this.newestFirst,
    required this.onToggleOrder,
  });

  final bool newestFirst;
  final VoidCallback onToggleOrder;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Past Messages', style: AppTypography.listHeading),
          Semantics(
            button: true,
            label: newestFirst ? 'Show oldest first' : 'Show newest first',
            child: GestureDetector(
              onTap: onToggleOrder,
              child: Container(
                width: AppSizes.iconButton,
                height: AppSizes.iconButton,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.summaryRow),
                  boxShadow: AppShadows.iconButton,
                ),
                child: SvgPicture.asset('assets/icons/contact_sort.svg'),
              ),
            ),
          ),
        ],
      );
}
