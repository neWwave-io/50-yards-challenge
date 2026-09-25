import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../data/profile_data.dart';
import 'cropped_image.dart';
import 'profile_card.dart';

/// The guardian who signed up, and the children on the account.
class FamilyCard extends StatelessWidget {
  const FamilyCard({
    super.key,
    required this.guardian,
    required this.children,
    this.onAddChild,
  });

  final Guardian guardian;
  final List<ProfileChild> children;

  /// Hidden when null.
  final VoidCallback? onAddChild;

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CroppedImage.square(
                'assets/images/profile/guardian.png',
                size: ProfileCardTitle.iconSize,
                scale: 1.2283,
                inset: 0.1096,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guardian.title,
                      style: AppTypography.sectionTitle.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 2),
                    Text('Name', style: AppTypography.statLabel),
                    const SizedBox(height: 2),
                    Text(
                      guardian.name ?? 'Not set',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.profileValue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, thickness: 1, color: AppColors.borderDefault),
          const SizedBox(height: AppSpacing.md),
          ProfileCardTitle(
            icon: const CroppedImage.square(
              'assets/images/profile/kids.png',
              size: ProfileCardTitle.iconSize,
              scale: 1.225,
              inset: 0.1107,
            ),
            title: 'Kid Signed Up',
            trailing: onAddChild == null
                ? null
                : ProfileRoundButton(
                    size: AppSizes.tabIcon,
                    onTap: onAddChild!,
                    semanticLabel: 'Add a child',
                    icon: SvgPicture.asset(
                      'assets/icons/profile_plus.svg',
                      width: AppSizes.icon,
                      height: AppSizes.icon,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (children.isEmpty)
            Text('No children added yet.', style: AppTypography.statLabel)
          else
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              _ChildRow(number: i + 1, child: children[i]),
            ],
        ],
      ),
    );
  }
}

class _ChildRow extends StatelessWidget {
  const _ChildRow({required this.number, required this.child});

  final int number;
  final ProfileChild child;

  @override
  Widget build(BuildContext context) {
    final birthday = child.dateOfBirth;

    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.olive100,
        borderRadius: BorderRadius.circular(AppRadii.summaryRow),
      ),
      child: Row(
        children: [
          Text('$number.', style: AppTypography.childIndex),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              child.summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.summaryValue,
            ),
          ),
          if (birthday != null) ...[
            const SizedBox(width: AppSpacing.sm),
            // The design gives the cake and date an 80px slot; a long month
            // name is allowed to widen it rather than overflow.
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 80),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/icons/profile_cake.svg',
                    width: AppSizes.icon,
                    height: 16.2895,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(dayAndMonth(birthday), style: AppTypography.summaryValue),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
